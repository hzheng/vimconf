" VIM-specific vimscript

" override the mapping in program.vim
nmap <buffer> <S-Right> :exe('help '.expand('<cword>'))<CR>
