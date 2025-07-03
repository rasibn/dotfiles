#!/usr/bin/env python3
import subprocess
import sys
import os
from library import pipe, panic, command_exists


def main():
    try:
        selected_file = find_file(get_search_paths())
        if selected_file:
            subprocess.run(["nvim", selected_file], check=True)
        else:
            panic("No file selected.")
    except (subprocess.CalledProcessError, KeyboardInterrupt) as error:
        panic(f"Interrupted: {error}")
    except Exception as error:
        panic(f"An unexpected error occurred: {error}")


def get_search_paths() -> list[str]:
    return sys.argv[1:2] + [
        os.environ.get(env, ".") for env in ("PROJECT_DIR", "WORK_DIR", "ASSET_DIR")
    ]


def find_file(paths_to_search: list[str]) -> str:
    if not command_exists("fzf"):
        panic("fzf is not installed.")
    if not command_exists("fd") and not command_exists("find"):
        panic("Neither fd nor find is installed.")
    return pipe(build_find_cmd(paths_to_search), build_fzf_cmd())


def build_find_cmd(paths: list[str]) -> list[str]:
    path_args = [["--search-path", p] for p in paths]
    return (
        [
            "fd",
            "--type",
            "f",
            *sum(path_args, []),  # sum on a list concats
            "--follow",
            "--hidden",
            "--exclude",
            ".git",
        ]
        if command_exists("fd")
        else ["find", *paths, "-type", "f"]
    )


def build_fzf_cmd() -> list[str]:
    return ["fzf"] + (
        [
            "--ansi",
            "--preview-window=right:45%",
            "--preview=bat --color=always --style=header,grid --line-range :300 {}",
        ]
        if command_exists("bat")
        else []
    )


main()
