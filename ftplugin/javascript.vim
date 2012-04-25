" Javascript-specific vimscript

if exists('b:_loaded_javascript') || &cp || version < 700
    finish
endif

let b:_loaded_javascript = 1

call utils#mapDebugger('S-F3', 'jsl', 
            \'-nologo -nofilelisting -nosummary -nocontext -process',
            \'%f(%l): %m')
call utils#mapDebugger('S-F4', 'jslint', '', 
            \'%+Gmsg,Lint\ at\ line\ %l\ character\ %c: %m, %-G%.%#', 1)
