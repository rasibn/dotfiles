from subprocess import Popen, PIPE, CalledProcessError, call, DEVNULL
from typing import List
import shutil
import sys


def pipe(*commands: List[str]) -> str:
    """Pipe multiple shell commands together and return the final output."""
    if not commands:
        raise ValueError("No commands provided to pipe()")

    processes = []
    prev_stdout = None

    for _, cmd in enumerate(commands):
        p = Popen(cmd, stdin=prev_stdout, stdout=PIPE, text=True)
        if prev_stdout:
            prev_stdout.close()  # Close previous pipe in parent
        prev_stdout = p.stdout
        processes.append(p)

    # Get final output from the last process
    final_output, _ = processes[-1].communicate()

    # Wait for all processes and check exit codes
    for p in processes:
        p.wait()
        if p.returncode != 0:
            raise CalledProcessError(p.returncode, p.args)

    return final_output.strip()


def panic(message: str, code: int = 1) -> None:
    """Print an error message and exit."""
    print(message, file=sys.stderr)
    sys.exit(code)


def check_call(cmd: List[str]) -> bool:
    """Run a command and return True if it succeeds (exit code 0), suppressing output."""
    return call(cmd, stdout=DEVNULL, stderr=DEVNULL) == 0


def command_exists(command: str) -> bool:
    """Check if a command exists in the system PATH."""
    return shutil.which(command) is not None
