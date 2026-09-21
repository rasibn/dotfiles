#!/usr/bin/env python3
"""Generate a commit message from staged changes and create the commit."""

from __future__ import annotations

import argparse
import subprocess
import sys
import tempfile
from pathlib import Path


PROMPT = (
    "Read the staged diff provided to you. Generate one concise imperative "
    "commit subject, preferably using Conventional Commits when appropriate. "
    "Output only the subject line, with no quotes, markdown, or explanation."
)


def run(command: list[str], *, input_text: str | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command,
        input=input_text,
        text=True,
        capture_output=True,
        check=False,
    )


def staged_diff() -> str:
    status = run(["git", "diff", "--cached", "--quiet"])
    if status.returncode == 0:
        raise RuntimeError("No staged changes to commit.")
    if status.returncode != 1:
        raise RuntimeError(status.stderr.strip() or "Unable to inspect staged changes.")

    diff = run(["git", "diff", "--cached", "--binary"])
    if diff.returncode != 0:
        raise RuntimeError(diff.stderr.strip() or "Unable to read staged changes.")
    return diff.stdout


def generate_with_luna(diff: str) -> str:
    result = run(
        [
            "codex",
            "exec",
            "--ephemeral",
            "--model",
            "gpt-5.6-luna",
            "-c",
            'model_reasoning_effort="low"',
            "--sandbox",
            "read-only",
            PROMPT,
        ],
        input_text=diff,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or result.stdout.strip() or "Codex failed.")
    return result.stdout


def generate_with_qwen(diff: str) -> str:
    diff_path: Path | None = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            prefix="gcai-",
            suffix=".diff",
            delete=False,
        ) as diff_file:
            diff_file.write(diff)
            diff_path = Path(diff_file.name)

        result = run(
            [
                "opencode",
                "run",
                "--model",
                "careem/local/qwen/qwen3.6-35b",
                "--format",
                "default",
                "--file",
                str(diff_path),
                "--",
                PROMPT,
            ]
        )
        if result.returncode != 0:
            raise RuntimeError(
                result.stderr.strip() or result.stdout.strip() or "OpenCode failed."
            )
        return result.stdout
    finally:
        if diff_path is not None:
            diff_path.unlink(missing_ok=True)


def clean_message(raw_message: str) -> str:
    for line in raw_message.splitlines():
        line = line.strip()
        if not line or line.startswith("```"):
            continue
        return line.strip("\"'")
    raise RuntimeError("The model did not generate a commit message.")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Generate a commit message from staged changes and commit them."
    )
    parser.add_argument(
        "--model",
        required=True,
        choices=("luna", "qwen-35"),
        help="model backend to use",
    )
    args = parser.parse_args()

    try:
        diff = staged_diff()
        raw_message = (
            generate_with_luna(diff) if args.model == "luna" else generate_with_qwen(diff)
        )
        message = clean_message(raw_message)
    except (OSError, RuntimeError) as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1

    return subprocess.run(["git", "commit", "-m", message], check=False).returncode


if __name__ == "__main__":
    raise SystemExit(main())
