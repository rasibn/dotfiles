#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "--watch" && -n "${NIRI_SOCKET:-}" ]]; then
  "$0"
  niri msg --json event-stream | while IFS= read -r event; do
    case "$event" in
      *'"WindowFocusChanged"'*|*'"WorkspaceActivated"'*|*'"WindowsChanged"'*|*'"WindowOpenedOrChanged"'*|*'"WindowClosed"'*|*'"WindowLayoutsChanged"'*|*'"WorkspacesChanged"'*)
        "$0"
        ;;
    esac
  done
  exit 0
fi

if [[ -n "${NIRI_SOCKET:-}" ]]; then
  is_niri=true
  workspace_id=$(niri msg --json workspaces 2>/dev/null | jq -r '.[] | select(.is_focused) | .id' | head -n 1)
  clients=$(niri msg --json windows 2>/dev/null) || {
    printf '{"text":""}\n'
    exit 0
  }
else
  is_niri=false
  active_workspace=$(hyprctl activeworkspace -j 2>/dev/null) || {
    printf '{"text":""}\n'
    exit 0
  }
  workspace_id=$(jq -r '.id // empty' <<<"$active_workspace")
  clients=$(hyprctl clients -j 2>/dev/null) || {
    printf '{"text":""}\n'
    exit 0
  }
fi

if [[ -z "$workspace_id" ]]; then
  printf '{"text":""}\n'
  exit 0
fi

jq -c --argjson workspace_id "$workspace_id" \
  --argjson is_niri "$is_niri" '
  def app_name:
    (.class // .app_id // "") as $app
    | if $app == "com.mitchellh.ghostty" then "Ghostty"
    elif $app == "brave-browser" then "Brave"
    elif $app == "firefox" then "Firefox"
    elif $app == "chromium" then "Chromium"
    elif $app == "google-chrome" then "Chrome"
    elif $app == "" then "Window"
    else $app
    end;

  map(select((if $is_niri then .workspace_id else .workspace.id end) == $workspace_id))
  | sort_by(if $is_niri then (.layout.pos_in_scrolling_layout[0] // .id) else (.at[0] // .id) end)
  | map(
      . as $window
      | ($window | app_name) as $app
      | if (if $is_niri then $window.is_focused else $window.focusHistoryID == 0 end) then
          "<span foreground=\"#a02058\">  ● \($app)  </span>"
        else
          "<span foreground=\"#826b75\">  <span alpha=\"1\">●</span> \($app)  </span>"
        end
    )
  | join(" ")
  | {text: .}
' <<<"$clients"
