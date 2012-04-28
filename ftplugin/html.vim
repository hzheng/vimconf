" HTML-specific vimscript

if exists('b:_loaded_html') || &cp || version < 700
    finish
endif

let b:_loaded_html = 1


" Fast input {
    " use <ESC> to avoid the cursor being moved by plugins(e.g. xmledit)
    imap <buffer> <leader>d5 <!DOCTYPE html><ESC>A<CR>
" }

exe "so " escape(expand('<sfile>:p:h'), ' ') . '/xml_common.vim'

"=============Plugin settings=============

exe "so " g:BUNDLE_PATH . '/xmledit/ftplugin/xml.vim'
let loaded_xmledit = 1
