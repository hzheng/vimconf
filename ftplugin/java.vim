" Java-specific vimscript

if exists('b:_loaded_java') || &cp || version < 700
    finish
endif

let b:_loaded_java = 1


" Format {
    set si           "smart indent

    set fdm=syntax   "fold based on syntax
    "set fdm=marker fmr=zz.FOLDSTART,zz.END fdl=2 fdc=2
" }

" Edit {
    let java_space_errors = 1 " show redundant spaces

    set omnifunc=javacomplete#Complete 
" }
