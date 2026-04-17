import { exec } from "./exec.js";

const REPO_DIR_ENV_VARS = ["PROJECT_DIR", "WORK_DIR", "ASSET_DIR"];

export interface Repo {
  name: string;
  path: string;
}

async function findGitRepos(dir: string): Promise<Repo[]> {
  const result = await exec([
    "find",
    dir,
    "-name",
    "node_modules",
    "-prune",
    "-o",
    "-name",
    ".worktrees",
    "-prune",
    "-o",
    "-name",
    ".git",
    "-type",
    "d",
    "-print",
  ]);

  if (result.exitCode !== 0) return [];

  return result.stdout
    .split("\n")
    .filter(Boolean)
    .map((gitDir) => {
      const repoPath = gitDir.replace(/\/\.git$/, "");
      const name = repoPath.startsWith(dir + "/")
        ? repoPath.slice(dir.length + 1)
        : repoPath.split("/").pop() || repoPath;
      return { name, path: repoPath };
    });
}

export async function discoverRepos(): Promise<Repo[]> {
  const dirs: string[] = [];

  for (const envVar of REPO_DIR_ENV_VARS) {
    const dir = process.env[envVar];
    if (dir) dirs.push(dir);
  }

  const results = await Promise.all(dirs.map(findGitRepos));
  const repos = results.flat();

  const seen = new Set<string>();
  return repos.filter((r) => {
    if (seen.has(r.path)) return false;
    seen.add(r.path);
    return true;
  });
}
