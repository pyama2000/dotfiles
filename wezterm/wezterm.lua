local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- herdr の永続セッションに attach し、無ければ作成する（`tmux new-session -A` 相当）
config.default_prog = { "/run/current-system/sw/bin/fish", "--login", "--command", "herdr" }

-- 外観（背景の透過・パディングは ghostty 設定から移植。
-- タイトルバーは WezTerm デフォルトのまま表示する）
config.color_scheme = "Kanagawa (Gogh)"
config.window_background_opacity = 0.75
config.window_padding = { left = 10, right = 10, top = 5, bottom = 5 }
config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font_with_fallback({
  { family = "Explex35 Console NF" },
  { family = "UDEV Gothic 35NF" },
  { family = "YuGothic" },
})
config.font_size = 12.0
-- リガチャ無効（ghostty の font-feature = -dlig 相当）
config.harfbuzz_features = { "dlig=0" }

return config
