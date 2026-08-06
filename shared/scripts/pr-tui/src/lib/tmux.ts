import { exec } from "./exec.js";
import { getMainWorktreeBranch, sessionName } from "./git.js";
import { getPRsByBranch } from "./gh.js";
import { getSessionNotifications, getAllNotificationFlags } from "./notifications.js";
import type { Session, TmuxWindow } from "./types.js";

export function isInsideTmux(): boolean {
  return !!process.env.TMUX;
}

export async function sessionExists(name: string): Promise<boolean> {
  const result = await exec(["tmux", "has-session", "-t", name]);
  return result.exitCode === 0;
}

export async function createSession(name: string, cwd: string): Promise<void> {
  await exec(["tmux", "new-session", "-d", "-s", name, "-c", cwd]);
}

export async function switchClient(name: string): Promise<void> {
  if (isInsideTmux()) {
    await exec(["tmux", "switch-client", "-t", name]);
  } else {
    await exec(["tmux", "attach-session", "-t", name]);
  }
}

export async function killSession(name: string): Promise<void> {
  await exec(["tmux", "kill-session", "-t", name]);
}

export async function openWorktreeSession(sessionName: string, worktreeDir: string): Promise<void> {
  const exists = await sessionExists(sessionName);
  if (!exists) {
    await createSession(sessionName, worktreeDir);
  }
  await switchClient(sessionName);
}

async function fetchAllWindows(): Promise<{
  sessionNames: string[];
  windowsBySession: Map<string, TmuxWindow[]>;
  pathsBySession: Map<string, string>;
  paneBranchesBySession: Map<string, string[]>;
}> {
  const [windowsResult, sessionsResult] = await Promise.all([
    exec([
      "tmux",
      "list-windows",
      "-a",
      "-F",
      "#{session_name}\t#{window_index}\t#{window_name}\t#{pane_title}",
    ]),
    exec(["tmux", "list-sessions", "-F", "#{session_name}\t#{session_path}"]),
  ]);
  const windowsBySession = new Map<string, TmuxWindow[]>();
  const pathsBySession = new Map<string, string>();
  const paneBranchesBySession = new Map<string, string[]>();
  if (sessionsResult.exitCode === 0) {
    for (const line of sessionsResult.stdout.split("\n").filter(Boolean)) {
      const [sess, sessionPath] = line.split("\t");
      if (sess && sessionPath) pathsBySession.set(sess, sessionPath);
    }
  }
  if (windowsResult.exitCode !== 0)
    return { sessionNames: [], windowsBySession, pathsBySession, paneBranchesBySession };
  for (const line of windowsResult.stdout.split("\n").filter(Boolean)) {
    const [sess, idxStr, name, paneTitle] = line.split("\t");
    if (!sess) continue;
    const idx = parseInt(idxStr!);
    const window: TmuxWindow = {
      index: idx,
      name: name ?? `window ${idx}`,
      paneTitle: paneTitle || null,
    };
    const existing = windowsBySession.get(sess);
    if (existing) existing.push(window);
    else windowsBySession.set(sess, [window]);
  }
  const paneResult = await exec([
    "tmux",
    "list-panes",
    "-a",
    "-F",
    "#{session_name}\t#{pane_current_path}",
  ]);
  if (paneResult.exitCode === 0) {
    const panePaths = paneResult.stdout
      .split("\n")
      .filter(Boolean)
      .map((line) => {
        const [session, path] = line.split("\t");
        return session && path ? { session, path } : null;
      })
      .filter((pane): pane is { session: string; path: string } => pane !== null);
    const branchResults = await Promise.all(
      panePaths.map(async ({ session, path }) => {
        const result = await exec(["git", "-C", path, "branch", "--show-current"]);
        return { session, branch: result.exitCode === 0 ? result.stdout : "" };
      }),
    );
    for (const { session, branch } of branchResults) {
      if (!branch) continue;
      const branches = paneBranchesBySession.get(session) ?? [];
      if (!branches.includes(branch)) branches.push(branch);
      paneBranchesBySession.set(session, branches);
    }
  }
  return {
    sessionNames: Array.from(windowsBySession.keys()),
    windowsBySession,
    pathsBySession,
    paneBranchesBySession,
  };
}

