scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let g:precious_matcher_blocks = get(g:, "precious_matcher_blocks", {})


" base source
" neocomplcache context filetype
" https://github.com/Shougo/neocomplcache.vim/blob/master/autoload/neocomplcache/context_filetype.vim
let s:context_blocks = {
\	'c': [
\		{'end': '$', 'filetype': 'masm', 'start': '_*asm_*\s\+\h\w*'},
\		{'end': '}', 'filetype': 'masm', 'start': '_*asm_*\s*\%(\n\s*\)\?{'},
\		{'end': ');', 'filetype': 'gas', 'start': '_*asm_*\s*\%(_*volatile_*\s*\)\?('}
\	],
\	'cpp': [
\		{'end': '$', 'filetype': 'masm', 'start': '_*asm_*\s\+\h\w*'},
\		{'end': '}', 'filetype': 'masm', 'start': '_*asm_*\s*\%(\n\s*\)\?{'},
\		{'end': ');', 'filetype': 'gas', 'start': '_*asm_*\s*\%(_*volatile_*\s*\)\?('}
\	],
\	'd': [{'end': '}', 'filetype': 'masm', 'start': 'asm\s*\%(\n\s*\)\?{'}],
\	'eruby': [{'end': '%>', 'filetype': 'ruby', 'start': '<%[=#]\?'}],
\	'help': [{'end': '^<', 'filetype': 'vim', 'start': '^>'}],
\	'html': [
\		{
\			'end': '</script>',
\			'filetype': 'javascript',
\			'start': '<script\%( [^>]*\)\? type="text/javascript"\%( [^>]*\)\?>'
\		},
\		{
\			'end': '</script>',
\			'filetype': 'coffee',
\			'start': '<script\%( [^>]*\)\? type="text/coffeescript"\%( [^>]*\)\?>'
\		},
\		{
\			'end': '</style>',
\			'filetype': 'css',
\			'start': '<style\%( [^>]*\)\? type="text/css"\%( [^>]*\)\?>'
\		}
\	],
\	'int-nyaos': [{'end': '^\1', 'filetype': 'lua', 'start': '\<lua_e\s\+\(["'']\)'}],
\	'nyaos': [{'end': '^\1', 'filetype': 'lua', 'start': '\<lua_e\s\+\(["'']\)'}],
\	'perl6': [{'end': '}', 'filetype': 'pir', 'start': 'Q:PIR\s*{'}],
\	'python': [
\		{'end': '\\\@<!\1\s*)', 'filetype': 'vim', 'start': 'vim.command\s*(\([''"]\)'},
\		{'end': '\\\@<!\1\s*)', 'filetype': 'vim', 'start': 'vim.eval\s*(\([''"]\)'}
\	],
\	'vim': [
\		{'end': '^\1', 'filetype': 'python', 'start': '^\s*py\%[thon\]3\? <<\s*\(\h\w*\)'},
\		{'end': '^\1', 'filetype': 'ruby', 'start': '^\s*rub\%[y\] <<\s*\(\h\w*\)'},
\		{'end': '^\1', 'filetype': 'lua', 'start': '^\s*lua <<\s*\(\h\w*\)'}
\	],
\	'vimshell': [
\		{'end': '\\\@<!\1', 'filetype': 'vim', 'start': 'vexe \([''"]\)'},
\		{'end': '\n', 'filetype': 'vim', 'start': ' :\w*'},
\		{'end': '\n', 'filetype': 'vim', 'start': ' vexe\s\+'}
\	],
\	'xhtml': [
\		{
\			'end': '</script>',
\			'filetype': 'javascript',
\			'start': '<script\%( [^>]*\)\? type="text/javascript"\%( [^>]*\)\?>'
\		},
\		{
\			'end': '</script>',
\			'filetype': 'coffee',
\			'start': '<script\%( [^>]*\)\? type="text/coffeescript"\%( [^>]*\)\?>'
\		},
\		{
\			'end': '</style>',
\			'filetype': 'css',
\			'start': '<script\%( [^>]*\)\? type="text/css"\%( [^>]*\)\?>'
\		}
\	],
\	'markdown': [
\		{"start" : '^\s*```s*\(\h\w*\)', "end" : '^```$', "filetype" : '\1'},
\	],
\}



" a <= b
function! s:pos_less_equal(a, b)
	return a:a[0] == a:b[0] ? a:a[1] <= a:b[1] : a:a[0] <= a:b[0]
endfunction

let s:null_pos = [0, 0]


function! s:context_region(start_pattern, end_pattern)
	let start = searchpos(a:start_pattern, "bneW")
	if start == s:null_pos
		return []
	endif

	let end_pattern = a:end_pattern
	if end_pattern =~ '\\1'
		let match_list = matchlist(getline(start[0]), a:start_pattern)
		let end_pattern = substitute(end_pattern, '\\1', '\=match_list[1]', 'g')
	endif

	let end_forward = searchpos(end_pattern, 'ncW')
	if end_forward== s:null_pos
		let end_forward = [line('$'), len(getline('$'))+1]
	endif

	let end_backward = searchpos(end_pattern, 'bcnW')
	if s:pos_less_equal(start, end_backward)
		return []
	endif

	if start[1] == len(getline(start[0]))
		let start[0] += 1
		let start[1] = 1
	endif

	return [start, end_forward]
endfunction


function! s:is_in(start_pattern, end_pattern, pos)
	let region = s:context_region(a:start_pattern, a:end_pattern)
	if empty(region)
		return 0
	endif

	" start < pos && pos < end
	if s:pos_less_equal(region[0], a:pos) && s:pos_less_equal(a:pos, region[1])
		return 1
	endif
	return 0
endfunction


function! s:get(filetype)
	let base_filetype = a:filetype
	let contexts = get(extend(copy(s:context_blocks), g:precious_matcher_blocks), base_filetype, [])
	if empty(contexts)
		return ""
	endif

	let pos = [line('.'), col('.')]
	for context in contexts
		if s:is_in(context.start, context.end, pos)
			if context.filetype =~ '\\1'
				let match_list = matchlist(getline(searchpos(context.start, 'nbW')[0]), context.start)
				return substitute(context.filetype, '\\1', '\=match_list[1]', 'g')
			else
				return context.filetype
			endif
		endif
	endfor

	return ""
endfunction


let s:matcher = {}

function! s:matcher.apply()
	let base_filetype = precious#base_filetype()
	return s:get(base_filetype)
endfunction

call precious#regist_matcher("context_blocks", s:matcher)
unlet s:matcher


let &cpo = s:save_cpo
unlet s:save_cpo
