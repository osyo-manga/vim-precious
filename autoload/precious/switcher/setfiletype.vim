scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:switcher = {}

function! s:switcher.apply(context)
	let base_filetype = a:context.base_filetype
	let filetype = a:context.context_filetype
	if &filetype != filetype
		let &filetype = filetype
		call precious#set_base_filetype(base_filetype)
	endif
endfunction



call precious#regist_switcher("setfiletype", s:switcher)
unlet s:switcher


augroup precious-switcher-setfiletype
	autocmd!
	autocmd BufWinLeave *
\		call win_execute(bufwinid(str2nr(expand('<abuf>'))),
\			'call precious#autocmd_switch(precious#base_filetype())')
	autocmd BufWinEnter *
\		call precious#autocmd_switch(precious#context_filetype())
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
