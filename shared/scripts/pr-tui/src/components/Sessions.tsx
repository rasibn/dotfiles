import React, { useState, useEffect } from "react";
import { Box, Text, useInput } from "ink";
import { SelectList } from "./SelectList.js";
import { listSessions, killSession, openWorktreeSession, openWorktreePane } from "../lib/tmux.js";
import { removeWorktree, deleteBranch, getRepoRoot } from "../lib/git.js";
import { exec } from "../lib/exec.js";
import type { Session } from "../lib/types.js";

interface SessionsProps {
  cwd: string;
  active: boolean;
}

export function Sessions({ cwd, active }: SessionsProps) {
  const [sessions, setSessions] = useState<Session[]>([]);
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
    const result = await listSessions(repoRoot);
    setSessions(result);
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

  const handleSelect = async (sess: Session) => {
    const repoRoot = await getRepoRoot(cwd);
    if (!repoRoot) return;

    setStatus(`Cleaning ${sess.name}...`);
    await killSession(sess.name);
    const messages = [`Killed session: ${sess.name}`];

    if (sess.worktreePath && sess.branch) {
      const wtResult = await removeWorktree(repoRoot, sess.worktreePath);
      if (wtResult.ok) {
        messages.push(`Removed worktree: ${sess.branch}`);
        const brResult = await deleteBranch(repoRoot, sess.branch, false);
        if (!brResult.ok) await deleteBranch(repoRoot, sess.branch, true);
      } else {
        messages.push(`Could not remove worktree: ${wtResult.error}`);
      }
    }

    setStatus(messages.join("\n"));
    await refresh();
  };

  const handleKeyAction = async (key: string, sess: Session) => {
    const dir = sess.worktreePath ?? process.env.HOME ?? "/";
    if (key === "o") {
      setStatus(`Opening ${sess.name}...`);
      await openWorktreeSession(sess.name, dir);
      setStatus("");
    } else if (key === "p") {
      setStatus(`Opening pane for ${sess.name}...`);
      await openWorktreePane(sess.name, dir);
      setStatus("");
    } else if (key === "x") {
      await exec(["bash", "-c", `rm -f /tmp/claude-stop-${sess.name}-* /tmp/claude-notify-${sess.name}-*`]);
      await refresh();
    }
  };

  if (loading) {
    return <Text color="yellow">Loading sessions...</Text>;
  }

  return (
    <Box flexDirection="column">
      <SelectList
        items={sessions}
        active={active}
        searchValue={(s) => s.name}
        onSelect={handleSelect}
        onKeyAction={handleKeyAction}
        emptyText="No active sessions"
        renderItem={(sess, { isCursor }) => (
          <>
            <Text color={isCursor ? "cyan" : undefined}>{isCursor ? "> " : "  "}</Text>
            <Text color={isCursor ? "cyan" : undefined} bold={isCursor}>
              {sess.name}
            </Text>
            {sess.claudeNotify && <Text color="red"> [!]</Text>}
            {sess.claudeStop && <Text color="yellow"> [?]</Text>}
            {sess.isDirty && <Text color="yellow"> dirty</Text>}
            {sess.isOrphan && <Text color="red"> orphan</Text>}
          </>
        )}
      />
      <Box marginTop={1}>
        <Text dimColor>{"Enter delete  o open  p pane  x clear notify"}</Text>
      </Box>
      {status && (
        <Box marginTop={1}>
          <Text color="yellow">{status}</Text>
        </Box>
      )}
    </Box>
  );
}
