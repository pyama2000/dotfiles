if status is-interactive
  eval (/opt/homebrew/bin/brew shellenv)
end

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
set fish_greeting ''
set -gx LC_ALL ja_JP.UTF-8
set -gx LC_TYPE ja_JP.UTF-8
set -gx LANG ja_JP.UTF-8
fish_add_path /usr/local/sbin
fish_add_path $HOME/.local/bin

##############################
# asdf                       #
##############################
source ~/.asdf/asdf.fish

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
# starship                   #
##############################
starship init fish | source

##############################
# zoxide                     #
##############################
zoxide init fish | source

##############################
# direnv                     #
##############################
set -x EDITOR nvim
direnv hook fish | source

##############################
# lima                       #
##############################
set -x LIMA_INSTANCE docker

##############################
# docker                     #
##############################
set -x DOCKER_BUILDKIT 1

##############################
# Node.js                    #
##############################
# fish_add_path (npm get prefix)/bin

##############################
# Deno                       #
##############################
set -x DENO_INSTALL "$HOME"/.deno
fish_add_path $DENO_INSTALL/bin

##############################
# MySQL client               #
##############################
fish_add_path "/opt/homebrew/opt/mysql-client/bin"

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

##############################
# Alias                      #
##############################
## ghq
alias ghg 'ghq get'
alias ghl 'ghq list'
## exa (Replacement for `ls` command)
alias exaf 'exa --long --all --group-directories-first --bytes --header --group --git'
alias exat 'exa --all --group-directories-first --group --git --tree --ignore-glob .git'
## cargo
alias rfmt 'cargo fmt'
alias cch 'cargo check --color=always'
alias clippy 'cargo clippy'
## fzf + bat
alias fpre 'fzf --preview "bat --color=always {}"'
alias fvim 'nvim (fpre)'
## pipenv
alias piid 'pipenv install --dev flake8 pylint isort mypy pysnooper pydocstyle bandit && pipenv install --dev --pre black'
## Docker
alias dc 'docker compose'
## terraform
alias tf 'terraform'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/r0417/google-cloud-sdk/path.fish.inc' ]; . '/Users/r0417/google-cloud-sdk/path.fish.inc'; end
