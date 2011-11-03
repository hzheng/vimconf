" Vim helper

" Environment {
    fun! utils#init(conf)
        let g:VIMCONF = a:conf
    endfun

    " the following can NOT be put into the above function due to sfile
    let g:VIMFILES = expand('<sfile>:p:h:h')
    let g:BUNDLE = g:VIMFILES."/bundle/"
    let g:FTPLUGIN = g:VIMFILES."/ftplugin/"
    let g:TEMPLATES = g:VIMFILES."/templates/"
    let g:VIMTMP = g:VIMFILES."/tmp/"
    let g:SESSIONS = g:VIMTMP."session/"
" }

" File {
    " filetype initialization
    fun! utils#FileTypeInit()
        let filename = expand("%")
        " load extra script
        "au FileType xml source ~/.vim/extra/xml.vim
        "au BufNewFile,BufRead * silent! so ~/.vim/extra/%:e.vim
        if IsProgram()
            exe "silent! so ".g:FTPLUGIN."program.vim"
            " set tag file
            exe "set tags=~/tags/".&filetype
        endif

        if !strlen(filename)  " stdin
            "exe "normal! iempty filename"
        elseif filereadable(filename)
            "exe "normal! i FileTypeInit old:" bufname("%") &filetype 
        elseif &modifiable "new modifiable file
            " load template
            "au BufNewFile * silent! 0r ~/.vim/templates/%:e | norm G
            "exe "silent! 0r ~/.vim/templates/".&filetype
            "call utils#ExpandBuffer(expand('~/.vim/templates/').&filetype)
            call utils#ExpandBuffer(g:TEMPLATES.&filetype)
            exe "normal! G"
        endif
    endfun

    " Reads a file with the variables resolved and writes into buffer
    fun! utils#ExpandBuffer(file)
        if !filereadable(a:file)
            return
        endif

        exe "read " a:file
        exe ":1d"
        for linenum in range(1, line('$'))
            let line = getline(linenum)
            if line =~ '\$'
                call setline(linenum, expand(line))
            endif
        endfor
    endfun

    fun! IsProgram()
        return index(["c","cpp","java","cs","objc","python","ruby","perl","php","javascript"], &filetype) >= 0
    endfun

    fun! GetSessionDir()
        return g:SESSIONS . getcwd()
    endfun

    fun! GetSessionFile()
        return GetSessionDir() . "/session.vim"
    endfun

    fun! utils#SaveSession()
        let sessiondir = GetSessionDir()
        if (filewritable(sessiondir) != 2)
            exe "silent !mkdir -p " sessiondir
            redraw!
        endif
        exe "mksession! " GetSessionFile()
    endfun

    fun! utils#UpdateSession()
        let sessionfile = GetSessionFile()
        if (filereadable(sessionfile))
            exe "mksession! " . sessionfile
            echo "updating session"
        endif
    endfun

    fun! utils#LoadSession()
        if argc() == 0
            let sessionfile = GetSessionFile()
            if (filereadable(sessionfile))
                exe "so" sessionfile
            else
                echo "No session loaded."
            endif
        endif
    endfun

    fun! utils#GetUrl()
        let target = expand('<cfile>')
        if target == ""
            return ""
        endif

        if matchstr(target, '[a-z]*:\/\/[^ ]*') != ""
            return target
        endif

        let target = expand(target)
        if filereadable(target) || isdirectory(target)
            return target
        else " take it as a http site
            return "http://".target
        endif
    endfun

    fun! utils#OpenUrl()
        let url = utils#GetUrl()
        if url == ""
            echo "empty target"
            return
        endif
        
        " mac
        "echo url
        exe "!open ".url
    endfun
" }

" Format {
    fun! utils#ToggleColorColumn()
        if !exists("&colorcolumn")
            return
        endif

        if &colorcolumn == ""
            set colorcolumn=+1
        else
            set colorcolumn=
        endif
    endfun

    fun! utils#ToggleNumber()
        if exists("&relativenumber")
            if &relativenumber
                set number
            elseif &number
                set nonumber
            else
                set relativenumber
            endif
        else
            set number!
        endif
    endfun

    fun! utils#InsertStatuslineColor(mode)
        if a:mode == 'i'
            hi statusline guibg=magenta
        elseif a:mode == 'r'
            hi statusline guibg=blue
        else
            hi statusline guibg=red
        endif
    endfun

    fun! utils#TabLine()
        let res = ''
        let curtab = tabpagenr()
        let i = 0

        if has('win32')
            let pat = '.\+\\'
        else
            let pat = '.\+/'
        endif

        for i in range(1, tabpagenr('$'))
            let res .= ((i == curtab) ? '%#TabLineSel#' : '%#TabLine#')
            let res .= ' '
            let res .= substitute(bufname(tabpagebuflist(i)[0]), pat, '', 'g')
            let res .= ' '
            let i += 1
        endfor

        let res .= '%#TabLineFill#'
        return res
    endfun

    fun! utils#GuiTabLabel()
        let label = ''
        let bufnrlist = tabpagebuflist(v:lnum)
        " Add '+' if one of the buffers in the tab page is modified
        for bufnr in bufnrlist
            if getbufvar(bufnr, "&modified")
                let label .= '+'
                break
            endif
        endfor
        " Append the tab number
        let label .= v:lnum . ': '
        " Append the buffer name
        let name = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
        if name == ''
            " give a name to no-name documents
            if &buftype == 'quickfix'
                let name = '[Quickfix List]'
            else
                let name = '[No Name]'
            endif
        else
            " get only the file name
            let name = fnamemodify(name, ":t")
        endif
        let label .= name
        " Append the number of windows in the tab page if more than 1
        let wincount = tabpagewinnr(v:lnum, '$')
        if wincount > 1
            let label .= " [" . wincount . "]"
        endif
        return label
    endfun

    fun! utils#GuiTabToolTip()
        let tip = ''
        for bufnr in tabpagebuflist(v:lnum)
            " separate buffer entries
            if tip != ''
                let tip .= " \n "
            endif
            " Add name of buffer
            let name = bufname(bufnr)
            if name == ''
                " give a name to no name documents
                if getbufvar(bufnr, '&buftype') == 'quickfix'
                    let name = '[Quickfix List]'
                else
                    let name = '[No Name]'
                endif
            endif
            let tip .= name
            " add modified/modifiable flags
            if getbufvar(bufnr, "&modified")
                let tip .= ' [+]'
            endif
            if getbufvar(bufnr, "&modifiable") == 0
                let tip .= ' [-]'
            endif
        endfor
        return tip
    endfun
" }

" Calendar {
    fun! utils#CalInit()
        exe "read ".g:TEMPLATES."diary"
        call InsertChineseDate()
    endfun

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
" }
