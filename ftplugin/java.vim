" Java-specific vimscript

if exists("_loaded_java_vim")
    finish
endif

let _loaded_java_vim = 1

" Define some abbreviations to draw comments.
ia #b         /********************************************************
ia #m   <Space>*                                                      *
ia #e   <Space>********************************************************/ 
ia #l         /*------------------------------------------------------*/ 

set si           "smart indent

set fdm=syntax   "fold based on syntax
"set fdm=marker fmr=zz.FOLDSTART,zz.END fdl=2 fdc=2

"let java_space_errors = 1 " show redundant spaces

set omnifunc=javacomplete#Complete 
