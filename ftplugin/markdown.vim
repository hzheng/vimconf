" Markdown-specific vimscript

if exists('b:_loaded_md') || &cp || version < 700
    finish
endif

let b:_loaded_md = 1


" Fast input {
    " underline title adornments
    nn <buffer> <Leader>u=     yypVr=
    nn <buffer> <Leader>u-     yypVr-
" }

" Debug {
    if executable('maruku')
        setl efm=%A%.%#Maruku\ tells\ you:,%C\+\-%#,%C\|%m
        setl makeprg=maruku\ -b\ %\ -o\ /tmp/%<.html
    elseif executable('rdiscount')
        setl makeprg=rediscount\ %\ >/tmp/%<.html
    elseif executable('redcarpet')
        setl makeprg=redcarpet\ %\ >/tmp/%<.html
    elseif executable('Markdown.pl')
        setl makeprg=Markdown.pl\ --html4tags\ %\ >/tmp/%<.html
    endif
" }
