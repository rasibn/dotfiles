#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
exec python3 "$(dirname "$0")/paneru-events.py"
