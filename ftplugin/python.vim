" Python-specific vimscript

if exists('b:_loaded_python') || &cp || version < 700
    finish
endif

let b:_loaded_python = 1

" Edit {
    set ofu=pythoncomplete#Complete

    set fdm=indent   "fold based on indent
    set nosmartindent "no smart indent
" }

" Debug {
    set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
" }

"=============Lint settings=============

fun! <SID>PythonGrep(tool)
    set lazyredraw
    " Close any existing cwindows.
    cclose
    let l:grepformat_save = &grepformat
    let l:grepprogram_save = &grepprg
    set grepformat&vim
    set grepformat&vim
    let &grepformat = '%f:%l:%m'
    if a:tool == "pylint"
        let &grepprg = 'pylint --output-format=parseable --reports=n'
    elseif a:tool == "pychecker"
        let &grepprg = 'pychecker -Q -q'
    else
        echohl WarningMsg
        echo "PythonGrep Error: Unknown Tool"
        echohl none
    endif
    if &readonly == 0 | update | endif
    silent! grep! %
    let &grepformat = l:grepformat_save
    let &grepprg = l:grepprogram_save
    let l:mod_total = 0
    let l:win_count = 1
    " Determine correct window height
    windo let l:win_count = l:win_count + 1
    if l:win_count <= 2 | let l:win_count = 4 | endif
    windo let l:mod_total = l:mod_total + winheight(0)/l:win_count |
                \ exe 'resize +'.l:mod_total
    " Open cwindow
    exe 'belowright copen '.l:mod_total
    nnoremap <buffer> <silent> c :cclose<CR>
    set nolazyredraw
    redraw!
endfun

if executable('pylint')
    if (!hasmapto('<SID>PythonGrep(pylint)') && (maparg('<S-F3>') == ''))
        map <S-F3> :call <SID>PythonGrep('pylint')<CR>
        map! <S-F3> :call <SID>PythonGrep('pylint')<CR>
    else
        if (!has("gui_running") || has("win32"))
            echo "Python Pylint Error: No Key mapped.\n".
                        \ "<S-F3> is taken and a replacement was not assigned."
        endif
    endif
endif

if executable('pychecker')
    if (!hasmapto('<SID>PythonGrep(pychecker)') && (maparg('<S-F4>') == ''))
        map <S-F4> :call <SID>PythonGrep('pychecker')<CR>
        map! <S-F4> :call <SID>PythonGrep('pychecker')<CR>
    else
        if (!has("gui_running") || has("win32"))
            echo "Python Pychecker Error: No Key mapped.\n".
                        \ "<S-F4> is taken and a replacement was not assigned."
        endif
    endif
endif

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

