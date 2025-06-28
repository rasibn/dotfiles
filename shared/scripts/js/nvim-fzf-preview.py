#!/usr/bin/env python3
import subprocess
import sys
import os
from typing import List, Dict
import shutil


def main():
    """Main function that orchestrates the file finding and editing process."""
    try:
        paths = get_search_paths()
        deps = check_dependencies()

        try:
            selected_file = find_file(deps["has_fd"], paths, deps).strip()
            if len(selected_file) != 0:
                subprocess.run(["nvim", selected_file], check=True)
            else:
                print("No file selected.")
                sys.exit(1)

        except (subprocess.CalledProcessError, KeyboardInterrupt):
            print("No file selected.")
            sys.exit(1)

    except Exception as error:
        print(f"An unexpected error occurred: {error}")
        sys.exit(1)


def get_search_paths() -> list[str]:
    """Get configuration from command line arguments and environment variables."""
    search_path = [sys.argv[1]] if len(sys.argv) > 1 else []

    project_dir = os.environ.get("PROJECT_DIR", ".")
    work_dir = os.environ.get("WORK_DIR", ".")
    asset_dir = os.environ.get("ASSET_DIR", ".")

    search_path = search_path + [project_dir, work_dir, asset_dir]
    return search_path


def command_exists(command: str) -> bool:
    """Check if a command exists in the system PATH."""
    return shutil.which(command) is not None


def check_dependencies() -> Dict[str, bool]:
    """Check for the availability of optional dependencies."""
    return {
        "has_fd": command_exists("fd"),
        "has_bat": command_exists("bat"),
        "has_fzf": command_exists("fzf"),
    }


def build_fzf_args(has_bat: bool) -> List[str]:
    """Build fzf arguments based on available dependencies."""
    if has_bat:
        return [
            "--ansi",
            "--preview-window",
            "right:45%",
            "--preview",
            "bat --color=always --style=header,grid --line-range :300 {}",
        ]
    return []


def find_file(with_fd: bool, paths_to_search: list[str], deps: Dict[str, bool]) -> str:
    """Find files using fd command."""
    # Build fd command
    if with_fd:
        command = ["fd", "--type", "f"]
        for path in paths_to_search:
            command.extend(["--search-path", path])
        command.extend(["--follow", "--hidden", "--exclude", ".git"])
    else:
        command = ["find"] + paths_to_search + ["-type", "f"]

    # Build fzf command
    fzf_args = ["fzf"] + build_fzf_args(deps["has_bat"])

    # Run fd piped to fzf
    fd_process = subprocess.Popen(command, stdout=subprocess.PIPE, text=True)
    fzf_process = subprocess.Popen(
        fzf_args, stdin=fd_process.stdout, stdout=subprocess.PIPE, text=True
    )

    # Close fd stdout in parent process
    if fd_process.stdout:
        fd_process.stdout.close()

    # Get the result
    result, _ = fzf_process.communicate()

    # Wait for fd to complete and check return codes
    fd_process.wait()
    if fzf_process.returncode != 0:
        raise subprocess.CalledProcessError(fzf_process.returncode, "fzf")

    return result


if __name__ == "__main__":
    main()
