" plugin for creating and deleting fold-marks
" 	this is only required if the foldmethod is set to syntax but
" 	marker should also be used

if exists('g:loaded_folding') || &compatible
	finish
endif

let g:loaded_folding = 1

" get own script ID
nmap <c-f11><c-f12><c-f13> <sid>
let s:sid = "<SNR>" . maparg("<c-f11><c-f12><c-f13>", "n", 0, 1).sid . "_"
nunmap <c-f11><c-f12><c-f13>


""""
"" global variables
""""
"{{{
let g:fold_map_create = get(g:, "fold_map_create", "<c-f>")
let g:fold_map_delete = get(g:, "fold_map_delete", "<c-a-f>")
let g:fold_map_toggle = get(g:, "fold_map_toggle", "ff")
let g:fold_map_toggle_all = get(g:, "fold_map_toggle_all", "gff")

let g:fold_state = 1
"}}}

""""
"" local functions
""""
"{{{
" setup folding config
function s:fold_init()
	if index(['c', 'cpp', 'yacc'], &filetype) != -1
		call util#map#ni(g:fold_map_create, ':call ' . s:sid . 'fold_toggle()<cr>', '<buffer>')
		call util#map#ni(g:fold_map_delete, ':call' . s:sid . 'fold_delete_mark()<cr>', '<buffer>')
		call util#map#v(g:fold_map_create, ':call ' . s:sid . 'fold_create_mark()<cr>', '<buffer>')

	else
		call util#map#ni(g:fold_map_create, 'za', '<buffer> noinsert')
		call util#map#ni(g:fold_map_delete, 'zd', '<buffer>')
		call util#map#v(g:fold_map_create, ':fold<cr>', '<buffer> noinsert')
	endif
endfunction
"}}}

"{{{
" toggle fold
function s:fold_toggle()
	setlocal foldmethod=syntax
	normal! za
	setlocal foldmethod=manual
endfunction
"}}}

"{{{
" create a fold-mark for the last region selected in visual mode
function s:fold_create_mark()
	setlocal foldmethod=syntax

	exec "normal! '<A /*{{{*/"
	exec "normal! '>A /*}}}*/"
	exec "foldclose"

	setlocal foldmethod=manual
endfunction
"}}}

"{{{
" delete a fold-mark for c-files
function s:fold_delete_mark()
	" open current fold if trying to delete a closed fold
	if foldclosed('.') != -1
		exe "foldopen"
	endif

	" goto start of line
	exe "normal! 0"

	" check wether current line is
	" 	start of a fold
	" 	end of a fold
	" 	part of a fold
	if search(' \/\*{{{\*\/', '', line('.')) != 0
		exec "normal! 2diw"
		call search(' \/\*}}}\*\/')
		exec "normal! 2diw"
	elseif search(' \/\*}}}\*\/', '', line('.')) != 0
		exec "normal! 2diw"
		call search(' \/\*{{{\*\/', 'b')
		exec "normal! 2diw"
	else
		call search(' \/\*}}}\*\/')
		exec "normal! 2diw"
		call search(' \/\*{{{\*\/', 'b')
		exec "normal! 2diw"
	endif
endfunction
"}}}

"{{{
function s:fold_toggle_all()
	if g:fold_state == 1
		exec "0,$foldopen"
		let g:fold_state = 0
	else
		exec "0,$foldclose"
		let g:fold_state = 1
	endif
endfunction
"}}}

""""
"" autocommands
""""
"{{{
" syntax region for C/C++ fold markers
autocmd filetype c,cpp syn region	cFold		matchgroup=cComment start="/\*{{{\*/" end="/\*}}}\*/" contains=cCppParen,cFormat,cComment,cInclude,cType,cTodo,cStatement,cppStatement,cStructure,cDefine,cRepeat,cLabel,cUserCont,cStorageClass,cString,cCppString,cCommentL,cCommentStart,cConditional,cRepeat,cCharacter,cSpecialCharacter,cNumber,cOctal,cOctalZero,cFloat,cOctalError,cOperator,cPreProc,cIncluded,cError,cPreCondit,cConstant,cCppSkip,cCppOut,cSpecial,cCommentString,cComment2String,cCommentSkip fold

" intially close folds
autocmd filetype c,cpp,yacc,sh	setlocal foldmethod=syntax | silent! 0,$foldclose | setlocal foldmethod=manual
autocmd filetype java 			setlocal foldmethod=syntax foldnestmax=2 | silent! 0,$foldclose | setlocal foldmethod=manual
"}}}

""""
"" vim config
""""
"{{{
" FoldingMethod <manual, marker, syntax, indent, expr>
set foldmethod=marker
set foldnestmax=1
"}}}


""""
"" mappings
""""
"{{{
call util#map#n(g:fold_map_toggle_all, ':call ' . s:sid . 'fold_toggle_all()<cr>', '')
call util#map#n(g:fold_map_toggle, 'za', '')

" fold creation
autocmd filetype * call s:fold_init()
"}}}
