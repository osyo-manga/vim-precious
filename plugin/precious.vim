scriptencoding utf-8
if exists('g:loaded_precious')
  finish
endif
let g:loaded_precious = 1

let s:save_cpo = &cpo
set cpo&vim


let g:precious_enable_switchers = get(g:, "precious_enable_switchers", {})


let g:precious_enable_switch_CursorMoved
\	= get(g:, "precious_enable_switch_CursorMoved", {})

let g:precious_enable_switch_CursorMoved_i
\	= get(g:, "precious_enable_switch_CursorMoved_i", {})


function! s:is_enable_switch_CursorMoved(filetype)
	return (get(g:precious_enable_switch_CursorMoved, "*", 1)
\		 || get(g:precious_enable_switch_CursorMoved, a:filetype, 0))
\		 && get(g:precious_enable_switch_CursorMoved, a:filetype, 1)
endfunction


function! s:is_enable_switch_CursorMoved_i(filetype)
	return (get(g:precious_enable_switch_CursorMoved_i, "*", 1)
\		 || get(g:precious_enable_switch_CursorMoved_i, a:filetype, 0))
\		 && get(g:precious_enable_switch_CursorMoved_i, a:filetype, 1)
endfunction


augroup precious-augroup
	autocmd!
	autocmd FileType * call precious#set_base_filetype(&filetype)

	autocmd CursorMoved *
\		if s:is_enable_switch_CursorMoved(precious#base_filetype())
\|			PreciousSwitchAutcmd
\|		endif

	autocmd CursorMovedI *
\		if s:is_enable_switch_CursorMoved_i(precious#base_filetype())
\|			PreciousSwitchAutcmd
\|		endif

augroup END


command! -bar -nargs=? -complete=filetype
\	PreciousSwitch
\	call precious#switch(empty(<q-args>) ? precious#context_filetype() : <q-args>)

command! -bar
\	PreciousReset
\	call precious#switch(precious#base_filetype())


command! -nargs=1 PreciousSetContextLocal
\	call precious#contextlocal(<q-args>)


command! -bar -nargs=? -complete=filetype
\	PreciousSwitchAutcmd
\	call precious#autocmd_switch(empty(<q-args>) ? precious#context_filetype() : <q-args>)


" textobj
try
	call textobj#user#plugin('precious', {
\     '-': {
\       'select-i': 'icx',
\     '*select-i-function*': 'textobj#precious#select_i_forward',
\     },
\   })
catch
endtry


" quickrun.vim operator
nnoremap <silent> <Plug>(precious-quickrun-op)
\	:<C-u>set operatorfunc=precious#quickrun_operator<CR>g@


let &cpo = s:save_cpo
unlet s:save_cpo
