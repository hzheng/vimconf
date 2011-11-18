" VIM main configuration file

"=============Built-in settings=============

" Basic {
    set nocompatible " ignore vi compatibility
    set history=100

    "override the default leader '\'
    let mapleader = ','
    "swap comma and backslash for convenience
    nn , \
    nn \ ,

    " load utils.vim to perform some initialization
    call utils#init(expand('<sfile>:p'))

    "run shell
    nmap <Leader>r :sh<CR> 
" }

" Format {
    " autowrap comments using textwidth and insert the current comment leader
    set formatoptions+=c
    " automatically insert a comment leader after an enter
    set formatoptions+=r
    " automatically insert the current comment leader after 'o' or 'O'
    set formatoptions+=o
    " allow formatting of comments with 'gq'
    set formatoptions+=q
    " long lines are not broken in insert mode
    set formatoptions+=l
    " Do no auto-wrap text using textwidth (does not apply to comments)
    set formatoptions-=t
" }

" indentation/tab {
    " turn off C indentation, and set the comments option to the default.
    "c/c++ type will override this in ftplugin
    au FileType * set nocindent comments& 
    set autoindent
    set shiftwidth=4  " set shift width or the size of an indentation.
    " disable auto indentation
    nn <Leader>I :setl noai nocin nosi inde=<CR>

    set tabstop=4
    set softtabstop=4
    " insert tabs as spaces
    set expandtab
    " in front of a line inserts blanks according to 'shiftwidth', a <BS>
    " will delete a 'shiftwidth' worth of space at the start of the line.
    set smarttab

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
    nmap <Leader>f0 :setl foldlevel=0<CR>
    nmap <Leader>f1 :setl foldlevel=1<CR>
    nmap <Leader>f2 :setl foldlevel=2<CR>
    nmap <Leader>f3 :setl foldlevel=3<CR>
    nmap <Leader>f4 :setl foldlevel=4<CR>
    nmap <Leader>f5 :setl foldlevel=5<CR>
    nmap <Leader>f6 :setl foldlevel=6<CR>
    nmap <Leader>f7 :setl foldlevel=7<CR>
    nmap <Leader>f8 :setl foldlevel=8<CR>
    nmap <Leader>f9 :setl foldlevel=9<CR>
" }

" Search {
    set hlsearch " highlight the target of a search.
    set incsearch  " incremental search
    set ignorecase " Ignore case when search
    " toggle case ignore
    nmap <Leader>C :set ignorecase! ignorecase?<CR>
    set smartcase
    set nowrapscan " No wrap scan when search
    " toggle search highlighting
    nmap  <silent> <Leader>/ :set hls!<bar>set hls?<CR>
" }

" Jump {
    " go to older jump position(constrast with Tab or C-I)
    nmap <S-Tab>    <C-O>
" }

" Edit {
    set showmode
    set linebreak " avoid wrapping a word
    set showmatch " show parentheses matching
    " allow BS to delete newlines and beyond the start of the insertion point
    set backspace=2 
    set whichwrap=b,s,h,l,<,>,[,] " allow the cursor to wrap on anything
    set nojoinspaces " don't add two spaces after ., ?, !
    set report=0  " report all line change

    set pastetoggle=<F2> " paste toggle (sane indentation on pastes)

    set gdefault " set g as default when substitute

    " auto complete {
        "set complete=.,w,b,u,t,i,k,s
        set complete=.,w,b,u,t,i
        "set completeopt=longest,menu
        set completeopt=menuone,longest,preview

        set omnifunc=syntaxcomplete#Complete
        " Omni completion
        ino <S-Space> <C-X><C-O>
    " }

    " block editing {
        vmap <Tab>   >gv
        vmap <S-Tab> <gv
    " }

    " Spell {
        set dictionary+=/usr/share/dict/words
        set thesaurus+=/usr/share/dict/mthesaur.txt
        exe 'set spellfile=' . g:VIMFILES . '/spell/en.utf-8.add'
        " toggle spell checking
        nmap <F3> :setl spell! spelllang=en_gb<CR>
    " }

    " Encoding {
        set encoding=utf-8
        " for MacVim
        set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
    " }

    " Whitespace {
        " toggle highlighting problematic whitespace
        nmap <F4> :setl list! list?<CR>
        set listchars=tab:>.,trail:.,extends:#,nbsp:.
    " }
" }

