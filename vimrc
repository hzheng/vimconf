" VIM main configuration file

"=============Built-in settings=============

" Basic {
    set nocompatible " ignore vi compatibility
    let mapleader = ","
    "let mapleader = "\\"
    "swap comma and backslash for convenience
    nn , \
    nn \ ,

    call utils#init(expand('<sfile>:p')) " load utils.vim
    " manually load pathogen for sake of git submodule
    runtime bundle/pathogen/autoload/pathogen.vim
    call pathogen#infect() " generate plugins path

    "run shell
    nmap <Leader>r :sh<CR> 

    set history=100
" }

" Format(indentation, tab etc.) {
    " autowrap comments using textwidth and insert the current comment leader
    set fo+=c
    " automatically insert a comment leader after an enter
    set fo+=r
    " automatically insert the current comment leader after 'o' or 'O'
    set fo+=o
    " allow formatting of comments with "gq"
    set fo+=q
    " long lines are not broken in insert mode
    set fo+=l
    " Do no auto-wrap text using textwidth (does not apply to comments)
    set fo-=t

    " turn off C indentation, and set the comments option to the default.
    "c/c++ type will override this in ftplugin
    au FileType * set nocindent comments& 
    set ai " Turn on automatic indentation.
    set sw=4  " Set shift width or the size of an indentation.
    " disable auto indentation
    nn <Leader>I :setl noai nocin nosi inde=<CR>

    set ts=8 "tab stop(or 4 in python?)
    set sts=4 " soft tab stop
    set et " Insert tabs as spaces
    " Set smart tab: in front of a line inserts blanks according to
    " 'shiftwidth', A <BS> will delete a 'shiftwidth' worth of space
    " at the start of the line.
    set sta
" }

" Fold {
    set nofoldenable        "dont fold by default
    set foldnestmax=4       "deepest fold
    set foldlevel=2         "not work?
    "augroup vimrc
      "au BufReadPre * setlocal foldmethod=indent
      "au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
    "augroup END
    nmap <Leader>f0 :set foldlevel=0<CR>
    nmap <Leader>f1 :set foldlevel=1<CR>
    nmap <Leader>f2 :set foldlevel=2<CR>
    nmap <Leader>f3 :set foldlevel=3<CR>
    nmap <Leader>f4 :set foldlevel=4<CR>
    nmap <Leader>f5 :set foldlevel=5<CR>
    nmap <Leader>f6 :set foldlevel=6<CR>
    nmap <Leader>f7 :set foldlevel=7<CR>
    nmap <Leader>f8 :set foldlevel=8<CR>
    nmap <Leader>f9 :set foldlevel=9<CR>
" }

" Search {
    set hls " Have vim highlight the target of a search.
    set is  " Do incremental searches.
    set ignorecase " Ignore case when search
    " Toggle case ignore
    nmap <Leader>C :set ignorecase! ignorecase?<CR>
    set scs " Set smart case
    set nowrapscan " No wrap scan when search
    " Turn search highlighting on and off
    "map  <F8>        :set hls!<bar>set hls?<CR>
    nmap  <silent> <Leader>/ :set hls!<bar>set hls?<CR>
    "nmap <silent> <Leader>/ :nohlsearch<CR>
    "imap <F8>        <ESC>:set hls!<bar>set hls?<CR>i
" }

" Edit {
    set smd " Show mode
    set lbr "set link break to avoid wrapping a word
    set sm " Show parentheses matching
    set bs=2 " Allow backspace to delete newlines and beyond the start of the insertion point
    set ww=b,s,h,l,<,>,[,] " Allow the cursor to wrap on anything
    set nojoinspaces " Don't add two spaces after ., ?, !
    set ta " Set textauto to recognize ^M files
    set report=0  " Report all change
    "set paste
    "set pt=<Leader>p  " paste toggle (sane indentation on pastes)

    set gd " set g as default when substitute
    
    "most input abbreviations should go to filetype-aware's scripts(under .vim/ftplugin)

    " fast input {
        nn  <CR>         i<CR>
        nn  <Space>      i<Space>
        nn  <BS>         i<BS>
        nn <leader>u=     yypVr=
        nn <leader>u-     yypVr-
    " }

    " block editing {
        vmap <Tab>   >gv
        vmap <S-Tab> <gv
    " }

    " Spell {
        set dict+=/usr/share/dict/words " dictionary
        set thesaurus+=/usr/share/dict/mthesaur.txt " thesaurus
        " Toggle spell checking
        nmap <Leader>S :setlocal spell! spelllang=en_gb<CR>
    " }

    " Encoding {
        set encoding=utf-8
        " for MacVim
        set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
    " }

    "set list
    set listchars=tab:>.,trail:.,extends:#,nbsp:. " Highlight problematic whitespace
    
