" Python-specific vimscript

" Define some abbreviations
"imap im import

"autocmd FileType python set omnifunc=pythoncomplete#Complete

" PyDiction {
    let g:pydiction_location = '~/.vim/pydiction/complete-dict'
    let g:pydiction_menu_height = 20
    set complete+=k~/.vim/pydiction iskeyword+=.,(
" }
