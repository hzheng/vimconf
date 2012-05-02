" XML/HTML's common vimscript

if exists('b:_loaded_xml_common') || &cp || version < 700
    finish
endif

let b:_loaded_xml_common = 1


" entities
"imap <leader>> &gt;
"imap <leader>< &lt;

" Debug {
    if &filetype == 'html'
        let b:parser = 'html4'
    elseif &filetype =~ 'html5'
        let b:parser = 'html5'
    else " xml, xhtml etc.
        let b:parser = 'xml'
    endif

    if &makeprg != 'make'
        " if makeprg has been set, don't override it.
        " some plugin(e.g. markdown plugin) may invoke
        " this script for non-sgml file
        finish
    endif

    setl efm=\"%f\":%l.%c-%m
    exe 'setl makeprg=curl\ -s\ -F\ laxtype=yes\ -F\ parser=' .
                \b:parser .
                \'\ -F\ level=error\ -F\ out=gnu\ -F\ doc=@%' .
                \'\ http://validator.nu'
" }
