# fish の対話シェル設定の本体。home-manager 生成の config.fish から source される。
# このファイルはリポジトリ実体なので編集が新しいシェルから即時反映される。

##############################
# Homebrew（macOS のみ）      #
##############################
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

# Reportedly zoxide/eza not found. Adding Nix binary paths explicitly.
fish_add_path /run/current-system/sw/bin
fish_add_path /etc/profiles/per-user/$USER/bin
fish_add_path $HOME/.nix-profile/bin

##############################
# aqua                       #
##############################
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x AQUA_ROOT_DIR "$XDG_DATA_HOME/aquaproj-aqua"
set -x AQUA_GLOBAL_CONFIG "$HOME/dotfiles/aqua.yaml"
fish_add_path "$AQUA_ROOT_DIR/bin"

##############################
# config                     #
##############################
set fish_greeting ""
set -gx LC_ALL ja_JP.UTF-8
set -gx LC_TYPE ja_JP.UTF-8
set -gx LANG ja_JP.UTF-8
fish_add_path /usr/local/sbin
fish_add_path $HOME/.local/bin

##############################
# Abbreviations              #
##############################
# 引数を後ろに続けるプレフィックス型の省略形は abbr にする
# （入力時に展開されるため、履歴に完全なコマンドが残る）。
# ghq
abbr -a ghg "ghq get"
abbr -a ghl "ghq list"
# cargo
abbr -a rfmt "cargo fmt"
abbr -a cch "cargo check --color=always"
abbr -a clippy "cargo clippy"
# Docker
abbr -a dc "docker compose"
# terraform
abbr -a tf terraform

##############################
# Aliases                    #
##############################
# それ自体で完結するコマンド、およびコマンド置換から参照されるものは alias のままにする。
# exa
alias exaf "eza --long --all --group-directories-first --bytes --header --group --git"
alias exat "eza --all --group-directories-first --group --git --tree --ignore-glob .git"
# fzf + bat（fpre は fvim がコマンド置換で参照するため abbr にできない）
alias fpre 'fzf --preview "bat --color=always {}"'
alias fvim "nvim (fpre)"
# pipenv
alias piid "pipenv install --dev flake8 pylint isort mypy pysnooper pydocstyle bandit && pipenv install --dev --pre black"

##############################
# Python                     #
##############################
set -x PIPENV_VENV_IN_PROJECT 1

##############################
# Go                         #
##############################
set -x GOPATH $HOME/go
fish_add_path $HOME/go/bin

##############################
# Rust                       #
##############################
fish_add_path $HOME/.cargo/bin

##############################
# fzf                        #
##############################
set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'

##############################
# direnv                     #
##############################
set -x EDITOR nvim

##############################
# lima（macOS の docker VM 用）#
##############################
if test (uname) = Darwin
    set -x LIMA_INSTANCE docker
end

##############################
# docker                     #
##############################
set -x DOCKER_BUILDKIT 1

##############################
# Theme                      #
##############################
set -l foreground DCD7BA
set -l selection 2D4F67
set -l comment 727169
set -l red C34043
set -l orange FF9E64
set -l yellow C0A36E
set -l green 76946A
set -l purple 957FB8
set -l cyan 7AA89F
set -l pink D27E99

set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
