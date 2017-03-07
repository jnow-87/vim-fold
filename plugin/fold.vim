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
let g:fold_map_toggle_ni = get(g:, "fold_map_toggle_ni", "<c-f>")
let g:fold_map_toggle_n = get(g:, "fold_map_toggle", "ff")
let g:fold_map_open_all = get(g:, "fold_map_open_all", "fo")
let g:fold_map_close_all = get(g:, "fold_map_close_all", "fc")
"}}}

""""
"" local functions
""""
"{{{
" toggle fold
function s:fold_toggle_syntax()
	setlocal foldmethod=syntax
	silent! normal! za
	setlocal foldmethod=manual
endfunction
"}}}

""""
"" autocommands
""""
"{{{
autocmd filetype c,cpp,yacc,sh,java
	\ setlocal foldmethod=syntax |
	\ silent! 0,$foldclose |
	\ setlocal foldmethod=manual |
	\ call util#map#ni(g:fold_map_toggle_ni, ':call ' . s:sid . 'fold_toggle_syntax()<cr>', '<buffer> noinsert')

autocmd filetype java setlocal foldnestmax=2
"}}}

""""
"" vim config
""""
"{{{
set foldmethod=marker
set foldnestmax=1
"}}}

""""
"" mappings
""""
"{{{
call util#map#n(g:fold_map_open_all, 'zR', '')
call util#map#n(g:fold_map_close_all, 'zM', '')
call util#map#ni(g:fold_map_toggle_ni, 'za', 'noinsert')
call util#map#n(g:fold_map_toggle_n, 'za', '')
"}}}
