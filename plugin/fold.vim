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


" FoldingMethode <manual, marker, syntax, indent, expr>
set foldmethod=marker
set foldnestmax=1


" general fold mappings
nmap <silent> <s-F> :foldopen<CR><insert>
nmap <silent> <c-F> :foldclose<CR>
imap <silent> <c-F> <ESC>:foldclose<CR>
autocmd filetype c,cpp setlocal foldmethod=syntax 


" mappings for c and cpp
autocmd filetype c,cpp vmap <silent> <c-F> <esc>:call <SID>c_create_fold_mark()<cr>
autocmd filetype c,cpp imap <silent> <c-a-f> <esc>:call <SID>c_delete_fold_mark()<cr><insert>
autocmd filetype c,cpp nmap <silent> <c-a-f> :call <SID>c_delete_fold_mark()<cr>

"
autocmd filetype c,cpp syn region	cFold		matchgroup=cComment start="/\*{{{\*/" end="/\*}}}\*/" contains=cCppParen,cFormat,cComment,cInclude,cType,cTodo,cStatement,cppStatement,cStructure,cDefine,cRepeat,cLabel,cUserCont,cStorageClass,cString,cCppString,cCommentL,cCommentStart,cConditional,cRepeat,cCharacter,cSpecialCharacter,cNumber,cOctal,cOctalZero,cFloat,cOctalError,cOperator,cPreProc,cIncluded,cError,cPreCondit,cConstant,cCppSkip,cCppOut,cSpecial,cCommentString,cComment2String,cCommentSkip fold
