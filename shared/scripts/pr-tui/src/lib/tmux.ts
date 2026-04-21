import { exec } from "./exec.js";
import type { Session } from "./types.js";

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

export async function listSessions(repoRoot: string | null): Promise<Session[]> {
  const sessResult = await exec(["tmux", "list-sessions", "-F", "#{session_name}"]);
  if (sessResult.exitCode !== 0) return [];

  const sessionNames = sessResult.stdout.split("\n").filter(Boolean);

  const toSessionSet = (glob: string, prefix: string) =>
    new Set(
      Array.from(new Bun.Glob(glob).scanSync()).map((f) =>
        (f as string).replace(prefix, "").replace(/-\d+$/, ""),
      ),
    );

  const stopFlags = toSessionSet("/tmp/claude-stop-*", "/tmp/claude-stop-");
  const notifyFlags = toSessionSet("/tmp/claude-notify-*", "/tmp/claude-notify-");

  if (!repoRoot) {
    return sessionNames.map((name) => ({
      name,
      branch: null,
      worktreePath: null,
      isDirty: false,
      isOrphan: false,
      claudeStop: stopFlags.has(name),
      claudeNotify: notifyFlags.has(name),
    }));
  }

  const worktreeDir = `${repoRoot}/.worktrees/`;
  const wtResult = await exec(["git", "worktree", "list", "--porcelain"], { cwd: repoRoot });

  const wtBlocks = wtResult.stdout.split("\n\n").filter((b) => b.includes(worktreeDir));
  const wtEntries = wtBlocks.map((block) => {
    const lines = block.split("\n");
    const path = lines.find((l) => l.startsWith("worktree "))?.slice(9) ?? "";
    const branch = lines.find((l) => l.startsWith("branch refs/heads/"))?.slice(18) ?? null;
    return { path, branch };
  });

  const dirtyResults = await Promise.all(
    wtEntries.map(({ path }) => exec(["git", "-C", path, "status", "--porcelain"], { cwd: repoRoot })),
  );

  const worktreeMap = new Map<string, { path: string; branch: string | null; isDirty: boolean }>();
  for (let i = 0; i < wtEntries.length; i++) {
    const { path, branch } = wtEntries[i]!;
    worktreeMap.set(path.split("/").pop()!, { path, branch, isDirty: dirtyResults[i]!.stdout.length > 0 });
  }

  const repoName = repoRoot.split("/").pop()!;

  return sessionNames.map((name) => {
    const wt = worktreeMap.get(name);
    const isRepoSession = name.startsWith(`${repoName}_`);
    return {
      name,
      branch: wt?.branch ?? null,
      worktreePath: wt?.path ?? null,
      isDirty: wt?.isDirty ?? false,
      isOrphan: isRepoSession && !wt,
      claudeStop: stopFlags.has(name),
      claudeNotify: notifyFlags.has(name),
    };
  });
}

export async function openWorktreePane(sessionName: string, worktreeDir: string): Promise<void> {
  const exists = await sessionExists(sessionName);
  if (!exists) {
    await createSession(sessionName, worktreeDir);
  }
  await exec(["tmux", "split-window", "-h", "-c", worktreeDir]);
}
