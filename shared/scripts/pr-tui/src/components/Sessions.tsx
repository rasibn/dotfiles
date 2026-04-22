import React, { useState, useEffect } from "react";
import { Box, Text, useInput } from "ink";
import { useAtomValue } from "jotai";
import { focusAtom } from "../lib/atoms.js";
import { SelectList } from "./SelectList.js";
import { Confirm } from "./Confirm.js";
import { listSessions, killSession, openWorktreeSession, openWorktreePane } from "../lib/tmux.js";
import { removeWorktree, deleteBranch, getRepoRoot } from "../lib/git.js";
import { exec } from "../lib/exec.js";
import type { Session } from "../lib/types.js";

interface SessionsProps {
  cwd: string | null;
}

export function Sessions({ cwd }: SessionsProps) {
  const focus = useAtomValue(focusAtom);
  const [sessions, setSessions] = useState<Session[]>([]);
  const [loading, setLoading] = useState(true);
  const [status, setStatus] = useState("");
  const [confirming, setConfirming] = useState<Session | null>(null);

  const refresh = async (showLoading = false) => {
    if (showLoading) setLoading(true);
    setStatus("");
    const repoRoot = cwd ? await getRepoRoot(cwd) : null;
    const next = await listSessions(repoRoot);
    setSessions((prev) => {
      const same =
        prev.length === next.length &&
        prev.every((s, i) => {
          const n = next[i]!;
          return s.name === n.name && s.isDirty === n.isDirty && s.isOrphan === n.isOrphan &&
            s.claudeStop === n.claudeStop && s.claudeNotify === n.claudeNotify;
        });
      return same ? prev : next;
    });
    setLoading(false);
  };

  useEffect(() => { refresh(true); }, [cwd]);

  useEffect(() => {
    const id = setInterval(refresh, 2000);
    return () => clearInterval(id);
  }, [cwd]);

  useInput((input) => {
    if (input === "r") refresh();
  }, { isActive: focus === "sidebar" && !confirming });

  const doDelete = async (sess: Session) => {
    const repoRoot = cwd ? await getRepoRoot(cwd) : null;
    setStatus(`Deleting ${sess.name}...`);
    await killSession(sess.name);
    const messages = [`Killed session: ${sess.name}`];
    if (repoRoot && sess.worktreePath && sess.branch) {
      const wtResult = await removeWorktree(repoRoot, sess.worktreePath);
      if (wtResult.ok) {
        messages.push(`Removed worktree: ${sess.branch}`);
        const brResult = await deleteBranch(repoRoot, sess.branch, false);
        if (!brResult.ok) await deleteBranch(repoRoot, sess.branch, true);
      } else {
        messages.push(`Could not remove worktree: ${wtResult.error}`);
      }
    }
    await exec(["bash", "-c", `rm -f /tmp/claude-stop-${sess.name}-* /tmp/claude-notify-${sess.name}-*`]);
    setStatus(messages.join("\n"));
    await refresh();
  };

  const handleSelect = async (sess: Session) => {
    const dir = sess.worktreePath ?? process.env.HOME ?? "/";
    setStatus(`Opening ${sess.name}...`);
    await openWorktreeSession(sess.name, dir);
    setStatus("");
  };

  const handleKeyAction = async (key: string, sess: Session) => {
    if (confirming) return;
    if (key === "p") {
      const dir = sess.worktreePath ?? process.env.HOME ?? "/";
      setStatus(`Opening pane for ${sess.name}...`);
      await openWorktreePane(sess.name, dir);
      setStatus("");
    } else if (key === "d") {
      setConfirming(sess);
    } else if (key === "x") {
      await exec(["bash", "-c", `rm -f /tmp/claude-stop-${sess.name}-* /tmp/claude-notify-${sess.name}-*`]);
      await refresh();
    }
  };

  if (loading) return <Text color="yellow">Loading sessions...</Text>;

  return (
    <Box flexDirection="column">
      <SelectList
        panel="sidebar"
        disabled={!!confirming}
        items={sessions}
        searchValue={(s) => s.name}
        onSelect={handleSelect}
        onKeyAction={handleKeyAction}
        emptyText="No active sessions"
        renderItem={(sess, { isCursor }) => {
          const badges =
            (sess.claudeNotify ? " [!]" : "") +
            (sess.claudeStop ? " [?]" : "") +
            (sess.isDirty ? " dirty" : "") +
            (sess.isOrphan ? " orphan" : "");
          const maxName = 39 - badges.length;
          const name = sess.name.length > maxName ? sess.name.slice(0, maxName - 1) + "…" : sess.name;
          return (
            <>
              <Text color={isCursor ? "cyan" : undefined}>{isCursor ? "> " : "  "}</Text>
              <Text color={isCursor ? "cyan" : undefined} bold={isCursor}>{name}</Text>
              {sess.claudeNotify && <Text color="red"> [!]</Text>}
              {sess.claudeStop && <Text color="yellow"> [?]</Text>}
              {sess.isDirty && <Text color="yellow"> dirty</Text>}
              {sess.isOrphan && <Text color="red"> orphan</Text>}
            </>
          );
        }}
      />
      {confirming ? (
        <Confirm
          message={`Delete ${confirming.name}?`}
          panel="sidebar"
          onConfirm={() => { doDelete(confirming); setConfirming(null); }}
          onCancel={() => setConfirming(null)}
        />
      ) : (
        <Box marginTop={1}>
          <Text dimColor>↵ open  p pane  d del  x clear</Text>
        </Box>
      )}
      {status && <Box marginTop={1}><Text color="yellow">{status}</Text></Box>}
    </Box>
  );
}
