dotfiles
===

## INSTALLATION

```bash
git clone https://github.com/pyama2000/dotfiles.git ~/dotfiles
cd ~/dotfiles
script/install.sh
cargo make --makefile script/task.toml setup \
  -e GIT_NAME=<GIT_NAME> \
  -e GIT_EMAIL=<GIT_EMAIL> \
  -e GO_VERSION=<GO_VERSION> \
  -e NODE_VERSION=<NODE_VERSION> \
  -e PYTHON_VERSION=<PYTHON_VERSION>
```

Environments:

| value           | key type | example             |
|:----------------|:---------|:--------------------|
| GIT\_NAME       | string   | pyama2000           |
| GIT\_EMAIL      | string   | example@example.com |
| GO\_VERSION     | string   | 1.14.2              |
| NODE\_VERSION   | string   | 12.16.9             |
| PYTHON\_VERSION | string   | 3.9.0               |

### GUI tools

- 1Password
- Alfred
- Clipy
- Discord
- Docker
- gitify
- Google Chrome
- Google 日本語入力
- Rectangle
- Slack
- Zoom

## UPDATE

```bash
cd ~/dotfiles
cargo make --makefile script/task.toml update
```

## CHEAT SHEETS

- [tmux](https://github.com/pyama2000/dotfiles/tree/master/doc/cheatsheet/tmux.md)
- NeoVim
    - [coc.nvim](https://github.com/pyama2000/dotfiles/tree/master/doc/cheatsheet/neovim/coc.md)
    - [defx.nvim](https://github.com/pyama2000/dotfiles/tree/master/doc/cheatsheet/neovim/defx.md)
    - [denite.nvim](https://github.com/pyama2000/dotfiles/tree/master/doc/cheatsheet/neovim/denite.md)
    - [keymap](https://github.com/pyama2000/dotfiles/tree/master/doc/cheatsheet/neovim/keymap.md)
