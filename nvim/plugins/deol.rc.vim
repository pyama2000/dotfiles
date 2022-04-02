" let s:deol_win_width_ratio = 0.85
" let s:deol_win_height_ratio = 100
" let deol_win_width = float2nr(&columns * s:deol_win_width_ratio)
" let deol_win_height = float2nr(&lines * s:deol_win_height_ratio)
" " let s:deol_win_width = float2nr((&columns - (&columns * s:deol_win_width_ratio)) / 2);
" " let s:deol_win_height = float2nr((&columns - (&columns * s:deol_win_width_ratio)) / 2);
" 
" " nnoremap <silent><C-o> :<C-u>Deol fish -split=floating -winwidth=deol_win_width -winheight=deol_win_height<CR>
" nnoremap <silent><C-o> :<C-u>Deol fish -split=floating -winwidth=200 -winheight=50<CR>
nnoremap <silent><C-o>f :<C-u>Deol fish -split=floating<CR>
nnoremap <silent><C-o>h :<C-u>Deol fish -split=farleft<CR>
nnoremap <silent><C-o>l :<C-u>Deol fish -split=farright<CR>
tnoremap <ESC>   <C-\><C-n>
