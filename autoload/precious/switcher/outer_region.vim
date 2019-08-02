scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:syntax_region_name = 'preciousOuterContext'
let s:switcher = {}

function! s:switcher.apply(context)
  let has_contextfiletype_vim = 0
  silent! let has_contextfiletype_vim = context_filetype#version()
  if !has_contextfiletype_vim
    echo "precious.vim - Please install context_filetype.vim"
    return ""
  endif

  if a:context.base_filetype !=# a:context.context_filetype
    call s:start_region_update()
  else
    call s:stop_region_update()
  endif
endfunction


call precious#regist_switcher("outer_region", s:switcher)
unlet s:switcher


function! s:start_region_update()
  augroup precious-switcher-outer-region
    autocmd! * <buffer>
    autocmd CursorMoved,CursorMovedI <buffer> call s:update_region()
  augroup END
  execute 'highlight default link' s:syntax_region_name 'Comment'
  call s:update_region()
endfunction

function! s:stop_region_update()
  augroup precious-switcher-outer-region
    autocmd! * <buffer>
  augroup END
  call s:clear_region()
endfunction

function! s:update_region()
  let base_filetype = precious#base_filetype()
  let context = context_filetype#get(base_filetype)
  if &filetype !=# context.filetype
        \ || get(b:, 'precious_prev_context_range', []) ==# context.range
    return
  endif

  let [first_line, first_col] = context.range[0]
  let [last_line , last_col ] = context.range[1]
  if first_col == 1
    let first_line = max([1, first_line - 1])
    let first_col  = col([first_line, '$'])
  endif
  if last_col < col([last_line, '$']) - 1
    let last_col  += 1
  else
    let last_line += 1
    let last_col   = 1
  endif

  silent! execute 'syntax clear' s:syntax_region_name
  execute 'syntax region' s:syntax_region_name
        \ 'start="\%<'. first_line .'l^"'
        \ 'end="\%'. first_line .'l\%'. first_col .'c"'
        \ 'keepend'
  execute 'syntax region' s:syntax_region_name
        \ 'start="\%'. last_line .'l\%'. last_col .'c"'
        \ 'end="\%$"'
        \ 'keepend containedin=ALL'

  let b:precious_prev_context_range = copy(context.range)
endfunction

function! s:clear_region()
  silent! execute 'syntax clear' s:syntax_region_name
  unlet! b:precious_prev_context_range
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
