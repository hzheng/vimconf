" RST-specific vimscript

if exists("b:_loaded_rst_vim")
    finish
endif

let b:_loaded_rst_vim = 1

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
    ab date .. \|date\| date::
    ab time .. \|time\| date:: %H:%M
" }

"=============Plugin settings=============

if utils#enabledPlugin('vst') >= 0
    nmap <buffer> <Leader>fr :Vst foldr<CR>
    au BufReadPre * :Vst foldr

    " manually load
    call utils#loadPlugin('vst')
endif
