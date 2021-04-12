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
colorscheme ayu

if g:colors_name == 'ayu'
  let ayucolor='dark' " available: light / dark / mirage
  let g:airline_theme = 'ayu_dark' " available: ayu_light / ayu_dark / ayu_mirage
endif

if g:colors_name == 'onedark'
  let g:airline_theme = 'onedark'
endif

if g:colors_name == 'gruvbox'
  set t_Co=256
  let g:airline_theme = 'gruvbox'
endif

if g:colors_name == 'elly'
  let g:airline_theme = 'elly'
endif

if g:colors_name == 'tokyonight'
  let g:tokyonight_style = 'night' " available: night / storm
  let g:tokyonight_enable_italic = 1
  let g:airline_theme= 'tokyonight'
endif
