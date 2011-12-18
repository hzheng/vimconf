" Before Vim builtin filetype.vim

if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    " prolog type
    au BufRead,BufNewFile *.pro set ft=prolog
augroup END

finish
