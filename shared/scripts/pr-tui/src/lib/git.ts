import { existsSync, mkdirSync, readFileSync } from "fs";
import { join } from "path";
import { ok, err, type Result } from "neverthrow";
import { exec } from "./exec.js";
import { killSession, openWorktreeSession } from "./tmux.js";
import { logEvent } from "./events.js";
import type { Branch, Worktree } from "./types.js";

export const WORKTREES_SUBDIR = ".claude/worktrees";

export function worktreesDir(repoRoot: string): string {
  return `${repoRoot}/${WORKTREES_SUBDIR}`;
}

export function safeName(branch: string): string {
  return branch.replace(/[/.:\s]/g, "-");
}

export function sessionName(repoRoot: string, branch: string): string {
  const repo = repoRoot.split("/").pop() || "repo";
  return `${repo}_${safeName(branch)}`;
}

export function getRepoRoot(cwd: string): string | null {
  let dir = cwd;
  while (true) {
    if (existsSync(join(dir, ".git"))) return dir;
    const parent = join(dir, "..");
    if (parent === dir) return null;
    dir = parent;
  }
}

export async function listBranches(cwd: string): Promise<Branch[]> {
  const [branchResult, wtResult] = await Promise.all([
    exec(["git", "branch", "--format=%(refname:short)|%(HEAD)"], { cwd }),
    exec(["git", "worktree", "list", "--porcelain"], { cwd }),
  ]);

  const worktreeBranches = new Set<string>();
  for (const line of wtResult.stdout.split("\n")) {
    if (line.startsWith("branch refs/heads/")) {
      worktreeBranches.add(line.replace("branch refs/heads/", ""));
    }
  }

  if (!branchResult.stdout) return [];

  return branchResult.stdout.split("\n").map((line) => {
    const [name, head] = line.split("|");
    return {
      name: name!,
      isCurrent: head === "*",
      hasWorktree: worktreeBranches.has(name!),
    };
  });
}

export async function listWorktrees(repoRoot: string): Promise<Worktree[]> {
  const [wtResult, vvResult] = await Promise.all([
    exec(["git", "worktree", "list"], { cwd: repoRoot }),
    exec(["git", "branch", "-vv"], { cwd: repoRoot }),
  ]);
  if (!wtResult.stdout) return [];

  const worktreeDir = `${worktreesDir(repoRoot)}/`;
  const lines = wtResult.stdout.split("\n").filter((l) => l.includes(worktreeDir));

  const entries = lines.map((line) => {
    const parts = line.split(/\s+/);
    const path = parts[0]!;
    const branch = (parts[2] || "").replace(/[[\]]/g, "");
    const sName = path.split("/").pop() || branch;
    const branchLine = vvResult.stdout
      .split("\n")
      .find((l) =>
        l.match(new RegExp(`^[* ] ${branch.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}\\s`)),
      );
    const isRemoteGone = branchLine ? branchLine.includes("[gone]") : false;
    return { path, branch, sName, isRemoteGone };
  });

  const statusResults = await Promise.all(
    entries.map(({ path }) =>
      exec(["git", "-C", path, "status", "--porcelain"], { cwd: repoRoot }),
    ),
  );

  const worktrees: Worktree[] = entries.map((e, i) => ({
    path: e.path,
    branch: e.branch,
    safeName: e.sName,
    isDirty: statusResults[i]!.stdout.length > 0,
    isRemoteGone: e.isRemoteGone,
  }));

  return worktrees;
}

export function getMainWorktreeBranch(repoRoot: string): string | null {
  try {
    const head = readFileSync(join(repoRoot, ".git", "HEAD"), "utf8").trim();
    const match = head.match(/^ref: refs\/heads\/(.+)$/);
    return match ? match[1]! : null;
  } catch {
    return null;
  }
}

export async function getRemoteUrl(repoRoot: string): Promise<string | null> {
  const result = await exec(["git", "config", "--get", "remote.origin.url"], { cwd: repoRoot });
  return result.exitCode === 0 ? result.stdout.trim() : null;
}

export async function fetchBranch(cwd: string, branch: string): Promise<void> {
  await exec(["git", "fetch", "origin", `${branch}:${branch}`], { cwd });
}

export async function addWorktree(
  repoRoot: string,
  branch: string,
  targetDir: string,
): Promise<Result<void, string>> {
  mkdirSync(worktreesDir(repoRoot), { recursive: true });
  await fetchBranch(repoRoot, branch);

  const result = await exec(["git", "worktree", "add", targetDir, branch], { cwd: repoRoot });
  if (result.exitCode !== 0) return err(result.stderr);

  await exec(["git", "-C", targetDir, "branch", "--set-upstream-to", `origin/${branch}`]);
  return ok(undefined);
}

export async function removeWorktree(
  repoRoot: string,
  path: string,
): Promise<Result<void, string>> {
  const result = await exec(["git", "worktree", "remove", path], { cwd: repoRoot });
  if (result.exitCode !== 0) return err(result.stderr);
  return ok(undefined);
}

export async function deleteBranch(
  cwd: string,
  branch: string,
  force = false,
): Promise<Result<void, string>> {
  const flag = force ? "-D" : "-d";
  const result = await exec(["git", "branch", flag, branch], { cwd });
  if (result.exitCode !== 0) return err(result.stderr);
  return ok(undefined);
}

export async function createBranch(cwd: string, branch: string): Promise<Result<void, string>> {
  const result = await exec(["git", "branch", branch], { cwd });
  if (result.exitCode !== 0) return err(result.stderr);
  logEvent({ action: "create_branch", branch, cwd });
  return ok(undefined);
}

/** Kill session, remove worktree, delete branch. Returns status messages. */
export async function cleanupBranch(
  repoRoot: string,
  branch: string,
  sName: string,
  worktreePath: string | null,
): Promise<string[]> {
  const messages: string[] = [];

  await killSession(sName);
  messages.push(`Killed session: ${sName}`);
  logEvent({ action: "kill_session", sessionName: sName, cwd: repoRoot });

  if (worktreePath) {
    const wtResult = await removeWorktree(repoRoot, worktreePath);
    if (wtResult.isOk()) {
      messages.push(`Removed worktree: ${branch}`);
      logEvent({ action: "remove_worktree", worktreePath, cwd: repoRoot });
    } else {
      messages.push(`Could not remove worktree: ${wtResult.error}`);
    }
  }

  const brResult = await deleteBranch(repoRoot, branch, false);
  if (brResult.isErr()) await deleteBranch(repoRoot, branch, true);
  messages.push(`Deleted branch: ${branch}`);
  logEvent({ action: "delete_branch", branch, cwd: repoRoot });

  return messages;
}

/** Ensure a worktree exists for `branch` then switch to its tmux session. */
export async function openBranchSession(
  repoRoot: string,
  branch: string,
  wtDir: string,
  allowExisting = false,
): Promise<Result<void, string>> {
  const result = await addWorktree(repoRoot, branch, wtDir);
  if (result.isErr()) {
    const isExisting =
      result.error.includes("already used by worktree") || result.error.includes("already exists");
    if (!allowExisting || !isExisting) return result;
  }
  await openWorktreeSession(sessionName(repoRoot, branch), wtDir);
  logEvent({ action: "open_branch", branch, worktreePath: wtDir, cwd: repoRoot });
  return ok(undefined);
}
