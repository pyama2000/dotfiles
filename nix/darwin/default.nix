{ pkgs, user, system, ... }:

{
  # システム全体にインストールするパッケージのリストです。
  # パッケージを検索するには、例として `nix-env -qaP | grep wget` のように実行してください。
  environment.shells = [ pkgs.fish ];
  environment.systemPackages =
    [ pkgs.vim
    ];

  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.fish;
  };


  # nix.package = pkgs.nix;

  # このシステムで Nix Flakes と新しい CLI コマンドを利用できるようにします。
  # 現代的な Nix 環境構築には必須の設定です。
  nix.settings.experimental-features = "nix-command flakes";

  # nix-darwin 環境の環境変数を読み込むための /etc/zshrc を生成・管理します。
  # これを有効にしないと、nix でインストールしたコマンドにパスが通らないなどの問題が発生します。
  # Fish を使用する場合でも、システムとの互換性や互換性のために有効にしておくことが推奨されます。
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;


  # darwin-version コマンドの出力に Git コミットハッシュを含めるための設定です。
  # 構成管理の再現性を確認するのに役立ちますが、dirty な状態だと null になることがあります。
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # 後方互換性のために使用される stateVersion です。
  # 変更する際は、必ず `man darwin-configuration-changelog` またはリリースノートを確認してください。
  # 安易に変更するとシステム設定が予期せず変更される可能性があります。
  system.stateVersion = 5;

  # この構成を適用するプラットフォーム（アーキテクチャ）を指定します。
  # Apple Silicon Mac の場合は "aarch64-darwin"、Intel Mac の場合は "x86_64-darwin" となります。
  nixpkgs.hostPlatform = system;
}
