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

def refresh():
    global last
    result = subprocess.run(['paneru', 'query', 'active', '--json'], capture_output=True, text=True)
    if result.returncode:
        state = ('Paneru offline', None)
    else:
        try:
            active = json.loads(result.stdout)
        except ValueError:
            return
        label = ' — '.join(x for x in (active.get('focused_app_name'), active.get('focused_window_title')) if x) or 'Desktop'
        state = (label, active.get('virtual_workspace_number') or 1)
    if state == last:
        return
    args = ['sketchybar', '--set', 'focused', 'label=' + state[0], 'label.color=0xffe5eedd' if state[1] else 'label.color=0xffe7be7d']
    for number in range(1, 5):
        selected = number == state[1]
        args += ['--set', f'workspace.{number}', 'background.color=' + ('0xffb3e1a7' if selected else '0xee0d141b'), 'icon.color=' + ('0xff0d141b' if selected else '0xffb3e1a7')]
    if subprocess.run(args, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0:
        last = state

while True:
    with subprocess.Popen(['paneru', 'subscribe', '--json'], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True) as stream:
        child = stream
        refresh()
        for line in stream.stdout:
            try:
                event = json.loads(line)
            except ValueError:
                continue
            if event.get('event') in {'window_focused', 'window_title_changed', 'virtual_workspace_changed', 'windows_changed', 'display_changed'}:
                refresh()
    refresh()
    # Backoff only after the daemon disconnects, never between normal events.
    time.sleep(2)
