#!/usr/bin/env python3

import os
import sys
from pathlib import Path
from subprocess import Popen, PIPE, CalledProcessError
from typing import List, Optional
from library import pipe, panic, command_exists, check_call


def get_directories() -> List[str]:
    """Get list of directories from PROJECT_DIR, WORK_DIR, and ASSET_DIR."""
    project_dir = os.environ.get("PROJECT_DIR", "")
    work_dir = os.environ.get("WORK_DIR", "")
    asset_dir = os.environ.get("ASSET_DIR", "")

    search_dirs = [d for d in [project_dir, work_dir, asset_dir] if d]

    if not search_dirs:
        return []

    dirs = []

    if command_exists("fd"):
        try:
            for search_dir in search_dirs:
                if os.path.exists(search_dir):
                    result = pipe(
                        ["fd", ".", "--type", "d", "--max-depth", "1", search_dir]
                    )
                    if result:
                        dirs.extend(result.split("\n"))
        except (CalledProcessError, FileNotFoundError):
            pass

    if not dirs:
        # Use find as fallback
        try:
            find_cmd = (
                ["find"]
                + search_dirs
                + ["-mindepth", "1", "-maxdepth", "1", "-type", "d"]
            )
            result = pipe(find_cmd)
            if result:
                dirs = result.split("\n")
        except (CalledProcessError, FileNotFoundError):
            pass

    return [d for d in dirs if d.strip()]


def select_directory(dirs: List[str]) -> Optional[str]:
    """Use fzf to select a directory from the list."""
    if not command_exists("fzf"):
        panic("ERROR: fzf is not installed. Please install fzf first.")

    try:
        # Create fzf process
        fzf_proc = Popen(["fzf"], stdin=PIPE, stdout=PIPE, text=True)
        selected, _ = fzf_proc.communicate("\n".join(dirs))

        if fzf_proc.returncode == 0:
            return selected.strip()
        else:
            return None
    except (CalledProcessError, FileNotFoundError):
        panic("ERROR: Failed to run fzf")


def is_tmux_running() -> bool:
    """Check if tmux is running."""
    return check_call(["pgrep", "tmux"])


def tmux_has_session(session_name: str) -> bool:
    """Check if tmux session exists."""
    return check_call(["tmux", "has-session", "-t", session_name])


def create_tmux_session(
    session_name: str, directory: str, detached: bool = False
) -> None:
    """Create a tmux session with multiple windows."""
    # Create new session
    cmd = ["tmux", "new-session"]
    if detached:
        cmd.append("-d")
    cmd.extend(["-s", session_name, "-n", "nvim", "-c", directory])

    if check_call(cmd):
        # Create additional windows
        check_call(
            ["tmux", "new-window", "-t", session_name, "-n", "zsh", "-c", directory]
        )
        check_call(
            ["tmux", "new-window", "-t", session_name, "-n", "extra", "-c", directory]
        )

        # Send cd commands to ensure proper directory and prompt updates
        for window in ["nvim", "zsh", "extra"]:
            check_call(
                [
                    "tmux",
                    "send-keys",
                    "-t",
                    f"{session_name}:{window}",
                    f"cd '{directory}'",
                    "Enter",
                ]
            )
    else:
        panic(f"ERROR: Failed to create tmux session '{session_name}'")


def main():
    """Main function to handle tmux session management."""
    # Check if directory was provided as argument
    if len(sys.argv) == 2:
        selected = sys.argv[1]
    else:
        # Get directories and let user select
        dirs = get_directories()

        if not dirs:
            panic("ERROR: No directories found in specified paths.")

        selected = select_directory(dirs)

        if not selected:
            sys.exit(0)

    # Get session name from directory basename
    selected_name = Path(selected).name.replace(".", "_")

    # Check tmux state
    tmux_running = is_tmux_running()
    in_tmux = bool(os.environ.get("TMUX"))

    # If not in tmux and tmux is not running, create and attach directly
    if not in_tmux and not tmux_running:
        create_tmux_session(selected_name, selected, detached=False)
        return

    # Create session if it doesn't exist
    if not tmux_has_session(selected_name):
        create_tmux_session(selected_name, selected, detached=True)

    # Attach or switch to session
    if not in_tmux:
        # Not in tmux, attach to session
        os.execvp("tmux", ["tmux", "attach-session", "-t", selected_name])
    else:
        # In tmux, switch to session
        os.execvp("tmux", ["tmux", "switch-client", "-t", selected_name])


main()
