if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/pyama/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/Users/pyama/.cache/dein')
  call dein#begin('/Users/pyama/.cache/dein')

  " Load dein.toml & dein_lazy.toml
  call dein#load_toml('~/.config/nvim/plugins/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.config/nvim/plugins/dein_lazy.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" Auto install
if dein#check_install()
  call dein#install()
endif

" Required
filetype plugin indent on

