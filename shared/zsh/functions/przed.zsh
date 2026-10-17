przed() {
    if ! command -v zeditor >/dev/null 2>&1; then
        echo "zeditor is not installed"
        return 1
    fi

    local repo_root branch base_branch base_dir editor_status
    repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
        echo "Not inside a Git repository"
        return 1
    }

    branch=$(git branch --show-current)
    if (( $# > 0 )); then
        base_branch=$(gh pr view "$1" --json baseRefName --jq .baseRefName 2>/dev/null)
    else
        base_branch=$(gh pr view --json baseRefName --jq .baseRefName 2>/dev/null)
    fi
    if [[ -z "$base_branch" ]]; then
        echo "No pull request found for branch '$branch'"
        return 1
    fi

    git fetch --no-tags origin "$base_branch" || return 1

    base_dir=$(mktemp -d) || return 1
    if ! git archive "origin/$base_branch" | tar -x -C "$base_dir"; then
        rm -rf "$base_dir"
        return 1
    fi

    zeditor --wait --diff "$base_dir" "$repo_root"
    editor_status=$?
    rm -rf "$base_dir"
    return $editor_status
}
