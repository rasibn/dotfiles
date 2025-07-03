#!/usr/bin/env python3

import os
import sys

from subprocess import Popen, PIPE, CalledProcessError
from library import pipe, panic, command_exists
from typing import List, Optional


def get_search_directories(extra_dirs: Optional[List[str]]) -> List[str]:
    """Get list of directories to search in."""
    # Default environment directories
    project_dir = os.environ.get("PROJECT_DIR", "")
    work_dir = os.environ.get("WORK_DIR", "")
    asset_dir = os.environ.get("ASSET_DIR", "")

    search_dirs = []

    # Add environment directories if they exist
    for env_dir in [project_dir, work_dir, asset_dir]:
        if env_dir and os.path.exists(env_dir):
            search_dirs.append(env_dir)

    # Add extra directories if provided
    if extra_dirs:
        for extra_dir in extra_dirs:
            if os.path.exists(extra_dir):
                search_dirs.append(extra_dir)
            else:
                print(
                    f"Warning: Directory '{extra_dir}' does not exist, skipping.",
                    file=sys.stderr,
                )

    return search_dirs


def find_directories_recursive(search_dirs: List[str]) -> List[str]:
    """Find all directories recursively in the given search directories."""
    dirs = []

    if command_exists("fd"):
        # Use fd for directory discovery (faster and more features)
        try:
            for search_dir in search_dirs:
                result = pipe(["fd", ".", "--type", "d", search_dir])
                if result:
                    dirs.extend(result.split("\n"))
        except (CalledProcessError, FileNotFoundError):
            # Fall back to find if fd fails
            pass

    if not dirs:
        # Use find as fallback
        try:
            find_cmd = ["find"] + search_dirs + ["-type", "d"]
            result = pipe(find_cmd)
            if result:
                dirs = result.split("\n")
        except (CalledProcessError, FileNotFoundError):
            pass

    # Remove duplicates and empty strings, sort for consistency
    unique_dirs = sorted(list(set(d for d in dirs if d.strip())))
    return unique_dirs


def select_directory_with_fzf(dirs: List[str]) -> Optional[str]:
    """Use fzf to select a directory from the list."""
    if not command_exists("fzf"):
        panic("ERROR: fzf is not installed. Please install fzf first.")

    if not dirs:
        panic("ERROR: No directories found to select from.")

    try:
        # Create fzf process with nice options
        fzf_proc = Popen(
            [
                "fzf",
                "--prompt",
                "Select directory: ",
                "--height",
                "40%",
                "--reverse",
                "--border",
            ],
            stdin=PIPE,
            stdout=PIPE,
            text=True,
        )

        selected, _ = fzf_proc.communicate("\n".join(dirs))

        if fzf_proc.returncode == 0:
            return selected.strip()
        else:
            return None
    except (CalledProcessError, FileNotFoundError):
        panic("ERROR: Failed to run fzf")


def change_directory(target_dir: str) -> None:
    """Change to the target directory."""
    try:
        os.chdir(target_dir)
        print(f"Changed to: {target_dir}")

        # Print the new working directory
        print(f"Current directory: {os.getcwd()}")

        # Optional: Launch a new shell in the directory
        # This allows the cd to persist after the script exits
        shell = os.environ.get("SHELL", "/bin/bash")
        os.execvp(shell, [shell])

    except (OSError, FileNotFoundError) as e:
        panic(f"ERROR: Cannot change to directory '{target_dir}': {e}")


def main():
    """Main function to handle smart cd functionality."""
    args = sys.argv[1:]

    # Parse arguments - first arg is target directory, rest are additional search paths
    target_dir = None
    extra_dirs = []

    if args:
        # First argument is the target directory
        target_dir = args[0]
        # Rest are additional search directories
        extra_dirs = args[1:]

    # Expand user paths in additional directories
    extra_dirs = [os.path.expanduser(d) for d in extra_dirs]

    # If a directory is specified, try to cd to it first
    if target_dir:
        expanded_target = os.path.expanduser(target_dir)

        # Check if it's a relative or absolute path that exists
        if os.path.exists(expanded_target) and os.path.isdir(expanded_target):
            change_directory(expanded_target)
            return

        # If not found, search for it in the search directories
        search_dirs = get_search_directories(extra_dirs)

        if not search_dirs:
            panic(
                "ERROR: No search directories available. Set PROJECT_DIR, WORK_DIR, ASSET_DIR environment variables or provide additional search paths"
            )

        print(
            f"Directory '{target_dir}' not found locally, searching in configured directories..."
        )
        all_dirs = find_directories_recursive(search_dirs)

        # Filter directories that contain the target name
        matching_dirs = [d for d in all_dirs if target_dir in os.path.basename(d)]

        if not matching_dirs:
            print(
                f"No directories matching '{target_dir}' found, showing all directories..."
            )
            matching_dirs = all_dirs

        # Use fzf to select from matching directories
        selected = select_directory_with_fzf(matching_dirs)

        if selected:
            change_directory(selected)
        else:
            print("No directory selected.")

    else:
        # No directory specified, show all directories for selection
        search_dirs = get_search_directories(extra_dirs)

        if not search_dirs:
            panic(
                "ERROR: No search directories available. Set PROJECT_DIR, WORK_DIR, ASSET_DIR environment variables or provide additional search paths"
            )

        print("Finding directories...")
        all_dirs = find_directories_recursive(search_dirs)

        selected = select_directory_with_fzf(all_dirs)

        if selected:
            change_directory(selected)
        else:
            print("No directory selected.")


if __name__ == "__main__":
    main()
