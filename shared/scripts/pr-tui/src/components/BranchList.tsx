import React, { useState, useEffect } from "react";
import { Box, Text, useInput } from "ink";
import { useAtomValue } from "jotai";
import { focusAtom } from "../lib/atoms.js";
import { SelectList } from "./SelectList.js";
import {
  listBranches,
  sessionName,
  createBranch,
  getRepoRoot,
  openBranchSession,
  worktreesDir,
} from "../lib/git.js";
import type { Branch } from "../lib/types.js";

interface BranchListProps {
  cwd: string;
}

export function BranchList({ cwd }: BranchListProps) {
  const focus = useAtomValue(focusAtom);
  const [branches, setBranches] = useState<Branch[]>([]);
  const [loading, setLoading] = useState(true);
  const [status, setStatus] = useState("");
  const [busy, setBusy] = useState(false);

  const refresh = async () => {
    setLoading(true);
    setStatus("");
    setBranches(await listBranches(cwd));
    setLoading(false);
  };

  useEffect(() => {
    refresh();
  }, [cwd]);

  useInput(
    (input) => {
      if (input === "r") refresh();
    },
    { isActive: focus === "main" && !busy },
  );

  const handleSelect = async (branch: Branch) => {
    const repoRoot = await getRepoRoot(cwd);
    if (!repoRoot) {
      setStatus("Not in a git repository");
      return;
    }

    const sName = sessionName(repoRoot, branch.name);
    const wtDir = branch.isCurrent ? repoRoot : `${worktreesDir(repoRoot)}/${sName}`;

    setBusy(true);
    setStatus(`Setting up ${branch.name}...`);
    const result = await openBranchSession(
      repoRoot,
      branch.name,
      wtDir,
      branch.hasWorktree || branch.isCurrent,
    );
    if (result.isErr()) {
      setStatus(`Error: ${result.error}`);
      setBusy(false);
      return;
    }
    setBusy(false);
    await refresh();
  };

  const handleCreate = async (name: string) => {
    const repoRoot = await getRepoRoot(cwd);
    if (!repoRoot) {
      setStatus("Not in a git repository");
      return;
    }

    setBusy(true);
    setStatus(`Creating branch ${name}...`);
    const result = await createBranch(repoRoot, name);
    if (result.isErr()) {
      setStatus(`Error: ${result.error}`);
      setBusy(false);
      return;
    }

    const sName = sessionName(repoRoot, name);
    const wtDir = `${worktreesDir(repoRoot)}/${sName}`;
    const wtResult = await openBranchSession(repoRoot, name, wtDir, false);
    if (wtResult.isErr()) {
      setStatus(`Error: ${wtResult.error}`);
      setBusy(false);
      return;
    }
    setBusy(false);
    await refresh();
  };

  if (loading) return <Text color="yellow">Loading branches...</Text>;

  return (
    <Box flexDirection="column">
      <SelectList
        panel="main"
        items={branches}
        searchValue={(b) => b.name}
        onSelect={handleSelect}
        onCreate={handleCreate}
        emptyText="No branches found"
        renderItem={(branch, { isCursor }) => (
          <>
            <Text color={isCursor ? "magenta" : undefined} bold={isCursor}>
              {isCursor ? "> " : "  "}
            </Text>
            <Text color={isCursor ? "magenta" : undefined} bold={isCursor}>
              {branch.name}
            </Text>
            {branch.isCurrent && (
              <Text color="green" dimColor>
                {" "}
                (main worktree)
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
