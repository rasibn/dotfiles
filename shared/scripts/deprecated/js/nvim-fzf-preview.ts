#!/usr/bin/env bun
import { $ } from "bun";

main().catch((error) => {
  console.error('An unexpected error occurred:', error.message);
  process.exit(1);
});

async function main() {
  const config = getScriptConfig();
  const deps = await checkDependencies();

  try {
    let result: string;

    if (deps.hasFd) {
      const pathsToSearch = config.searchPath ? [config.searchPath] : config.defaultSearchDirs;
      const fdArgs = pathsToSearch.flatMap(p => ['--search-path', p]);
      const fileListCmd = ['fd', '--type', 'f', ...fdArgs, '--follow', '--hidden', '--exclude', '.git'];
      const fzfArgs = buildFzfArgs(deps.hasBat);

      result = await $`${fileListCmd} | fzf ${fzfArgs}`.text();
    } else {
      const pathsToSearch = config.searchPath ? [config.searchPath] : config.defaultSearchDirs;
      const fzfArgs = buildFzfArgs(deps.hasBat);

      result = await $`find ${pathsToSearch} -type f | fzf ${fzfArgs}`.text();
    }

    const selectedFile = result.trim();
    if (selectedFile) {
      await $`nano ${selectedFile}`;
    } else {
      console.log('No file selected.');
      process.exit(1);
    }
  } catch (error) {
    console.log('No file selected.');
    process.exit(1);
  }
}

function getScriptConfig(): { searchPath: string; defaultSearchDirs: string[]; } {
  const searchPath = process.argv[2];
  const PROJECT_DIR = process.env.PROJECT_DIR || '.';
  const WORK_DIR = process.env.WORK_DIR || '.';
  const ASSET_DIR = process.env.ASSET_DIR || '.';

  return {
    searchPath,
    defaultSearchDirs: [PROJECT_DIR, WORK_DIR, ASSET_DIR],
  };
}

async function commandExists(command: string): Promise<boolean> {
  try {
    await $`command -v ${command}`.quiet();
    return true;
  } catch {
    return false;
  }
}

async function checkDependencies(): Promise<{ hasFd: boolean; hasBat: boolean; }> {
  const [hasFd, hasBat] = await Promise.all([
    commandExists('fd'),
    commandExists('bat'),
  ]);

  return { hasFd, hasBat };
}

function buildFzfArgs(hasBat: boolean): string[] {
  if (hasBat) {
    return [
      '--ansi',
      '--preview-window', 'right:45%',
      '--preview', 'bat --color=always --style=header,grid --line-range :300 {}'
    ];
  }
  return [];
}
