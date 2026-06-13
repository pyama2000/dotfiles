# NOTE: Homebrew パッケージは nix-darwin の homebrew モジュール
# (nix/darwin/homebrew.nix) で宣言的に管理しています。このファイルは
# 参考用のミラーです。実体の編集は homebrew.nix 側で行ってください。
#
# nixpkgs にある CLI ツールは Nix(home-manager の home.packages)へ移管しました。
# ここに残す Homebrew パッケージは:
#   - git        : Nix 適用前の git clone（ブートストラップ）で必要
#   - python@3.9 : EOL のため nixpkgs に無い
#   - GUI casks  : macOS アプリは cask が適切（nixpkgs の darwin GUI は不安定）
# 除外: fish / fzf（Nix の home-manager に統合）、aqua（ブートストラップで導入）。
tap "docker/tap"
brew "git"
brew "python@3.9"
cask "alfred"
cask "clipy"
cask "copilot-cli"
cask "discord"
cask "ghostty"
cask "insomnia"
cask "kiro"
cask "ngrok"
cask "postman"
cask "qblocker"
cask "rectangle"
cask "docker/tap/sbx"
cask "tableplus"
cask "wezterm"
cask "zoom"
