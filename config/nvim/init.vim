" Required
filetype off
let g:python3_host_prog = $PYENV_ROOT . '/shims/python3'

" Read dein scripts
runtime! config/dein.vim

" Read keymaps
runtime! config/keymap.vim


" My setting-------------------------------
" Set theme
colorscheme dracula

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
