export interface LocalBranch {
  name: string;
  isCurrent: boolean;
  hasWorktree: boolean;
  commitAuthor?: string;
  commitsAhead: number;
  commitsBehind: number;
  isRemoteGone: boolean;
}

export interface BranchEntry {
  name: string;
  isCurrent: boolean;
  hasWorktree: boolean;
  prNumber?: number;
  prTitle?: string;
  commitsAhead: number;
  commitsBehind: number;
  isRemote: boolean;
  isRemoteGone: boolean;
  unresolvedComments: number;
}

export interface PR {
  number: number;
  title: string;
  headRefName: string;
  author: string;
  labels: string[];
  unresolvedComments: number;
}

export interface Worktree {
  path: string;
  branch: string;
  safeName: string;
  isDirty: boolean;
  isRemoteGone: boolean;
}

export interface TmuxWindow {
  index: number;
  name: string;
  paneTitle: string | null;
}

export interface ClaudeNotification {
  windowIndex: number;
  windowName: string;
  paneTitle: string | null;
  type: "stop" | "notify";
}

export interface Session {
  name: string;
  branch: string | null;
  prNumber: number | null;
  prTitle: string | null;
  worktreeName: string | null;
  worktreePath: string | null;
  isDirty: boolean;
  isOrphan: boolean;
  windows: TmuxWindow[];
  notifications: ClaudeNotification[];
  paneBranches: string[];
}
