dotfiles
===

## 開発環境構築

cargo-make で `setup` タスクを実行する. 

```shell script
git clone https://github.com/pyama2000/dotfiles.git ~/dotfiles
cd ~/dotfiles
script/install.sh
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

cargo-make で `update` タスクを実行する. 

```shell script
cargo make --profile production --makefile script/task.toml update
```

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
