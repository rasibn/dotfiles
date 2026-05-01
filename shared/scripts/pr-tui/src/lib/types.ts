export interface Branch {
  name: string;
  isCurrent: boolean;
  hasWorktree: boolean;
  commitAuthor?: string;
}

export interface PR {
  number: number;
  title: string;
  headRefName: string;
  author: string;
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
  worktreePath: string | null;
  isDirty: boolean;
  isOrphan: boolean;
  windows: TmuxWindow[];
  notifications: ClaudeNotification[];
}
