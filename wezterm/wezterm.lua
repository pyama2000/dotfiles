local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- herdr の永続セッションに attach し、無ければ作成する（`tmux new-session -A` 相当）
config.default_prog = { "/run/current-system/sw/bin/fish", "--login", "--command", "herdr" }

-- enable_kitty_keyboard は有効化しない（デフォルト false のまま）。
-- 有効にすると ctrl+数字 は判別できるようになるが、wezterm 20240203 の
-- kitty プロトコル実装は Esc を仕様違反のレガシー \x1b のまま送るバグがあり
-- （wezterm#3621）、プロトコルモードの herdr が Esc キーとして解釈できず
-- Esc が全アプリで死ぬ。herdr 側は alt+数字（レガシー表現可）で代替する。

-- 外観（背景の透過・パディングは ghostty 設定から移植。
-- タイトルバーは WezTerm デフォルトのまま表示する）
config.color_scheme = "Kanagawa (Gogh)"
config.window_background_opacity = 0.75
config.window_padding = { left = 10, right = 10, top = 5, bottom = 5 }

-- 右下に日時を表示（tmux のステータスバー右側 %Y-%m-%d %H:%M:%S を WezTerm で再現）。
-- herdr は単一の WezTerm タブ内で動くため、タブバーを常時表示にして最下段へ移し、
-- 右寄せの update-right-status に時刻を毎秒描画する。
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
-- タブバー背景を Kanagawa の bg に合わせる（color_scheme に上書きマージされる）。
config.colors = {
  tab_bar = {
    background = "#1f1f28",
  },
}

wezterm.on("update-right-status", function(window)
  window:set_right_status(wezterm.format({
    { Background = { Color = "#1f1f28" } },
    { Foreground = { Color = "#c8c093" } }, -- Kanagawa fg（tmux の時刻表示色と統一）
    { Text = " " .. wezterm.strftime("%Y-%m-%d %H:%M:%S") .. " " },
  }))
end)

config.font = wezterm.font_with_fallback({
  { family = "Explex35 Console NF" },
  { family = "UDEV Gothic 35NF" },
  { family = "YuGothic" },
})
config.font_size = 12.0
-- リガチャ無効（ghostty の font-feature = -dlig 相当）
config.harfbuzz_features = { "dlig=0" }

return config
