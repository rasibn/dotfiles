import type { BranchEntry, LocalBranch, PR } from "./types.js";

export type OwnershipFilter = "mine" | "other";

export function mergeBranchesWithPRs(
  localBranches: LocalBranch[],
  prs: PR[],
  currentUser: string | null,
  ownership: OwnershipFilter,
): BranchEntry[] {
  const prsByBranch = new Map(prs.map((pr) => [pr.headRefName, pr] as const));
  const localBranchNames = new Set(localBranches.map((branch) => branch.name));
  const entries: BranchEntry[] = [
    ...localBranches.map((branch) => {
      const pr = prsByBranch.get(branch.name);
      return {
        ...branch,
        isRemote: false,
        unresolvedComments: pr?.unresolvedComments ?? 0,
        ...(pr && { prNumber: pr.number, prTitle: pr.title }),
      };
    }),
    ...prs
      .filter((pr) => !localBranchNames.has(pr.headRefName))
      .map((pr) => ({
        name: pr.headRefName,
        isCurrent: false,
        hasWorktree: false,
        prNumber: pr.number,
        prTitle: pr.title,
        commitsAhead: 0,
        commitsBehind: 0,
        isRemote: true,
        isRemoteGone: false,
        unresolvedComments: pr.unresolvedComments,
      })),
  ];

  return entries
    .filter((entry) => {
      const pr = prsByBranch.get(entry.name);
      const isMine = !pr || (currentUser !== null && pr.author === currentUser);
      return ownership === "mine" ? isMine : !isMine;
    })
    .sort((a, b) => {
      const category = (entry: BranchEntry) => (entry.isRemote ? 2 : entry.prTitle ? 1 : 0);
      return category(a) - category(b);
    });
}
