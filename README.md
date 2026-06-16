dotfiles
===

## 開発環境構築（新規 macOS）

真っさらな macOS では以下の順で構築します。**CLI ツール・Neovim 本体・macOS システム設定・Homebrew は Nix**（nix-darwin + home-manager）が、**Neovim プラグイン・asdf/Node/Python ランタイム・aqua ツールは cargo-make** が担当します。Nix が大部分を構築するため、`cargo make setup` の前に **Nix のブートストラップ（手順 3〜4）が必須**です。

### 1. リポジトリの取得

```shell script
git clone https://github.com/pyama2000/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

> 初回の `git` 実行で Xcode Command Line Tools のインストールを促されたら従ってください（`git` が無い場合は `xcode-select --install` で先に導入）。

### 2. Homebrew / Rust / cargo-make の導入

```shell script
script/install.sh
```

`homebrew.nix` は Homebrew 本体が入っている前提（git のブートストラップや GUI casks を管理）なので、Nix より先に実行します。Rust と cargo-make もここで入ります。

### 3. Nix のインストール（Determinate Systems installer）

```shell script
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

> flakes / nix-command がデフォルトで有効になります。インストール後は **シェルを開き直して** `nix` に PATH を通してください。

### 4. nix-darwin の初回適用

`darwin-rebuild` はまだ存在しないため、初回だけ `nix run` で nix-darwin を起動して `switch` します（2 回目以降は「開発環境更新」の `darwin-rebuild` を使用）。

```shell script
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/dotfiles/nix#macos
```

> これで CLI ツール・Neovim 本体・macOS システム設定・Homebrew（brews/casks）が一括で構築されます。`switch` はシステムを書き換えるため root が必要です。
> ブートストラップのコマンドは nix-darwin のバージョンで変わることがあります。失敗する場合は [nix-darwin](https://github.com/LnL7/nix-darwin) の最新手順を参照してください。

### 5. cargo-make の `setup`（Nix 非管理分）

最後に Nix 管理外（Neovim プラグイン・asdf/Node/Python・aqua ツール・dotfiles 同期）を構築します。

```shell script
cd ~/dotfiles
cargo make --profile production --makefile script/task.toml setup \
  -e GIT_NAME=<GIT_NAME> \
  -e GIT_EMAIL=<GIT_EMAIL>
```

環境変数:

| value           | key type | example             | 用途                                                   |
|:----------------|:---------|:--------------------|:-------------------------------------------------------|
| GIT\_NAME       | string   | pyama2000           | git の `user.name`（`~/.config/git/local/config` に投入）|
| GIT\_EMAIL      | string   | example@example.com | git の `user.email`（同上）                            |

`setup` タスクの `setup_git_local` が `GIT_NAME` / `GIT_EMAIL` を
`~/.config/git/local/config` に書き込み、`git.nix` の `include` 経由で読み込まれます。

## macOS / システム設定 (Nix)

macOS のシステム設定・Homebrew・CLI ツールの一部は Nix（flake + nix-darwin +
home-manager, aarch64-darwin）で宣言的に管理しています。設定変更を反映するには
`nix/` で `darwin-rebuild` を実行します。

```shell script
cd ~/dotfiles/nix
darwin-rebuild build --flake .#macos        # ビルドのみ（評価チェック、root 不要）
sudo darwin-rebuild switch --flake .#macos  # ビルドして適用（root 必須）
```

> `switch` / `activate` / `rollback` / `check` はシステムを書き換えるため `sudo`（root）で実行する必要があります。`build` は root 不要です。
> flake は git 追跡ファイルのみを参照するため、新規追加した `nix/**.nix` は事前に `git add` してください。

- macOS 設定: `nix/darwin/default.nix`（`system.defaults` / Touch ID sudo など）
- Homebrew: `nix/darwin/homebrew.nix`（brews / casks）
- フォント (Explex): `nix/darwin/fonts.nix`（`fonts.packages`）。macOS は Nix が管理し、Linux は cargo-make の `setup_font` が担当します。
- Git 設定 / fish / starship: `nix/home-manager/`

## 開発環境更新

更新チャネルは **Nix** と **cargo-make** の 2 系統に分かれており、重複しません（CLI ツールの単一 source of truth は Nix という方針のため）。

| チャネル | 更新対象 | sudo |
|:---------|:---------|:-----|
| Nix (`nix flake update` → `darwin-rebuild switch`) | Neovim **本体**・nixpkgs の CLI ツール群・macOS システム設定・Homebrew | switch のみ必要 |
| cargo-make (`update` タスク) | Neovim **プラグイン**（lazy.nvim / `lazy-lock.json`）・asdf と Node/Python ランタイム・aqua ツール（`tracer`/`tfenv`/`lambroll`）・dotfiles 同期 | 不要 |

> Neovim は「本体は Nix、プラグインは cargo-make」という住み分けです。macOS では Go/Deno・cargo 系ツール・`link_*`・フォント等は `.linux` 限定の no-op になっており、`update` を回しても何もしません（Nix 管理へ移行済みのため）。

### 1. Nix 側（本体・CLI・システム設定）

```shell script
cd ~/dotfiles/nix
nix flake update                            # 入力(nixpkgs 等)を更新し flake.lock を書き換え（root 不要）
darwin-rebuild build --flake .#macos        # ビルドのみで検証（root 不要）
sudo darwin-rebuild switch --flake .#macos  # システムへ適用（root 必須）
```

> `build` を挟むことで、eval エラーやパッケージ削除などの破壊的変更をシステムに触れる前に検出できます。ビルド成果物は Nix ストアにキャッシュされ `switch` が再利用するため、検証コストは実質ありません。
> 特定ツールだけ上げたいときは全体更新ではなく `nix flake update nixpkgs` のように入力を絞ると影響範囲を小さくできます。
> 適用後に不調なら `sudo darwin-rebuild --rollback` で前の世代へ戻せます。問題なければ `flake.lock` をコミットして「動いた構成」を固定します。

### 2. cargo-make 側（プラグイン・ランタイム・aqua）

```shell script
cd ~/dotfiles
cargo make --profile production --makefile script/task.toml update
```

### 推奨順序・頻度

両者は独立ですが、プラグインは Neovim 本体のバージョンに依存しうるため **Nix（本体）→ cargo-make（プラグイン）** の順が自然です。頻度は **月 1 回程度＋ `build` での検証** を目安にします。`lazy-lock.json` と `flake.lock` は Renovate でも自動更新されるため、手動更新は「まとめて今すぐ上げたいとき」に使う整理でも構いません。

## インストールされるツール

### GUI ツール

- 1Password
- Alfred
- Clipy
- Discord
- Docker
- Google Chrome
- Google 日本語入力
- Insomnia
- Postman
- QBlocker
- Rectangle
- Slack
- TablePlus
- Zoom

## チートシート

- [tmux](https://github.com/pyama2000/dotfiles/tree/master/doc/cheatsheet/tmux.md)
- NeoVim
    - [coc.nvim](https://github.com/pyama2000/dotfiles/tree/master/doc/cheatsheet/neovim/coc.md)
    - [defx.nvim](https://github.com/pyama2000/dotfiles/tree/master/doc/cheatsheet/neovim/defx.md)
    - [denite.nvim](https://github.com/pyama2000/dotfiles/tree/master/doc/cheatsheet/neovim/denite.md)
    - [keymap](https://github.com/pyama2000/dotfiles/tree/master/doc/cheatsheet/neovim/keymap.md)
