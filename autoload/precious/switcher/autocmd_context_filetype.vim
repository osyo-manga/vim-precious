scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:switcher = {}


let s:cache_command = {}
function! s:doautocmd_user(command)
	if !has_key(s:cache_command, a:command)
		execute "autocmd precious-switcher-autocmd_context_filetype-dummy"
\			"User " . a:command." silent! execute ''"
		let s:cache_command[a:command] = "doautocmd <nomodeline> User " . a:command
	endif
	echom s:cache_command[a:command]
	execute s:cache_command[a:command]
endfunction


function! s:switcher.apply(context)
	let context_filetype = a:context.context_filetype
	let prev_context_filetype = a:context.prev_context_filetype
	echo prev_context_filetype

	call s:doautocmd_user("PreciousFileTypeLeave_".prev_context_filetype)
	call s:doautocmd_user("PreciousFileType")
	call s:doautocmd_user("PreciousFileType_".context_filetype)
endfunction


augroup precious-switcher-autocmd_context_filetype-dummy
	autocmd!
augroup END

call precious#regist_switcher("autocmd_context_filetype", s:switcher)
unlet s:switcher


let &cpo = s:save_cpo
unlet s:save_cpo
