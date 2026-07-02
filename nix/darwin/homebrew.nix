{ ... }:

{
  # Homebrew のパッケージを nix-darwin で宣言的に管理します。
  # 旧来は Brewfile + 各 cargo-make タスクの `brew install` で散在していたものを集約しました。
  #
  # 注意: このモジュールは Homebrew 本体をインストールしません。
  # 事前に Homebrew を導入しておく必要があります（script/install.sh / aqua タスク経由）。
  #
  # fzf / fish は Nix(home-manager の programs.*）に統合したためここには含めません。
  # git はブートストラップ（Nix 適用前の git clone）で必要なため Homebrew に残します。
  homebrew = {
    enable = true;

    onActivation = {
      # 初期は宣言外パッケージを削除しません。安定後に "uninstall" / "zap" を検討します。
      cleanup = "none";
      autoUpdate = false;
      upgrade = false;
    };

    # sbx cask、aqua 本体（aquaproj/aqua/aqua）がそれぞれ docker/tap, aquaproj/aqua 由来のため
    # tap を宣言します。
    taps = [
      "docker/tap"
      "aquaproj/aqua"
    ];

    # nixpkgs に存在する CLI ツールは Nix(home-manager の home.packages)へ移しました。
    # ここに残すのは Nix で扱えない / 扱うべきでないものだけです:
    #   - git             : Nix 適用前の `git clone`（ブートストラップ）で必要
    #   - python@3.9      : EOL のため nixpkgs から削除済み（移行先が無い）
    #   - readline / xz   : python ビルド依存。mise は既定で precompiled binary を使うが、
    #                       compile フォールバック（python-build）と python@3.9 が参照するため残す
    brews = [
      "git"
      "python@3.9"
      "readline"
      "xz"
    ];

    # aqua 本体は nixpkgs に存在しないため Homebrew で管理します。
    # aquaproj/aqua tap は formula を廃止して cask のみ提供するため casks に宣言します
    # （旧 formula 版が入っている場合は `brew uninstall --formula aqua` してから switch すること）。
    casks = [
      "aquaproj/aqua/aqua"
      "alfred"
      "clipy"
      "discord"
      "insomnia"
      "kiro"
      "postman"
      "qblocker"
      "rectangle"
      "docker/tap/sbx"
      "tableplus"
      "wezterm"
      "zoom"
    ];
  };
}
