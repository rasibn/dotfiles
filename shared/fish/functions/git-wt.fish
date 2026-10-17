function git-wt -d "Create or enter a Git worktree"
    set target_dir ..

    if test (count $argv) -ge 2
        if test $argv[1] = "--path"
            set target_dir $argv[2]
        else
            echo "Usage: git-wt [--path DIR]"
            return 1
        end
    end

    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "❌ Not inside a Git repo."
        return 1
    end

    set repo_name (basename (git rev-parse --show-toplevel))
    set branches (git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | sort | uniq | grep -vE '^HEAD$')
    if test (count $branches) -eq 0
        echo "No branches found."
        return 1
    end

    set branch (printf "%s\n" $branches | fzf --prompt="Select branch> ")
    if test -z "$branch"
        echo "Aborted."
        return 0
    end

    set branch_sanitized (string replace -a '/' '-' $branch)
    set final_dir "$target_dir/$repo_name.$branch_sanitized"

    if test -d "$final_dir"
        echo "✅ Worktree already exists: $final_dir"
    else
        echo "🛠️  Creating worktree for '$branch'"
        git worktree add "$final_dir" "$branch"
    end

    cd "$final_dir"
    eval "$EDITOR ."
end
