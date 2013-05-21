scriptencoding utf-8
" if exists('g:loaded_precious')
"   finish
" endif
" let g:loaded_precious = 1

let s:save_cpo = &cpo
set cpo&vim


let g:precious_enable_auto_switch_CursorMoved
\	= get(g:, "precious_enable_auto_switch_cursormoved", 1)

let g:precious_enable_auto_switch_CursorMoved_i
\	= get(g:, "precious_enable_auto_switch_CursorMoved_i", 1)


augroup precious-augroup
	autocmd!
	autocmd FileType * call precious#set_base_filetype(&filetype)

	autocmd CursorMoved *
\		if g:precious_enable_auto_switch_CursorMoved
\|			call precious#autocmd_switch()
\|		endif

	autocmd CursorMovedI *
\		if g:precious_enable_auto_switch_CursorMoved_i
\|			call precious#autocmd_switch()
\|		endif

augroup END


command! PreciousSwitch call precious#switch()


command! -nargs=1 PreciousSetContextLocal
\	call precious#contextlocal(<q-args>)


let &cpo = s:save_cpo
unlet s:save_cpo
