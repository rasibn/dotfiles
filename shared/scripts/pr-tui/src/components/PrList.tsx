import React, { useState, useEffect } from "react";
import { Box, Text, useInput } from "ink";
import { useAtomValue } from "jotai";
import { focusAtom } from "../lib/atoms.js";
import { SelectList } from "./SelectList.js";
import { sessionName, getRepoRoot, openBranchSession, worktreesDir } from "../lib/git.js";
import { listPRs } from "../lib/gh.js";
import type { PR } from "../lib/types.js";

interface PrListProps {
  cwd: string;
}

export function PrList({ cwd }: PrListProps) {
  const focus = useAtomValue(focusAtom);
  const [prs, setPrs] = useState<PR[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);
  const [status, setStatus] = useState("");

  const refresh = async () => {
    setLoading(true);
    setError("");
    setStatus("");
    const result = await listPRs(cwd);
    if (result.isErr()) {
      setError(result.error);
      setLoading(false);
      return;
    }
    setPrs(result.value);
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

  const handleSelect = async (pr: PR) => {
    const repoRoot = await getRepoRoot(cwd);
    if (!repoRoot) {
      setStatus("Not in a git repository");
      return;
    }

    const sName = sessionName(repoRoot, pr.headRefName);
    const wtDir = `${worktreesDir(repoRoot)}/${sName}`;

    setBusy(true);
    setStatus(`Setting up PR #${pr.number} (${pr.headRefName})...`);
    const result = await openBranchSession(repoRoot, pr.headRefName, wtDir, true);
    if (result.isErr()) {
      setStatus(`Error: ${result.error}`);
      setBusy(false);
      return;
    }
    setBusy(false);
    await refresh();
  };

  if (loading) return <Text color="yellow">Loading PRs...</Text>;
  if (error)
    return (
      <Box flexDirection="column">
        <Text color="red">{error}</Text>
        <Text dimColor>Press r to retry</Text>
      </Box>
    );

  return (
    <Box flexDirection="column">
      <SelectList
        panel="main"
        items={prs}
        searchValue={(pr) => `${pr.number} ${pr.title} ${pr.headRefName} ${pr.author}`}
        onSelect={handleSelect}
        emptyText="No open PRs found"
        renderItem={(pr, { isCursor }) => (
          <Box flexDirection="column">
            <Box>
              <Text color={isCursor ? "magenta" : undefined} bold={isCursor}>
                {isCursor ? "> " : "  "}
              </Text>
              <Text color="green">#{pr.number}</Text>
              <Text> </Text>
              <Text color={isCursor ? "magenta" : undefined} bold={isCursor}>
                {pr.title}
              </Text>
            </Box>
            <Box>
              <Text>{"    "}</Text>
              <Text dimColor>{pr.headRefName}</Text>
              <Text dimColor> @{pr.author}</Text>
            </Box>
          </Box>
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
