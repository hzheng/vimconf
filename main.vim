" VIM configuration file

"=============sets=============
" Turn on automatic indentation.
set ai

" Automatically write files as needed.
set aw 

" Set shift width or the size of an indentation.
set sw=4 

" Have vim highlight the target of a search.
set hls

" Do incremental searches.
set is 

" Ignore case when search
set ignorecase

" Set smart case
set scs

" No wrap scan when search
set nowrapscan

" Set the width of text to 80 characters.
" set tw=80

"set link break to avoid wraping a word
set lbr

" Show partially typed commands
set sc           

" Show parentheses matching
set sm

" Show the ruler
set ru

" Set ruler format: length, column, percentage, total lines,
" chop position, middle position, file name, modification and read-only flag.
set ruf=%40(%4l,%2v(%p%%\ of\ \%L)%<%=%8.20t%m%R%)              

" Allow backspace to delete newlines and beyond the start of the insertion point
set bs=2

" Allow the cursor to wrap on anything
set ww=b,s,h,l,<,>,[,]

" Don't add two spaces after ., ?, !
set nojoinspaces

" Insert tabs as spaces
set et

" Set smart tab: in front of a line inserts blanks according to
" 'shiftwidth', A <BS> will delete a 'shiftwidth' worth of space
" at the start of the line.
set sta

" Set textauto to recognize ^M files
set ta

" Don't show status line
set ls=0

" Set wildmode
set wim=longest,full

" Swap directory
set dir=/tmp

" Turn on backup
set backup

" Turn on write backup
set wb

" Backup directory
set bdir=/tmp

" Backup extension
set bex=~

" Show mode
set smd

" Set mouse
set mouse=a

" Suffixes to put to the end of the list when completing file names
set suffixes=.bak,~,.o,.class,.info,.swp

" Patterns to put to ignore when completing file names
set wig=*.bak,~,*.o,*.info,*.swp,*.class

" Report all change
set report=0

" Set soft tab stop
set sts=4

" Expand tab
set et

" smart tab
set sta

" read dictionary
set dict=/usr/share/dict/words

" set encoding
set encoding=utf-8
" for MacVim
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936

" variables
let mapleader = ","

"=============abbreviations=============
"most abbreviations should go to filetype-aware's scripts(under .vim/extra)


"=============maps=============
" Making it so ; works like : for commands. Saves typing and eliminates :W
" style typos due to lazy holding shift.
"nnoremap ; :

" Map save buffer
"map  <S-CR>       :w<CR>
"map  <F4>       :w<CR>
"map! <F4>       <ESC>:w<CR>
"map! <S-F4>     <ESC>ZZ

"Navigate argument list
"map  <F5>       :prev<CR>
"map  <F6>       :n<CR>
"map  <S-F5>     :fir<CR>
"map  <S-F6>     :la<CR>

" Turn search highlighting on and off
"map  <F8>        :set hls!<bar>set hls?<CR>
"imap <F8>        <ESC>:set hls!<bar>set hls?<CR>i

" Delete current buffer
"map  <F12>       :bd<CR>

" fast input
nn  <CR>         i<CR>
nn  <Space>      i<Space>
nn  <BS>         i<BS>

" Facilitate window navigation
nmap <ESC>w   <c-w>
nmap <ESC>v   <c-w>w

"=============syntax=============
" Turn on syntax highlighting:
syntax on

"=============C/C++ indentation and comments=============
" For all files, set the format options, turn off C indentation, and finally set the comments option to the default.
au FileType * set formatoptions=tcql nocindent
\                  comments& 

" For all C and C++ files, set the formatoptions, turn on C indentation, and set the comments option.
au FileType c,cpp 
\       set fo=croql cindent
\        comments=sr:/*,mb:*,ex:*/,://

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
            exe "silent! so ~/.vim/extra/program.vim"
            " set tag file
            exe "set tags=~/tags/".&filetype
        endif
        exe "silent! so ~/.vim/extra/".&filetype.".vim"

        if filereadable(expand("%"))
            "exe "normal! i FileTypeInit old:" bufname("%") &filetype 
        else " load template for new file
            "au BufNewFile * silent! 0r ~/.vim/templates/%:e | norm G
            exe "silent! 0r ~/.vim/templates/".&filetype
            exe "normal! G"
        endif
    endfun
    au FileType * call FileTypeInit()
" }

"=============plugins=============
"
" NerdTree {
    "load NERDTree on startup, but command line alias is prefered
    "au VimEnter * NERDTree
    "highlight main window
    au VimEnter * silent! wincmd p

    "map  :NERDTreeToggle
    nmap <ESC>e :NERDTreeToggle<CR>
    "nmap <ESC>e :NERDTreeToggle<CR><C-W><C-S><C-W><C-J>:BufExplorer<CR>

    let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
" }

" Tag, TagList {
    "set completeopt=longest,menu
    ino <S-Space> <C-X><C-O>
    map <S-Left> <C-T>
    map <S-Right> <C-]>
    map <S-Up> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
    map <S-Down> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
    
    nmap <ESC>t :TlistToggle<CR>
    nmap <ESC>u :TlistUpdate<CR>
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
" }

" BufExplorer {
    "nmap <ESC>b :BufExplorer<CR> "built-in <leader>be
    let g:bufExplorerSplitVertical = 1 
    let g:bufExplorerSortBy = 'mru'
    let g:bufExplorerUseCurrentWindow = 1
    let g:bufExplorerShowRelativePath = 1
    let g:bufExplorerDefaultHelp = 0
" }

" FuzzyFinder {
    nmap <ESC>b :FufBuffer<CR>
    nmap <ESC>f :FufFile<CR>
    nmap <ESC>g :FufTag<CR>
" }

" SuperTab {
    let g:SuperTabDefaultCompletionType = "context"
    "let g:SuperTabMappingTabLiteral = '<c-tab>' " default
" }

" SnipMate {
    let g:snips_author='Hui Zheng'
    let g:author='Hui Zheng'
    let g:snips_email='xyzdll@gmail.com'
    let g:email='xyzdll@gmail.com'
    let g:snips_github='https://github.com/hzheng'
    let g:github='https://github.com/hzheng'
    "au FileType c,cpp,java,python,ruby,perl,php,objc,javascript,xml,html,xhtml,sh source ~/.vim/extra/snipMate.vim
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

    nmap <ESC>c :Calendar<CR>
    "cmap cal Calendar<SPACE>
    "cmap caL CalendarH<SPACE>
    let calendar_diary = "$DIARY_DIR"
    au BufNewFile *.cal read $HOME/.vim/templates/diary | call InsertChineseDate()
    "au BufNewFile,BufRead *.cal set ft=rst
" }

:if $VIM_CRONTAB == "true"
:set nobackup
:set nowritebackup
:endif

