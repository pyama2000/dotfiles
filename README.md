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

| value           | key type | example             |
|:----------------|:---------|:--------------------|
| GIT\_NAME       | string   | pyama2000           |
| GIT\_EMAIL      | string   | example@example.com |


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
