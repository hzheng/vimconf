" Programming files' common vimscript

if exists("_loaded_program_vim")
    finish
endif

let _loaded_program_vim = 1

" Set the width of text
set tw=79

if !utils#enabledPlugin('taglist')
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
    "nmap <F6> :!/usr/local/bin/ctags -R --fields=+iaS --extra=+q .<CR>
    "nmap <F6> :!/usr/local/bin/ctags -R .<CR>

    " don't load since tagbar is preferred
    "call utils#loadPlugin('taglist')
endif

if !utils#enabledPlugin('tagbar')
    nmap <Leader>T :TagbarToggle<CR>
    let g:tagbar_ctags_bin = g:CTAGS
    let g:tagbar_autofocus = 1 " auto focus when open

    " manually load
    call utils#loadPlugin('tagbar')
endif

if !utils#enabledPlugin('nerdcommenter')
    " manually load
    call utils#loadPlugin('nerdcommenter')
    " FIXME: DON'T work if user change filetype after opening a non-program file
endif

if !utils#enabledPlugin('autoclose')
    nmap <Leader>A <Plug>ToggleAutoCloseMappings

    " manually load
    call utils#loadPlugin('autoclose')
endif
