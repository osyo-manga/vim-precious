scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! precious#set_base_filetype(filetype)
	let b:precious_base_filetype = a:filetype
endfunction


function! precious#base_filetype()
	if !has_key(b:, "precious_base_filetype")
		call precious#set_base_filetype(&filetype)
	endif
	return b:precious_base_filetype
endfunction


let s:matchers = []
function! precious#regist_matcher(name, matcher)
	call insert(s:matchers, {
\		"name"    : a:name,
\		"matcher" : a:matcher
\	})
endfunction


function! precious#context_filetype()
	let base_filetype = precious#base_filetype()
	for matcher in s:matchers
		let filetype = matcher.matcher.apply(base_filetype)
		if !empty(filetype)
			return filetype
		endif
	endfor
	return base_filetype
endfunction


let s:blocks = {
\	"vim" : [
\		{"start" : 'ruby\s*<<\s*REOF', "end" : '^REOF', "filetype" : "ruby", },
\		{"start" : 'python\s*<<\s*PEOF', "end" : '^PEOF', "filetype" : "python", },
\	],
\	"html" : [
\		{"start" : '<script language="JavaScript">', "end" : '^<\/script>', "filetype" : "javascript", },
\	],
\}

let s:matcher = {}

function! s:matcher.apply(base_filetype)
	let blocks = get(s:blocks, a:base_filetype, [])
	if empty(blocks)
		return ""
	endif
	for block in blocks
		if searchpair(block.start, "", block.end, "nbW")
			return block.filetype
		endif
	endfor
	return ""
endfunction

" call precious#regist_matcher("blocks", s:matcher)
unlet s:matcher


let s:matcher = {}

function! s:matcher.apply(base_filetype)
	let filetype = neocomplcache#context_filetype#get(a:base_filetype)
	return filetype ==# "nothing" ? "" : filetype
endfunction

call precious#regist_matcher("neocomplcache", s:matcher)
unlet s:matcher



let s:switchers = []
function! precious#regist_switcher(name, switcher)
	call insert(s:switchers, {
\		"name"    : a:name,
\		"switcher" : a:switcher
\	})
endfunction


function! precious#switch()
	let context_filetype = precious#context_filetype()
	if context_filetype == &filetype
		return 0
	endif

	let base_filetype = precious#base_filetype()
	let context = {
\		"base_filetype" : base_filetype,
\		"context_filetype" : context_filetype,
\	}
	for switcher in s:switchers
		call switcher.switcher.apply(context)
	endfor
endfunction

let s:switch_last_error_msg = ""
function! precious#switch_last_error_message()
	return s:switch_last_error_msg
endfunction

function! precious#autocmd_switch()
	try
		call precious#switch()
	catch //
		echo "Throw precious#autocmd_switch() : Please 'echo precious#switch_last_error_message()'"
		let s:switch_last_error_msg = v:throwpoint . " : " . v:errmsg . " : " . v:exception
	endtry
endfunction


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
