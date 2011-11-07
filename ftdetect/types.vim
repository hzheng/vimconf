" customize file types

au BufRead,BufNewFile * call s:DetectType()

fun! s:DetectType()
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
    elseif extension == 'pro'
        set ft=prolog
    elseif extension == 'cal'
        set ft=rst
    elseif extension == 'txt'
        setf text
    endif
endfun

" Python {
    fun! s:MaybeDjango(filename)
        if a:filename =~ '^\(admin\|manage\|settings\|urls\|models\|views\|forms\)\.py$'
            return 1
        endif

        let parentdir = expand("%:p:h:t")
        if parentdir =~ '^\(settings\|urls\|models\|views\|forms\|templatetags\)$'
            return 1
        endif
    endfun
" }

" utils {
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
" }
