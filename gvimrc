" GVIM-specific configuration file

" Input {
    set noimdisable
    "inoremap <ESC> <ESC>:set iminsert=0<CR>
    set imactivatekey=C-space
" }

" Screen {
    if has('fullscreen')
        set fuopt=maxvert,maxhorz  " full screen
        au GUIEnter * set fullscreen
        " toggle fullscreen mode
        nmap <F1> :set fullscreen!<CR>
    endif

    set guioptions-=T      " remove the toolbar
    set guioptions-=m      " remove the menu
    set guioptions-=l      " remove the left scrollbar
    set guioptions-=L      " remove the left scrollbar
    set guioptions-=r      " remove the right scrollbar
    set guioptions-=R      " remove the right scrollbar
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
    set tabpagemax=15      " show at most 15 tabs
    set showtabline=2      " always show tab line

    if exists('g:useGuiTab') " use GUI tab
        set guioptions+=e
        set guitabtooltip=%{utils#GuiTabToolTip()}
        set guitablabel=%{utils#GuiTabLabel()}
    else " use non-GUI tab
        set guioptions-=e
        set tabline=%!utils#TabLine()
    endif
" }


" Cursor {
    set cursorline
    set cursorcolumn

    set mousehide " hide mouse when typing
" }
