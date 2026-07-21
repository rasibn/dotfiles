import { existsSync, readFileSync } from "fs";
import { homedir } from "os";
import { join } from "path";

export interface Config {
  sidebarWidth: number;
  verticalBreakpoint: number;
  refreshInterval: number;
  defaultFocus: "sidebar" | "main";
}

const DEFAULTS: Config = {
  sidebarWidth: 55,
  verticalBreakpoint: 90,
  refreshInterval: 2000,
  defaultFocus: "sidebar",
};

const CONFIG_PATH = join(homedir(), ".config", "pr-tui", "config.json");

function loadConfig(): Config {
  if (!existsSync(CONFIG_PATH)) return DEFAULTS;
  try {
    const raw = JSON.parse(readFileSync(CONFIG_PATH, "utf8"));
    return { ...DEFAULTS, ...raw };
  } catch {
    return DEFAULTS;
  }
}

export const config = loadConfig();
