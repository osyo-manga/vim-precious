scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:nullpos = [0, 0]

function! s:to_cursorpos(pos)
	if a:pos == s:nullpos
		return [0, 0, 0, 0]
	endif
	return [0, a:pos[0], a:pos[1], 0]
endfunction


function! textobj#precious#select_i_forward()
	let [start, end] = context_filetype#get_range(precious#base_filetype())
	return ["v",
\		s:to_cursorpos(start),
\		s:to_cursorpos(end)
\	]
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo

