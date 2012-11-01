if exists('g:loaded_paste_middleware') || &cp
  finish
endif

let g:loaded_paste_middleware = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

if !exists('g:paste_middleware_stack')
  let g:paste_middleware_stack = []
endif

nmap <silent> <Plug>PasteMiddlewareBefore :silent call paste_middleware#Paste('P', 0)<cr>
nmap <silent> <Plug>PasteMiddlewareAfter  :silent call paste_middleware#Paste('p', 0)<cr>
" xmap <silent> <Plug>PasteMiddlewareBefore :silent call paste_middleware#Paste('P', 1)<cr>
" xmap <silent> <Plug>PasteMiddlewareAfter  :silent call paste_middleware#Paste('p', 1)<cr>

let &cpo = s:keepcpo
unlet s:keepcpo