" File {
    " automatically read outside change
    set autoread
    " automatically write files as needed.
    set autowrite
    " automatically save when focus is lost
    au BufLeave,FocusLost * silent! wa
    " hide buffer instead of closing
    set hidden

    set wildmode=longest,full
    " suffixes to put to the end of the list when completing file names
    set suffixes=.bak,~,.o,.class,.info,.swp
    " patterns to put to ignore when completing file names
    set wildignore=*.bak,~,*.o,*.info,*.swp,*.class,*.pyc,.git,.svn

    " swap directory(double slash means keep full path)
    exe 'set dir='. g:VIMTMP . '/swap//'
    set backup " turn on backup
    set writebackup " turn on write backup
    " backup directory
    exe 'set backupdir='. g:VIMTMP . '/backup//'
    set backupext=~

    if exists('&undofile')
        set undofile
        " set max number of changes that can be undone
        set undolevels=1000 
        " set max number lines to save for undo on a buffer reload
        set undoreload=10000
        exe 'set undodir='. g:VIMTMP . '/undo'
    endif
" }

" Save state {
    " do not store global and local values in a session
    set sessionoptions-=options
    "set sessionoptions-=curdir
    "set sessionoptions+=sesdir
    " do not store empty windows(avoid nerdtree problem)
    set sessionoptions-=blank

    if has('gui_running') " auto change session only in GUI
        au VimEnter * nested :call utils#LoadSession()
        au VimLeave * :call utils#UpdateSession()
    endif
    nmap <Leader>ss :call utils#SaveSession()<CR>

    " Save viminfo
    exe 'set viminfo+=n' . g:VIMTMP . '/viminfo'

    " Save view records
    exe 'set viewdir='. g:VIMTMP . '/view'
    au BufWinLeave * silent! mkview
    au BufWinEnter * silent! loadview

    " make 'crontab -e' work
    if $VIM_CRONTAB == 'true'
        set nobackup
        set nowritebackup
    endif
" }

" Window/Tab/Buffer {
    " window
    "nmap <Tab>    <c-w>w
    "nmap <Leader>P  <c-w>p
    nmap <Leader>V   <c-w>v
    "nmap <Leader>V   :vs<SPACE>
    nmap <Leader>S   <c-w>s
    "nmap <Leader>S   :sp<SPACE>
    "nmap <ESC>q   <c-w>q
    nmap <down>      <c-w>j
    nmap <up>        <c-w>k
    nmap <left>      <c-w>h
    nmap <right>     <c-w>l
    "nmap <Leader>N   <c-w>n
    "nmap <Leader>O   <c-w>o

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

    " display messages 
    nmap <F11> :messages<CR>
    imap <F11> <ESC>:messages<CR>
" }

" External {
    nn <silent> <S-CR> :call utils#OpenUrl()<CR><CR>
    nn <silent> <S-leftmouse> :call utils#OpenUrl()<CR><CR>
" }

" GUI {
    "set background=light
    "color spring            " load a colorscheme
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

    set showcmd " show partially typed commands

    set ruler " show the ruler
    " Set ruler format: length, column, percentage, total lines,
    " chop position, middle position, filename, modification and read-only flag
    set rulerformat=%40(%4l,%2v(%p%%\ of\ \%L)%<%=%8.20t%m%R%)              

    if has('statusline')
        set laststatus=2   " always show status

        set statusline=%<%f\    " filename
        set statusline+=%w%h%m%r " options
        set statusline+=\ [%{&ff}/%Y] " filetype
        "set statusline+=\ [%{getcwd()}]     " current dir
        "set statusline+=\ [A=\%03.3b/H=\%02.2B] " ASCII/Hex value of char
        " show right aligned file nav info
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%\ of\ \%L
    endif

    " line {
        nmap <Leader>CC :call utils#ToggleColorColumn()<cr>

        if exists('&relativenumber') && &modifiable
            setl relativenumber
        else
            setl number
        endif
        nmap <F6> :call utils#ToggleNumber()<cr>
        imap <F6> <Esc>:call utils#ToggleNumber()<cr>
    " }
" }


"=============Plugin settings=============

if utils#enabledPlugin('nerdtree') > 0
    "load NERDTree on startup, but command line alias is prefered
    "au VimEnter * NERDTree
    "highlight main window
    au VimEnter * silent! wincmd p

    "map  :NERDTreeToggle
    nmap <silent> <Leader>E :NERDTreeToggle<CR>:NERDTreeMirror<CR>
    "nmap <ESC>e :NERDTreeToggle<CR><C-W><C-S><C-W><C-J>:BufExplorer<CR>

    let NERDTreeIgnore = ['\.o', '\.class', '\.pyc',
                        \ '\~$', '\.swo$', '\.swp$',
                        \ '\.git', '\.hg', '\.svn']
    "set autochdir
    let NERDTreeChDirMode = 2
    nn <Leader>. :NERDTree .<CR>
    ca nt NERDTree
    ca bm Bookmark
endif

