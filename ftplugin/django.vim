" Django-specific vimscript

if exists("b:_loaded_django_vim")
    finish
endif

let b:_loaded_django_vim = 1

nmap <buffer> <F10> :set makeprg=python\ manage.py\ test\| call utils#make()<CR>
