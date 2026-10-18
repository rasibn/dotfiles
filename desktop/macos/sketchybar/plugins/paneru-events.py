#!/usr/bin/env python3
"""One event consumer; no normal-path sleeps or periodic window queries."""

import json
import subprocess
import time
import signal
import sys

child = None


def shutdown(signum, frame):
    if child is not None and child.poll() is None:
        child.terminate()
        child.wait(timeout=2)
    sys.exit(0)


signal.signal(signal.SIGTERM, shutdown)

last = None
slot_count = 0
# Remove stale slots if launchd restarts the listener without reloading the bar.
subprocess.run(
    ["sketchybar", "--remove", "/^window\\.[0-9]+$/"],
    stdout=subprocess.DEVNULL,
    stderr=subprocess.DEVNULL,
)


def refresh():
    global last, slot_count
    result = subprocess.run(
        ["paneru", "query", "state", "--json"], capture_output=True, text=True
    )
    if result.returncode:
        state = ("Paneru offline", None, ())
    else:
        try:
            document = json.loads(result.stdout)
        except ValueError:
            return
        active = document.get("active", {})
        number = active.get("virtual_workspace_number") or 1
        workspace = next(
            (
                row
                for row in document.get("virtual_workspaces", [])
                if row.get("number") == number
                and row.get("native_workspace_id") == active.get("native_workspace_id")
            ),
            {},
        )
        # Paneru emits strip order, then floating windows. Screen x coordinates
        # are clamped for off-screen windows and must not be used for sorting.
        windows = tuple(
            (
                w["window_id"],
                w.get("app_name") or "Window",
                bool(w.get("focused")),
                bool(w.get("floating")),
            )
            for w in workspace.get("windows", [])
        )
        state = ("Desktop", number, windows)
    if state == last:
        return
    windows = state[2]
    args = [
        "sketchybar",
        "--set",
        "focused",
        "label=" + state[0],
        "drawing=" + ("off" if windows else "on"),
    ]
    for number in range(1, 5):
        selected = number == state[1]
        args += [
            "--set",
            f"workspace.{number}",
            "background.color=" + ("0xffb3e1a7" if selected else "0xee0d141b"),
            "icon.color=" + ("0xff0d141b" if selected else "0xffb3e1a7"),
        ]
    for index in range(len(windows), slot_count):
        args += ["--remove", f"window.{index}"]
    max_chars = max(3, min(16, 70 // max(1, len(windows))))
    for index, (window_id, name, focused, floating) in enumerate(windows):
        item = f"window.{index}"
        if index >= slot_count:
            args += ["--add", "item", item, "left"]
        color = "0xff0d141b" if focused else "0xffe5eedd"
        args += [
            "--set",
            item,
            "drawing=on",
            "label=" + name,
            "label.max_chars=" + str(max_chars),
            "label.color=" + color,
            "icon=" + ("~" if floating else ""),
            "icon.drawing=" + ("on" if floating else "off"),
            "icon.color=" + color,
            "background.color=" + ("0xffb3e1a7" if focused else "0xee0d141b"),
            "--move",
            item,
            "after",
            "focused" if index == 0 else f"window.{index - 1}",
        ]
    if (
        subprocess.run(
            args, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        ).returncode
        == 0
    ):
        last = state
        slot_count = len(windows)


while True:
    with subprocess.Popen(
        ["paneru", "subscribe", "--json"],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True,
    ) as stream:
        child = stream
        refresh()
        for line in stream.stdout:
            try:
                event = json.loads(line)
            except ValueError:
                continue
            if event.get("event") in {
                "window_focused",
                "window_title_changed",
                "virtual_workspace_changed",
                "windows_changed",
                "display_changed",
            }:
                refresh()
    refresh()
    # Backoff only after the daemon disconnects, never between normal events.
    time.sleep(2)
