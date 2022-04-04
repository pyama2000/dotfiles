let s:plugin = '~/.config/nvim/plugins/config/dein.toml'
let s:lazy = '$HOME/.config/nvim/plugins/config/dein_lazy.toml'
let s:theme = '$HOME/.config/nvim/plugins/config/dein_theme.toml'

if &compatible
  set nocompatible
endif

let s:cache_dir = expand('~/.cache/dein')
let s:repo_dir = s:cache_dir . '/repos/github.com/Shougo/dein.vim'

execute 'set runtimepath^=' . fnamemodify(s:repo_dir, ':p')

let s:plugin_vimrc_dir = '$HOME/.config/nvim/plugins'
function! RequirePlugin(path)
  execute "source" s:plugin_vimrc_dir . '/' . a:path
endfunction

let g:dein#auto_recache = v:true
if dein#load_state(s:cache_dir)
  call dein#begin(s:cache_dir)
  call dein#add(s:repo_dir)

  call dein#load_toml(s:plugin, {'lazy': 0})
  call dein#load_toml(s:theme, {'lazy': 0})
  call dein#load_toml(s:lazy, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on
