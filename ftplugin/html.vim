" HTML-specific vimscript

if exists("_loaded_html_vim")
    finish
endif

let _loaded_html_vim = 1

exe "so " g:BUNDLE_PATH . '/xmledit/ftplugin/xml.vim'
let loaded_xmledit = 1
