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
  #
  # aqua（aquaproj/aqua/aqua）はここで管理しません。サードパーティ tap の formula は
  # nix-darwin が実行する `brew bundle` の tap 信頼ガードで弾かれるため、aqua は従来どおり
  # ブートストラップ（script/install.sh / cargo-make の setup_aqua → `brew install aquaproj/aqua/aqua`）
  # に任せます。
  homebrew = {
    enable = true;

    onActivation = {
      # 初期は宣言外パッケージを削除しません。安定後に "uninstall" / "zap" を検討します。
      cleanup = "none";
      autoUpdate = false;
      upgrade = false;
    };

    # sbx cask が docker/tap 由来のため tap を宣言します。
    # その他の tap（aquaproj/aqua, hashicorp, kitagry など）は現状参照する
    # brew/cask が無いので宣言しません（必要になったら追記してください）。
    taps = [
      "docker/tap"
    ];

    # nixpkgs に存在する CLI ツールは Nix(home-manager の home.packages)へ移しました。
    # ここに残すのは Nix で扱えない / 扱うべきでないものだけです:
    #   - git        : Nix 適用前の `git clone`（ブートストラップ）で必要
    #   - python@3.9 : EOL のため nixpkgs から削除済み（移行先が無い）
    # ※ readline / xz など asdf の python ビルド依存は cargo-make(languages/python.toml)が
    #   別途 `brew install` します。
    brews = [
      "git"
      "python@3.9"
    ];

    casks = [
      "alfred"
      "clipy"
      "copilot-cli"
      "discord"
      "ghostty"
      "insomnia"
      "kiro"
      "ngrok"
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
