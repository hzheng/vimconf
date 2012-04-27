" HTML-specific vimscript

if exists('b:_loaded_html') || &cp || version < 700
    finish
endif

let b:_loaded_html = 1


" Debug {
    setl efm=\"%f\":%l.%c-%m
    setl makeprg=curl\ -s\ -F\ laxtype=yes\ -F\ parser=html5\
                \ -F\ level=warn\ -F\ out=gnu\ -F\ doc=@%\
                \ http://validator.nu
" }

"=============Plugin settings=============

exe "so " g:BUNDLE_PATH . '/xmledit/ftplugin/xml.vim'
let loaded_xmledit = 1
