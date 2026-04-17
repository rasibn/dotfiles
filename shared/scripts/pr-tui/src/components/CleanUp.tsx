import React, { useState, useEffect } from "react";
import { Box, Text, useInput } from "ink";
import { SelectList } from "./SelectList.js";
import { listWorktrees, removeWorktree, deleteBranch, getRepoRoot } from "../lib/git.js";
import { killSession, sessionExists } from "../lib/tmux.js";
import { exec } from "../lib/exec.js";
import type { Worktree } from "../lib/types.js";

interface CleanUpProps {
  cwd: string;
  active: boolean;
}

export function CleanUp({ cwd, active }: CleanUpProps) {
  const [worktrees, setWorktrees] = useState<Worktree[]>([]);
  const [loading, setLoading] = useState(true);
  const [status, setStatus] = useState("");

  const refresh = async () => {
    setLoading(true);
    setStatus("");

    const repoRoot = await getRepoRoot(cwd);
    if (!repoRoot) {
      setStatus("Not in a git repository");
      setLoading(false);
      return;
    }

    await exec(["git", "fetch", "-p"], { cwd: repoRoot });
    await exec(["git", "worktree", "prune"], { cwd: repoRoot });

    const result = await listWorktrees(repoRoot);
    setWorktrees(result);
    setLoading(false);
  };

  useEffect(() => {
    refresh();
  }, [cwd]);

  useInput(
    (input) => {
      if (input === "r") refresh();
    },
    { isActive: active },
  );

  const handleCleanup = async (toClean: Worktree[]) => {
    const repoRoot = await getRepoRoot(cwd);
    if (!repoRoot) return;

    setStatus(`Cleaning ${toClean.length} worktree(s)...`);
    const messages: string[] = [];

    for (const wt of toClean) {
      if (await sessionExists(wt.safeName)) {
        await killSession(wt.safeName);
        messages.push(`Killed session: ${wt.safeName}`);
      }

      const wtResult = await removeWorktree(repoRoot, wt.path);
      if (wtResult.ok) {
        messages.push(`Removed worktree: ${wt.branch}`);
        // Force delete if remote is gone (squash-merged PRs), safe delete otherwise
        const brResult = await deleteBranch(repoRoot, wt.branch, wt.isRemoteGone);
        if (brResult.ok) {
          messages.push(`Deleted branch: ${wt.branch}`);
        } else {
          messages.push(`Kept branch ${wt.branch}: ${brResult.error}`);
        }
      } else {
        messages.push(`Failed to remove ${wt.branch}: ${wtResult.error}`);
      }
    }

    setStatus(messages.join("\n"));
    await refresh();
  };

  if (loading) {
    return <Text color="yellow">Loading worktrees...</Text>;
  }

  return (
    <Box flexDirection="column">
      <SelectList
        items={worktrees}
        active={active}
        multiSelect
        searchValue={(wt) => wt.branch}
        onConfirm={handleCleanup}
        emptyText="No worktrees to clean up"
        renderItem={(wt, { isCursor, isSelected }) => (
          <>
            <Text color={isCursor ? "cyan" : undefined}>{isCursor ? "> " : "  "}</Text>
            <Text color={isSelected ? "magenta" : undefined}>{isSelected ? "[x] " : "[ ] "}</Text>
            <Text color={isCursor ? "cyan" : undefined} bold={isCursor}>
              {wt.branch}
            </Text>
            <Text> </Text>
            {wt.isDirty ? <Text color="yellow">dirty</Text> : <Text color="green">clean</Text>}
            {wt.isRemoteGone && <Text color="red"> remote gone</Text>}
          </>
        )}
      />
      {status && (
        <Box marginTop={1}>
          <Text color="yellow">{status}</Text>
        </Box>
      )}
    </Box>
  );
}
