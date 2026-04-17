import { exec } from "./exec.js";

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
