-- Hyprland 0.55+ Lua config
-- Converted from hyprland.conf with hyprconf2lua, then manually reviewed.

---@module 'hl'

-- Programs
local terminal = "ghostty"
local fileManager = "thunar"
local menu = "rofi -combi-modi window,drun -show combi -show-icons"
local mainMod = "SUPER"

-- Monitors
hl.monitor({
	output = "DP-2",
	mode = "2560x1440@180",
	position = "0x0",
	scale = 1.33,
})

hl.monitor({
	output = "eDP-1",
	mode = "1920x1200@60.0",
	position = "0x0",
	scale = 1.33,
})

-- Environment
hl.env("XCURSOR_SIZE", 24)
hl.env("HYPRCURSOR_SIZE", 24)

-- Look and feel
hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 8,
		border_size = 2,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
		resize_on_border = true,
		allow_tearing = false,
		layout = "scrolling",
	},

	decoration = {
		rounding = 10,
		rounding_power = 4,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 8,
			render_power = 3,
			color = "rgba(00000033)",
		},
		blur = {
			enabled = true,
			size = 8,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = false,
	},

	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "caps:swapescape",
		kb_rules = "",
		follow_mouse = 0,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.3,
		},
	},
})

-- Scrolling layout animations
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global", enabled = true, speed = 12, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 6.3, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 5.5, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.7, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.7, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.7, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 4.4, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4.6, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.7, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2.1, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.6, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.3, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.45, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.3, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 8.5, bezier = "quick" })

-- Scrolling (niri-like) layout
hl.config({
	scrolling = {
		direction = "right",
		column_width = 0.5,
		focus_fit_method = 1,
		follow_focus = true,
		follow_min_visible = 0.4,
		fullscreen_on_one_column = true,
		wrap_focus = true,
		wrap_swapcol = true,
		explicit_column_widths = "0.25, 0.333, 0.5, 0.667, 1.0",
	},
})

-- Three-finger horizontal swipe to scroll through columns.
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "scroll_move",
})

-- Per-device input
hl.device({
	name = "compx-vxe-r1-pro-1",
	sensitivity = -0.65,
})

hl.device({
	name = "compx-vxe-nordicmouse-1k-dongle-1",
	sensitivity = -0.95,
})

-- Keybinds
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(
	mainMod .. " + SHIFT + S",
	hl.dsp.exec_cmd("flock -n /tmp/hyprshot.lock sh -c 'hyprshot --freeze --mode=region --raw --clipboard-only | swappy -f -'")
)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle", layout_aware = true }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.layout("fit expand"))
hl.bind(mainMod .. " + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + V", hl.dsp.layout("colresize +conf"))


-- Move focus between columns (niri: Mod+H/L)
hl.bind(mainMod .. " + H", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + L", hl.dsp.layout("focus r"))
hl.bind(mainMod .. " + left", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + right", hl.dsp.layout("focus r"))

-- Move focus between windows within a column (niri: Mod+K/J)
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Move columns (niri: Mod+Shift+H/L)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.layout("swapcol r"))

-- Stack / unstack windows into columns
hl.bind(mainMod .. " + comma", hl.dsp.layout("consume"))
hl.bind(mainMod .. " + period", hl.dsp.layout("expel"))
hl.bind(mainMod .. " + O", hl.dsp.layout("consume_or_expel prev"))

-- Reset the focused column to the default width.
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.layout("colresize 0.5"))

-- Super+O is enough for the stack/unstack workflow.
-- Super+T is intentionally disabled; promote places the new column to the right,
-- while Super+O targets the previous (left) column.
-- hl.bind(mainMod .. " + T", hl.dsp.layout("promote"))

-- Fit the focused column fully into view.
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.layout("fit_into_view"))

-- Workspaces
for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Scroll through columns
hl.bind(mainMod .. " + mouse_down", hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + mouse_up", hl.dsp.layout("move -col"))

-- Mouse binds
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume / brightness
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { repeating = true })
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), { repeating = true })
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume raise"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume lower"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("swayosd-client --brightness raise"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("swayosd-client --brightness lower"),
	{ locked = true, repeating = true }
)

-- Media keys
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("swayosd-server")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("waybar")
	hl.exec_cmd("mako")
	hl.exec_cmd("udiskie &")
	hl.exec_cmd("hypridle")
end)
