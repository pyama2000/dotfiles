{
  pkgs,
  user,
  lib,
  config,
  ...
}:

let
  # dotfile を Nix ストアにコピーせず、リポジトリ実体を指す symlink を張ります。
  # これによりリポジトリ側を編集すると即反映され（nvim の lazy-lock.json 更新なども）、
  # 宣言的管理（home-manager）と編集しやすさを両立します。
  repo = "${config.home.homeDirectory}/dotfiles";
in
{
  imports = [
    ./starship.nix
    ./fish.nix
    ./git.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = user;
  # ホームディレクトリはプラットフォーム毎に異なります（macOS は /Users、Linux は /home）。
  home.homeDirectory = lib.mkForce (
    if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}"
  );

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  #
  # CLI ツールは原則ここ（Nix）で一元管理します。aqua / Homebrew は
  # nixpkgs に存在しないものだけを担当します（aqua: tracer/tfenv/lambroll、
  # Homebrew: git のブートストラップと python@3.9、および GUI casks）。
  # バージョンは aqua のような個別ピンではなく flake.lock（nixpkgs リビジョン）で固定され、
  # `nix flake update` でまとめて更新されます。
  home.packages = [
    # CLI（汎用）
    pkgs.eza
    pkgs.bat
    pkgs.aws-nuke
    pkgs.gh
    pkgs.jq
    pkgs.jnv
    pkgs.fd
    pkgs.ripgrep
    pkgs.repgrep
    pkgs.sd
    pkgs.ast-grep
    pkgs.ghq
    pkgs.grpcurl
    pkgs.circleci-cli
    pkgs.wget
    pkgs.rclone
    pkgs.git-crypt
    pkgs.gnupg
    pkgs.global
    pkgs.tmux
    pkgs.neovim
    # ngrok は Homebrew cask から移行（unfree のため allowUnfreePredicate に追加済み）。
    pkgs.ngrok
    # 履歴書き換え用ツール。従来は ad-hoc に brew install していました。
    pkgs.git-filter-repo
    # GitHub ダッシュボード TUI。設定は後続フェーズで管理します。
    pkgs.gh-dash
    # ターミナル常駐のエージェントマルチプレクサ（https://herdr.dev）。
    pkgs.herdr
    # レビュー志向のターミナル diff ビューア（https://www.hunk.dev）。
    pkgs.hunk

    # コンテナ / クラウド / インフラ
    pkgs.docker-client
    pkgs.docker-compose
    pkgs.docker-buildx
    pkgs.buildkit
    pkgs.awscli2
    pkgs.google-cloud-sdk
    pkgs.kubectl
    pkgs.packer
    pkgs.tflint
    pkgs.ecspresso

    # ビルド / proto / DB
    pkgs.protobuf
    pkgs.buf
    # protoc プラグイン群（go install から移行）
    pkgs.protoc-gen-doc
    pkgs.protoc-gen-go
    pkgs.protoc-gen-go-grpc
    pkgs.grpc-gateway
    # mysql80 は 2026-04-30 に EOL となり nixpkgs から削除されたため、8.4 LTS へ移行。
    pkgs.mysql84
    pkgs.postgresql_14
    pkgs.percona-toolkit
    pkgs.redis
    # DB マイグレーションツール（go install から移行）
    pkgs.sql-migrate

    # Python ツールチェイン
    pkgs.uv
    pkgs.ruff

    # 言語ランタイム
    # Go は Go1 互換性保証 + go.mod の toolchain 機構（GOTOOLCHAIN=auto）で
    # プロジェクト毎のバージョンを自動取得するため Nix の単一バージョンで足ります。
    # Deno も自己更新が不要なので Nix 管理にします。
    # Node / Python はバージョン切替のため mise を使います（programs.mise 参照）。
    pkgs.go
    pkgs.deno
    pkgs.zig

    # Go 補助ツール（go install から移行）
    pkgs.gow

    # JavaScript / Web
    pkgs.biome
    # corepack も pnpm 用のシム（bin/pnpm）を提供し pkgs.pnpm と衝突するため、
    # 明示的にインストールした pkgs.pnpm を優先させます。
    (lib.hiPrio pkgs.pnpm)
    # corepack（npm から移行）
    pkgs.corepack

    # Rust 補助ツール（cargo install から移行）
    pkgs.cargo-update
    pkgs.cargo-expand
    pkgs.cargo-generate
    pkgs.cargo-make
    pkgs.cargo-nextest
    pkgs.protoc-gen-prost-crate
    pkgs.tokio-console

    # Linter / Formatter
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.actionlint
    pkgs.hadolint
    pkgs.stylua

    # Language Server
    pkgs.bash-language-server
    pkgs.lua-language-server
    pkgs.terraform-ls
    pkgs.yaml-language-server
    pkgs.kotlin-language-server
    # gopls（go install から移行）
    pkgs.gopls
    # python-lsp-server（uv から移行）
    pkgs.python3Packages.python-lsp-server

    # Nix
    pkgs.nixd
    pkgs.nixfmt
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    # GNU userland（macOS の BSD 版を置き換えます。Linux はネイティブに備えるため不要）
    pkgs.coreutils
    pkgs.gnused
    pkgs.gnugrep
    pkgs.gawk

    # lima は macOS で docker を動かすための VM です（Linux では不要）。
    pkgs.lima
  ];

  # Using Home Manager to manage these programs
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Node / Python のバージョンマネージャ（asdf から移行）。
  # パッケージ導入と fish 統合のみ Nix に任せ、グローバル設定はリポジトリ実体
  # （mise/config.toml、下の xdg.configFile で symlink）に置きます。
  # 実体のインストールは script/install.sh の `mise install` が担います。
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
  };

  # シェル履歴（fish 標準履歴の置き換え）。設定はリポジトリ実体（atuin/config.toml）。
  programs.atuin = {
    enable = true;
    # fish への init 注入（`atuin init fish`）は home-manager ではなく
    # リポジトリ実体（fish/interactive.fish）で行う。init に渡すフラグ
    # （例: --disable-up-arrow で上キーを fish 標準の履歴遡りにする）を
    # rebuild なしで編集・即時反映できるようにするため。
    enableFishIntegration = false;
  };

  # docker CLI プラグインを Nix 提供のバイナリで賄います（従来は cargo-make が
  # curl で ~/.docker/cli-plugins に取得していました）。docker はこのディレクトリを
  # 探索するため、Nix ストアのバイナリを symlink します。
  home.file.".docker/cli-plugins/docker-compose".source = "${pkgs.docker-compose}/bin/docker-compose";
  home.file.".docker/cli-plugins/docker-buildx".source = "${pkgs.docker-buildx}/bin/docker-buildx";

  # 設定ファイル（リポジトリ実体を指す symlink）。従来 cargo-make の link_* が
  # 張っていた symlink を home-manager に移管します。
  home.file.".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${repo}/.tmux.conf";
  home.file.".profile".source = config.lib.file.mkOutOfStoreSymlink "${repo}/.profile";
  home.file.".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${repo}/.vimrc";

  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${repo}/nvim";
    "wezterm".source = config.lib.file.mkOutOfStoreSymlink "${repo}/wezterm";
    # GitHub CLI 関連（gh / gh-dash）の設定はリポジトリの github-cli/ 配下にまとめています。
    # gh はディレクトリ単位ではなくファイル単位で symlink します。hosts.yml には
    # 認証情報が含まれるため、リポジトリには含めずローカルの実ファイルのままにします。
    "gh/config.yml".source = config.lib.file.mkOutOfStoreSymlink "${repo}/github-cli/gh/config.yml";
    "gh-dash".source = config.lib.file.mkOutOfStoreSymlink "${repo}/github-cli/gh-dash";
    # mise / atuin は programs.* でパッケージと fish 統合だけ有効化し、
    # 設定ファイルはリポジトリ実体への symlink にします（編集が即時反映される）。
    "mise/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${repo}/mise/config.toml";
    "atuin/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${repo}/atuin/config.toml";
    "herdr/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${repo}/herdr/config.toml";
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/takahiko-yamashita/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
