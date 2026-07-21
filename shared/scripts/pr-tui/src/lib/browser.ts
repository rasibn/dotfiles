import { spawn } from "child_process";

export function openInBrowser(url: string): Promise<void> {
  return new Promise((resolve) => {
    const cmd =
      process.platform === "darwin" ? "open" : process.platform === "win32" ? "start" : "xdg-open";
    const proc = spawn(cmd, [url], { detached: true });
    proc.unref();
    setTimeout(resolve, 100);
  });
}

export function prToGithubUrl(remoteUrl: string, prNumber: number): string {
  const repoUrl = remoteUrl
    .replace(/\.git$/, "")
    .replace(/^git@github\.com:/, "https://github.com/");
  return `${repoUrl}/pull/${prNumber}`;
}

export function branchToCompareUrl(remoteUrl: string, branch: string): string {
  const repoUrl = remoteUrl
    .replace(/\.git$/, "")
    .replace(/^git@github\.com:/, "https://github.com/");
  return `${repoUrl}/compare/main...${encodeURIComponent(branch)}?expand=1`;
}
