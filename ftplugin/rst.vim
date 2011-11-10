" RST-specific vimscript

if exists("_loaded_rst_vim")
    finish
endif

let _loaded_rst_vim = 1

" VST {
    nmap <leader>rf :Vst foldr<CR>
    au BufReadPre * :Vst foldr
" }

" Fast input {
    " recommended underline title adornments
    nn <leader>u#     yypVr#yykP2j
    nn <leader>u3     yypVr#
    nn <leader>u*     yypVr*yykP2j
    nn <leader>u8     yypVr*

    nn <leader>u=     yypVr=
    nn <leader>u-     yypVr-
    nn <leader>u^     yypVr^
    nn <leader>u"     yypVr"

    nn <leader>u+     yypVr+
    nn <leader>u_     yypVr_
    nn <leader>u~     yypVr~
    nn <leader>u'     yypVr'
    nn <leader>u`     yypVr`
    nn <leader>u.     yypVr.
    nn <leader>u:     yypVr:

    " time
    ab date .. \|date\| date::
    ab time .. \|time\| date:: %H:%M
" }
