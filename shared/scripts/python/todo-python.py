#!/usr/bin/env python3
import os
import sys
import subprocess
from pathlib import Path
from library import command_exists, panic, check_call


def main():
    selected = sys.argv[1] if len(sys.argv) == 2 else select_directory()

    if not selected:
        sys.exit(0)

    selected_path = Path(selected).resolve()
    selected_name = selected_path.name.replace(".", "_")
    tmux_running = is_tmux_running()

    if not is_inside_tmux() and not tmux_running:
        create_session(selected_name, selected_path, detached=False)
        sys.exit(0)

    if not has_tmux_session(selected_name):
        create_session(selected_name, selected_path, detached=True)

    if not is_inside_tmux():
        attach_session(selected_name)
    else:
        switch_client(selected_name)


def select_directory() -> str:
    if command_exists("fd"):
        dirs = run_capture(
            ["fd", ".", "--type", "d", "--max-depth", "1", *get_env_dirs()]
        )
    else:
        dirs = run_capture(
            ["find", *get_env_dirs(), "-mindepth", "1", "-maxdepth", "1", "-type", "d"]
        )

    if not dirs:
        panic("No directories found in specified paths.")

    if not command_exists("fzf"):
        panic("fzf is not installed. Please install fzf first.")

    return run_fzf(dirs.splitlines())


def get_env_dirs() -> list[str]:
    return [
        os.environ.get("PROJECT_DIR", "."),
        os.environ.get("WORK_DIR", "."),
        os.environ.get("ASSET_DIR", "."),
    ]


def run_capture(cmd: list[str]) -> str:
    try:
        result = subprocess.run(
            cmd,
            text=True,
            capture_output=True,
            stderr=subprocess.DEVNULL,
            check=True,
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        return ""


def run_fzf(choices: list[str]) -> str:
    proc = subprocess.run(
        ["fzf"],
        input="\n".join(choices),
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
    )
    return proc.stdout.strip()


def is_tmux_running() -> bool:
    return check_call(["pgrep", "tmux"])


def is_inside_tmux() -> bool:
    return "TMUX" in os.environ


def has_tmux_session(name: str) -> bool:
    return check_call(["tmux", "has-session", "-t", name])


def create_session(name: str, directory: Path, detached: bool):
    cmd = ["tmux", "new-session", "-s", name, "-n", "nvim", "-c", str(directory)]
    if detached:
        cmd.insert(3, "-d")  # insert -d after new-session

    subprocess.run(cmd)
    for window in ["zsh", "extra"]:
        subprocess.run(
            ["tmux", "new-window", "-t", name, "-n", window, "-c", str(directory)]
        )

    for win in ["nvim", "zsh", "extra"]:
        subprocess.run(
            ["tmux", "send-keys", "-t", f"{name}:{win}", f"cd '{directory}'", "Enter"]
        )


def attach_session(name: str):
    subprocess.run(["tmux", "attach-session", "-t", name])


def switch_client(name: str):
    subprocess.run(["tmux", "switch-client", "-t", name])


if __name__ == "__main__":
    main()
