" VIM-specific vimscript

if exists('b:_loaded_vim') || &cp || version < 700
    finish
endif

let b:_loaded_vim = 1

" override the mapping in program.vim
nmap <buffer> <S-Right> :exe('help '.expand('<cword>'))<CR>

"let &keywordprg=':help' " global setting, not good
