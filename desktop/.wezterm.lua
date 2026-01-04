local wezterm = require("wezterm")

local config = {}

-- In newer versions of wezterm, use the config_builder which will help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

local is_linux = function()
	return wezterm.target_triple:find("linux") ~= nil
end
local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end
local is_windows = function()
	return wezterm.target_triple:find("windows") ~= nil
end

-- config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "Kanagawa (Gogh)"

if is_linux() then
	config.font_size = 14.0
end

if is_darwin() then
	config.font_size = 16
end

config.tab_bar_at_bottom = true
config.window_close_confirmation = "NeverPrompt"
config.window_background_opacity = 0.95

-- Tmux-style tab bar
config.use_fancy_tab_bar = false
config.tab_max_width = 30
config.colors = {
	tab_bar = {
		background = "#16161d",
		active_tab = {
			bg_color = "#d27e99",
			fg_color = "#16161d",
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#2a2a37",
			fg_color = "#d27e99",
		},
		inactive_tab_hover = {
			bg_color = "#54546d",
			fg_color = "#dcd7ba",
		},
	},
}

-- Tmux-style tab formatting with box separators
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.active_pane.title
	if #title > max_width - 6 then
		title = title:sub(1, max_width - 9) .. "..."
	end

	local background = "#2a2a37"
	local foreground = "#d27e99"

	if tab.is_active then
		background = "#d27e99"
		foreground = "#16161d"
	elseif hover then
		background = "#54546d"
		foreground = "#dcd7ba"
	end

	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = " " .. (tab.tab_index + 1) .. ":" .. title .. " " },
		{ Background = { Color = "#16161d" } },
		{ Foreground = { Color = "#727169" } },
		{ Text = "│" },
	}
end)

config.window_padding = {
	bottom = 0,
}

local act = wezterm.action

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 5000 }
config.keys = {
	{
		mods = "LEADER",
		key = "-",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER|SHIFT",
		key = "|",
		action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
	},
	{
		mods = "LEADER",
		key = "m",
		action = act.TogglePaneZoomState,
	},
	{
		mods = "LEADER",
		key = "v",
		action = act.ActivateCopyMode,
	},
	{
		mods = "LEADER",
		key = "h",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "j",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER",
		key = "k",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		mods = "LEADER",
		key = "l",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		mods = "LEADER",
		key = "h",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "j",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER",
		key = "k",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		mods = "LEADER",
		key = "l",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		mods = "LEADER",
		key = "c",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "q",
		action = act.CloseCurrentPane({ confirm = false }),
	},
	{
		mods = "LEADER",
		key = "x",
		action = act.CloseCurrentPane({ confirm = false }),
	},
	{
		mods = "CTRL",
		key = "w",
		action = act.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "[",
		mods = "LEADER",
		action = act.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "]",
		action = act.ActivateTabRelative(1),
	},
	{
		mods = "LEADER|SHIFT",
		key = "{",
		action = act.MoveTabRelative(-1),
	},
	{
		mods = "LEADER|SHIFT",
		key = "}",
		action = act.MoveTabRelative(1),
	},
	{
		mods = "LEADER",
		key = "1",
		action = act.ActivateTab(0),
	},
	{
		mods = "LEADER",
		key = "2",
		action = act.ActivateTab(1),
	},
	{
		mods = "LEADER",
		key = "3",
		action = act.ActivateTab(2),
	},
	{
		mods = "LEADER",
		key = "4",
		action = act.ActivateTab(3),
	},
	{
		mods = "LEADER",
		key = "5",
		action = act.ActivateTab(4),
	},
	{
		mods = "LEADER",
		key = "6",
		action = act.ActivateTab(5),
	},
	{
		mods = "LEADER",
		key = "7",
		action = act.ActivateTab(6),
	},
	{
		mods = "LEADER",
		key = "8",
		action = act.ActivateTab(7),
	},
	{
		mods = "LEADER",
		key = "9",
		action = act.ActivateTab(8),
	},
	{
		mods = "LEADER",
		key = "0",
		action = act.ActivateTab(9),
	},
	{
		mods = "LEADER",
		key = "r",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},
}

local workspace_keybinds = {
	{
		mods = "LEADER",
		key = "s",
		action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	{
		mods = "LEADER",
		key = "w",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Text = "Enter workspace name:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	{
		mods = "LEADER",
		key = "n",
		action = act.SwitchWorkspaceRelative(1),
	},
	{
		mods = "LEADER",
		key = "p",
		action = act.SwitchWorkspaceRelative(-1),
	},
	{
		mods = "LEADER|SHIFT",
		key = "$",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Text = "Rename workspace:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
				end
			end),
		}),
	},
}

wezterm.on("update-right-status", function(window, pane)
	local workspace = window:active_workspace()
	window:set_right_status(wezterm.format({
		{ Text = " " .. workspace .. "   " },
	}))
end)

for _, key in ipairs(workspace_keybinds) do
	table.insert(config.keys, key)
end

config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

return config
