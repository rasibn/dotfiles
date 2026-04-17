export interface Branch {
  name: string;
  isCurrent: boolean;
  hasWorktree: boolean;
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
