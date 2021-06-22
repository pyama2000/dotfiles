let g:floaterm_autoclose = 1
let g:floaterm_height = 0.8
let g:floaterm_width = 0.85

" keymap
nnoremap   <silent>   <C-u>n    :FloatermNew<CR>
tnoremap   <silent>   <C-u>n    <C-\><C-n>:FloatermNew<CR>
nnoremap   <silent>   <C-u>[    :FloatermPrev<CR>
tnoremap   <silent>   <C-u>[    <C-\><C-n>:FloatermPrev<CR>
nnoremap   <silent>   <C-u>]    :FloatermNext<CR>
tnoremap   <silent>   <C-u>]    <C-\><C-n>:FloatermNext<CR>
nnoremap   <silent>   <C-u>t   :FloatermToggle<CR>
tnoremap   <silent>   <C-u>t   <C-\><C-n>:FloatermToggle<CR>
