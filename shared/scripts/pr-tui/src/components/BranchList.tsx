import React, { useState, useEffect } from "react";
import { Box, Text, useInput } from "ink";
import { SelectList } from "./SelectList.js";
import { listBranches, safeName, addWorktree, getRepoRoot } from "../lib/git.js";
import { openWorktreeSession } from "../lib/tmux.js";
import type { Branch } from "../lib/types.js";

interface BranchListProps {
  cwd: string;
  active: boolean;
}

export function BranchList({ cwd, active }: BranchListProps) {
  const [branches, setBranches] = useState<Branch[]>([]);
  const [loading, setLoading] = useState(true);
  const [status, setStatus] = useState("");

  const refresh = async () => {
    setLoading(true);
    setStatus("");
    const result = await listBranches(cwd);
    setBranches(result);
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

  const handleSelect = async (branch: Branch) => {
    if (branch.isCurrent) {
      setStatus("Already on this branch in main worktree");
      return;
    }

    const repoRoot = await getRepoRoot(cwd);
    if (!repoRoot) {
      setStatus("Not in a git repository");
      return;
    }

    const sName = safeName(branch.name);
    const wtDir = `${repoRoot}/.worktrees/${sName}`;

    setStatus(`Setting up ${branch.name}...`);

    if (!branch.hasWorktree) {
      const result = await addWorktree(repoRoot, branch.name, wtDir);
      if (!result.ok) {
        setStatus(`Error: ${result.error}`);
        return;
      }
    }

    setStatus(`Switching to ${sName}...`);
    await openWorktreeSession(sName, wtDir);
    await refresh();
  };

  if (loading) {
    return <Text color="yellow">Loading branches...</Text>;
  }

  return (
    <Box flexDirection="column">
      <SelectList
        items={branches}
        active={active}
        searchValue={(b) => b.name}
        onSelect={handleSelect}
        emptyText="No branches found"
        renderItem={(branch, { isCursor }) => (
          <>
            <Text color={isCursor ? "cyan" : undefined} bold={isCursor}>
              {isCursor ? "> " : "  "}
            </Text>
            <Text color={isCursor ? "cyan" : undefined} bold={isCursor}>
              {branch.name}
            </Text>
            {branch.isCurrent && (
              <Text color="green" dimColor>
                {" "}
                (current)
              </Text>
            )}
            {branch.hasWorktree && !branch.isCurrent && (
              <Text color="yellow" dimColor>
                {" "}
                (worktree)
              </Text>
            )}
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
