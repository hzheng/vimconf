" Python-specific vimscript

if exists('b:_loaded_python') || &cp || version < 700
    finish
endif

let b:_loaded_python = 1

" Edit {
    setl ofu=pythoncomplete#Complete

    setl fdm=indent   "fold based on indent
    setl nosmartindent "no smart indent
" }

" Debug {
    setl efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

    call utils#mapDebugger('S-F3', 'pylint', 
                \'--output-format=parseable --reports=n', '%f:%l:%m')
    "call utils#mapDebugger('S-F4', 'pychecker', '-Q -q', '%f:%l:%m')
    "call utils#mapDebugger('S-F4', 'pyflakes', '', '%f:%l:%m')
" }

"=============Plugin settings=============

if utils#enabledPlugin('pydoc') > 0
    nmap <buffer> <Leader>w <Leader>pw<CR>
    "nmap <buffer> <Leader>W <Leader>pW<CR>
    nmap <buffer> <Leader>k <Leader>pk<CR>
    "nmap <buffer> <Leader>K <Leader>pK<CR>
endif

if utils#enabledPlugin('pyflakes') > 0
    " don't use quickfix window to avoid confliction with compilation error
    let g:pyflakes_use_quickfix = 0
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

if utils#enabledPlugin('pydiction') >= 0
    let g:pydiction_location = g:BUNDLE_PATH . '/pydiction/complete-dict'
    let g:pydiction_menu_height = 20
    "set complete+=k~/.vim/bundle/pydiction iskeyword+=.,(

    " manually load(always reload)
    call utils#loadPlugin('pydiction', 1)
endif

if utils#enabledPlugin('pep8') >= 0
    let g:pep8_map = '<buffer> <Leader>8'

    " manually load(always reload)
    call utils#loadPlugin('pep8', 1)
endif


"=============virtualenv settings=============

if exists("g:python_did_virtualenv")
    finish
endif

let g:python_did_virtualenv = 1

if !exists("$VIRTUAL_ENV")
    finish
endif

python << EOF
import os.path
import sys
import vim
project_base_dir = os.environ['VIRTUAL_ENV']
sys.path.insert(0, project_base_dir)
activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
execfile(activate_this, dict(__file__=activate_this))
EOF

