" VIM main configuration file

"=============Built-in settings=============

" Basic {
    set nocompatible " ignore vi compatibility
    "let mapleader = ","   "will slow down search
    let mapleader = "\\"
" }

" Utility {
    " Reads a file with the variables resolved and writes into buffer
    fun! ExpandBuffer(file)
        "disable format and indent temporarily
        setl fo-=c fo-=r fo-=o
        setl noai nocin nosi inde=

        let lines = ""
        for line in readfile(a:file)
            if line =~ '^[^#].*\$'
                let line = expand(line)
            endif
            let lines = lines.line."\n"
        endfor
        exe "normal!i".lines
    endfun
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
    nn <leader>ni :setl noai nocin nosi inde=<CR>

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
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>
" }

" Search {
    set hls " Have vim highlight the target of a search.
    set is  " Do incremental searches.
    set ignorecase " Ignore case when search
    set scs " Set smart case
    set nowrapscan " No wrap scan when search
    " Turn search highlighting on and off
    "map  <F8>        :set hls!<bar>set hls?<CR>
    map  <silent> <leader>/ :set hls!<bar>set hls?<CR>
    "nmap <silent> <leader>/ :nohlsearch<CR>
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
    
    "most input abbreviations should go to filetype-aware's scripts(under .vim/ftplugin)

    " fast input {
        nn  <CR>         i<CR>
        nn  <Space>      i<Space>
        nn  <BS>         i<BS>
    " }

    " Spell {
        set dict+=/usr/share/dict/words " dictionary
        set thesaurus+=/usr/share/dict/mthesaur.txt " thesaurus
        "imap <Leader>s <C-o>:setlocal spell! spelllang=en_gb<CR>
        nmap <Leader>s :setlocal spell! spelllang=en_gb<CR>
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
    set aw " Automatically write files as needed.
    set wim=longest,full " Set wildmode
    " Suffixes to put to the end of the list when completing file names
    set suffixes=.bak,~,.o,.class,.info,.swp
    " Patterns to put to ignore when completing file names
    set wig=*.bak,~,*.o,*.info,*.swp,*.class,*.pyc,.git,.svn

    set dir=/tmp " Swap directory
    set backup " Turn on backup
    set wb " Turn on write backup
    set bdir=/tmp " Backup directory
    set bex=~ " Backup extension

    " Save view records
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
    "nmap <S-Tab>  <c-w>p
    nmap <ESC>v   <c-w>v
    nmap <ESC>s   <c-w>s
    "nmap <ESC>q   <c-w>q
    nmap <ESC>j   <c-w>j
    nmap <ESC>k   <c-w>k
    nmap <ESC>h   <c-w>h
    nmap <ESC>l   <c-w>l
    nmap <leader>n <c-w>n
    nmap <leader>o <c-w>o

    " Tab
    nmap <S-Tab>  :tabnew<CR>

    " Buffer navigation
    nmap <ESC>d   :bd<CR>
    nmap <ESC>n   :bn<CR>
    nmap <ESC>p   :bp<CR>
    "map  <F5>       :prev<CR>
    "map  <F6>       :n<CR>
    "map  <S-F5>     :fir<CR>
    "map  <S-F6>     :la<CR>

    " Buffer manipulation 
    " avoid conflicting with 'q' command(for recording)
    nmap <leader>q   :q<CR>
    nmap <leader>qq  :q!<CR>
    nmap <leader>qa  :qa<CR>
    nmap <leader>qaa :qa!<CR>

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

    fun! IsProgram()
        return index(["c","cpp","java","cs","objc","python","ruby","perl","php","javascript"], &filetype) >= 0
    endfun

    " initialization
    fun! FileTypeInit()
        " load extra script
        "au FileType xml source ~/.vim/extra/xml.vim
        "au BufNewFile,BufRead * silent! so ~/.vim/extra/%:e.vim
        if IsProgram()
            exe "silent! so ~/.vim/ftplugin/program.vim"
            " set tag file
            exe "set tags=~/tags/".&filetype
        endif
        "exe "silent! so ~/.vim/ftplugin/".&filetype.".vim"

        if filereadable(expand("%"))
            "exe "normal! i FileTypeInit old:" bufname("%") &filetype 
        elseif &modifiable "new modifiable file
            " load template
            "au BufNewFile * silent! 0r ~/.vim/templates/%:e | norm G
            "exe "silent! 0r ~/.vim/templates/".&filetype
            call ExpandBuffer(expand('~/.vim/templates/').&filetype)
            exe "normal! G"
        endif
    endfun
    au FileType * call FileTypeInit()