export async function listSessions(repoRoot: string | null): Promise<Session[]> {
  const { sessionNames, windowsBySession, pathsBySession, paneBranchesBySession } =
    await fetchAllWindows();
  const notifFlags = getAllNotificationFlags();
  if (sessionNames.length === 0) return [];

  const notificationResults = sessionNames.map((name) => {
    const windows = windowsBySession.get(name) ?? [];
    return notifFlags.has(name) ? getSessionNotifications(name, windows) : [];
  });

  if (!repoRoot) {
    return sessionNames.map((name, i) => ({
      name,
      branch: null,
      prNumber: null,
      prTitle: null,
      worktreeName: null,
      worktreePath: null,
      isDirty: false,
      isOrphan: false,
      windows: windowsBySession.get(name) ?? [],
      notifications: notificationResults[i]!,
      paneBranches: paneBranchesBySession.get(name) ?? [],
    }));
  }

  const wtResult = await exec(["git", "worktree", "list", "--porcelain"], { cwd: repoRoot });

  const wtBlocks = wtResult.stdout.split("\n\n").filter(Boolean);
  const wtEntries = wtBlocks
    .map((block) => {
      const lines = block.split("\n");
      const path = lines.find((l) => l.startsWith("worktree "))?.slice(9) ?? "";
      const branch = lines.find((l) => l.startsWith("branch refs/heads/"))?.slice(18) ?? null;
      return { path, branch, name: path.split("/").pop() ?? path };
    })
    .filter(({ path }) => path !== repoRoot);

  const dirtyResults = await Promise.all(
    wtEntries.map(({ path }) =>
      exec(["git", "-C", path, "status", "--porcelain"], { cwd: repoRoot }),
    ),
  );

  const worktreeMap = new Map<
    string,
    { path: string; branch: string | null; name: string; isDirty: boolean }
  >();
  for (let i = 0; i < wtEntries.length; i++) {
    const { path, branch, name } = wtEntries[i]!;
    worktreeMap.set(path, {
      path,
      branch,
      name,
      isDirty: dirtyResults[i]!.stdout.length > 0,
    });
  }

  const repoName = repoRoot.split("/").pop()!;
  const rootBranch = getMainWorktreeBranch(repoRoot);
  const rootSessionName = rootBranch ? sessionName(repoRoot, rootBranch) : null;
  const prsResult = await getPRsByBranch(repoRoot);
  const prsByBranch = new Map(
    prsResult.isOk()
      ? [...prsResult.value].map(
          ([branch, pr]) => [branch, { number: pr.number, title: pr.title }] as const,
        )
      : [],
  );

  return sessionNames.map((name, i) => {
    const sessionPath = pathsBySession.get(name);
    const wt =
      Array.from(worktreeMap.values()).find(
        (entry) => sessionPath === entry.path || sessionPath?.startsWith(`${entry.path}/`),
      ) ??
      (rootBranch && name === sessionName(repoRoot, rootBranch)
        ? {
            path: repoRoot,
            branch: rootBranch,
            name: repoName,
            isDirty: false,
          }
        : undefined);
    const isRootSession = name === rootSessionName;
    const isRepoSession = name.startsWith(sessionName(repoRoot, ""));
    const branch = wt?.branch ?? (isRootSession ? rootBranch : null);
    const pr = branch ? prsByBranch.get(branch) : undefined;
    return {
      name,
      branch,
      prNumber: pr?.number ?? null,
      prTitle: pr?.title ?? null,
      worktreeName: wt?.name ?? null,
      worktreePath: wt?.path ?? (isRootSession ? repoRoot : null),
      isDirty: wt?.isDirty ?? false,
      isOrphan: isRepoSession && !wt && !isRootSession,
      windows: windowsBySession.get(name) ?? [],
      notifications: notificationResults[i]!,
      paneBranches: paneBranchesBySession.get(name) ?? [],
    };
  });
}

export async function openWindow(sessionName: string, windowIndex: number): Promise<void> {
  await switchClient(sessionName);
  await exec(["tmux", "select-window", "-t", `${sessionName}:${windowIndex}`]);
}

export async function openWorktreePane(sessionName: string, worktreeDir: string): Promise<void> {
  const exists = await sessionExists(sessionName);
  if (!exists) {
    await createSession(sessionName, worktreeDir);
  }
  await exec(["tmux", "split-window", "-h", "-c", worktreeDir]);
}
