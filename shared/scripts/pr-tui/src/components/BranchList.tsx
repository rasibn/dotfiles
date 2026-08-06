import React, { useState, useEffect, useCallback } from "react";
import { Box, Text } from "ink";
import { useAtomValue } from "jotai";
import { focusAtom } from "../lib/atoms.js";
import { useGuardedInput } from "../lib/useGuardedInput.js";
import { SelectList } from "./SelectList.js";
import { Confirm } from "./Confirm.js";
import {
  listBranches,
  sessionName,
  createBranch,
  cleanupBranch,
  getRepoRoot,
  getRemoteUrl,
  openBranchSession,
  worktreesDir,
  listWorktrees,
} from "../lib/git.js";
import { openInBrowser, branchToCompareUrl, prToGithubUrl } from "../lib/browser.js";
import type { BranchEntry } from "../lib/types.js";
import { getCurrentUser, listPRs } from "../lib/gh.js";
import { mergeBranchesWithPRs } from "../lib/branch-entries.js";

interface BranchListProps {
  cwd: string;
  ownership: "mine" | "other";
  viewportSize: number;
}

export function BranchList({ cwd, ownership, viewportSize }: BranchListProps) {
  const focus = useAtomValue(focusAtom);
  const [branches, setBranches] = useState<BranchEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [status, setStatus] = useState("");
  const [busy, setBusy] = useState(false);
  const [confirming, setConfirming] = useState<BranchEntry | null>(null);

  const refresh = useCallback(async () => {
    setLoading(true);
    setStatus("");
    const [nextBranches, prsResult, currentUser] = await Promise.all([
      listBranches(cwd),
      listPRs(cwd),
      getCurrentUser(cwd),
    ]);
    setBranches(
      mergeBranchesWithPRs(
        nextBranches,
        prsResult.isOk() ? prsResult.value : [],
        currentUser,
        ownership,
      ),
    );
    setLoading(false);
  }, [cwd, ownership]);

  useEffect(() => {
    refresh();
  }, [refresh]);

  useGuardedInput(
    "main",
    (input) => {
      if (input === "r") refresh();
    },
    { isActive: focus === "main" && !busy },
  );

  const handleSelect = async (branch: BranchEntry) => {
    const repoRoot = getRepoRoot(cwd);
    if (!repoRoot) {
      setStatus("Not in a git repository");
      return;
    }

    const sName = sessionName(repoRoot, branch.name);
    const existing = (await listWorktrees(repoRoot)).find((wt) => wt.branch === branch.name);
    const wtDir = branch.isCurrent
      ? repoRoot
      : (existing?.path ?? `${worktreesDir(repoRoot)}/${sName}`);

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
    const repoRoot = getRepoRoot(cwd);
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

  const doDelete = async (branch: BranchEntry) => {
    const repoRoot = getRepoRoot(cwd);
    if (!repoRoot) return;

    const sName = sessionName(repoRoot, branch.name);
    const existing = branch.hasWorktree
      ? (await listWorktrees(repoRoot)).find((wt) => wt.branch === branch.name)
      : undefined;
    const wtDir = existing?.path ?? null;
    setStatus(`Deleting ${branch.name}...`);
    const messages = await cleanupBranch(repoRoot, branch.name, sName, wtDir);
    setStatus(messages.join("\n"));
    await refresh();
  };

  const handleKeyAction = async (key: string, branch: BranchEntry) => {
    if (confirming) return;
    if (key === "d" && !branch.isCurrent) {
      setConfirming(branch);
    } else if (key === "o") {
      const repoRoot = getRepoRoot(cwd);
      if (!repoRoot) {
        setStatus("Not in a git repository");
        return;
      }
      const remoteUrl = await getRemoteUrl(repoRoot);
      if (!remoteUrl) {
        setStatus("Could not find remote URL");
        return;
      }
      const url = branch.prNumber
        ? prToGithubUrl(remoteUrl, branch.prNumber)
        : branchToCompareUrl(remoteUrl, branch.name);
      setStatus(`Opening ${url}...`);
      await openInBrowser(url);
      setTimeout(() => setStatus(""), 2000);
    }
  };

  if (loading) return <Text color="yellow">Loading branches...</Text>;

  return (
    <Box flexDirection="column">
      <SelectList
        panel="main"
        disabled={!!confirming}
        items={branches}
        viewportSize={viewportSize}
        itemLines={(branch) =>
          2 +
          (branch.prTitle && !branch.isRemote ? 1 : 0) +
          (branch.unresolvedComments > 0 || branch.sonarCoverage !== null ? 1 : 0)
        }
        searchValue={(b) => `${b.name} ${b.prTitle ?? ""} ${b.isRemote ? "is:remote" : "is:local"}`}
        onSelect={handleSelect}
        onCreate={ownership === "mine" ? handleCreate : undefined}
        onKeyAction={handleKeyAction}
        emptyText="No branches found"
        renderItem={(branch, { isCursor }) => {
          const label = branch.prTitle ?? branch.name;
          const branchColor = branch.isRemoteGone
            ? "red"
            : branch.prTitle
              ? isCursor
                ? "magenta"
                : "cyan"
              : isCursor
                ? "yellow"
                : "blue";
          const worktreeStatus = branch.isCurrent
            ? " (main worktree)"
            : branch.hasWorktree
              ? " (worktree)"
              : "";
          return (
            <Box flexDirection="column" width="100%">
              <Box>
                <Text color={branchColor} bold={isCursor}>
                  {isCursor ? "> " : "  "}
                </Text>
                <Text color={branchColor} bold={isCursor} wrap="truncate">
                  {branch.prNumber ? `#${branch.prNumber} ` : ""}
                  {label}
                  {!branch.prTitle && worktreeStatus}
                </Text>
                {(branch.commitsAhead > 0 || branch.commitsBehind > 0) && (
                  <>
                    <Text dimColor> (</Text>
                    {branch.commitsAhead > 0 && <Text color="green">up {branch.commitsAhead}</Text>}
                    {branch.commitsAhead > 0 && branch.commitsBehind > 0 && <Text dimColor> </Text>}
                    {branch.commitsBehind > 0 && (
                      <Text color="red">down {branch.commitsBehind}</Text>
                    )}
                    <Text dimColor>)</Text>
                  </>
                )}
                {branch.isRemoteGone && (
                  <Text color="red" dimColor wrap="truncate">
                    {" "}
                    (remote gone)
                  </Text>
                )}
              </Box>
              {branch.prTitle &&
                (branch.unresolvedComments > 0 || branch.sonarCoverage !== null) && (
                  <Box>
                    <Text>{"    "}</Text>
                    {branch.sonarCoverage !== null && (
                      <Text color={branch.sonarCoverage >= 80 ? "green" : "red"}>
                        coverage {branch.sonarCoverage}%
                      </Text>
                    )}
                    {branch.sonarCoverage !== null && branch.unresolvedComments > 0 && (
                      <Text dimColor> · </Text>
                    )}
                    {branch.unresolvedComments > 0 && (
                      <Text color="red">unresolved {branch.unresolvedComments}</Text>
                    )}
                  </Box>
                )}
              {branch.prTitle && !branch.isRemote && (
                <Box>
                  <Text>{"    "}</Text>
                  <Text dimColor wrap="truncate">
                    {branch.name}
                    {worktreeStatus}
                  </Text>
                </Box>
              )}
              <Text dimColor wrap="truncate">
                {"─".repeat(200)}
              </Text>
            </Box>
          );
        }}
      />
      {confirming && (
        <Confirm
          message={`Delete ${confirming.name}?`}
          panel="main"
          onConfirm={() => {
            doDelete(confirming);
            setConfirming(null);
          }}
          onCancel={() => setConfirming(null)}
        />
      )}
      {status && (
        <Box marginTop={1}>
          <Text color="yellow">{status}</Text>
        </Box>
      )}
    </Box>
  );
}
