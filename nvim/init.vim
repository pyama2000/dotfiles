let g:python_host_prog = '~/.asdf/shims/python2'
let g:python3_host_prog = '~/.asdf/shims/python3'

runtime! plugins/dein.rc.vim
runtime! keymap.vim
runtime! colorscheme.vim

syntax enable
set number
set title
set cursorline
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set smartindent
set softtabstop=2
set clipboard=unnamedplus
set nobackup
set nowritebackup

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.php setlocal tabstop=2 shiftwidth=4
augroup END

set pumblend=30
