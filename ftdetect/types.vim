" Processes after file type detection(invoked by Vim builtin fileytype.vim)

if exists('b:_loaded_types') || &cp || version < 700
    finish
endif

let b:_loaded_types = 1

au FileType * call s:reviewType()

fun! s:reviewType()
    if &filetype =~ '^\(pdf\|doc\|zip\|tar\)$'
        "echomsg 'binary file'
        return
    elseif &filetype =~ '^\(text\|diff\|help\)$'
        "echomsg 'text file'
        return
    elseif &filetype == 'plaintex'
        set filetype=tex
        return
    endif

    let filename = fnameescape(expand('%'))
    if &filetype == 'python'
        if s:matchPattern('django') || s:maybeDjango(filename)
            set filetype=python.django
            return
        endif
    endif

    "echomsg 'assumed as source code of a program'
    exe 'so '. g:FTPLUGIN . '/program.vim'

    if !strlen(filename)  " stdin
        "echomsg 'stdin'
    elseif filereadable(filename) " existing file
        "echomsg 'readable: ' . filename
    elseif &modifiable && &buftype == ''
        " load template for new modifiable normal file
        call s:expandBuffer(fnameescape(g:TEMPLATES . '/' . &filetype))
        norm! G
    endif
endfun

" utils {
    fun! s:maybeDjango(filename)
        if a:filename =~ '^\(admin\|manage\|settings\|urls\|models\|views\|forms\)\.py$'
            return 1
        endif

        let parentdir = expand('%:p:h:t')
        if parentdir =~ '^\(settings\|urls\|models\|views\|forms\|templatetags\)$'
            return 1
        endif
    endfun

    fun! s:matchPattern(pattern)
        let n = line('$')
        if n > 100
            let n = 100
        endif
        let i = 1
        while i <= n
            if getline(i) =~ a:pattern
                return 1
            endif
            let i += 1
        endwhile
    endfun

    " Reads a file with the variables resolved and writes into buffer
    fun! s:expandBuffer(file)
        if !filereadable(a:file)
            return
        endif

        exe 'silent! 0r ' a:file
        for linenum in range(1, line('$'))
            let line = getline(linenum)
            if line =~ '\$'
                call setline(linenum, expand(line))
            endif
        endfor
    endfun
" }
