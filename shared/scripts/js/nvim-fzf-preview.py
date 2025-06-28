#!/usr/bin/env python3
import subprocess
import sys
import os
from typing import List, Dict
import shutil


def main():
    """Main function that orchestrates the file finding and editing process."""
    try:
        config = get_script_config()
        deps = check_dependencies()

        try:
            if deps["has_fd"]:
                result = find_files_with_fd(config, deps)
            else:
                result = find_files_with_find(config, deps)

            selected_file = result.strip()
            if selected_file:
                subprocess.run(["nano", selected_file], check=True)
            else:
                print("No file selected.")
                sys.exit(1)

        except (subprocess.CalledProcessError, KeyboardInterrupt):
            print("No file selected.")
            sys.exit(1)

    except Exception as error:
        print(f"An unexpected error occurred: {error}")
        sys.exit(1)


def get_script_config() -> Dict[str, any]:
    """Get configuration from command line arguments and environment variables."""
    search_path = sys.argv[1] if len(sys.argv) > 1 else None

    project_dir = os.environ.get("PROJECT_DIR", ".")
    work_dir = os.environ.get("WORK_DIR", ".")
    asset_dir = os.environ.get("ASSET_DIR", ".")

    return {
        "search_path": search_path,
        "default_search_dirs": [project_dir, work_dir, asset_dir],
    }


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


def find_files_with_fd(config: Dict[str, any], deps: Dict[str, bool]) -> str:
    """Find files using fd command."""
    paths_to_search = (
        [config["search_path"]]
        if config["search_path"]
        else config["default_search_dirs"]
    )

    # Build fd command
    fd_args = ["fd", "--type", "f"]
    for path in paths_to_search:
        fd_args.extend(["--search-path", path])
    fd_args.extend(["--follow", "--hidden", "--exclude", ".git"])

    # Build fzf command
    fzf_args = ["fzf"] + build_fzf_args(deps["has_bat"])

    # Run fd piped to fzf
    fd_process = subprocess.Popen(fd_args, stdout=subprocess.PIPE, text=True)
    fzf_process = subprocess.Popen(
        fzf_args, stdin=fd_process.stdout, stdout=subprocess.PIPE, text=True
    )

    # Close fd stdout in parent process
    fd_process.stdout.close()

    # Get the result
    result, _ = fzf_process.communicate()

    # Wait for fd to complete and check return codes
    fd_process.wait()
    if fzf_process.returncode != 0:
        raise subprocess.CalledProcessError(fzf_process.returncode, "fzf")

    return result


def find_files_with_find(config: Dict[str, any], deps: Dict[str, bool]) -> str:
    """Find files using find command."""
    paths_to_search = (
        [config["search_path"]]
        if config["search_path"]
        else config["default_search_dirs"]
    )

    # Build find command
    find_args = ["find"] + paths_to_search + ["-type", "f"]

    # Build fzf command
    fzf_args = ["fzf"] + build_fzf_args(deps["has_bat"])

    # Run find piped to fzf
    find_process = subprocess.Popen(find_args, stdout=subprocess.PIPE, text=True)
    fzf_process = subprocess.Popen(
        fzf_args, stdin=find_process.stdout, stdout=subprocess.PIPE, text=True
    )

    # Close find stdout in parent process
    find_process.stdout.close()

    # Get the result
    result, _ = fzf_process.communicate()

    # Wait for find to complete and check return codes
    find_process.wait()
    if fzf_process.returncode != 0:
        raise subprocess.CalledProcessError(fzf_process.returncode, "fzf")

    return result


if __name__ == "__main__":
    main()
