" Python-specific vimscript

if exists("_loaded_python_vim")
    finish
endif

let _loaded_python_vim = 1

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

" Pyflakes {
    "let g:pyflakes_use_quickfix = 0
" }

" Ropevim {
    nmap <leader>j :RopeGotoDefinition<CR>
    nmap <leader>R :RopeRename<CR>

    "let $PYTHONPATH .= ":" . g:BUNDLE_PATH . "/ropevim/ftplugin/python/libs/rope"
    let ropevim_vim_completion = 1
" }

" Pytest {
    nmap <Leader>tt :Pytest<SPACE>
    nmap <Leader>tf :Pytest file<CR>
    nmap <Leader>tF :Pytest file verbose<CR>
    nmap <Leader>tc :Pytest class<CR>
    nmap <Leader>tC :Pytest class verbose<CR>
    nmap <Leader>tm :Pytest method<CR>
    nmap <Leader>tM :Pytest method verbose<CR>
    nmap <Leader>te :Pytest error<CR>
    nmap <Leader>ts :Pytest session<CR>
" }
