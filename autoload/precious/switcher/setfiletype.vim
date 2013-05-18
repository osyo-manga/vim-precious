scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:switcher = {}

function! s:switcher.apply(context)
	let base_filetype = a:context.base_filetype
	let filetype = a:context.context_filetype
	let &filetype = filetype
	call precious#set_base_filetype(base_filetype)
endfunction


call precious#regist_switcher("setfiletype", s:switcher)
unlet s:switcher


let &cpo = s:save_cpo
unlet s:save_cpo
