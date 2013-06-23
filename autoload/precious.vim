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


function! s:prev_context_filetype()
	if !exists("b:precious_prev_context_filetype")
		let b:precious_prev_context_filetype = precious#base_filetype()
	endif
	return b:precious_prev_context_filetype
endfunction


function! s:is_enable_switch(switch, filetype)
	return (get(get(g:precious_enable_switchers, "*", {}), a:switch, 1)
\		 || get(get(g:precious_enable_switchers, a:filetype, {}), a:switch, 0))
\		 && get(get(g:precious_enable_switchers, a:filetype, {}), a:switch, 1)
endfunction


function! precious#switch(filetype)
	let context_filetype = a:filetype

	let prev_context_filetype = s:prev_context_filetype()
	if context_filetype == prev_context_filetype
		return 0
	endif

	let base_filetype = precious#base_filetype()
	let context = {
\		"base_filetype" : base_filetype,
\		"context_filetype" : context_filetype,
\		"prev_context_filetype" : prev_context_filetype
\	}

	call precious#reset_contextlocal()
	try
		for [name, switcher] in items(s:switchers)
			if s:is_enable_switch(name, base_filetype)
				call switcher.apply(context)
			endif
		endfor
	finally
		let b:precious_prev_context_filetype = context_filetype
	endtry
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


function! precious#log()
	return s:switch_last_error_msg
endfunction


function! precious#autocmd_switch(...)
	try
		call call("precious#switch", a:000)
	catch
		echo "Throw precious#autocmd_switch() : Please 'echo precious#log()'"
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


function! precious#quickrun_operator(wise)
	let type = precious#context_filetype()
	let wise = {
	\ 'line': 'V',
	\ 'char': 'v',
	\ 'block': "\<C-v>" }[a:wise]
	call quickrun#run({
\		'region': {
\			'first': getpos("'[")[1 :],
\			'last':  getpos("']")[1 :],
\			'wise': wise,
\			'selection': 'inclusive',
\		},
\		"type" : type
\	},
\	)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
