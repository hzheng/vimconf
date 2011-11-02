" GVIM-specific configuration file


" Screen {
    set fuopt=maxvert,maxhorz  " full screen
    au GUIEnter * set fullscreen
    set guioptions-=T      " remove the toolbar
    set guioptions-=m      " remove the menu
    "set guioptions=mcr
    set lines=80           " default in my screen: 75
    "set background=dark
" }

" Status line {
    au InsertEnter * call utils#InsertStatuslineColor(v:insertmode)
    au InsertLeave * hi statusline guibg=green
    " default the statusline to green when entering Vim
    hi statusline guibg=green
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
 
    " The following take not effect(?)
    hi TabLineSel guifg=green guibg=darkgray gui=bold
    hi TabLineFill guifg=darkgray guibg=NONE gui=NONE 
    hi TabLine guifg=darkgray guibg=red gui=NONE
" }


" Cursor {
    hi Cursor guibg=#ffa500 guifg=bg gui=NONE
    set cursorline
    hi CursorLine guibg=lightgray
    set cursorcolumn
    hi CursorColumn guibg=lightgray
" }
