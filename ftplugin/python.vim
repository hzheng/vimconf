" Python-specific vimscript

if exists("b:_loaded_python_vim")
    finish
endif

let b:_loaded_python_vim = 1

" Edit {
    set ofu=pythoncomplete#Complete

    set fdm=indent   "fold based on indent
    set nosmartindent "no smart indent
" }

"=============Plugin settings=============

if utils#enabledPlugin('pydoc') > 0
    nmap <buffer> <Leader>w <Leader>pw<CR>
    "nmap <buffer> <Leader>W <Leader>pW<CR>
    nmap <buffer> <Leader>k <Leader>pk<CR>
    "nmap <buffer> <Leader>K <Leader>pK<CR>
endif

if utils#enabledPlugin('pyflakes') > 0
    "let g:pyflakes_use_quickfix = 0
endif

if utils#enabledPlugin('ropevim') > 0
    nmap <leader>j :RopeGotoDefinition<CR>
    nmap <leader>R :RopeRename<CR>

    "let $PYTHONPATH .= ":" . g:BUNDLE_PATH . "/ropevim/ftplugin/python/libs/rope"
    let ropevim_vim_completion = 1
endif

if utils#enabledPlugin('pytest') > 0
    nmap <buffer> <Leader>tt :Pytest<SPACE>
    nmap <buffer> <Leader>tf :Pytest file<CR>
    nmap <buffer> <Leader>tF :Pytest file verbose<CR>
    nmap <buffer> <Leader>tc :Pytest class<CR>
    nmap <buffer> <Leader>tC :Pytest class verbose<CR>
    nmap <buffer> <Leader>tm :Pytest method<CR>
    nmap <buffer> <Leader>tM :Pytest method verbose<CR>
    nmap <buffer> <Leader>te :Pytest error<CR>
    nmap <buffer> <Leader>ts :Pytest session<CR>
    nmap <buffer> <Leader>tn <Esc>:Pytest next<CR>
    nmap <buffer> <Leader>tp <Esc>:Pytest previous<CR>
endif

if utils#enabledPlugin('pydiction') == 0
    let g:pydiction_location = g:BUNDLE_PATH . '/pydiction/complete-dict'
    let g:pydiction_menu_height = 20
    "set complete+=k~/.vim/bundle/pydiction iskeyword+=.,(

    " manually load
    call utils#loadPlugin('pydiction')
endif

if utils#enabledPlugin('pep8') == 0
    let g:pep8_map = '<buffer> <Leader>8'

    " manually load
    call utils#loadPlugin('pep8')
endif
