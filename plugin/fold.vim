if exists('g:loaded_folding') || &compatible
	finish
endif

let g:loaded_folding = 1


" plugin for creating and deleting fold-marks
" 	this is only required if the foldmethod is set to syntax but
" 	marker should also be used


" create a fold-mark for the last region selected in visual mode
function s:c_create_fold_mark()
	exec "normal '<A /*{{{*/"
	exec "normal '>A /*}}}*/"
	exec "foldclose"
endfunction

" delete a fold-mark for c-files
function s:c_delete_fold_mark()
	" open current fold if trying to delete a closed fold
	if foldclosed('.') != -1
		exe "foldopen"
	endif

	" goto start of line
	exe "normal 0"

	" check wether current line is
	" 	start of a fold
	" 	end of a fold
	" 	part of a fold
	if search(' \/\*{{{\*\/', '', line('.')) != 0
		exec "normal 2diw"
		call search(' \/\*}}}\*\/')
		exec "normal 2diw"
	elseif search(' \/\*}}}\*\/', '', line('.')) != 0
		exec "normal 2diw"
		call search(' \/\*{{{\*\/', 'b')
		exec "normal 2diw"
	else
		call search(' \/\*}}}\*\/')
		exec "normal 2diw"
		call search(' \/\*{{{\*\/', 'b')
		exec "normal 2diw"
	endif
endfunction

" define region for C/C++ fold markers
autocmd filetype c,cpp syn region	cFold		matchgroup=cComment start="/\*{{{\*/" end="/\*}}}\*/" contains=cCppParen,cFormat,cComment,cInclude,cType,cTodo,cStatement,cppStatement,cStructure,cDefine,cRepeat,cLabel,cUserCont,cStorageClass,cString,cCppString,cCommentL,cCommentStart,cConditional,cRepeat,cCharacter,cSpecialCharacter,cNumber,cOctal,cOctalZero,cFloat,cOctalError,cOperator,cPreProc,cIncluded,cError,cPreCondit,cConstant,cCppSkip,cCppOut,cSpecial,cCommentString,cComment2String,cCommentSkip fold


" FoldingMethod <manual, marker, syntax, indent, expr>
set foldmethod=marker
set foldnestmax=1

autocmd filetype c,cpp setlocal foldmethod=syntax | silent! 0,$foldclose | setlocal foldmethod=manual
autocmd filetype java setlocal foldmethod=syntax foldnestmax=2 | silent! 0,$foldclose | setlocal foldmethod=manual

" create a fold
autocmd filetype * 
	\ if index(['c', 'cpp'], &filetype) != -1 |
	\	nmap <buffer> <silent> <c-f> :setlocal foldmethod=syntax<cr>za:setlocal foldmethod=manual<cr> |
	\	vmap <buffer> <silent> <c-f> <esc>:setlocal foldmethod=syntax<cr>:call <SID>c_create_fold_mark()<cr>:setlocal foldmethod=manual<cr> |
	\	imap <buffer> <silent> <c-f> <esc>:setlocal foldmethod=syntax<cr>za:setlocal foldmethod=manual<cr> |
	\	imap <buffer> <silent> <c-a-f> <esc>:call <SID>c_delete_fold_mark()<cr><insert> |
	\	nmap <buffer> <silent> <c-a-f> :call <SID>c_delete_fold_mark()<cr> |
	\ else |
	\	nmap <buffer> <silent> <c-f> za |
	\	vmap <silent> <c-f> :fold<cr> |
	\	imap <buffer> <silent> <c-f> <esc>za |
	\	nmap <buffer> <silent> <c-a-f> zd |
	\	imap <buffer> <silent> <c-a-f> <esc>zd<insert> |
	\ endif
