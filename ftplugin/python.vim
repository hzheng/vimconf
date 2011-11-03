" Python-specific vimscript

" Define some abbreviations
"imap im import

"autocmd FileType python set omnifunc=pythoncomplete#Complete

" PyDiction {
    let g:pydiction_location = g:BUNDLE . 'pydiction/complete-dict'
    let g:pydiction_menu_height = 20
    "set complete+=k~/.vim/bundle/pydiction iskeyword+=.,(
" }

set fdm=indent   "fold based on indent

set nosmartindent "no smart indent
