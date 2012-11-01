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
      if line("'[") == line('$') + 1
        if after_mapping != ''
          silent exe "normal ".after_mapping
        endif
      else
        silent exe "normal ".before_mapping
      endif
    elseif a:normal_command ==# 'p' && after_mapping != ''
      if line("'[") == 0
        if before_mapping != ''
          silent exe "normal ".before_mapping
        endif
      else
        silent exe "normal ".after_mapping
      endif
    else
      continue
    endif

    let text = join(sj#GetLines(line("'["), line("']")), "\n")."\n"

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
  elseif line("']") == line('$') + 1
    normal! p
  else
    exe 'normal! '.a:normal_command
  endif
endfunction
