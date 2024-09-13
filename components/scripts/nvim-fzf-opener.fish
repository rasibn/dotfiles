#!/usr/bin/env fish

function command_exists
    command -v $argv[1] >/dev/null 2>&1
end

# Update search paths if a directory argument is provided
if test -n "$argv[1]"
    if command_exists fd
        set FILE (fd --type f --search-path "$argv[1]" --follow --hidden --exclude .git | fzf)
    else
        set FILE (find "$argv[1]" -type f | fzf)
    end
else
    if command_exists fd
        set FILE (fd --type f --search-path $PROJECT_DIR --search-path $WORK_DIR --search-path $ASSET_DIR --follow --hidden --exclude .git | fzf)
    else
        set FILE (find $PROJECT_DIR $WORK_DIR $ASSET_DIR -type f | fzf)
    end
end

# Check if a file was selected
if test -z "$FILE"
    echo "No file selected."
    exit 1
else
    nvim "$FILE"
end
