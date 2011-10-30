" Vim helper

" File {
    " Reads a file with the variables resolved and writes into buffer
    fun! ExpandBuffer(file)
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

    fun! IsProgram()
        return index(["c","cpp","java","cs","objc","python","ruby","perl","php","javascript"], &filetype) >= 0
    endfun

    fun! GetUrl()
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

    fun! OpenUrl()
        let url = GetUrl()
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
    fun! ToggleColorColumn()
        if !exists("&colorcolumn")
            return
        endif

        if &colorcolumn == ""
            set colorcolumn=+1
        else
            set colorcolumn=
        endif
    endfun

    fun! ToggleNumber()
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
" }
