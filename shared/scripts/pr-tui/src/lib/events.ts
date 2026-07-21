import { appendFileSync, readFileSync, mkdirSync } from "fs";
import { join } from "path";
import { homedir } from "os";

const EVENTS_LOG = join(homedir(), ".config", "pr-tui", "events.log");

export interface EventEntry {
  action:
    | "delete_branch"
    | "delete_worktree"
    | "create_branch"
    | "open_branch"
    | "kill_session"
    | "remove_worktree";
  branch?: string;
  sessionName?: string;
  worktreePath?: string;
  cwd: string;
}

function formatEvent(entry: EventEntry): string {
  const now = new Date();
  const time = now.toLocaleTimeString("en-US", {
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hour12: false,
  });

  const parts: string[] = [time];

  switch (entry.action) {
    case "delete_branch":
      parts.push(`Deleted branch ${entry.branch}`);
      break;
    case "create_branch":
      parts.push(`Created branch ${entry.branch}`);
      break;
    case "open_branch":
      if (entry.worktreePath) {
        parts.push(`Opened branch ${entry.branch} (worktree: ${entry.worktreePath})`);
      } else {
        parts.push(`Opened branch ${entry.branch}`);
      }
      break;
    case "kill_session":
      parts.push(`Killed session ${entry.sessionName}`);
      break;
    case "remove_worktree":
      parts.push(`Removed worktree ${entry.worktreePath}`);
      break;
  }

  parts.push(`in ${entry.cwd}`);
  return parts.join(" ");
}

export function logEvent(entry: EventEntry): void {
  try {
    const dir = join(homedir(), ".config", "pr-tui");
    mkdirSync(dir, { recursive: true });
    const line = formatEvent(entry);
    appendFileSync(EVENTS_LOG, line + "\n");
  } catch {
    // silently fail if we can't write
  }
}

export function readEvents(limit = 50): string[] {
  try {
    const content = readFileSync(EVENTS_LOG, "utf8");
    const lines = content.split("\n").filter(Boolean);
    return lines.slice(-limit);
  } catch {
    return [];
  }
}
