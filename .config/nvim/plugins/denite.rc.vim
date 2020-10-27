" To browse a list of current directory and buffers
nnoremap <silent><C-d>a :<C-u>Denite file buffer -split=floating file:new<CR>
" To browse a list of currently open buffers
nnoremap <silent><C-d>b :<C-u>Denite buffer -split=floating file:new<CR>
" To browse a list of current directory
nnoremap <silent><C-d>f :<C-u>Denite file -split=floating file:new<CR>
" To browse recursive list of all the files under the current working
" directory
nnoremap <silent><C-d>r :<C-u>Denite file/rec -split=floating file:new<CR>
" Normal grep
nnoremap <silent><C-d>gr :<C-u>Denite grep -buffer-name=search<CR>
" Grep under the cursor word
nnoremap <silent><C-d>, :<C-u>DeniteCursorWord grep -buffer-name=search line<CR>
" Resume the grep search buffer
nnoremap <silent><C-d>gs :<C-u>Denite -resume -buffer-name=search<CR>
" Gather command histories and run it
nnoremap <silent><C-d>c :<C-u>Denite command_history -split=floating<CR>

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> o
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> s
  \ denite#do_map('do_action', 'split')
  nnoremap <silent><buffer><expr> v
  \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

" Change file/rec command for `ripgrep`
call denite#custom#var('file/rec', 'command',
    \ ['rg', '--files', '--hidden', '--glob', '!.git'])

" Change grep source command for `ripgrep`
call denite#custom#var('grep', 'command',
    \ ['rg', '--hidden', '--glob', '!.git'])
call denite#custom#var('grep', 'default_opts',
		\ ['-i', '--vimgrep', '--no-heading'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
