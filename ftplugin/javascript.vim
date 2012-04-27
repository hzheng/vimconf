" Javascript-specific vimscript

if exists('b:_loaded_javascript') || &cp || version < 700
    finish
endif

let b:_loaded_javascript = 1

" Debug {
    " JavaScript Lint
    call utils#mapDebugger('S-F3', 'jsl', 
                \'-nologo -nofilelisting -nosummary -nocontext -process',
                \'%f(%l): %m')

    " JsLint
    if executable('npm') " assume V8-version(installed by npm)
        call utils#mapDebugger('S-F4', 'jslint', '',
                    \'%-G,
                    \%-P%f,
                    \%E\ %#\#%n\ %m,
                    \%C%.%#//\ Line\ %l\,\ Pos\ %c,
                    \%-G%.%#\ is\ OK.')
    else " assume SpiderMoney-version which accept input from stdin
        call utils#mapDebugger('S-F4', 'jslint', '', 
                    \'Lint\ at\ line\ %l\ character\ %c: %m, %-G%.%#', 1)
    endif
" }
