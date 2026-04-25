import React, { useState, useEffect } from "react";
import { Box, Text, useInput } from "ink";
import { useAtomValue } from "jotai";
import { focusAtom } from "../lib/atoms.js";
import { SelectList } from "./SelectList.js";
import { Confirm } from "./Confirm.js";
import {
  listSessions,
  killSession,
  openWorktreeSession,
  openWorktreePane,
  openWindow,
} from "../lib/tmux.js";
import { clearWindowNotification, clearAllNotifications } from "../lib/notifications.js";
import { removeWorktree, deleteBranch, getRepoRoot } from "../lib/git.js";
import { config } from "../lib/config.js";
import type { Session, ClaudeNotification, TmuxWindow } from "../lib/types.js";

interface SessionsProps {
  cwd: string | null;
}

type SessionRow = { kind: "session"; session: Session };
type NotifRow = { kind: "notif"; session: Session; notif: ClaudeNotification };
type WindowRow = { kind: "window"; session: Session; window: TmuxWindow };
type ListItem = SessionRow | NotifRow | WindowRow;

export function Sessions({ cwd }: SessionsProps) {
  const focus = useAtomValue(focusAtom);
  const [sessions, setSessions] = useState<Session[]>([]);
  const [loading, setLoading] = useState(true);
  const [status, setStatus] = useState("");
  const [confirming, setConfirming] = useState<Session | null>(null);
  const [expandedSessions, setExpandedSessions] = useState(new Set<string>());
  const [scrollToTopSignal, setScrollToTopSignal] = useState(0);

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
          return (
            s.name === n.name &&
            s.isDirty === n.isDirty &&
            s.isOrphan === n.isOrphan &&
            s.windows.length === n.windows.length &&
            s.notifications.length === n.notifications.length &&
            s.notifications.every(
              (notif, j) =>
                notif.windowIndex === n.notifications[j]?.windowIndex &&
                notif.type === n.notifications[j]?.type,
            )
          );
        });
      return same ? prev : next;
    });
    setLoading(false);
  };

  useEffect(() => {
    refresh(true);
  }, [cwd]);
  useEffect(() => {
    const id = setInterval(refresh, config.refreshInterval);
    return () => clearInterval(id);
  }, [cwd]);

  useInput(
    (input) => {
      if (input === "r") refresh();
      if (input === "W") {
        setExpandedSessions((prev) => {
          const allNames = sessions.map((s) => s.name);
          const allExpanded = allNames.every((n) => prev.has(n));
          return allExpanded ? new Set() : new Set(allNames);
        });
        setScrollToTopSignal((n) => n + 1);
      }
    },
    { isActive: focus === "sidebar" && !confirming },
  );

  const doDelete = async (sess: Session) => {
    const repoRoot = cwd ? await getRepoRoot(cwd) : null;
    setStatus(`Deleting ${sess.name}...`);
    await killSession(sess.name);
    const messages = [`Killed session: ${sess.name}`];
    if (repoRoot && sess.worktreePath && sess.branch) {
      const wtResult = await removeWorktree(repoRoot, sess.worktreePath);
      if (wtResult.isOk()) {
        messages.push(`Removed worktree: ${sess.branch}`);
        const brResult = await deleteBranch(repoRoot, sess.branch, false);
        if (brResult.isErr()) await deleteBranch(repoRoot, sess.branch, true);
      } else {
        messages.push(`Could not remove worktree: ${wtResult.error}`);
      }
    }
    await clearAllNotifications(sess.name);
    setStatus(messages.join("\n"));
    await refresh();
  };

  const handleSelect = async (item: ListItem) => {
    const sess = item.session;
    if (item.kind === "notif") {
      setStatus(`Opening ${sess.name}:${item.notif.windowName}...`);
      await clearWindowNotification(sess.name, item.notif.windowIndex, item.notif.type);
      await openWindow(sess.name, item.notif.windowIndex);
      setStatus("");
      await refresh();
      return;
    }
    if (item.kind === "window") {
      setStatus(`Opening ${sess.name}:${item.window.name}...`);
      await openWindow(sess.name, item.window.index);
      setStatus("");
      return;
    }
    const dir = sess.worktreePath ?? process.env.HOME ?? "/";
    setStatus(`Opening ${sess.name}...`);
    await openWorktreeSession(sess.name, dir);
    setStatus("");
  };

  const handleKeyAction = async (key: string, item: ListItem) => {
    if (confirming) return;
    const sess = item.session;

    if (item.kind === "notif") {
      if (key === "x") {
        await clearWindowNotification(sess.name, item.notif.windowIndex, item.notif.type);
        await refresh();
      }
      return;
    }

    if (item.kind === "window") return;

    // session row
    if (key === "w") {
      setExpandedSessions((prev) => {
        const next = new Set(prev);
        if (next.has(sess.name)) next.delete(sess.name);
        else next.add(sess.name);
        return next;
      });
    } else if (key === "p") {
      const dir = sess.worktreePath ?? process.env.HOME ?? "/";
      setStatus(`Opening pane for ${sess.name}...`);
      await openWorktreePane(sess.name, dir);
      setStatus("");
    } else if (key === "d") {
      setConfirming(sess);
    } else if (key === "x") {
      await clearAllNotifications(sess.name);
      await refresh();
    }
  };

  const items: ListItem[] = sessions.flatMap((session) => [
    { kind: "session", session } as SessionRow,
    ...session.notifications.map((notif) => ({ kind: "notif", session, notif }) as NotifRow),
    ...(expandedSessions.has(session.name)
      ? session.windows.map((window) => ({ kind: "window", session, window }) as WindowRow)
      : []),
  ]);

  if (loading) return <Text color="yellow">Loading sessions...</Text>;

  return (
    <Box flexDirection="column" height="100%">
      <Box flexGrow={1} flexDirection="column" overflow="hidden">
        <SelectList
          panel="sidebar"
          disabled={!!confirming}
          items={items}
          searchValue={(item) => item.session.name}
          onSelect={handleSelect}
          onKeyAction={handleKeyAction}
          emptyText="No active sessions"
          scrollToTopSignal={scrollToTopSignal}
          renderItem={(item, { isCursor }) => {
            if (item.kind === "notif") {
              const { notif } = item;
              return (
                <Box>
                  <Text>{isCursor ? "> " : "  "}</Text>
                  <Text dimColor> </Text>
                  <Text color={notif.type === "notify" ? "red" : "yellow"}>
                    {notif.type === "notify" ? "[!]" : "[?]"}
                  </Text>
                  <Text color={isCursor ? "magenta" : "white"}> {notif.windowName}</Text>
                  {notif.paneTitle && <Text dimColor>: {notif.paneTitle}</Text>}
                </Box>
              );
            }

            if (item.kind === "window") {
              const { window: win } = item;
              return (
                <Box>
                  <Text>{isCursor ? "> " : "  "}</Text>
                  <Text dimColor> </Text>
                  <Text color={isCursor ? "magenta" : "white"}>{win.name}</Text>
                  {win.paneTitle && <Text dimColor>: {win.paneTitle}</Text>}
                </Box>
              );
            }

            const { session: sess } = item;
            const isExpanded = expandedSessions.has(sess.name);
            const maxName = 39 - (sess.isDirty ? 6 : 0) - (sess.isOrphan ? 7 : 0) - 2;
            const name =
              sess.name.length > maxName ? sess.name.slice(0, maxName - 1) + "…" : sess.name;
            return (
              <Box>
                <Text color={isCursor ? "magenta" : undefined}>{isCursor ? "> " : "  "}</Text>
                <Text color={isCursor ? "magenta" : undefined} bold={isCursor}>
                  {name}
                </Text>
                {sess.isDirty && <Text color="yellow"> dirty</Text>}
                {sess.isOrphan && <Text color="red"> orphan</Text>}
                <Text dimColor> {isExpanded ? "▾" : "▸"}</Text>
              </Box>
            );
          }}
        />
      </Box>
      {confirming ? (
        <Confirm
          message={`Delete ${confirming.name}?`}
          panel="sidebar"
          onConfirm={() => {
            doDelete(confirming);
            setConfirming(null);
          }}
          onCancel={() => setConfirming(null)}
        />
      ) : (
        <Box marginTop={1}>
          <Text dimColor>↵ open p pane w/W windows d del x clear</Text>
        </Box>
      )}
      {status && (
        <Box marginTop={1}>
          <Text color="yellow">{status}</Text>
        </Box>
      )}
    </Box>
  );
}
