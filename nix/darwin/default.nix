{
  pkgs,
  user,
  system,
  lib,
  ...
}:

{
  imports = [
    ./homebrew.nix
    ./fonts.nix
  ];

  # 一部の CLI ツール（packer は BSL 1.1）は unfree ライセンスのため、
  # 対象を明示列挙して許可します（home-manager は useGlobalPkgs でこの設定を共有）。
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "packer"
    ];

  # システム全体にインストールするパッケージのリストです。
  # パッケージを検索するには、例として `nix-env -qaP | grep wget` のように実行してください。
  environment.shells = [ pkgs.fish ];
  environment.systemPackages = [
    pkgs.vim
  ];

  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.fish;
  };

  # system.defaults などのユーザー単位 macOS 設定を適用する対象ユーザーです。
  # 近年の nix-darwin ではユーザー固有の defaults を書き込むために必須となります。
  system.primaryUser = user;

  # nix.package = pkgs.nix;

  # このシステムで Nix Flakes と新しい CLI コマンドを利用できるようにします。
  # 現代的な Nix 環境構築には必須の設定です（リスト指定が推奨）。
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Nix ストアの自動メンテナンスです。
  # gc: 古い世代を定期的に削除してディスクを節約します。
  # optimise: ストア内の重複ファイルをハードリンク化して容量を削減します。
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 3;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  # nix-darwin 環境の環境変数を読み込むための /etc/zshrc を生成・管理します。
  # これを有効にしないと、nix でインストールしたコマンドにパスが通らないなどの問題が発生します。
  # Fish を使用する場合でも、システムとの互換性や互換性のために有効にしておくことが推奨されます。
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;

  # sudo を Touch ID で認証できるようにします（/etc/pam.d/sudo_local 経由）。
  security.pam.services.sudo_local.touchIdAuth = true;

  # macOS のシステム設定を宣言的に管理します。
  # ここは個人の好みに合わせて調整する前提の代表的な設定です。
  # 反映には `darwin-rebuild switch` 後に再ログイン（または対象アプリの再起動）が必要な項目があります。
  system.defaults = {
    NSGlobalDomain = {
      # キーリピートを高速化します（値が小さいほど速い）。
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      # すべての拡張子を表示します。
      AppleShowAllExtensions = true;
      # キー長押しによるアクセント文字入力を無効化し、キーリピートを優先します。
      ApplePressAndHoldEnabled = false;
      # 自動スペル修正を無効化します。
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      # リスト表示をデフォルトにします。
      FXPreferredViewStyle = "Nlsv";
      # ウィンドウタイトルにフルパスを表示します。
      _FXShowPosixPathInTitle = true;
    };

    dock = {
      autohide = true;
      show-recents = false;
      mru-spaces = false;
      tilesize = 48;
      orientation = "bottom";
    };

    trackpad = {
      # タップでクリックを有効化します。
      Clicking = true;
      # 3 本指ドラッグを有効化します。
      TrackpadThreeFingerDrag = true;
    };
  };

  # Caps Lock を Control に割り当てます。
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # darwin-version コマンドの出力に Git コミットハッシュを含めるための設定です。
  # 構成管理の再現性を確認するのに役立ちますが、dirty な状態だと null になることがあります。
  # （flake.nix の specialArgs から self を受け取って設定します）

  # 後方互換性のために使用される stateVersion です。
  # 変更する際は、必ず `man darwin-configuration-changelog` またはリリースノートを確認してください。
  # 安易に変更するとシステム設定が予期せず変更される可能性があります。
  system.stateVersion = 5;

  # この構成を適用するプラットフォーム（アーキテクチャ）を指定します。
  # Apple Silicon Mac の場合は "aarch64-darwin"、Intel Mac の場合は "x86_64-darwin" となります。
  nixpkgs.hostPlatform = system;
}
