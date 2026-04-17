import React, { useState, useEffect } from "react";
import { Box, Text, useInput } from "ink";
import { useVimNav } from "../hooks/useVimNav.js";
import { exec } from "../lib/exec.js";
import { safeName, addWorktree, getRepoRoot } from "../lib/git.js";
import { openWorktreeSession } from "../lib/tmux.js";
import type { PR } from "../lib/types.js";

interface PrListProps {
  cwd: string;
  active: boolean;
}

export function PrList({ cwd, active }: PrListProps) {
  const [prs, setPrs] = useState<PR[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [status, setStatus] = useState("");

  const { cursor, viewportStart, viewportEnd } = useVimNav({
    length: prs.length,
    active,
  });

  const refresh = async () => {
    setLoading(true);
    setError("");
    setStatus("");

    const result = await exec([
      "gh",
      "pr",
      "list",
      "--limit",
      "50",
      "--json",
      "number,title,headRefName,author",
      "--jq",
      ".",
    ], { cwd });

    if (result.exitCode !== 0) {
      setError("Failed to fetch PRs (is gh authenticated?)");
      setLoading(false);
      return;
    }

    try {
      const data = JSON.parse(result.stdout || "[]");
      setPrs(
        data.map((pr: any) => ({
          number: pr.number,
          title: pr.title,
          headRefName: pr.headRefName,
          author: pr.author?.login || "unknown",
        })),
      );
    } catch {
      setError("Failed to parse PR data");
    }

    setLoading(false);
  };

  useEffect(() => {
    refresh();
  }, [cwd]);

  useInput(
    (input, key) => {
      if (input === "r") {
        refresh();
      }
      if (key.return && cursor >= 0 && cursor < prs.length) {
        handleSelect(prs[cursor]!);
      }
    },
    { isActive: active },
  );

  const handleSelect = async (pr: PR) => {
    const repoRoot = await getRepoRoot(cwd);
    if (!repoRoot) {
      setStatus("Not in a git repository");
      return;
    }

    const sName = safeName(pr.headRefName);
    const wtDir = `${repoRoot}/.worktrees/${sName}`;

    setStatus(`Setting up PR #${pr.number} (${pr.headRefName})...`);

    const result = await addWorktree(repoRoot, pr.headRefName, wtDir);
    if (!result.ok && !result.error?.includes("already exists")) {
      setStatus(`Error: ${result.error}`);
      return;
    }

    setStatus(`Switching to ${sName}...`);
    await openWorktreeSession(sName, wtDir);
    await refresh();
  };

  if (loading) {
    return <Text color="yellow">Loading PRs...</Text>;
  }

  if (error) {
    return (
      <Box flexDirection="column">
        <Text color="red">{error}</Text>
        <Text dimColor>Press r to retry</Text>
      </Box>
    );
  }

  const visible = prs.slice(viewportStart, viewportEnd);

  return (
    <Box flexDirection="column">
      {prs.length === 0 ? (
        <Text dimColor>No open PRs found</Text>
      ) : (
        visible.map((pr, i) => {
          const realIndex = viewportStart + i;
          const isCursor = realIndex === cursor;
          return (
            <Box key={pr.number}>
              <Text color={isCursor ? "cyan" : undefined} bold={isCursor}>
                {isCursor ? ">" : " "}{" "}
              </Text>
              <Text color="green">#{pr.number}</Text>
              <Text> </Text>
              <Text color={isCursor ? "cyan" : undefined} bold={isCursor}>
                {pr.title}
              </Text>
              <Text dimColor>
                {" "}
                ({pr.headRefName}) @{pr.author}
              </Text>
            </Box>
          );
        })
      )}
      {prs.length > viewportEnd - viewportStart && (
        <Text dimColor>
          [{viewportStart + 1}-{viewportEnd} of {prs.length}]
        </Text>
      )}
      {status ? (
        <Box marginTop={1}>
          <Text color="yellow">{status}</Text>
        </Box>
      ) : null}
    </Box>
  );
}