if utils#enabledPlugin('bufexplorer') > 0
    "built-in <Leader>be
    "nmap <Leader>b :BufExplorer<CR>
    let g:bufExplorerSplitVertical = 1 
    let g:bufExplorerSortBy = 'mru'
    let g:bufExplorerUseCurrentWindow = 1
    let g:bufExplorerShowRelativePath = 1
    let g:bufExplorerDefaultHelp = 0
endif

if utils#enabledPlugin('fuzzyfinder') > 0
    nmap <Leader><Space> :FufBuffer<CR>
    nmap <Leader>e :FufFile<CR>
    "nmap <Leader>g :FufTaggedFile<CR>
    "nmap <Leader>d :FufDir<CR>
    "nmap <Leader>t :FufTag<CR>
endif

if utils#enabledPlugin('command-t') > 0
    nmap <Leader><Space> :CommandTBuffer<CR>
    nmap <Leader>e :CommandT<CR>
    nmap <Leader>y :CommandTFlush<CR>
    "let g:CommandTSearchPath = $HOME . '$HOME/Projects'
    let g:CommandTMatchWindowAtTop = 0
    let g:CommandTMaxFiles = 20000
endif

if utils#enabledPlugin('supertab') > 0
    let g:SuperTabDefaultCompletionType = 'context'
    "let g:SuperTabMappingTabLiteral = '<c-tab>' " default
    "let g:SuperTabCrMapping = 0
endif

if utils#enabledPlugin('snipmate') > 0
    let g:snips_author = expand($USER_FULLNAME)
    let g:author = expand($USER_FULLNAME)
    let g:snips_email = expand($USER_EMAIL)
    let g:email = expand($USER_EMAIL)
    let g:snips_github = expand($USER_GITHUB)
    let g:github = expand($USER_GITHUB)
    "nn <Leader>rs <esc>:exec ReloadAllSnippets()<cr>
endif

if utils#enabledPlugin('tabular') > 0
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

if utils#enabledPlugin('calendar') > 0
    "nmap <ESC>c :Calendar<CR>
    nmap <Leader>Ca :Calendar<CR>
    "cmap cal Calendar<SPACE>
    "cmap caL CalendarH<SPACE>
    let calendar_diary = '$DIARY_DIR'
    au BufNewFile *.cal call utils#CalInit()
endif

if utils#enabledPlugin('ack') > 0
    " improve grep if possible
    set grepprg=ack\ -a

    nmap <Leader>a :Ack<SPACE>
endif

if utils#enabledPlugin('gundo') > 0
    nmap <leader>U :GundoToggle<CR>
endif

if utils#enabledPlugin('fugitive') > 0
    nmap <Leader>ge :Gedit<Space>
    nmap <Leader>gb :Gblame<CR>
    nmap <Leader>gs :Gstatus<CR>
    nmap <Leader>gc :Gcommit<CR>
    nmap <Leader>gd :Gdiff<CR>
    nmap <Leader>gD :Gsdiff<CR>
    nmap <Leader>gl :Glog<CR>
    nmap <Leader>gr :Gread<CR>
    nmap <Leader>gw :Gwrite<CR>
    nmap <Leader>gr :GBrowse<CR>
    vmap <Leader>gr :GBrowse<CR>
    " show status
    " set statusline+=%{fugitive#statusline()} 
endif

if utils#enabledPlugin('vcscommand') > 0
    nmap <Leader>va <Plug>VCSAdd
    nmap <Leader>vb <Plug>VCSAnnotate
    nmap <Leader>vB <Plug>VCSAnnotate!
    nmap <Leader>vc <Plug>VCSCommit
    nmap <Leader>vd <Plug>VCSDiff
    nmap <Leader>vD <Plug>VCSDelete
    nmap <Leader>vg <Plug>VCSGotoOriginal
    nmap <Leader>vG <Plug>VCSGotoOriginal!
    nmap <Leader>vi <Plug>VCSInfo
    nmap <Leader>vl <Plug>VCSLog
    nmap <Leader>vL <Plug>VCSLock
    nmap <Leader>vr <Plug>CSReview
    nmap <Leader>vs <Plug>VCSStatus
    nmap <Leader>vu <Plug>VCSUpdate
    nmap <Leader>vU <Plug>VCSUnlock
    nmap <Leader>vv <Plug>VCSVimDiff
endif

if utils#enabledPlugin('tasklist') > 0
    nmap <leader>tl <Plug>TaskList
    let g:tlTokenList = ['FIXME', 'TODO', 'XXX', 'HACK']
endif

" NOTE: For program-specific or filetype-specific plugin settings,
" we manage to put them into program.vim or <filetype>.vim under ftplugin
