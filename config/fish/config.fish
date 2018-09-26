# Setting for greeting message
set fish_greeting ''

# Fixing Perl Warning (For MacOS)
set -gx LANG ja_JP.UTF-8 $LANG
set -gx LC_ALL ja_JP.UTF-8 $LC_ALL

# Setting for pyenv
## Set enviroment valeue `PYENV_ROOT`
set -gx PYENV_ROOT $HOME/.anyenv/envs/pyenv

## Set (pyenv init - fish)
set -gx PYENV_SHELL fish
source '/Users/pyama/.anyenv/envs/pyenv/libexec/../completions/pyenv.fish'
command pyenv rehash 2>/dev/null
function pyenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    source (pyenv "sh-$command" $argv|psub)
  case '*'
    command pyenv "$command" $argv
  end
end

# Setting for goenv
set -gx GOENV_ROOT $HOME/.anyenv/envs/goenv
command goenv rehash 2 > /dev/null

# Setting for golang
set -gx GOPATH $HOME/go

# Alias
# Git
alias ga 'git add .'
alias gc 'git commit'

## ghq (Manage the remote repositoty clones)
alias ghg 'ghq get'
alias ghl 'ghq list'
alias ghrm 'rm -rf (ghq root)/(ghq list | fzf)'
alias ghcd 'cd (ghq root)/(ghq list | fzf)'

## lazygit (Simple terminal UI for git commands)
alias lg 'lazygit'
