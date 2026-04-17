import { exec } from "./exec.js";
import type { Branch, Worktree } from "./types.js";

export function safeName(branch: string): string {
  return branch.replace(/[/.:\s]/g, "-");
}

export async function getRepoRoot(cwd: string): Promise<string | null> {
  const result = await exec(["git", "rev-parse", "--show-toplevel"], { cwd });
  return result.exitCode === 0 ? result.stdout : null;
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
  const wtResult = await exec(["git", "worktree", "list"], { cwd: repoRoot });
  if (!wtResult.stdout) return [];

  const worktreeDir = `${repoRoot}/.worktrees/`;
  const lines = wtResult.stdout.split("\n").filter((l) => l.includes(worktreeDir));

  const worktrees: Worktree[] = [];

  for (const line of lines) {
    const parts = line.split(/\s+/);
    const path = parts[0]!;
    const branch = (parts[2] || "").replace(/[[\]]/g, "");
    const sName = path.split("/").pop() || branch;

    const statusResult = await exec(["git", "-C", path, "status", "--porcelain"], {
      cwd: repoRoot,
    });
    const isDirty = statusResult.stdout.length > 0;

    const vvResult = await exec(["git", "branch", "-vv"], { cwd: repoRoot });
    const branchLine = vvResult.stdout
      .split("\n")
      .find((l) =>
        l.match(new RegExp(`^[* ] ${branch.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}\\s`)),
      );
    const isRemoteGone = branchLine ? branchLine.includes("[gone]") : false;

    worktrees.push({ path, branch, safeName: sName, isDirty, isRemoteGone });
  }

  return worktrees;
}

export async function fetchBranch(cwd: string, branch: string): Promise<void> {
  await exec(["git", "fetch", "origin", `${branch}:${branch}`], { cwd });
}

export async function addWorktree(
  repoRoot: string,
  branch: string,
  targetDir: string,
): Promise<{ ok: boolean; error?: string }> {
  // Ensure .worktrees directory exists
  await exec(["mkdir", "-p", `${repoRoot}/.worktrees`]);

  // Try to fetch the branch (ignore errors for local-only branches)
  await fetchBranch(repoRoot, branch);

  const result = await exec(["git", "worktree", "add", targetDir, branch], {
    cwd: repoRoot,
  });

  if (result.exitCode !== 0) {
    return { ok: false, error: result.stderr };
  }
  return { ok: true };
}

export async function removeWorktree(
  repoRoot: string,
  path: string,
): Promise<{ ok: boolean; error?: string }> {
  const result = await exec(["git", "worktree", "remove", path], { cwd: repoRoot });
  if (result.exitCode !== 0) {
    return { ok: false, error: result.stderr };
  }
  return { ok: true };
}

export async function deleteBranch(
  cwd: string,
  branch: string,
): Promise<{ ok: boolean; error?: string }> {
  const result = await exec(["git", "branch", "-d", branch], { cwd });
  if (result.exitCode !== 0) {
    return { ok: false, error: result.stderr };
  }
  return { ok: true };
}
