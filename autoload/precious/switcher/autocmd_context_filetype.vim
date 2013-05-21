scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:switcher = {}

let s:cahche = {}
function! s:make_dummy_autocmd(filetype)
	if !has_key(s:cahche, a:filetype)
		augroup precious-switcher-autocmd_context_filetype-dummy
			execute "autocmd User PreciousFileType_".a:filetype." execute ''"
		augroup END
	endif
	let s:cahche[a:filetype] = 1
endfunction

function! s:switcher.apply(context)
	let context_filetype = a:context.context_filetype
	call s:make_dummy_autocmd(context_filetype)

	doautocmd <nomodeline> User PreciousFileType
	execute "doautocmd <nomodeline> User PreciousFileType_".context_filetype
endfunction


augroup precious-switcher-autocmd_context_filetype-dummy
	autocmd!
	autocmd User PreciousFileType execute ""
augroup END


call precious#regist_switcher("autocmd_context_filetype", s:switcher)
unlet s:switcher


let &cpo = s:save_cpo
unlet s:save_cpo
