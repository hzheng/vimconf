" Python-specific vimscript

" Define some abbreviations
"imap im import

"autocmd FileType python set omnifunc=pythoncomplete#Complete

" PyDiction {
    let g:pydiction_location = g:BUNDLE_PATH . '/pydiction/complete-dict'
    let g:pydiction_menu_height = 20
    "set complete+=k~/.vim/bundle/pydiction iskeyword+=.,(
" }

set fdm=indent   "fold based on indent

set nosmartindent "no smart indent

" Pydoc {
    "nn <Leader>py :call <SID>ShowPyDoc('<C-R><C-W>', 1)<CR>
    nmap <Leader>w <Leader>pw<CR>
    "nmap <Leader>W <Leader>pW<CR>
    nmap <Leader>k <Leader>pk<CR>
    "nmap <Leader>K <Leader>pK<CR>
" }
