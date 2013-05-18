scriptencoding utf-8
if exists('g:loaded_precious')
  finish
endif
let g:loaded_precious = 1

let s:save_cpo = &cpo
set cpo&vim

augroup precious-augroup
	autocmd!
	autocmd FileType * call precious#set_base_filetype(&filetype)
	autocmd CursorMoved * call precious#autocmd_switch()
augroup END


command! PreciousSwitch call precious#switch()

let &cpo = s:save_cpo
unlet s:save_cpo
