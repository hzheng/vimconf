" After Vim builtin filetype.vim

if exists("did_load_filetypes_userafter")
    finish
endif

let did_load_filetypes_userafter = 1

augroup filetypedetect
    " jsp type
    au BufRead,BufNewFile *.jspf,*.tag,*tagf setf jsp
    " plaintext type
    au BufRead,BufNewFile *.txt setf text
    " rst type
    au BufRead,BufNewFile TODO,README,*.cal setf rst
    " configuration file
    au BufRead,BufNewFile *.conf setf cfg
augroup END
