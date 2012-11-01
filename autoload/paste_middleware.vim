function! paste_middleware#Paste(normal_command, visual)
  exe 'normal! '.a:normal_command

  if getregtype() !=# 'V'
    " Only linewise for now
    return
  endif

  undo

  for [before_mapping, after_mapping] in g:paste_middleware_stack
    let saved_cursor = getpos('.')

    if a:normal_command ==# 'P' && before_mapping != ''
      silent exe "normal ".before_mapping
    elseif a:normal_command ==# 'p' && after_mapping != ''
      if line("'[") <= 1
        silent exe "normal ".before_mapping
      else
        silent exe "normal ".after_mapping
      endif
    else
      continue
    endif

    let [start, end] = [getpos("'["), getpos("']")]

    if getregtype() ==# 'V'
      let text = join(sj#GetLines(line("'["), line("']")), "\n")."\n"
    elseif getregtype() ==# 'v'
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

    " TODO (2012-11-01) Specific for linewise, extract
    exe line("'[").','.line("']").'delete _'

    call setpos('.', saved_cursor)
  endfor

  " Problem: on the first (zeroth) line, dropping whitespace completely means
  " it's necessary to use P instead of p on the second round
  " TODO (2012-11-01) Check scenarios, document somehow
  if line("'[") == 0
    normal! P
  else
    exe 'normal! '.a:normal_command
  endif
endfunction
