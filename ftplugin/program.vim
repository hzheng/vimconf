" Programming files' common vimscript

if exists("b:_loaded_program_vim")
    finish
endif

let b:_loaded_program_vim = 1

" Format {
    " Set the width of text
    set tw=79
" }

" Edit {
    " default omni-complete function
    set ofu=syntaxcomplete#Complete
" }

" Tag {
    "set completeopt=longest,menu
    set completeopt=menuone,longest,preview
    map <buffer> <S-Left> <C-T>
    map <buffer> <S-Right> <C-]>
    map <buffer> <S-Up> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
    map <buffer> <S-Down> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

    let g:CTAGS = '/usr/local/bin/ctags'
    let g:TAG_DIR = '~/tags'
    exe "set tags+=" . g:TAG_DIR . "/" . &filetype
    exe "map <buffer> <C-F12> :!" . g:CTAGS . " -R -o tags .<CR><CR>"
" }

" Debug {
    nmap <buffer> <Leader>F   :call utils#ToggleQuickfix(0)<CR>
    nmap <buffer> <Leader>dl  :cl<CR>
    nmap <buffer> <Leader>dd  :cc<CR>
    nmap <buffer> <Leader>dn  :cn<CR>
    nmap <buffer> <Leader>dp  :cp<CR>
" }

"=============Plugin settings=============

if utils#enabledPlugin('taglist') >= 0
    "nmap <ESC>t :TlistToggle<CR>
    "nmap <Leader>l :TlistToggle<CR>
    "nmap <Leader>u :TlistUpdate<CR>
    let Tlist_Ctags_Cmd = g:CTAGS
    let Tlist_Use_Right_Window = 1
    let Tlist_Show_One_File = 1 
    let Tlist_File_Fold_Auto_Close = 1
    let Tlist_Show_Menu = 1
    "let Tlist_Sort_Type=1
    "let Tlist_WinWidth = 50
    "let Tlist_Auto_Open = 1

    " manually load
    call utils#loadPlugin('taglist')
endif

if utils#enabledPlugin('tagbar') >= 0
    nmap <buffer> <Leader>T :TagbarToggle<CR>
    let g:tagbar_ctags_bin = g:CTAGS
    let g:tagbar_autofocus = 1 " auto focus when open

    " manually load
    call utils#loadPlugin('tagbar')
endif

if utils#enabledPlugin('nerdcommenter') >= 0
    " manually load
    call utils#loadPlugin('nerdcommenter')
    " FIXME: DON'T work if user change filetype after opening a non-program file
endif

if utils#enabledPlugin('autoclose') >= 0
    nmap <buffer> <Leader>A <Plug>ToggleAutoCloseMappings

    " manually load
    call utils#loadPlugin('autoclose')
endif
