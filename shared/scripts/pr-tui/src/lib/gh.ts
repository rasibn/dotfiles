import { ok, err, type Result } from "neverthrow";
import { exec } from "./exec.js";
import type { PR } from "./types.js";

export async function listPRs(cwd: string): Promise<Result<PR[], string>> {
  const result = await exec(
    ["gh", "pr", "list", "--limit", "50", "--json", "number,title,headRefName,author", "--jq", "."],
    { cwd },
  );
  if (result.exitCode !== 0) return err("Failed to fetch PRs (is gh authenticated?)");
  try {
    const data = JSON.parse(result.stdout || "[]");
    return ok(
      data.map((pr: any) => ({
        number: pr.number,
        title: pr.title,
        headRefName: pr.headRefName,
        author: pr.author?.login || "unknown",
      })),
    );
  } catch {
    return err("Failed to parse PR data");
  }
}
