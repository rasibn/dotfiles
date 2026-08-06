import { ok, err, type Result } from "neverthrow";
import { exec } from "./exec.js";
import type { PR } from "./types.js";

const prCache = new Map<string, Promise<Result<Map<string, PR>, string>>>();
const userCache = new Map<string, Promise<string | null>>();

export function listPRs(cwd: string): Promise<Result<PR[], string>> {
  return getPRsByBranch(cwd).then((result) =>
    result.isOk() ? ok([...result.value.values()]) : err(result.error),
  );
}

export function getPRsByBranch(cwd: string): Promise<Result<Map<string, PR>, string>> {
  const cached = prCache.get(cwd);
  if (cached) return cached;
  const request = fetchPRs(cwd);
  prCache.set(cwd, request);
  return request;
}

async function fetchPRs(cwd: string): Promise<Result<Map<string, PR>, string>> {
  const result = await exec(
    [
      "gh",
      "pr",
      "list",
      "--limit",
      "50",
      "--json",
      "number,title,headRefName,author,labels",
      "--jq",
      ".",
    ],
    { cwd },
  );
  if (result.exitCode !== 0) return err("Failed to fetch PRs (is gh authenticated?)");
  try {
    const data = JSON.parse(result.stdout || "[]");
    const details = await getPRDetails(cwd);
    const prs = data.map((pr: any) => ({
      number: pr.number,
      title: pr.title,
      headRefName: pr.headRefName,
      author: pr.author?.login || details.get(pr.number)?.author || "unknown",
      labels: (pr.labels || []).map((l: any) => l.name).filter(Boolean),
      unresolvedComments: details.get(pr.number)?.unresolvedComments ?? 0,
      sonarCoverage: details.get(pr.number)?.sonarCoverage ?? null,
    }));
    return ok(new Map(prs.map((pr: PR) => [pr.headRefName, pr] as const)));
  } catch {
    return err("Failed to parse PR data");
  }
}

async function getPRDetails(
  cwd: string,
): Promise<
  Map<number, { author?: string; unresolvedComments: number; sonarCoverage: number | null }>
> {
  const repoResult = await exec(
    ["gh", "repo", "view", "--json", "nameWithOwner", "--jq", ".nameWithOwner"],
    {
      cwd,
    },
  );
  const [owner, name] = repoResult.stdout.split("/");
  if (repoResult.exitCode !== 0 || !owner || !name) return new Map();

  const result = await exec(
    [
      "gh",
      "api",
      "graphql",
      "-f",
      "query=query($owner:String!, $name:String!) { repository(owner:$owner, name:$name) { pullRequests(states:OPEN, first:50) { nodes { number commits(last:1) { nodes { commit { author { user { login } } } } } reviewThreads(first:100) { nodes { isResolved } } comments(first:100) { nodes { body author { login } } } } } } }",
      "-F",
      `owner=${owner}`,
      "-F",
      `name=${name}`,
    ],
    { cwd },
  );
  if (result.exitCode !== 0) return new Map();

  try {
    const nodes = JSON.parse(result.stdout).data?.repository?.pullRequests?.nodes || [];
    return new Map(
      nodes.flatMap((pr: any) => {
        const login = pr.commits?.nodes?.[0]?.commit?.author?.user?.login;
        const unresolvedComments = (pr.reviewThreads?.nodes || []).filter(
          (thread: any) => !thread.isResolved,
        ).length;
        let sonarCoverage: number | null = null;
        for (const comment of pr.comments?.nodes || []) {
          if (comment.author?.login !== "careem-cicd-sonarqube") continue;
          const match = comment.body?.match(/(\d+(?:\.\d+)?)% Coverage on New Code/);
          if (match) sonarCoverage = Number(match[1]);
        }
        return [[pr.number, { author: login, unresolvedComments, sonarCoverage }] as const];
      }),
    );
  } catch {
    return new Map();
  }
}

export async function getCurrentUser(cwd: string): Promise<string | null> {
  const cached = userCache.get(cwd);
  if (cached) return cached;
  const request = exec(["gh", "api", "user", "--jq", ".login"], { cwd }).then((result) =>
    result.exitCode === 0 ? result.stdout.trim() || null : null,
  );
  userCache.set(cwd, request);
  return request;
}
