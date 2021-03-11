" テキスト背景色
au ColorScheme * hi Normal ctermbg=none
" 括弧対応
au ColorScheme * hi MatchParen cterm=bold ctermfg=214 ctermbg=black
" スペルチェック
au Colorscheme * hi SpellBad ctermfg=23 cterm=none ctermbg=none

if (has("termguicolors"))
  set termguicolors
endif

set background=dark
colorscheme elly 

if g:colors_name == 'ayu'
  let ayucolor='dark'
endif

if g:colors_name == 'onedark'
  let g:lightline = { 'colorscheme': 'onedark' }
endif

if g:colors_name == 'gruvbox'
  set t_Co=256
  let g:lightline = { 'colorscheme': 'gruvbox' }
endif

if g:colors_name == 'elly'
  let g:lightline = { 'colorscheme': 'elly' }
endif
