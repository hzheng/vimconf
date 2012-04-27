" RST-specific vimscript

if exists('b:_loaded_rst') || &cp || version < 700
    finish
endif

let b:_loaded_rst = 1


" Fast input {
    " recommended underline title adornments
    nn <buffer> <Leader>u#     yypVr#yykP2j
    nn <buffer> <Leader>u3     yypVr#
    nn <buffer> <Leader>u*     yypVr*yykP2j
    nn <buffer> <Leader>u8     yypVr*

    nn <buffer> <Leader>u=     yypVr=
    nn <buffer> <Leader>u-     yypVr-
    nn <buffer> <Leader>u^     yypVr^
    nn <buffer> <Leader>u"     yypVr"

    nn <buffer> <Leader>u+     yypVr+
    nn <buffer> <Leader>u_     yypVr_
    nn <buffer> <Leader>u~     yypVr~
    nn <buffer> <Leader>u'     yypVr'
    nn <buffer> <Leader>u`     yypVr`
    nn <buffer> <Leader>u.     yypVr.
    nn <buffer> <Leader>u:     yypVr:

    " time
    ab <buffer> date .. \|date\| date::
    ab <buffer> time .. \|time\| date:: %H:%M
" }

" Debug {
    if executable('rst2html.py')
        setl efm=%f:%l:\ %m
        setl makeprg=rst2html.py\ %\ /tmp/%<.html
    endif
" }

"=============Plugin settings=============

if utils#enabledPlugin('vst') >= 0
    nmap <buffer> <Leader>fr :Vst foldr<CR>
    au BufReadPre * :Vst foldr

    " manually load
    call utils#loadPlugin('vst')
endif
