import { exec } from "./exec.js";
import { worktreesDir, getMainWorktreeBranch, sessionName } from "./git.js";
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
}> {
  const result = await exec([
    "tmux",
    "list-windows",
    "-a",
    "-F",
    "#{session_name}\t#{window_index}\t#{window_name}\t#{pane_title}",
  ]);
  const windowsBySession = new Map<string, TmuxWindow[]>();
  if (result.exitCode !== 0) return { sessionNames: [], windowsBySession };
  for (const line of result.stdout.split("\n").filter(Boolean)) {
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
  return { sessionNames: Array.from(windowsBySession.keys()), windowsBySession };
}

export async function listSessions(repoRoot: string | null): Promise<Session[]> {
  const { sessionNames, windowsBySession } = await fetchAllWindows();
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
      worktreePath: null,
      isDirty: false,
      isOrphan: false,
      windows: windowsBySession.get(name) ?? [],
      notifications: notificationResults[i]!,
    }));
  }

  const worktreeDir = `${worktreesDir(repoRoot)}/`;
  const wtResult = await exec(["git", "worktree", "list", "--porcelain"], { cwd: repoRoot });

  const wtBlocks = wtResult.stdout.split("\n\n").filter((b) => b.includes(worktreeDir));
  const wtEntries = wtBlocks.map((block) => {
    const lines = block.split("\n");
    const path = lines.find((l) => l.startsWith("worktree "))?.slice(9) ?? "";
    const branch = lines.find((l) => l.startsWith("branch refs/heads/"))?.slice(18) ?? null;
    return { path, branch };
  });

  const dirtyResults = await Promise.all(
    wtEntries.map(({ path }) =>
      exec(["git", "-C", path, "status", "--porcelain"], { cwd: repoRoot }),
    ),
  );

  const worktreeMap = new Map<string, { path: string; branch: string | null; isDirty: boolean }>();
  for (let i = 0; i < wtEntries.length; i++) {
    const { path, branch } = wtEntries[i]!;
    worktreeMap.set(path.split("/").pop()!, {
      path,
      branch,
      isDirty: dirtyResults[i]!.stdout.length > 0,
    });
  }

  const repoName = repoRoot.split("/").pop()!;
  const rootBranch = getMainWorktreeBranch(repoRoot);
  const rootSessionName = rootBranch ? sessionName(repoRoot, rootBranch) : null;

  return sessionNames.map((name, i) => {
    const wt = worktreeMap.get(name);
    const isRootSession = name === rootSessionName;
    const isRepoSession = name.startsWith(`${repoName}_`);
    return {
      name,
      branch: wt?.branch ?? (isRootSession ? rootBranch : null),
      worktreePath: wt?.path ?? (isRootSession ? repoRoot : null),
      isDirty: wt?.isDirty ?? false,
      isOrphan: isRepoSession && !wt && !isRootSession,
      windows: windowsBySession.get(name) ?? [],
      notifications: notificationResults[i]!,
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
