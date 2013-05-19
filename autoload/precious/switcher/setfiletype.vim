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


function! s:reset_filetype()
	if &filetype != precious#base_filetype()
		let &filetype = precious#base_filetype()
	endif
endfunction

augroup precious-switcher-setfiletype
	autocmd!
	autocmd BufWinLeave * call s:reset_filetype()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
