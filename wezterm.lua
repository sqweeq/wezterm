local wezterm = require("wezterm")
local mux = wezterm.mux
local config = {}
local act = wezterm.action

wezterm.local_echo_threshold_ms = 50 -- e.g., 20 seconds
wezterm.maxfps = 120 -- e.g., 20 seconds

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
	-- Create a split occupying the right 1/3 of the screen
	-- pane:split({ size = 0.8, direction = "Left" })
	-- Create another split in the right of the remaining 2/3
	-- of the space; the resultant split is in the middle
	-- 1/3 of the display and has the focus.
	-- pane:split({ size = 0.5 })
end)
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.scrollback_lines = 100000
config.window_close_confirmation = "NeverPrompt"
config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.7,
}

-- config.font = wezterm.font("Bitstream Vera Sans Mono")
-- config.font = wezterm.font("JetBrains Mono")
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.font_size = 12

-- KEYS
local act = wezterm.action

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)
config.disable_default_key_bindings = true
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{ key = "l", mods = "CTRL|ALT", action = act.ActivateTabRelative(1) },
	{ key = "h", mods = "CTRL|ALT", action = act.ActivateTabRelative(-1) },
	{ key = "t", mods = "CTRL|ALT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "CTRL|ALT", action = act.CloseCurrentTab({ confirm = true }) },

	{
		key = "|",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			-- command = { args = { "top" } },
			size = { Percent = 50 },
		}),
	},
	{
		key = "}",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Up",
			-- command = { args = { "top" } },
			size = { Percent = 50 },
		}),
	},
	{
		key = "{",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			-- command = { args = { "top" } },
			size = { Percent = 50 },
		}),
	},
	{
		key = "p",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Left",
			-- command = { args = { "top" } },
			size = { Percent = 50 },
		}),
	},
	-- {
	-- 	key = "}",
	-- 	mods = "CTRL|SHIFT",
	-- 	action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	-- },

	{ key = "h", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },

	{ key = "LeftArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "RightArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 1 }) },
	{ key = "UpArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "DownArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 1 }) },

	{
		key = "T",
		mods = "CTRL|SHIFT",
		action = wezterm.action.TogglePaneZoomState,
	},
	{ key = "x", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },

	{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	{
		key = "O",
		mods = "CTRL|SHIFT",
		action = act.PasteFrom("Clipboard"),
	},
	{
		key = "c",
		mods = "CTRL|SHIFT",
		action = act.CopyTo("Clipboard"),
	},
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
	-- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
	-- mode until we cancel that mode.
	-- {
	-- 	key = "r",
	-- 	mods = "LEADER",
	-- 	action = act.ActivateKeyTable({
	-- 		name = "resize_pane",
	-- 		one_shot = false,
	-- 	}),
	-- },

	-- CTRL+SHIFT+Space, followed by 'a' will put us in activate-pane
	-- mode until we press some other key or until 1 second (1000ms)
	-- of time elapses
	-- {
	-- 	key = "a",
	-- 	mods = "LEADER",
	-- 	action = act.ActivateKeyTable({
	-- 		name = "activate_pane",
	-- 		timeout_milliseconds = 1000,
	-- 	}),
	-- },
	-- Switch to the default workspace
	{
		key = "y",
		mods = "CTRL|SHIFT",
		action = act.SwitchToWorkspace({
			name = "default",
		}),
	},
	-- Switch to a monitoring workspace, which will have `top` launched into it
	{
		key = "u",
		mods = "CTRL|SHIFT",
		action = act.SwitchToWorkspace({
			name = "monitoring",
			spawn = {
				args = { "top" },
			},
		}),
	},
	-- Create a new workspace with a random name and switch to it
	{ key = "i", mods = "CTRL|SHIFT", action = act.SwitchToWorkspace },
	-- Show the launcher in fuzzy selection mode and have it list all workspaces
	-- and allow activating one.
	{
		key = "9",
		mods = "ALT",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
	-- activate copy mode or vim mode
	{
		key = "Enter",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
	-- https://www.reddit.com/r/wezterm/comments/1egf4vy/im_a_little_bit_confused_by_the_search_overlay/
	{
		key = "Escape",
		mods = "NONE",
		action = act.Multiple({
			act.CopyMode("ClearPattern"),
			act.CopyMode("AcceptPattern"),
			act.CopyMode({ SetSelectionMode = "Cell" }),
		}),
	},
	-- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
	{
		key = "LeftArrow",
		mods = "OPT",
		action = act.SendKey({
			key = "b",
			mods = "ALT",
		}),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = act.SendKey({ key = "f", mods = "ALT" }),
	},
}

config.key_tables = {
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane' here corresponds to the name="resize_pane" in
	-- the key assignments above.
	-- resize_pane = {
	-- 	{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
	-- 	{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
	-- 	{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
	-- 	{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
	--
	-- 	-- Cancel the mode by pressing escape
	-- 	{ key = "Escape", action = "PopKeyTable" },
	-- },
}

return config
