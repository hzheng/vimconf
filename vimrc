" VIM main configuration file

"=============Built-in settings=============

" Basic {
    set nocompatible " ignore vi compatibility
    set history=100

    let mapleader = ","
    "let mapleader = "\\"
    "swap comma and backslash for convenience
    nn , \
    nn \ ,

    " load utils.vim to perform some initialization
    call utils#init(expand('<sfile>:p'))

    "run shell
    nmap <Leader>r :sh<CR> 
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

    filetype plugin indent on
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
    set pastetoggle=<F2>
    "set pt=<Leader>p  " paste toggle (sane indentation on pastes)

    set gd " set g as default when substitute

    "most input abbreviations should go to filetype-aware's scripts(under .vim/ftplugin)

    " fast input {
        "nn  <CR>         i<CR>
        nn  <Space>      i<Space>
        nn  <BS>         i<BS>

        " Omni completion
        ino <S-Space> <C-X><C-O>
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

    " Whitespace {
        " Highlight problematic whitespace
        "set list
        set listchars=tab:>.,trail:.,extends:#,nbsp:.
    " }
" }

" File {
    set ar " Automatically read outside change
    set aw " Automatically write files as needed.
    " Automatically save when focus is lost
    au BufLeave,FocusLost * silent! wa
    " hide buffer instead of closing
    set hidden

    set wim=longest,full " Set wildmode
    " Suffixes to put to the end of the list when completing file names
    set suffixes=.bak,~,.o,.class,.info,.swp
    " Patterns to put to ignore when completing file names
    set wig=*.bak,~,*.o,*.info,*.swp,*.class,*.pyc,.git,.svn

    " Swap directory(double slash means keep full path)
    exe "set dir=". g:VIMTMP . "/swap//"
    set backup " Turn on backup
    set wb " Turn on write backup
    " Backup directory
    exe "set bdir=". g:VIMTMP . "/backup//"
    set bex=~ " Backup extension

    if exists("&undofile")
        set undofile
        set undolevels=1000 "maximum number of changes that can be undone
        set undoreload=10000 "maximum number lines to save for undo on a buffer reload
        exe "set undodir=". g:VIMTMP . "/undo"
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
    exe "set viminfo+=n" . g:VIMTMP . "/viminfo"

    " Save view records
    exe "set viewdir=". g:VIMTMP . "/view"
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
    "nmap <S-Tab>    :tabnew<CR>
    nmap <C-M-left>   :tabprevious<CR>
    imap <C-M-left>   <ESC>:tabprevious<CR>
    nmap <C-M-right>  :tabNext<CR>
    imap <C-M-right>  <ESC>:tabNext<CR>
    nmap <C-M-up>     :tabfirst<CR>
    imap <C-M-up>     <ESC>:tabfirst<CR>
    nmap <C-M-down>   :tablast<CR>
    imap <C-M-down>   <ESC>:tablast<CR>

    " Buffer navigation
    nmap <C-BS>     :bd<CR>
    nmap <C-left>   :bp<CR>
    imap <C-left>   <ESC>:bp<CR>
    nmap <C-right>  :bn<CR>
    imap <C-right>  <ESC>:bn<CR>
    nmap <C-up>     :bf<CR>
    imap <C-up>     <ESC>:bf<CR>
    nmap <C-down>   :bl<CR>
    imap <C-down>   <ESC>:bl<CR>
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
        set stl+=%{fugitive#statusline()} "  Git status
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

if utils#enabledPlugin('nerdtree')
    "load NERDTree on startup, but command line alias is prefered
    "au VimEnter * NERDTree
    "highlight main window
    au VimEnter * silent! wincmd p

    "map  :NERDTreeToggle
    nmap <silent> <Leader>E :NERDTreeToggle<CR>:NERDTreeMirror<CR>
    "nmap <ESC>e :NERDTreeToggle<CR><C-W><C-S><C-W><C-J>:BufExplorer<CR>

    let NERDTreeIgnore=['\.o', '\.class', '\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
    "set autochdir
    let NERDTreeChDirMode = 2
    nn <Leader>. :NERDTree .<CR>
    ca nt NERDTree
    ca bm Bookmark
endif

if utils#enabledPlugin('bufexplorer')
    "built-in <Leader>be
    "nmap <Leader>b :BufExplorer<CR>
    let g:bufExplorerSplitVertical = 1 
    let g:bufExplorerSortBy = 'mru'
    let g:bufExplorerUseCurrentWindow = 1
    let g:bufExplorerShowRelativePath = 1
    let g:bufExplorerDefaultHelp = 0
endif

if utils#enabledPlugin('fuzzyfinder')
    nmap <Leader><Space> :FufBuffer<CR>
    nmap <Leader>e :FufFile<CR>
    "nmap <Leader>g :FufTaggedFile<CR>
    "nmap <Leader>d :FufDir<CR>
    "nmap <Leader>t :FufTag<CR>
endif

if utils#enabledPlugin('command-t')
    nmap <Leader><Space> :CommandTBuffer<CR>
    nmap <Leader>e :CommandT<CR>
    nmap <Leader>y :CommandTFlush<CR>
    "let g:CommandTSearchPath = $HOME . '$HOME/Projects'
    let g:CommandTMatchWindowAtTop = 0
    let g:CommandTMaxFiles = 20000
endif

if utils#enabledPlugin('supertab')
    let g:SuperTabDefaultCompletionType = "context"
    "let g:SuperTabMappingTabLiteral = '<c-tab>' " default
    "let g:SuperTabCrMapping = 0
endif

if utils#enabledPlugin('snipmate')
    let g:snips_author=expand($USER_FULLNAME)
    let g:author=expand($USER_FULLNAME)
    let g:snips_email=expand($USER_EMAIL)
    let g:email=expand($USER_EMAIL)
    let g:snips_github=expand($USER_GITHUB)
    let g:github=expand($USER_GITHUB)
    "au FileType c,cpp,java,python,ruby,perl,php,objc,javascript,xml,html,xhtml,sh source ~/.vim/extra/snipMate.vim
    "nn <Leader>rs <esc>:exec ReloadAllSnippets()<cr>
endif

if utils#enabledPlugin('tabular')
    nmap <Leader>z=  :Tabularize /=<CR>
    vmap <Leader>z=  :Tabularize /=<CR>
    nmap <Leader>z:  :Tabularize /:<CR>
    vmap <Leader>z:  :Tabularize /:<CR>
    nmap <Leader>z:: :Tabularize /:\zs<CR>
    vmap <Leader>z:: :Tabularize /:\zs<CR>
    nmap <Leader>z,  :Tabularize /,<CR>
    vmap <Leader>z,  :Tabularize /,<CR>
    nmap <Leader>z\  :Tabularize /<bar><CR>
    vmap <Leader>z\  :Tabularize /<bar><CR>
endif

if utils#enabledPlugin('calendar')
    "nmap <ESC>c :Calendar<CR>
    nmap <Leader>Ca :Calendar<CR>
    "cmap cal Calendar<SPACE>
    "cmap caL CalendarH<SPACE>
    let calendar_diary = "$DIARY_DIR"
    "au BufNewFile *.cal read $HOME/.vim/templates/diary | call InsertChineseDate()
    au BufNewFile *.cal call utils#CalInit()
    "au BufNewFile,BufRead *.cal set ft=rst
endif

if utils#enabledPlugin('ack')
    " improve grep if possible
    set grepprg=ack\ -a

    nmap <Leader>a :Ack<SPACE>
endif

if utils#enabledPlugin('gundo')
    nmap <leader>u :GundoToggle<CR>
endif

if utils#enabledPlugin('fugitive')
    nmap <leader>gb :Gbrowse<CR>
    vmap <leader>gb :Gbrowse<CR>
    nmap <leader>ge :Gedit<Space>
    nmap <leader>ga :Gblame<CR>
endif

if utils#enabledPlugin('tasklist')
    nmap <leader>tl <Plug>TaskList
    let g:tlTokenList = ["FIXME", "TODO", "XXX", "HACK"]
endif

" NOTE: For program-specific or filetype-specific plugin settings,
" we manage to put them into program.vim or <filetype>.vim under ftplugin

