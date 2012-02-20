" Markdown-specific vimscript

if exists('b:_loaded_md') || &cp || version < 700
    finish
endif

let b:_loaded_md = 1


" Fast input {
    " underline title adornments
    nn <buffer> <Leader>u=     yypVr=
    nn <buffer> <Leader>u-     yypVr-
" }
