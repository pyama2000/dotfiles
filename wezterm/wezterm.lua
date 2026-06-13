local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.default_prog = { "/run/current-system/sw/bin/fish", "--login", "--command", "tmux" }
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = "Kanagawa (Gogh)"
config.font = wezterm.font_with_fallback({
  { family = "Explex35 Console NF" },
  { family = "UDEV Gothic 35NF" },
  { family = "YuGothic" },
})
config.font_size = 12.0

return config
