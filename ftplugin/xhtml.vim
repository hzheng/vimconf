" XHTML-specific vimscript

if exists("_loaded_xhtml_vim")
    finish
endif

let _loaded_xhtml_vim = 1

exe "so " g:BUNDLE_PATH . '/xmledit/ftplugin/xml.vim'
let loaded_xmledit = 1
