set autoindent
set autoread
set clipboard=unnamedplus
set cursorline
set expandtab
set nobackup
set noswapfile
set nowritebackup
set number
set shiftwidth=2
set smartindent
set softtabstop=2
set tabstop=2
set title
syntax enable

""""""""""""""""""""""""""""""
" keymap                     "
""""""""""""""""""""""""""""""
" Clear highlight
map <C-n> :noh<CR>

" Split window
nmap <C-w>s :split<CR>
nmap <C-w>v :vsplit<CR>

" Move window
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
nmap <C-h> <C-w>h

" Tab
nmap <C-t>n :tabnew<CR>
nmap <C-t>N :tabNext<CR>
nmap <C-t>p :tabprevious<CR>

nnoremap j gj
nnoremap k gk
nnoremap <Space>w :w!<CR>

inoremap <silent> jj <ESC>
inoremap <silent> jjw <ESC>:w!<CR>
inoremap <silent> jjq <ESC>:wq!<CR>
