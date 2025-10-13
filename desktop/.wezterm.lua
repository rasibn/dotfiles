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
