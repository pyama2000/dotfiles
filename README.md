dotfiles
===

macOS / Linux 向けの個人 dotfiles です。**Nix**（flake + nix-darwin + home-manager）を中心に構築し、Nix で扱えないものだけを補助的なツールで管理します。**cargo-make は使いません。** セットアップは `script/install.sh`、日常の更新は `script/update.sh` の 2 スクリプトだけで完結します。

## 開発環境構築（新規マシン）

### 1. リポジトリの取得

```shell script
git clone https://github.com/pyama2000/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. ブートストラップ

```shell script
GIT_NAME=<GIT_NAME> GIT_EMAIL=<GIT_EMAIL> script/install.sh
```

`GIT_NAME` / `GIT_EMAIL` は環境変数で渡すか、省略すると対話端末で入力を求められます（`~/.config/git/local/config` に書き込まれ、`git.nix` の `include` 経由で読み込まれます）。**冪等**なので、途中で失敗しても何度でも再実行できます。

macOS では以下を順に行います。

1. Xcode Command Line Tools の確認・導入
2. Homebrew の導入（Nix 適用前の `git` ブートストラップ、および `aqua` バイナリ・GUI cask 導入に必要）
3. Nix の導入
4. `sudo darwin-rebuild switch --flake ~/dotfiles/nix#macos`（初回は `nix run nix-darwin/master#darwin-rebuild` 経由）— CLI ツール・Neovim 本体・macOS システム設定・Homebrew（brews/casks）が一括で構築されます
5. git のローカル設定書き込み
6. Nix 管理外のものを個別に導入: `aqua i`、`rustup`、`mise install`（nodejs/python ランタイム）、lima VM（`docker` / `docker-rosetta`）と docker context

Linux では apt 依存パッケージ・Nix の導入後、`home-manager switch --flake ~/dotfiles/nix#takahiko-yamashita@<x86_64|aarch64>-linux` を実行し、同様に git 設定・`aqua`・`rustup`・`mise` ランタイムを導入します。

## macOS / システム設定 (Nix)

macOS のシステム設定・Homebrew・CLI ツールの大部分は Nix（flake + nix-darwin + home-manager, aarch64-darwin）で宣言的に管理しています。設定変更を反映するには `nix/` で `darwin-rebuild` を実行します。

```shell script
cd ~/dotfiles/nix
darwin-rebuild build --flake .#macos        # ビルドのみ（評価チェック、root 不要）
sudo darwin-rebuild switch --flake .#macos  # ビルドして適用（root 必須）
```

> `switch` はシステムを書き換えるため `sudo`（root）が必要です。`build` は root 不要です。
> flake は git 追跡ファイルのみを参照するため、新規追加した `nix/**.nix` は事前に `git add` してください。

- macOS 設定: `nix/darwin/default.nix`（`system.defaults` / Touch ID sudo / unfree 許可リストなど）
- Homebrew: `nix/darwin/homebrew.nix`（brews / casks）
- フォント (Explex): `nix/darwin/fonts.nix`（`fonts.packages`）
- CLI ツール本体・dotfiles symlink・Git 設定 / fish / starship: `nix/home-manager/`（設定の実体は `git/` `fish/` `starship/` `mise/` `atuin/` などリポジトリ直下にあり、編集は rebuild なしで反映されます）

## Linux (standalone home-manager)

Linux は nix-darwin を使わず、standalone home-manager だけで管理します。

```shell script
home-manager switch --flake ~/dotfiles/nix#takahiko-yamashita@<x86_64|aarch64>-linux
```

## ツールの管理方針（source of truth）

CLI ツールは重複管理を避けるため、以下の優先順位で 1 箇所にだけ置きます。新しいツールを追加するときはこの順で検討してください。

1. **nixpkgs**（home-manager の `home.packages` / `programs.*`、`nix/home-manager/default.nix`）— 基本はここ
2. **aqua**（`aqua.yaml`）— nixpkgs に存在しないツールのみ（現状 `tracer` / `lambroll` / `github/copilot-cli`）
3. **Homebrew**（`nix-darwin` の `homebrew` モジュール、`nix/darwin/homebrew.nix`）— `git`（ブートストラップ）、`python@3.9`（EOL で nixpkgs から削除済み）、`readline` / `xz`（python ビルド依存: mise の compile フォールバックと python@3.9 が参照）、`aqua` バイナリ本体、GUI cask
4. **ネイティブのマネージャ**（残り全部）— `rustup`、nixpkgs に無い一部の cargo/uv/npm/go 製ツール（`kani-verifier` / `awscli-local` / `cronv` / `sshtunnel` / MCP サーバ / `@playwright/cli` など）。Node / Python のバージョン切替は `mise`（本体は nixpkgs の `programs.mise`、ランタイムは `mise install`）が担います

`Brewfile` は `update.sh` が `brew bundle dump` で自動生成する参照用ミラーであり、**手動編集はしません**。Homebrew の実体は `nix/darwin/homebrew.nix` です。

## 開発環境更新

日常の更新は 1 コマンドです。

```shell script
~/dotfiles/script/update.sh
```

未コミットの変更があると中断します（未追跡ファイルは許容）。処理内容は以下の順です。

1. `main` を最新化（`git pull --rebase`）
2. `nix flake update` で `nix/flake.lock` を更新
3. `darwin-rebuild build` / `nix build` で評価が通ることを検証（システムに触れる前の安全確認）
4. `flake.lock` に差分があれば自動でコミット・push
5. `darwin-rebuild switch` / `home-manager switch` で適用
6. `aqua i`・`rustup update`・`mise upgrade` を実行
7. macOS では `brew update && brew upgrade && brew upgrade --cask && brew autoremove && brew cleanup`
8. Neovim プラグインを更新（`Lazy! update`）、`nvim/lazy-lock.json` に差分があれば自動でコミット・push
9. macOS では `Brewfile` を再生成（`brew bundle dump --force --all`）— 差分があってもここは**自動コミットせず**レビューを促すだけです

> `flake.lock` と `lazy-lock.json` は Renovate でも自動更新されるため、手動での `update.sh` 実行は「まとめて今すぐ上げたいとき」の整理として使えば十分です。

## インストールされる GUI ツール

`nix/darwin/homebrew.nix` の cask で管理しています。

- Alfred
- Clipy
- Discord
- Insomnia
- Kiro
- Postman
- QBlocker
- Rectangle
- sbx (`docker/tap`)
- TablePlus
- WezTerm
- Zoom

## チートシート

- [tmux](https://github.com/pyama2000/dotfiles/tree/main/doc/cheatsheet/tmux.md)
- NeoVim
    - [coc.nvim](https://github.com/pyama2000/dotfiles/tree/main/doc/cheatsheet/neovim/coc.md)
    - [defx.nvim](https://github.com/pyama2000/dotfiles/tree/main/doc/cheatsheet/neovim/defx.md)
    - [denite.nvim](https://github.com/pyama2000/dotfiles/tree/main/doc/cheatsheet/neovim/denite.md)
    - [keymap](https://github.com/pyama2000/dotfiles/tree/main/doc/cheatsheet/neovim/keymap.md)
