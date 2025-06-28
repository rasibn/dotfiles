import unittest
from io import StringIO
import subprocess
from contextlib import redirect_stderr
from library import (
    pipe,
    panic,
    command_exists,
)


class TestUtils(unittest.TestCase):
    def test_pipe_single_command(self):
        result = pipe(["echo", "hello"])
        self.assertEqual(result, "hello")

    def test_pipe_multiple_commands(self):
        result = pipe(["echo", "one\ntwo\nthree"], ["grep", "two"])
        self.assertEqual(result, "two")

    def test_pipe_failure(self):
        with self.assertRaises(subprocess.CalledProcessError):
            pipe(["false"])  # always returns exit code 1

    def test_command_exists_true(self):
        self.assertTrue(command_exists("python"))

    def test_command_exists_false(self):
        self.assertFalse(command_exists("nonexistent_command_123"))

    def test_panic_prints_and_exits(self):
        stderr = StringIO()
        with self.assertRaises(SystemExit) as cm:
            with redirect_stderr(stderr):
                panic("Something went wrong", code=42)

        self.assertEqual(cm.exception.code, 42)
        self.assertIn("Something went wrong", stderr.getvalue())


if __name__ == "__main__":
    unittest.main()
