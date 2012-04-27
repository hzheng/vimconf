" CSS-specific vimscript

if exists('b:_loaded_css') || &cp || version < 700
    finish
endif

let b:_loaded_css = 1


" Debug {
    if executable('csslint')
        set efm=%f:\ line\ %l\\,\ col\ \%c\\,\ %m
        set makeprg=csslint\ --format=compact\ %
    endif
" }
