" Vim syntax file
" Language:	HTML5

if exists("b:changing_filetype")
    " coming here means html5 is detected from ftdetect/types.vim,
    " the syntax settings below won't take effect, so just skip them
    finish
endif

if version < 600
    syntax clear
elseif exists("b:current_syntax") && b:current_syntax == 'html5'
    finish
endif

if !exists("main_syntax")
    let main_syntax = 'html5'
endif

if !exists("b:current_syntax")
    if version < 600
        so <sfile>:p:h/html.vim
    else
        runtime! syntax/html.vim
        "unlet b:current_syntax
    endif
endif

"echomsg 'SETTING html5 syntax...' 

" Based on http://gist.github.com/256840
" HTML 5 tags
syn keyword htmlTagName contained article aside audio bb canvas command datagrid
syn keyword htmlTagName contained datalist details dialog embed figure footer
syn keyword htmlTagName contained header hgroup keygen mark meter nav output
syn keyword htmlTagName contained progress time ruby rt rp section time video
syn keyword htmlTagName contained source figcaption

" HTML 5 arguments
syn keyword htmlArg contained autofocus autocomplete placeholder min max step
syn keyword htmlArg contained contenteditable contextmenu draggable hidden item
syn keyword htmlArg contained itemprop list sandbox subject spellcheck
syn keyword htmlArg contained novalidate seamless pattern formtarget manifest
syn keyword htmlArg contained formaction formenctype formmethod formnovalidate
syn keyword htmlArg contained sizes scoped async reversed sandbox srcdoc
syn keyword htmlArg contained hidden role
syn match   htmlArg "\<\(aria-[\-a-zA-Z0-9_]\+\)=" contained
syn match   htmlArg contained "\s*data-[-a-zA-Z0-9_]\+"

let b:current_syntax = "html5"
