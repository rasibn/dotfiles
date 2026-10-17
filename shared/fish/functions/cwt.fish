function cwt -d "Select and enter an existing Git worktree"
    set repo_dir (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$repo_dir"
        echo "Not inside a Git repository"
        return 1
    end

    set worktrees (git -C "$repo_dir" worktree list --porcelain | awk '
        /^worktree / { path = substr($0, 10) }
        /^branch / {
            branch = substr($0, 8)
            sub(/^refs\/heads\//, "", branch)
            print branch "\t" path
        }
    ')

    if test (count $worktrees) -eq 0
        echo "No branch-backed worktrees found"
        return 1
    end

    set selected (printf "%s\n" $worktrees | fzf \
        --delimiter="\t" \
        --with-nth=1,2 \
        --prompt="worktree branch> " \
        --query=(string join ' ' -- $argv))
    or return

    set selected_parts (string split -m 1 \t -- $selected)
    cd -- $selected_parts[2]
end
