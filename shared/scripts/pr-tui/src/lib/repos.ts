import { readdirSync, statSync } from "fs";
import { join } from "path";

const REPO_DIR_ENV_VARS = ["PROJECT_DIR", "WORK_DIR", "ASSET_DIR"];
const MAX_DEPTH = 4;

export interface Repo {
  name: string;
  path: string;
}

function findGitRepos(dir: string): Repo[] {
  const repos: Repo[] = [];

  function walk(current: string, depth: number) {
    if (depth > MAX_DEPTH) return;
    let entries;
    try {
      entries = readdirSync(current, { withFileTypes: true });
    } catch {
      return;
    }
    for (const entry of entries) {
      if (!entry.isDirectory()) continue;
      if (entry.name === "node_modules") continue;
      if (entry.name === ".git") {
        const name = current.startsWith(dir + "/")
          ? current.slice(dir.length + 1)
          : current.split("/").pop() || current;
        repos.push({ name, path: current });
        return; // don't recurse into repos
      }
      walk(join(current, entry.name), depth + 1);
    }
  }

  walk(dir, 0);
  return repos;
}

export function discoverRepos(): Repo[] {
  const dirs: string[] = [];

  for (const envVar of REPO_DIR_ENV_VARS) {
    const dir = process.env[envVar];
    if (dir) dirs.push(dir);
  }

  const repos = dirs.flatMap(findGitRepos);

  const seen = new Set<string>();
  const unique = repos.filter((r) => {
    if (seen.has(r.path)) return false;
    seen.add(r.path);
    return true;
  });

  // Sort by most recently modified (uses .git dir mtime)
  return unique.sort((a, b) => {
    try {
      const mtimeA = statSync(`${a.path}/.git`).mtimeMs;
      const mtimeB = statSync(`${b.path}/.git`).mtimeMs;
      return mtimeB - mtimeA;
    } catch {
      return 0;
    }
  });
}
