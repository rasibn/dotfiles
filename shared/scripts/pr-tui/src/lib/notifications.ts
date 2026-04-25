import { exec } from "./exec.js";
import type { ClaudeNotification, TmuxWindow } from "./types.js";

export function getSessionNotifications(
  sessionName: string,
  windows: TmuxWindow[],
): ClaudeNotification[] {
  const stopFiles = Array.from(
    new Bun.Glob(`/tmp/claude-stop-${sessionName}-*`).scanSync(),
  ) as string[];
  const notifyFiles = Array.from(
    new Bun.Glob(`/tmp/claude-notify-${sessionName}-*`).scanSync(),
  ) as string[];

  const windowIndices = new Set<number>();
  const windowTypes = new Map<number, "stop" | "notify">();

  for (const f of notifyFiles) {
    const idx = parseInt(f.split("-").pop()!);
    if (!isNaN(idx)) {
      windowIndices.add(idx);
      windowTypes.set(idx, "notify");
    }
  }
  for (const f of stopFiles) {
    const idx = parseInt(f.split("-").pop()!);
    if (!isNaN(idx) && !windowTypes.has(idx)) {
      windowIndices.add(idx);
      windowTypes.set(idx, "stop");
    }
  }

  if (windowIndices.size === 0) return [];

  const windowMap = new Map(windows.map((w) => [w.index, w]));

  return Array.from(windowIndices)
    .sort()
    .map((idx) => {
      const w = windowMap.get(idx);
      return {
        windowIndex: idx,
        windowName: w?.name ?? `window ${idx}`,
        paneTitle: w?.paneTitle ?? null,
        type: windowTypes.get(idx)!,
      };
    });
}

export function getAllNotificationFlags(): Map<string, "stop" | "notify"> {
  const map = new Map<string, "stop" | "notify">();
  for (const f of new Bun.Glob("/tmp/claude-notify-*").scanSync()) {
    const parts = (f as string).replace("/tmp/claude-notify-", "").split("-");
    const sessionName = parts.slice(0, -1).join("-");
    if (sessionName) map.set(sessionName, "notify");
  }
  for (const f of new Bun.Glob("/tmp/claude-stop-*").scanSync()) {
    const parts = (f as string).replace("/tmp/claude-stop-", "").split("-");
    const sessionName = parts.slice(0, -1).join("-");
    if (sessionName && !map.has(sessionName)) map.set(sessionName, "stop");
  }
  return map;
}

export async function clearWindowNotification(
  sessionName: string,
  windowIndex: number,
  type: "stop" | "notify",
): Promise<void> {
  await exec(["rm", "-f", `/tmp/claude-${type}-${sessionName}-${windowIndex}`]);
}

export async function clearAllNotifications(sessionName: string): Promise<void> {
  await exec([
    "bash",
    "-c",
    `rm -f /tmp/claude-stop-${sessionName}-* /tmp/claude-notify-${sessionName}-*`,
  ]);
}
