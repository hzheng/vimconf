" GVIM-specific configuration file


" Screen {
    if has('fullscreen')
        set fuopt=maxvert,maxhorz  " full screen
        au GUIEnter * set fullscreen
        " toggle fullscreen mode
        nmap <F1> :set fullscreen!<CR>
    endif

    set guioptions-=T      " remove the toolbar
    set guioptions-=m      " remove the menu
    "set guioptions=mcr

    set guifont=Consolas:h13

    set lines=80           " default in my screen: 75
    "set background=dark
" }

" Status line {
    au InsertEnter * call utils#InsertStatuslineColor(v:insertmode)
    au InsertLeave * hi statusline guibg=blue
" }

" Tab {
    set guioptions+=e      " ensure the tab support
    set tabpagemax=15      " show at most 15 tabs
    set showtabline=2      " always show tab line

    set guitabtooltip=%{utils#GuiTabToolTip()}

    " guitablabel MUST be put into .gvimrc instead of .vimrc
    " since it's configured in MacVim's gvimrc
    "set guitablabel=%t
    set guitablabel=%{utils#GuiTabLabel()}
 
    " The following take no effect in fullscreen mode(?)
    hi TabLineSel guifg=green guibg=darkgray gui=bold
    hi TabLineFill guifg=darkgray guibg=NONE gui=NONE 
    hi TabLine guifg=darkgray guibg=red gui=NONE
" }


" Cursor {
    set cursorline
    set cursorcolumn

    set mousehide " hide mouse when typing
" }
