function pr-review -d "Select an open PR and review it in Zed or Neovim"
    set repo_root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$repo_root"
        echo "Not inside a Git repository"
        return 1
    end

    set selected (gh pr list \
        --limit 50 \
        --json number,headRefName,title \
        --template '{{range .}}{{.number}}\t{{.headRefName}}\t{{.title}}{{"\n"}}{{end}}' | \
        fzf \
        --delimiter="\t" \
        --with-nth=1,2,3 \
        --prompt="PR> " \
        --query=(string join ' ' -- $argv) \
        --preview='gh pr view {1}' \
        --preview-window=right:60%)
    or return

    set pr_parts (string split -m 2 \t -- $selected)
    set pr_number $pr_parts[1]
    set branch $pr_parts[2]
    set safe_branch (string replace -a '/' '-' -- $branch)
    set worktree_path "$repo_root/.claude/worktrees/pr-$pr_number-$safe_branch"

    set existing_path (git worktree list --porcelain | awk -v target="refs/heads/$branch" '
        /^worktree / { path = substr($0, 10) }
        $1 == "branch" && $2 == target { print path }
    ')
    if test -n "$existing_path"
        set worktree_path $existing_path
    else
        mkdir -p "$repo_root/.claude/worktrees"
        if not git show-ref --verify --quiet "refs/heads/$branch"
            git fetch origin "$branch:$branch"
            or return 1
        end
        git worktree add "$worktree_path" "$branch"
        or return 1
    end

    set editor (printf "Zed\tzeditor\nNeovim\tnvim\n" | fzf \
        --delimiter="\t" \
        --with-nth=1 \
        --prompt="Review in> ")
    or return
    set editor_parts (string split -m 1 \t -- $editor)

    if test "$editor_parts[2]" = zeditor
        zeditor --diff "$repo_root" "$worktree_path"
    else
        nvim --cmd "cd $worktree_path" -c PRReview
    end
end
