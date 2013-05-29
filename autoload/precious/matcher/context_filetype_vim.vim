scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:matcher = {}


function! s:matcher.apply()
	let base_filetype = precious#base_filetype()
	let has_contextfiletype_vim = 0
	silent! let has_contextfiletype_vim = context_filetype#version()
	if has_contextfiletype_vim
		return context_filetype#get_filetype(base_filetype)
	else
		echo "precious.vim - Please install context_filetype.vim"
		return ""
	endif
endfunction


call precious#regist_matcher("context_filetype_vim", s:matcher)
unlet s:matcher


let &cpo = s:save_cpo
unlet s:save_cpo
