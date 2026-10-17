function prdiff -d "Open the current PR's changes in Zed"
    if not command -q zeditor
        echo "zeditor is not installed"
        return 1
    end

    set repo_root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$repo_root"
        echo "Not inside a Git repository"
        return 1
    end

    set base_branch (gh pr view --json baseRefName --jq .baseRefName 2>/dev/null)
    if test -z "$base_branch"
        echo "Could not determine the PR base branch"
        return 1
    end

    git fetch --no-tags origin "$base_branch"
    or return 1

    set base_dir (mktemp -d)
    git archive "origin/$base_branch" | tar -x -C "$base_dir"
    if test $status -ne 0
        rm -rf "$base_dir"
        return 1
    end

    zeditor --wait --diff "$base_dir" "$repo_root"
    set editor_status $status
    rm -rf "$base_dir"
    return $editor_status
end
