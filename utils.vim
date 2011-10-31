" Vim helper

let g:VIMFILES = expand('<sfile>:p:h:h')
let g:FTPLUGIN = g:VIMFILES."/ftplugin/"
let g:TEMPLATES = g:VIMFILES."/templates/"

" File {
    " filetype initialization
    fun! utils#FileTypeInit()
        let filename = expand("%")
        " load extra script
        "au FileType xml source ~/.vim/extra/xml.vim
        "au BufNewFile,BufRead * silent! so ~/.vim/extra/%:e.vim
        if utils#IsProgram()
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

        " store current formats
        let old_fo = &formatoptions
        let old_inde = &indentexpr
        let old_ai = &autoindent
        let old_ci = &cindent
        let old_si = &smartindent
        " disable format and indent temporarily
        setl fo-=c fo-=r fo-=o   
        setl noai nocin nosi inde=
        " expand
        let lines = ""
        for line in readfile(a:file)
            if line =~ '^[^#].*\$'
                let line = expand(line)
            endif
            let lines = lines.line."\n"
        endfor
        exe "normal!i".lines
        " restore old formats
        exe "setl fo=".old_fo
        exe "setl inde=".old_inde
        if old_ai
            set ai
        endif
        if old_ci
            set ci
        endif
        if old_si
            set si
        endif
    endfun

    fun! utils#IsProgram()
        return index(["c","cpp","java","cs","objc","python","ruby","perl","php","javascript"], &filetype) >= 0
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
