" C/C++-specific vimscript

if exists("b:_loaded_cpp_vim")
    finish
endif

let b:_loaded_cpp_vim = 1

" Format {
    set si           "smart indent

    set fdm=syntax   "fold based on syntax

    "set fo=croql
    set cindent
" }

" Edit {
    set comments=sr:/*,mb:*,ex:*/,://

    let c_space_errors = 1 " show redundant spaces
" }
