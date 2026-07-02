{ config, ... }:

{
  # パッケージの導入と fish への init 注入のみ Nix に任せます。
  # settings を空にすると home-manager は starship.toml を生成しないため、
  # 下の symlink（リポジトリ実体）と衝突しません。
  programs.starship.enable = true;

  # 設定の本体はリポジトリ実体（starship/starship.toml）。編集が即時反映されます。
  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/starship/starship.toml";
}