" }

" File {
    set ar " Automatically read outside change
    set aw " Automatically write files as needed.
    "au FocusLost * :wa  " Automatically save when focus is lost

    set wim=longest,full " Set wildmode
    " Suffixes to put to the end of the list when completing file names
    set suffixes=.bak,~,.o,.class,.info,.swp
    " Patterns to put to ignore when completing file names
    set wig=*.bak,~,*.o,*.info,*.swp,*.class,*.pyc,.git,.svn

    " Swap directory(double slash means keep full path)
    exe "set dir=".g:VIMTMP."swap//"
    set backup " Turn on backup
    set wb " Turn on write backup
    " Backup directory
    exe "set bdir=".g:VIMTMP."backup//"
    set bex=~ " Backup extension

    if exists("&undofile")
        set undofile
        set undolevels=1000 "maximum number of changes that can be undone
        set undoreload=10000 "maximum number lines to save for undo on a buffer reload
        exe "set undodir=".g:VIMTMP."undo"
    endif
" }

" Save state {
    " Save session
    set ssop-=options " do not store global and local values in a session
    "set ssop-=curdir
    "set ssop+=sesdir
    set ssop-=blank   " do not store empty windows(avoid nerdtree problem)

    if has('gui_running') " auto change session only in GUI
        au VimEnter * nested :call utils#LoadSession()
        au VimLeave * :call utils#UpdateSession()
    endif
    nmap <Leader>SS :call utils#SaveSession()<CR>

    " Save viminfo
    exe "set viminfo+=n".g:VIMTMP."viminfo"

    " Save view records
    exe "set viewdir=".g:VIMTMP."view/"
    au BufWinLeave * silent! mkview
    au BufWinEnter * silent! loadview

    " make 'crontab -e' work
    if $VIM_CRONTAB == "true"
        set nobackup
        set nowritebackup
    endif
" }

" Window/Tab/Buffer {
    " window
    nmap <Tab>    <c-w>w
    nmap <Leader>P  <c-w>p
    nmap <Leader>v   <c-w>v
    nmap <Leader>s   <c-w>s
    "nmap <ESC>q   <c-w>q
    "nmap <Leader>j   <c-w>j
    nmap <down>      <c-w>j
    "nmap <Leader>k   <c-w>k
    nmap <up>        <c-w>k
    "nmap <Leader>h   <c-w>h
    nmap <left>      <c-w>h
    "nmap <Leader>l   <c-w>l
    nmap <right>     <c-w>l
    nmap <Leader>N   <c-w>n
    nmap <Leader>O   <c-w>o

    " Tab
    nmap <S-Tab>    :tabnew<CR>
    nmap <C-left>   :tabprevious<CR>
    nmap <C-right>  :tabNext<CR>
    nmap <C-up>     :tabfirst<CR>
    nmap <C-down>   :tablast<CR>

    " Buffer navigation
    nmap <Leader>d   :bd<CR>
    nmap <Leader>n   :bn<CR>
    nmap <Leader>p   :bp<CR>
    "map  <F5>       :prev<CR>
    "map  <F6>       :n<CR>
    "map  <S-F5>     :fir<CR>
    "map  <S-F6>     :la<CR>

    " Buffer manipulation 
    " avoid conflicting with 'q' command(for recording)
    " all the following use single letter not only for quick type, but also
    " for quick response(same prefix will delay vim)
    nmap <Leader><Leader> :q<CR>
    nmap <Leader>q   :q!<CR>
    nmap <Leader>x   :qa<CR>
    nmap <Leader>X   :qa!<CR>

    imap <F5> <Esc>:up<cr>
    nmap <F5> :up<cr>
    "map  <S-CR>       :w<CR>
    "map  <F4>       :w<CR>
    "map! <F4>       <ESC>:w<CR>
    "map! <S-F4>     <ESC>ZZ
