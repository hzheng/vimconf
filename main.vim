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

" Define some abbreviations to draw comments.
iab #b         /********************************************************
iab #m   <Space>*                                                      *
iab #e   <Space>********************************************************/ 
iab #l         /*------------------------------------------------------*/ 
iab bm <bean:message key="

"=============maps=============
" Making it so ; works like : for commands. Saves typing and eliminates :W
" style typos due to lazy holding shift.
"nnoremap ; :

" Map save buffer
"map  <S-CR>       :w<CR>
map  <F4>       :w<CR>
map! <F4>       <ESC>:w<CR>
map! <S-F4>     <ESC>ZZ

" fast input
nn  <CR>         i<CR>
nn  <Space>      i<Space>
nn  <BS>         i<BS>

"Navigate argument list
map  <F5>       :prev<CR>
map  <F6>       :n<CR>
map  <S-F5>     :fir<CR>
map  <S-F6>     :la<CR>

" Turn search highlighting on and off
map  <F8>        :set hls!<bar>set hls?<CR>
imap <F8>        <ESC>:set hls!<bar>set hls?<CR>i

" Delete current buffer
map  <F12>       :bd<CR>

" au FileType xml imap <Leader>v <?xml version="1.0"?><CR>
"            \  imap <Leader>i <?xml version="1.0" encoding="iso-8858-1"?><CR>
           
"=============functions=============
" Based on VIM tip 102: automatic tab completion of keywords
function InsertTabWrapper(dir)
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
	return "\<tab>"
    elseif "pre" == a:dir
	return "\<c-p>"
    else
	return "\<c-n>"
    endif
endfunction

" not needed any more since SuperTab has been installed
"inoremap <tab> <c-r>=InsertTabWrapper("pre")<CR>
"inoremap <s-tab> <c-r>=InsertTabWrapper("next")<CR>

"=============autocmds=============
" For all files, set the format options, turn off C indentation, and finally set the comments option to the default.
au FileType * set formatoptions=tcql nocindent
\                  comments& 

" For all C and C++ files, set the formatoptions, turn on C indentation, and set the comments option.
au FileType c,cpp 
\       set fo=croql cindent
\        comments=sr:/*,mb:*,ex:*/,://

"=============others=============
" Turn on syntax highlighting:
syntax on

filetype plugin indent on

"===============test new feature
" * Keystrokes -- For HTML Files

" Some automatic HTML tag insertion operations are defined next.  They are
" allset to normal mode keystrokes beginning \h.  Insert mode function keys are
" also defined, for terminals where they work.  The functions referred to are
" defined at the end of this .vimrc.

" \hc ("HTML close") inserts the tag needed to close the current HTML construct
" [function at end of file]:
au FileType html
            \ nnoremap \hc :call InsertCloseTag()<CR>

function! InsertCloseTag()
" inserts the appropriate closing HTML tag; used for the \hc operation defined
" above;
" requires ignorecase to be set, or to type HTML tags in exactly the same case
" that I do;
" doesn't treat <P> as something that needs closing;
" clobbers register z and mark z
" 
" by Smylers  http://www.stripey.com/vim/

  if &filetype == 'html'

    " list of tags which shouldn't be closed:
    let UnaryTags = ' Area Base Br DD DT HR Img Input LI Link Meta P Param '

    " remember current position:
    normal mz

    " loop backwards looking for tags:
    let Found = 0
    while Found == 0
      " find the previous <, then go forwards one character and grab the first
      " character plus the entire word:
      execute "normal ?\<LT>\<CR>l"
      normal "zyl
      let Tag = expand('<cword>')

      " if this is a closing tag, skip back to its matching opening tag:
      if @z == '/'
        execute "normal ?\<LT>" . Tag . "\<CR>"

      " if this is a unary tag, then position the cursor for the next
      " iteration:
      elseif match(UnaryTags, ' ' . Tag . ' ') > 0
        normal h

      " otherwise this is the tag that needs closing:
      else
        let Found = 1

      endif
    endwhile " not yet found match

    " create the closing tag and insert it:
    let @z = '</' . Tag . '>'
    normal `z
    if col('.') == 1
      normal "zP
    else
      normal "zp
    endif

  else " filetype is not HTML
    echohl ErrorMsg
    echo 'The InsertCloseTag() function is only intended to be used in HTML ' .
      \ 'files.'
    sleep
    echohl None

  endif " check on filetype

endfunction " InsertCloseTag()

augroup filetype
        au!
        au! BufRead,BufNewFile *.jsp    set filetype=xml
        au! BufRead,BufNewFile *.jspf   set filetype=xml
        au! BufRead,BufNewFile *.tag    set filetype=xml
        au! BufRead,BufNewFile *.pro    set filetype=prolog
augroup END

" XML file {
    au FileType xml source ~/.vim/extra/xml-file.vim
" }

" NerdTree {
    "load NERDTree on startup, but command line alias is prefered
    "au VimEnter * NERDTree
    "highlight main window
    au VimEnter * wincmd p

    "map  :NERDTreeToggle
    nmap <ESC>e :NERDTreeToggle<CR>

    let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
" }

" TagList {
    nmap <ESC>t :TlistToggle<CR>
    nmap <ESC>u :TlistUpdate<CR>
    let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
    let Tlist_Use_Right_Window = 1
    "let Tlist_Auto_Open = 1
" }

" BufExplorer {
    nmap <ESC>b :BufExplorer<CR>
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
    " let g:snips_github='https://github.com/jmoyers'
    " let g:github='https://github.com/jmoyers'
    "au FileType c,cpp,java,python,ruby,perl,php,objc,javascript,xml,html,xhtml,sh source ~/.vim/extra/snipMate.vim
" }

:if $VIM_CRONTAB == "true"
:set nobackup
:set nowritebackup
:endif

