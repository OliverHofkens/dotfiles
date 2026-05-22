local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- System
config.check_for_updates = false
config.max_fps = 120 -- Smoother scrolling in editors

-- GUI
function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "flexoki-dark"
	else
		return "flexoki-light"
	end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

-- config.font = wezterm.font_with_fallback({ "Inconsolata Nerd Font", "unscii" })
config.font = wezterm.font_with_fallback({ "Greybeard 16px", "unscii" })
config.font_size = 16
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.window_padding = {
	left = "2cell",
	right = "2cell",
	top = "1cell",
	bottom = "1cell",
}

return config
