-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
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

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha"

if is_linux() then
	config.font_size = 14.0
	config.enable_tab_bar = false
end

if is_darwin() then
	config.font_size = 15
end

config.window_close_confirmation = "NeverPrompt"
config.window_background_opacity = 1.00
config.window_padding = {
	bottom = 0,
}

return config
