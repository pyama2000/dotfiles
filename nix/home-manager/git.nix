{ lib, config, ... }:

{
  programs.git = {
    enable = true;

    # 設定の本体はリポジトリ実体（git/config）に置き、編集が即時反映されるようにします。
    # git/config の末尾で ~/.config/git/local/config（user.name / user.email）を
    # include しており、ローカル設定が最後に適用されます。
    settings = {
      include = {
        path = "${config.home.homeDirectory}/dotfiles/git/config";
      };
    };
  };

  # delta のインストールと core.pager / interactive.diffFilter の配線のみ Nix に任せ、
  # 表示オプションは git/config の [delta] セクションで管理します。
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  # Activation script to create local git config if it doesn't exist.
  # 中身（user.name / user.email）は script/install.sh の `setup_git_local` が
  # GIT_NAME / GIT_EMAIL から投入します。ここでは存在保証のため空ファイルのみ作成し、
  # 既存ファイルは上書きしません。
  home.activation.createGitLocalConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f ${config.home.homeDirectory}/.config/git/local/config ]; then
      run mkdir -p ${config.home.homeDirectory}/.config/git/local
      run touch ${config.home.homeDirectory}/.config/git/local/config
    fi
  '';
}
