{ config, ... }:

{
  programs.fish = {
    enable = true;

    # 設定の本体はリポジトリ実体（fish/interactive.fish・fish/functions/）に置き、
    # 編集が rebuild なしで新しいシェルから反映されるようにします。
    # zoxide / fzf / direnv / mise / atuin / starship の init 注入は
    # 各 programs.* の enableFishIntegration が担うため、ここでは source のみ行います。
    interactiveShellInit = ''
      set -p fish_function_path ${config.home.homeDirectory}/dotfiles/fish/functions
      source ${config.home.homeDirectory}/dotfiles/fish/interactive.fish
    '';
  };
}
