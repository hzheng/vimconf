" XML-specific vimscript

if exists('b:_loaded_xml_extra') || &cp || version < 700
    finish
endif

let b:_loaded_xml_extra = 1


" entities
"imap <leader>> &gt;
"imap <leader>< &lt;

"so ~/.vim/ftplugin/docbook.vim 
