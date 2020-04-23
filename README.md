# Build and share the  development enviroment

## Build

```bash
$ cd ~
$ git clone https://github.com/pyama2000/dotfiles.git
$ bash dotfiles/install.sh
```

## Install fish completions

```bash
$ curl https://raw.githubusercontent.com/fish-shell/fish-shell/master/share/completions/[COMMAND_NAME].fish > ~/.config/fish/completions/git.fish
```

## Installed application list

Shell: 

- fish shell
    - fisher(package manager for `fish shell`)

Languages:  

- Go: 1.12.7
- Node: 12.6.0
- Python: 2.7.16, 3.7.4
- Rust: latest stable, nightly

Tools:

- anyenv
    - anyenv-update
- bat(Installed from `cargo`)
- exa(Installed from `cargo`)
- fzf
- ghq(Installed from `go`)
- goenv
- lazydocker(Installed from `go`)
- lazygiy(Installed from `go`)
- neovim
- pipenv
- pyenv
- ripgrep(Installed from `cargo`)
- tokei(Installed from `cargo`)
- yarn
- starship

For neovim:

- pynvim(For python2 and python3 provider)
- neovim(For Node provider)
- dein.nvim

## CHANGELOG

### 2020/04/24

- Alacritty
- tmux
- Source Code Pro fonts