" }

" GUI {
    "set background=light
    "color spring            " load a colorscheme
    syntax on " Turn on syntax highlighting

    " Set mouse
    set mouse=a
    "set selection=exclusive
    "set selectmode=mouse,key
    "behave xterm

    if has('gui_running')
        set guioptions-=T      " remove the toolbar
        set lines=80           " default in my screen: 75
        set tabpagemax=15      " only show 15 tabs
    else
        set term=builtin_ansi  " Make arrow and other keys work
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

        fun! InsertStatuslineColor(mode)
          if a:mode == 'i'
            hi statusline guibg=magenta
          elseif a:mode == 'r'
            hi statusline guibg=blue
          else
            hi statusline guibg=red
          endif
        endfun

        au InsertEnter * call InsertStatuslineColor(v:insertmode)
        au InsertLeave * hi statusline guibg=green
        " default the statusline to green when entering Vim
        hi statusline guibg=green
    endif

    "set cursorline
    " highlight bg color of current line
    "hi cursorline guibg=#333333 
    " highlight cursor
    "hi CursorColumn guibg=#333333
" }


"=============Plugin settings=============

" NerdTree {
    "load NERDTree on startup, but command line alias is prefered
    "au VimEnter * NERDTree
    "highlight main window
    au VimEnter * silent! wincmd p

    "map  :NERDTreeToggle
    nmap <silent> <ESC>e :NERDTreeToggle<CR>:NERDTreeMirror<CR>
    "nmap <ESC>e :NERDTreeToggle<CR><C-W><C-S><C-W><C-J>:BufExplorer<CR>

    let NERDTreeIgnore=['\.o', '\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
    "set autochdir
    let NERDTreeChDirMode = 2
    nn <leader><leader> :NERDTree .<CR>
    ca nt NERDTree
    ca bm Bookmark
" }

" Tag, TagList, Tagbar {
    "set completeopt=longest,menu
    ino <S-Space> <C-X><C-O>
    map <S-Left> <C-T>
    map <S-Right> <C-]>
    map <S-Up> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
    map <S-Down> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
    
    "nmap <ESC>t :TlistToggle<CR>
    nmap <leader>l :TlistToggle<CR>
    nmap <leader>u :TlistUpdate<CR>
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


    nmap <ESC>t :TagbarToggle<CR>
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
" }

" BufExplorer {
    "built-in <leader>be
    "nmap <leader>b :BufExplorer<CR>
    let g:bufExplorerSplitVertical = 1 
    let g:bufExplorerSortBy = 'mru'
    let g:bufExplorerUseCurrentWindow = 1
    let g:bufExplorerShowRelativePath = 1
    let g:bufExplorerDefaultHelp = 0
" }

" FuzzyFinder {
    "nmap <ESC>b :FufBuffer<CR>
    "nmap <leader>b :FufBuffer<CR>
    "nmap <ESC>f :FufFile<CR>
    "nmap <leader>f :FufFile<CR>
    nmap <leader>g :FufTaggedFile<CR>
    "nmap <leader>d :FufDir<CR>
    nmap <leader>t :FufTag<CR>
" }

" Command-T {
    nmap <ESC>f :CommandT<CR>
    nmap <ESC>b :CommandTBuffer<CR>
    "let g:CommandTSearchPath = $HOME . '$HOME/Projects'
    let g:CommandTMatchWindowAtTop = 1
" }

" SuperTab {
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
    "nn <leader>rs <esc>:exec ReloadAllSnippets()<cr>
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
    fun! InsertChineseDate()
        exe 'normal! ggdd'
        let path = split(expand("%"), "/")
        if len(path) > 3
            let date = path[len(path) - 3 :]
            let day = substitute(date[2], ".cal", "日", "g")
            exe "normal! i       " date[0]."年".date[1]."月".day
            exe 'normal! o'
        endif
    endfun

    "nmap <ESC>c :Calendar<CR>
    nmap <leader>c :Calendar<CR>
    "cmap cal Calendar<SPACE>
    "cmap caL CalendarH<SPACE>
    let calendar_diary = "$DIARY_DIR"
    au BufNewFile *.cal read $HOME/.vim/templates/diary | call InsertChineseDate()
    "au BufNewFile,BufRead *.cal set ft=rst
" }