" }

" File type {
    "filetype plugin indent on
    filetype plugin on
    "set ofu=syntaxcomplete#Complete
    filetype indent on

    augroup filetype
            au!
            au! BufRead,BufNewFile *.jsp    set filetype=xml
            au! BufRead,BufNewFile *.jspf   set filetype=xml
            au! BufRead,BufNewFile *.tag    set filetype=xml
            au! BufRead,BufNewFile *.pro    set filetype=prolog
    augroup END

    au FileType * call utils#FileTypeInit()
" }

" External {
    nn <silent> <S-CR> :call utils#OpenUrl()<CR><CR>
    nn <silent> <S-leftmouse> :call utils#OpenUrl()<CR><CR>
" }

" GUI {
    "set background=light
    "color spring            " load a colorscheme
    "color moria
    syntax on " Turn on syntax highlighting

    " Set mouse
    set mouse=a
    set ttyfast
    "set selection=exclusive
    "set selectmode=mouse,key
    "behave xterm

    set term=$TERM " default
    if has('gui_running')
        " mostly are put into .gvimrc
    else
        "set term=builtin_ansi  " Make arrow and other keys work
        " tab
        set tabline=%!utils#TabLine()
        hi TabLineSel ctermfg=red ctermbg=gray cterm=NONE 
        hi TabLineFill ctermfg=darkgray ctermbg=NONE cterm=underline 
        hi TabLine ctermfg=darkgray ctermbg=NONE cterm=underline
        " cursor
        set cursorline
        hi CursorLine ctermbg=lightgray cterm=NONE
        set cursorcolumn
        hi CursorColumn ctermbg=lightgray
        " highlight cursor
    endif

    set sc " Show partially typed commands

    set ru " Show the ruler
    " Set ruler format: length, column, percentage, total lines,
    " chop position, middle position, file name, modification and read-only flag.
    set ruf=%40(%4l,%2v(%p%%\ of\ \%L)%<%=%8.20t%m%R%)              

    if has('statusline')
        set ls=2   " last status(always show status)

        set stl=%<%f\    " Filename
        set stl+=%w%h%m%r " Options
        "set stl+=%{fugitive#statusline()} "  Git Hotness
        set stl+=\ [%{&ff}/%Y]            " filetype
        "set stl+=\ [%{getcwd()}]          " current dir
        "set stl+=\ [A=\%03.3b/H=\%02.2B] " ASCII / Hexadecimal value of char
        set stl+=%=%-14.(%l,%c%V%)\ %p%%\ of\ \%L  " Right aligned file nav info
    endif

    " line {
        nmap <Leader>CC :call utils#ToggleColorColumn()<cr>

        if exists("&relativenumber")
            set relativenumber
        else
            set number
        endif
        nmap <F6> :call utils#ToggleNumber()<cr>
        imap <F6> <Esc>:call utils#ToggleNumber()<cr>
    " }
" }


"=============Plugin settings=============

" NerdTree {
    "load NERDTree on startup, but command line alias is prefered
    "au VimEnter * NERDTree
    "highlight main window
    au VimEnter * silent! wincmd p

    "map  :NERDTreeToggle
    nmap <silent> <Leader>e :NERDTreeToggle<CR>:NERDTreeMirror<CR>
    "nmap <ESC>e :NERDTreeToggle<CR><C-W><C-S><C-W><C-J>:BufExplorer<CR>

    let NERDTreeIgnore=['\.o', '\.class', '\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
    "set autochdir
    let NERDTreeChDirMode = 2
    nn <Leader>. :NERDTree .<CR>
    ca nt NERDTree
    ca bm Bookmark
" }

" Tag, TagList, Tagbar {
    "set completeopt=longest,menu
    map <S-Left> <C-T>
    map <S-Right> <C-]>
    map <S-Up> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
    map <S-Down> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
    
    "nmap <ESC>t :TlistToggle<CR>
    "nmap <Leader>l :TlistToggle<CR>
    "nmap <Leader>u :TlistUpdate<CR>
    let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
    let Tlist_Use_Right_Window = 1
    let Tlist_Show_One_File = 1 
    let Tlist_File_Fold_Auto_Close = 1
    let Tlist_Show_Menu = 1
    "let Tlist_Sort_Type=1
    "let Tlist_WinWidth = 50
    "let Tlist_Auto_Open = 1
    "nmap <F6> :!/usr/local/bin/ctags -R --fields=+iaS --extra=+q .<CR>
    "nmap <F6> :!/usr/local/bin/ctags -R .<CR>


    nmap <Leader>t :TagbarToggle<CR>
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
    let g:tagbar_autofocus = 1 " auto focus when open
