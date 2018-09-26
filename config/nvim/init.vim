" Required
filetype off

" dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/pyama/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/Users/pyama/.cache/dein')
  call dein#begin('/Users/pyama/.cache/dein')

"  " Let dein manage dein
"  " Required:
"  call dein#add('/Users/pyama/.cache/dein/repos/github.com/Shougo/dein.vim')
"
"  " Add or remove your plugins here:
"  call dein#add('Shougo/neosnippet.vim')
"  call dein#add('Shougo/neosnippet-snippets')
"
"  " You can specify revision/branch/tag.
"  call dein#add('Shougo/deol.nvim', { 'rev': '01203d4c9' })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required
filetype plugin indent on
syntax enable

" End dein Scripts-------------------------

" My setting-------------------------------
" Show number of lines
set number

" Show title
set title

" Use Sysyem clipboard
set clipboard+=unnamed

" Indent
set autoindent " Take indent for new line from previous line
set expandtab " Use spaces when <Tab> is inserted
set tabstop=2 " Set the number of spaces that <Tab> in file uses
set shiftwidth=2 " Set the number of spaces to use for indent
set smartindent " Set smart autoindenting
set softtabstop=2 " Set the number of spaces that <Tab> uses while editing

" Highlight the cursor
set cursorline
