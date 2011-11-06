" customize file types

au BufRead * call s:DetectType()

fun! s:DetectType()
    if &ft == "python"
        call s:SetDjango()
    endif
endfun

" Java {
    au BufRead,BufNewFile *.jspf   set ft=jsp
    au BufRead,BufNewFile *.tag    set ft=jsp
    au BufRead,BufNewFile *.tagf   set ft=jsp
" }

" Prolog {
    au BufRead,BufNewFile *.pro    set ft=prolog
" }

" reST {
    au BufRead,BufNewFile *.cal    set ft=rst
" }

" text {
    au BufRead,BufNewFile *.txt    setf text
" }

" python {
    fun! s:SetDjango()
        let n = line("$")
        if n > 100
            let n = 100
        endif
        let i = 1
        while i <= n
            if getline(i) =~ "django"
                set ft=python.django
                break
            endif
            let i += 1
        endwhile
    endfun
" }