" }

" BufExplorer {
    "built-in <Leader>be
    "nmap <Leader>b :BufExplorer<CR>
    let g:bufExplorerSplitVertical = 1 
    let g:bufExplorerSortBy = 'mru'
    let g:bufExplorerUseCurrentWindow = 1
    let g:bufExplorerShowRelativePath = 1
    let g:bufExplorerDefaultHelp = 0
" }

" FuzzyFinder {
    "nmap <ESC>b :FufBuffer<CR>
    "nmap <Leader>b :FufBuffer<CR>
    "nmap <ESC>f :FufFile<CR>
    "nmap <Leader>f :FufFile<CR>
    "nmap <Leader>g :FufTaggedFile<CR>
    "nmap <Leader>d :FufDir<CR>
    "nmap <Leader>t :FufTag<CR>
" }

" Command-T {
    "nmap <ESC>f :CommandT<CR>
    "nmap <ESC>b :CommandTBuffer<CR>
    nmap <S-Space> :CommandT<CR>
    nmap <Leader><Space> :CommandTBuffer<CR>
    nmap <Leader>y :CommandTFlush<CR>
    "let g:CommandTSearchPath = $HOME . '$HOME/Projects'
    let g:CommandTMatchWindowAtTop = 1
    let g:CommandTMaxFiles = 20000
" }

" AutoCompletion(SuperTab) {
    " Omni completion
    ino <S-Space> <C-X><C-O>

    let g:SuperTabDefaultCompletionType = "context"
    "let g:SuperTabMappingTabLiteral = '<c-tab>' " default
    "let g:SuperTabCrMapping = 0
" }

" SnipMate {
    let g:snips_author=expand($USER_FULLNAME)
    let g:author=expand($USER_FULLNAME)
    let g:snips_email=expand($USER_EMAIL)
    let g:email=expand($USER_EMAIL)
    let g:snips_github=expand($USER_GITHUB)
    let g:github=expand($USER_GITHUB)
    "au FileType c,cpp,java,python,ruby,perl,php,objc,javascript,xml,html,xhtml,sh source ~/.vim/extra/snipMate.vim
    "nn <Leader>rs <esc>:exec ReloadAllSnippets()<cr>
" }

" Tabular {  
" if exists(":Tabularize")
    nmap <Leader>a= :Tabularize /=<CR>
    vmap <Leader>a= :Tabularize /=<CR>
    nmap <Leader>a: :Tabularize /:<CR>
    vmap <Leader>a: :Tabularize /:<CR>
    nmap <Leader>a:: :Tabularize /:\zs<CR>
    vmap <Leader>a:: :Tabularize /:\zs<CR>
    nmap <Leader>a, :Tabularize /,<CR>
    vmap <Leader>a, :Tabularize /,<CR>
    nmap <Leader>a\ :Tabularize /<bar><CR>
    vmap <Leader>a\ :Tabularize /<bar><CR>
" }

" Calendar {

    "nmap <ESC>c :Calendar<CR>
    nmap <Leader>Ca :Calendar<CR>
    "cmap cal Calendar<SPACE>
    "cmap caL CalendarH<SPACE>
    let calendar_diary = "$DIARY_DIR"
    "au BufNewFile *.cal read $HOME/.vim/templates/diary | call InsertChineseDate()
    au BufNewFile *.cal call utils#CalInit()
    "au BufNewFile,BufRead *.cal set ft=rst
" }
