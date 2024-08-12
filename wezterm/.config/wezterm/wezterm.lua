local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- System
config.check_for_updates = false
config.max_fps = 120  -- Smoother scrolling in editors

-- GUI
config.color_scheme = 'flexoki-dark'
config.font = wezterm.font 'Inconsolata Nerd Font'
config.font_size = 16
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.window_padding = {
  left = '2cell',
  right = '2cell',
  top = '1cell',
  bottom = '1cell',
}

return config
