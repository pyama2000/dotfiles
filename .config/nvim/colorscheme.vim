" テキスト背景色
au ColorScheme * hi Normal ctermbg=none
" 括弧対応
au ColorScheme * hi MatchParen cterm=bold ctermfg=214 ctermbg=black
" スペルチェック
au Colorscheme * hi SpellBad ctermfg=23 cterm=none ctermbg=none

" au ColorScheme * hi LineNr       ctermbg=none ctermfg=240 cterm=italic " 行番号
" au ColorScheme * hi StatusLine   ctermbg=none " アクティブなステータスライン
" au ColorScheme * hi StatusLineNC ctermbg=none " 非アクティブなステータスライン
" au ColorScheme * hi Comment      ctermfg=243 cterm=italic " コメントアウト
" au ColorScheme * hi Statement    ctermfg=45
" au ColorScheme * hi DiffAdd      ctermbg=24  " 追加行
" au ColorScheme * hi Identifier   ctermfg=45 "cterm=bold

if (has("termguicolors"))
  set termguicolors
endif
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark
colorscheme gruvbox

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
