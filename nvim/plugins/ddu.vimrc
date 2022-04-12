nnoremap <silent> ;a
      \ <Cmd>call ddu#start({})<CR>
nnoremap <silent> ;b
      \ <Cmd>call ddu#start({'name': 'buffers'})<CR>
nnoremap <silent> ;g
      \ <Cmd>call ddu#start({'name': 'grep'})<CR>
nnoremap <silent> ;c
      \ <Cmd>call ddu#start({'name': 'cursor-grep', 'sources': [{'name': 'rg', 'params': {'input': expand('<cword>')}}]})<CR>

let s:float_window_width_ratio = 0.85
let s:float_window_height_ratio = 0.7

call ddu#custom#patch_global({
    \   'ui': 'ff',
    \   'uiParams': {
    \     'ff': {
    \       'split': 'floating',
    \       'startFilter': v:true,
    \       'winCol': float2nr((&columns - (&columns * s:float_window_width_ratio)) / 2),
    \       'winHeight': float2nr(&lines * s:float_window_height_ratio),
    \       'winRow': float2nr((&lines - (&lines * s:float_window_height_ratio)) / 2),
    \       'winWidth': float2nr(&columns * s:float_window_width_ratio),
    \       'prompt': '❯ ',
    \     },
    \   },
    \   'sources': [{'name': 'file_rec'}],
    \   'sourceOptions': {
    \     '_': {
    \       'matchers': ['matcher_substring'],
    \     },
    \   },
    \   'kindOptions': {
    \     'file': {
    \       'defaultAction': 'open',
    \     },
    \   },
    \ })

call ddu#custom#patch_local('buffers', {
    \   'uiParams': {
    \     'ff': {
    \       'startFilter': v:false,
    \     },
    \   },
    \   'sources': [{'name': 'buffer'}],
    \ })

call ddu#custom#patch_local('grep', {
    \   'volatile': v:true,
    \   'uiParams': {
    \     'ff': {
    \       'ignoreEmpty': v:false,
    \       'autoResize': v:false,
    \     },
    \   },
    \   'sources': [{'name': 'rg'}],
    \   'sourceParams': {
    \     'rg': {
    \       'args': ['--column', '--no-heading', '--color', 'never'],
    \     },
    \   },
    \   'sourceOptions': {
    \     '_': {
    \       'matchers': [],
    \     },
    \   },
    \ })

call ddu#custom#patch_local('cursor-grep', {
    \   'uiParams': {
    \     'ff': {
    \       'startFilter': v:false,
    \       'ignoreEmpty': v:false,
    \       'autoResize': v:false,
    \     },
    \   },
    \   'sources': [{'name': 'rg'}],
    \   'sourceParams': {
    \     'rg': {
    \       'args': ['--column', '--no-heading', '--color', 'never'],
    \     },
    \   },
    \ })

autocmd FileType ddu-ff call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> s
        \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'name': 'open', 'params': {'command': 'split'}})<CR>
  nnoremap <buffer><silent> v
        \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'name': 'open', 'params': {'command': 'vsplit'}})<CR>
  nnoremap <buffer><silent> i
        \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> p
        \ <Cmd>call ddu#ui#ff#do_action('preview')<CR>
  nnoremap <buffer><silent> q
        \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
function! s:ddu_filter_my_settings() abort
  inoremap <buffer><silent> <CR>
  \ <Esc><Cmd>close<CR>
  nnoremap <buffer><silent> <CR>
  \ <Cmd>close<CR>
  nnoremap <buffer><silent> q
  \ <Cmd>close<CR>
endfunction
