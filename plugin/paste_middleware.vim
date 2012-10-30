if exists("g:loaded_paste_middleware") || &cp
  finish
endif

let g:loaded_paste_middleware = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

function! PasteOne()
  let @" = "              one"
  let @+ = "              one"
  let @* = "              one"
  put
endfunction

function! PasteIndent()
  put
  normal! ==
endfunction

nmap <Plug>PasteOne    :call PasteOne()<cr>
nmap <Plug>PasteIndent :call PasteIndent()<cr>

let g:paste_middleware_stack = [
      \   "\<Plug>PasteIndent"
      \ ]

" nnoremap p :silent call PasteStack()<cr>

function! PasteStack()
  normal! p
  undo

  for mapping in g:paste_middleware_stack
    silent exe "normal ".mapping
    let [start, end] = [getpos("'["), getpos("']")]

    if getregtype() == 'V'
      let text = join(sj#GetLines(line("'["), line("']")), "\n")."\n"
    elseif getregtype() == 'v'
      " TODO (2012-10-30) Not quite working, due to positions changing
      let saved_cursor = getpos('.')
      let text = sj#GetByPosition(start, end)
      call setpos('.', saved_cursor)
    elseif getregtype() =~ "\<c-v>\\d\\+"
      " TODO (2012-10-30) Not quite working, due to having no idea how to work
      " with it
      let text = @"
    endif

    let @" = text
    let @+ = text
    let @* = text

    undo
  endfor

  normal! p
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
