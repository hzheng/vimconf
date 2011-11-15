" HTML-specific vimscript

if exists('b:_loaded_html') || &cp || version < 700
    finish
endif

let b:_loaded_html = 1


exe "so " g:BUNDLE_PATH . '/xmledit/ftplugin/xml.vim'
let loaded_xmledit = 1
