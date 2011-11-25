" Latex-specific vimscript

if exists('b:_loaded_tex') || &cp || version < 700
    finish
endif

let b:_loaded_tex = 1

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
setl shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
setl grepprg=grep\ -nH\ $*

" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
setl sw=2

" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
setl iskeyword+=:

if utils#enabledPlugin('vim-latex') >= 0
    " OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
    " 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
    " The following changes the default filetype back to 'tex':

    let g:tex_flavor = 'latex'
    " manually load
    call utils#loadPlugin('vim-latex')
endif
