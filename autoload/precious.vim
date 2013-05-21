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


let s:matchers = {}
function! precious#regist_matcher(name, matcher)
	let s:matchers[a:name] = a:matcher
" 	call insert(s:matchers, {
" \		"name"    : a:name,
" \		"matcher" : a:matcher
" \	})
endfunction


function! precious#context_filetype()
	for matcher in values(s:matchers)
		let filetype = matcher.apply()
		if !empty(filetype)
			return filetype
		endif
	endfor
	return precious#base_filetype()
endfunction



let s:switchers = {}
function! precious#regist_switcher(name, switcher)
	let s:switchers[a:name] = a:switcher
" 	call insert(s:switchers, {
" \		"name"    : a:name,
" \		"switcher" : a:switcher
" \	})
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

	call precious#reset_contextlocal()
	for switcher in values(s:switchers)
		call switcher.apply(context)
	endfor
endfunction


function! precious#contextlocal(expr)
	if !exists("b:precious_option_backup")
		let b:precious_option_backup = {}
	endif

	let expr = substitute(a:expr, '^no', '', "")
	let option = matchstr(expr, '\zs\w*\ze.*')
	
	execute "let old = &l:".option

	if !has_key(b:precious_option_backup, option)
		let b:precious_option_backup[option] = old
	endif
	execute "setlocal "a:expr
endfunction


function! precious#reset_contextlocal()
	if exists("b:precious_option_backup")
		for setting in items(b:precious_option_backup)
			execute "let &".setting[0]."=".setting[1]
		endfor
	endif
	let b:precious_option_backup = {}
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



function! s:setup()
	for file in split(globpath(&rtp, "autoload/precious/matcher/*.vim"), "\n")
		:source `=file`
	endfor

	for file in split(globpath(&rtp, "autoload/precious/switcher/*.vim"), "\n")
		:source `=file`
	endfor
endfunction
call s:setup()


let &cpo = s:save_cpo
unlet s:save_cpo
