" Django-specific vimscript

if exists('b:_loaded_django') || &cp || version < 700
    finish
endif

let b:_loaded_django = 1


nmap <buffer> <F10> :setl makeprg=python\ manage.py\ test\| call utils#make()<CR>
