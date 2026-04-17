import React, { useState, useEffect } from "react";
import { Box, Text, useInput } from "ink";
import { useVimNav } from "../hooks/useVimNav.js";
import { useMultiSelect } from "../hooks/useMultiSelect.js";
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

  const { cursor, viewportStart, viewportEnd } = useVimNav({
    length: worktrees.length,
    active,
  });

  const { selected, toggle, clear } = useMultiSelect({ active });

  const refresh = async () => {
    setLoading(true);
    setStatus("");
    clear();

    const repoRoot = await getRepoRoot(cwd);
    if (!repoRoot) {
      setStatus("Not in a git repository");
      setLoading(false);
      return;
    }

    // Prune dead remotes and orphaned worktrees
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
    (input, key) => {
      if (input === "r") {
        refresh();
      }

      // Toggle selection with Tab or Space
      if ((key.tab || input === " ") && cursor >= 0) {
        toggle(cursor);
      }

      // Execute cleanup on Enter
      if (key.return && selected.size > 0) {
        handleCleanup();
      }
    },
    { isActive: active },
  );

  const handleCleanup = async () => {
    const repoRoot = await getRepoRoot(cwd);
    if (!repoRoot) return;

    const toClean = [...selected].map((i) => worktrees[i]!).filter(Boolean);
    setStatus(`Cleaning ${toClean.length} worktree(s)...`);

    const messages: string[] = [];

    for (const wt of toClean) {
      // Kill tmux session
      if (await sessionExists(wt.safeName)) {
        await killSession(wt.safeName);
        messages.push(`Killed session: ${wt.safeName}`);
      }

      // Remove worktree
      const wtResult = await removeWorktree(repoRoot, wt.path);
      if (wtResult.ok) {
        messages.push(`Removed worktree: ${wt.branch}`);

        // Delete local branch
        const brResult = await deleteBranch(repoRoot, wt.branch);
        if (brResult.ok) {
          messages.push(`Deleted branch: ${wt.branch}`);
        } else {
          messages.push(`Kept branch ${wt.branch} (unmerged commits)`);
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

  const visible = worktrees.slice(viewportStart, viewportEnd);

  return (
    <Box flexDirection="column">
      {worktrees.length === 0 ? (
        <Text dimColor>No worktrees to clean up</Text>
      ) : (
        <>
          <Box marginBottom={1}>
            <Text dimColor>Tab/Space to select, Enter to clean up</Text>
          </Box>
          {visible.map((wt, i) => {
            const realIndex = viewportStart + i;
            const isCursor = realIndex === cursor;
            const isSelected = selected.has(realIndex);
            return (
              <Box key={wt.path}>
                <Text color={isCursor ? "cyan" : undefined}>
                  {isCursor ? ">" : " "}{" "}
                </Text>
                <Text color={isSelected ? "magenta" : undefined}>
                  {isSelected ? "[x]" : "[ ]"}{" "}
                </Text>
                <Text color={isCursor ? "cyan" : undefined} bold={isCursor}>
                  {wt.branch}
                </Text>
                <Text> </Text>
                {wt.isDirty ? (
                  <Text color="yellow">dirty</Text>
                ) : (
                  <Text color="green">clean</Text>
                )}
                {wt.isRemoteGone && (
                  <Text color="red"> remote gone</Text>
                )}
              </Box>
            );
          })}
          {selected.size > 0 && (
            <Box marginTop={1}>
              <Text color="magenta">
                {selected.size} selected — press Enter to clean up
              </Text>
            </Box>
          )}
        </>
      )}
      {worktrees.length > viewportEnd - viewportStart && (
        <Text dimColor>
          [{viewportStart + 1}-{viewportEnd} of {worktrees.length}]
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
