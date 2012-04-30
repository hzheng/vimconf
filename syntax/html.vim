" Vim syntax file
" Language:	HTML

if !exists("main_syntax")
    if version < 600
        syntax clear
    elseif exists("b:current_syntax")
        finish
    endif
    let main_syntax = 'html'
endif

if &filetype =~ 'html5'
    " coming here means html5 is detected from ftdetect/types.vim,
    " hence we have to manually source html5 syntax
    let b:current_syntax = "html"
    so <sfile>:p:h/html5.vim
    "runtime! syntax/html5.vim
    unlet b:current_syntax
endif

if main_syntax == 'html'
    unlet main_syntax
endif
