---
name: inspect-prtui
description: Launch prtui in a throwaway tmux session and read its rendered output as plain text, so layout and rendering bugs can be debugged hands-off.
trigger: When debugging prtui rendering, layout, viewport, or "entries missing / not showing" issues, or to see what prtui actually displays.
user-invocable: true
tags: [prtui, tui, ink, tmux, debugging]
---

# Inspect prtui

prtui needs a real PTY, refuses to run outside tmux, and paints to the alternate
screen — piping it gives escape soup. tmux solves all three; `capture-pane`
returns the rendered grid as text.

## Capture

```bash
REPO=/path/to/repo
PRTUI=/Users/rasib.nadeem/assets/dotfiles/shared/scripts/pr-tui/src/cli.tsx
tmux kill-session -t prtui_dbg 2>/dev/null
tmux new-session -d -s prtui_dbg -x 145 -y 41 -c "$REPO" "bun run $PRTUI $REPO"
sleep 9   # under ~8s you capture "Loading branches..."
tmux capture-pane -p -t prtui_dbg | sed 's/^ │[^│]*│ │//' | cat -n
tmux kill-session -t prtui_dbg
```

Always a throwaway session (never the user's `manager`), always pinned geometry
— layout bugs are size-dependent and detached sessions default to 80x24.
`send-keys` drives it between captures: `r` refresh, `j`/`k`, `h`/`l` tabs, `q`.

## Collapsed rows

The signature bug: Ink collapses a column Box's children onto one row when handed
more rows than fit, so a name and its `───` separator share a line.

```bash
tmux capture-pane -p -t prtui_dbg | sed 's/^ │[^│]*│ │//' | grep -nE "[a-zA-Z0-9](─{3,})"
```

Empty output = clean. Check heights 41/50/60 — it only appears once items exceed
the viewport, so one tall run hides it.

## Is it data or paint?

Call the pure path directly; if entries are right, the bug is in rendering.

```ts
import { listBranches } from "<abs>/src/lib/git.js";
import { listPRs, getCurrentUser } from "<abs>/src/lib/gh.js";
import { mergeBranchesWithPRs } from "<abs>/src/lib/branch-entries.js";
const [b, p, u] = await Promise.all([listBranches(cwd), listPRs(cwd), getCurrentUser(cwd)]);
console.log(mergeBranchesWithPRs(b, p.isOk() ? p.value : [], u, "mine"));
```

Imports must be absolute (scratchpad scripts resolve relative paths against
themselves), and run it from inside pr-tui so bun picks the pinned React 18.

## Invariants

- `app.tsx` passes `mainListHeight`, not `mainHeight`. `mainChrome = 7` = border 2
  + repo header 1 + tabs 2 (`marginBottom={1}`) + footer 1 + `[n of m]` 1. Update
  it when chrome changes; overshooting collapses rows and looks like missing data.
- `itemLines` must mirror `renderItem` exactly — divergence accumulates and pushes
  items out of view.
- Row children need explicit shrink: title `flexShrink={1}`, badges
  `flexShrink={0}`, or long titles push badges past the edge and wrap the row.
