" Processes after file type detection

if exists("b:_loaded_types_vim")
    finish
endif

let b:_loaded_types_vim = 1

au FileType * call s:initType()

au BufRead,BufNewFile * call s:reviewType()

fun! s:initType()
    let filename = fnameescape(expand("%"))
    " load extra script
    if s:isProgram()
        exe "so ". g:FTPLUGIN . "/program.vim"
    endif

    if !strlen(filename)  " stdin
        "echomsg 'stdin'
    elseif filereadable(filename) " existing file
        "echomsg 'readable: ' . filename
    elseif &modifiable && &buftype == ""
        " load template for new modifiable normal file
        call s:expandBuffer(fnameescape(g:TEMPLATES . "/" . &filetype))
        norm! G
    endif
endfun

fun! s:reviewType()
    let filename = expand("%")

    " check filetype
    if &ft == "python"
        if s:MatchPattern("django") || s:MaybeDjango(filename)
            set ft=python.django
        endif
        return
    endif

    " check extension
    let extension = expand("%:e")
    if extension =~ '^\(jspf\|tag\|tagf\)$'
        "set ft=jsp
        setf jsp
        return
    elseif extension == 'pro'
        set ft=prolog
        return
    elseif extension == 'cal'
        set ft=rst
        return
    elseif extension == 'txt'
        setf text
        return
    endif

    " check filename
    if filename =~ '^\(TODO\|README\)$'
        set ft=rst
    endif
endfun

" utils {
    fun! s:MaybeDjango(filename)
        if a:filename =~ '^\(admin\|manage\|settings\|urls\|models\|views\|forms\)\.py$'
            return 1
        endif

        let parentdir = expand("%:p:h:t")
        if parentdir =~ '^\(settings\|urls\|models\|views\|forms\|templatetags\)$'
            return 1
        endif
    endfun

    fun! s:MatchPattern(pattern)
        let n = line("$")
        if n > 100
            let n = 100
        endif
        let i = 1
        while i <= n
            if getline(i) =~ a:pattern
                "exe "set ft=" . a:ft
                return 1
            endif
            let i += 1
        endwhile
    endfun

    fun! s:isProgram()
        " TODO: need improvement
        "return &filetype =~ '^\(c\|cpp\|java\|cs\|objc\|python\|ruby\|perl\|php\|javascript\|vim\|sh\|lisp\|prolog\)$'
        return &filetype !~ '^\(text\|pdf\|zip\|tar\)$'
    endfun

    " Reads a file with the variables resolved and writes into buffer
    fun! s:expandBuffer(file)
        if !filereadable(a:file)
            return
        endif

        exe "silent! 0r " a:file
        for linenum in range(1, line('$'))
            let line = getline(linenum)
            if line =~ '\$'
                call setline(linenum, expand(line))
            endif
        endfor
    endfun
" }
