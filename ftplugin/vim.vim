" VIM-specific vimscript

" override the mapping in program.vim
nmap <S-Right> :exe('help '.expand('<cword>'))<CR>
