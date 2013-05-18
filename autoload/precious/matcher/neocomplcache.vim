scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:matcher = {}

function! s:matcher.apply()
	let base_filetype = precious#base_filetype()
	if !neocomplcache#is_enabled()
		return ""
	endif
	let filetype = neocomplcache#context_filetype#get(base_filetype)
	return filetype ==# "nothing" ? "" : filetype
endfunction

call precious#regist_matcher("neocomplcache", s:matcher)
unlet s:matcher


let &cpo = s:save_cpo
unlet s:save_cpo
