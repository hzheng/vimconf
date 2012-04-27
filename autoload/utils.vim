" Vim helper

" Environment {
    " the following MUST be put outside the init function due to sfile
    let g:VIMFILES = escape(expand('<sfile>:p:h:h'), ' ')

    fun! utils#init(conf)
        " directories
        let g:VIMCONF = a:conf
        let g:FTPLUGIN = g:VIMFILES . '/ftplugin'
        let g:TEMPLATES = g:VIMFILES . '/templates'
        let g:VIMTMP = expand($VIM_TMPDIR)
        if g:VIMTMP == ''  " just in case
            let g:VIMTMP = g:VIMFILES . '/tmp'
        endif

        " UI
        let g:QUICKFIX_HEIGHT = 20

        " plugin
        let g:LOAD_PLUGIN = 1
        let g:BUNDLE_DIR = 'bundle'

        " virtual printer's name
        let g:VIRTUAL_PRINTER = 'CUPS_PDF' 
        " virtual printer's output directory
        let g:PRINT_OUTPUT = expand('~/cups-pdf') 

        " load configuration file(may override the above variables)
        let g:CONF_FILE = g:VIMFILES . '/configuration.vim'
        exe 'so ' . g:CONF_FILE 

        if !isdirectory(g:VIMTMP)
            echoerr("g:VIMTMP's value(" . g:VIMTMP . ") is not a directory. "
                        \ . "Please set it in " . g:CONF_FILE
                        \ . " or set environment variable VIM_TMPDIR")
        endif
        let g:SESSIONS = g:VIMTMP . '/session'

        if g:LOAD_PLUGIN
            call s:loadPlugins()
        endif
    endfun
" }
        
" Plugin {
    " NOTE: after adding a new plugin, remember to execute :Helptags<CR>
    " TODO: support configuration file to customize plugins
    fun! s:loadPlugins()
        let g:BUNDLE_PATH = g:VIMFILES . '/' . g:BUNDLE_DIR

        " manually(instead auto) load pathogen for sake of git submodule
        exe 'runtime ' . g:BUNDLE_DIR . '/pathogen/autoload/pathogen.vim'

        let g:pathogen_disabled = []

        " temporarily disable some program- or filetype- specific plugins, 
        " which will be loaded in program.vim or <filetype>.vim under ftplugin
        " program-specific plugins
        call utils#disablePlugins('nerdcommenter', 'taglist',
                                  \ 'tagbar', 'autoclose')
        " python-specific plugins
        call utils#disablePlugins('pydiction', 'pep8')
        " rst-specific plugins
        call utils#disablePlugins('vst')
        " tex-specific plugins
        call utils#disablePlugins('vim-latex')

        if !has('python')
            " disable plugin that needs python 
            call utils#disablePlugins('pyflakes', 'ropevim', 'gundo')
        endif
        if has('ruby')
            " command-t should be enough
            call utils#disablePlugins('fuzzyfinder', 'l9')
        else
            " disable plugin that needs ruby 
            call utils#disablePlugins('command-t')
        endif
        if !executable('ack')
            call utils#disablePlugins('ack')
        endif

        " generate plugins path
        call pathogen#infect(g:BUNDLE_DIR)
        let s:delayedPlugins = {}
    endfun

    " Return plugin enabled status
    " -1 means nonexistent or permanently disabled
    "  0 means temporarily disabled(will be loaded later)
    "  1 means enabled
    fun! utils#enabledPlugin(plugin)
        if !exists('g:BUNDLE_PATH')
            return -2
        elseif !isdirectory(g:BUNDLE_PATH . '/' . a:plugin)
            return -1 " TODO: add disabled by configuration
        elseif index(g:pathogen_disabled, a:plugin) >= 0
            return 0
        else
            return 1
        endif
    endfun
    
    fun! utils#disablePlugins(...)
        for plugin in a:000
            call add(g:pathogen_disabled, plugin)
        endfor
    endfun

    " load temporarily disabled plugin manually
    " if the second argument is nonzero, reload even if it's loaded before
    " (this seems necessary at least for those scripts that define some 
    " buffer-scope mappings)
    fun! utils#loadPlugin(plugin, ...)
        if utils#enabledPlugin(a:plugin) != 0
            echomsg 'WARNING: try to load an undelayed plugin: ' . a:plugin
            return -1
        endif

        if !has_key(s:delayedPlugins, a:plugin)
            let s:delayedPlugins[a:plugin] = 1
        else " loaded before
            if a:0 == 0 || a:1 == 0
                "echomsg 'INFO: skipped an already-loaded plugin: ' a:plugin
                return 0
            else
                "echomsg 'INFO: reload an already-loaded plugin: ' a:plugin
            endif
        endif

        " TODO: not foolproof, probably need improvement
        let dir = g:BUNDLE_PATH . '/' . a:plugin
        exe 'set rtp^=' . fnameescape(dir)
        call s:doLoadPlugin(dir)

        let afterDir = dir . '/after'
        if isdirectory(afterDir)
            exe 'set rtp+=' . fnameescape(afterDir)
            call s:doLoadPlugin(afterDir)
        endif
        return 1
    endfun

    fun! s:doLoadPlugin(dir)
        call s:loadPath(globpath(a:dir, 'plugin/**/*.vim'))
        if &ft != ''
            call s:loadPath(globpath(a:dir, 'ftplugin/' . &ft . '/*.vim'))
            call s:loadPath(globpath(a:dir, 'ftplugin/' . &ft . '_*.vim'))
        endif
    endfun

    fun! s:loadPath(path)
        for src in split(a:path, '\n')
            "echomsg 'loading ' . src
            exe 'so ' . src 
        endfor
    endfun
" }

" File {
    fun! s:getSessionDir()
        return fnameescape(g:SESSIONS . getcwd())
    endfun

    fun! s:getSessionFile()
        return s:getSessionDir() . '/session.vim'
    endfun

    fun! utils#saveSession()
        let sessiondir = s:getSessionDir()
        if (filewritable(sessiondir) != 2)
            exe 'silent !mkdir -p ' sessiondir
            redraw!
        endif
        exe 'mksession! ' s:getSessionFile()
    endfun

    fun! utils#updateSession()
        let sessionfile = s:getSessionFile()
        if (filereadable(sessionfile))
            exe 'mksession! ' . sessionfile
            echo 'updating session'
        endif
    endfun

    fun! utils#loadSession()
        if argc() == 0
            let sessionfile = s:getSessionFile()
            if (filereadable(sessionfile))
                exe 'so' sessionfile
            else
                echo 'No session loaded.'
            endif
        endif
    endfun

    fun! utils#getUrl()
        let target = expand('<cfile>')
        if target == ''
            return ''
        endif

        if matchstr(target, '[a-z]*:\/\/[^ ]*') != ''
            return target
        endif

        let target = expand(target)
        if filereadable(target) || isdirectory(target)
            return target
        else " take it as a http site
            return 'http://' . target
        endif
    endfun

    fun! utils#openUrl()
        let url = utils#getUrl()
        if url == ''
            echo 'empty target'
            return
        endif
        
        " mac
        "echo url
        exe '!open '. url
    endfun
" }

" Window {
    " toggles the quickfix window.
    fun! utils#toggleQuickfix(forced)
        if exists('g:quickfixWin') && a:forced == 0
            cclose
        else
            exe 'copen ' . g:QUICKFIX_HEIGHT
        endif
    endfun

    " track the quickfix window
    augroup QuickFix
        au!
        au BufWinEnter quickfix let g:quickfixWin = bufnr('$')
        au BufWinLeave * if exists('g:quickfixWin')
                         \ && expand('<abuf>') == g:quickfixWin
                         \ | unlet! g:quickfixWin | endif
    augroup END
" }

" Format {
    fun! utils#toggleColorColumn()
        if !exists('&colorcolumn')
            return
        endif

        if &colorcolumn == ''
            setl colorcolumn=+1
        else
            setl colorcolumn=
        endif
    endfun

    fun! utils#toggleNumber()
        if exists('&relativenumber')
            if &relativenumber
                setl number
            elseif &number
                setl nonumber
            else
                setl relativenumber
            endif
        else
            setl number!
        endif
    endfun

    fun! utils#insertStatuslineColor(mode)
        if a:mode == 'i'
            hi statusline guibg=magenta
        elseif a:mode == 'r'
            hi statusline guibg=green
        else
            hi statusline guibg=red
        endif
    endfun

    fun! utils#tabLine()
        let label = ''
        let curtab = tabpagenr()
        let i = 0

        for i in range(1, tabpagenr('$'))
            let label .= ((i == curtab) ? '%#TabLineSel#' : '%#TabLine#')
            let label .= s:composeTabLabel(i)
            let label .= ' '
            let i += 1
        endfor

        let label .= '%#TabLineFill#'
        return label
    endfun

    fun! utils#guiTabLabel()
        return s:composeTabLabel(v:lnum)
    endfun

    fun! s:composeTabLabel(cur)
        let label = ''
        " add '+' if one of the buffers in the tab page is modified
        let bufs = tabpagebuflist(a:cur)
        for buf in bufs
            if getbufvar(buf, '&modified')
                let label .= '+'
                break
            endif
        endfor
        " append the tab number
        let label .= a:cur . ': '
        " append the buffer name
        let name = bufname(bufs[tabpagewinnr(a:cur) - 1])
        if name == ''
            " give a name to no-name documents
            if &buftype == 'quickfix'
                let name = '[Quickfix List]'
            else
                let name = '[No Name]'
            endif
        else
            " get only the file name
            let name = fnamemodify(name, ':t')
        endif
        let label .= name
        " append the number of windows in the tab page if more than 1
        let wincount = tabpagewinnr(a:cur, '$')
        if wincount > 1
            let label .= ' [' . wincount . ']'
        endif
        return label
    endfun

    fun! utils#guiTabToolTip()
        let tip = ''
        for bufnr in tabpagebuflist(v:lnum)
            " separate buffer entries
            if tip != ''
                let tip .= ' \n '
            endif
            " Add name of buffer
            let name = bufname(bufnr)
            if name == ''
                " give a name to no name documents
                if getbufvar(bufnr, '&buftype') == 'quickfix'
                    let name = '[Quickfix List]'
                else
                    let name = '[No Name]'
                endif
            endif
            let tip .= name
            " add modified/modifiable flags
            if getbufvar(bufnr, '&modified')
                let tip .= ' [+]'
            endif
            if getbufvar(bufnr, '&modifiable') == 0
                let tip .= ' [-]'
            endif
        endfor
        return tip
    endfun
" }

" Calendar {
    fun! utils#calInit()
        exe 'read '. g:TEMPLATES . '/diary'
        call s:insertChineseDate()
    endfun

    fun! s:insertChineseDate()
        exe 'norm! ggdd'
        let path = split(expand('%'), '/')
        if len(path) > 3
            let date = path[len(path) - 3 :]
            let day = substitute(date[2], '.cal', '日', 'g')
            exe 'norm! i       ' date[0] . '年' . date[1] . '月' . day
            exe 'norm! o'
        endif
    endfun
" }

" Compile/Debug {
    fun! utils#make(...)
        if a:0 
            let makeArgs = a:1
        else
            let makeArgs = ''
        endif

        silent! w " save first
        exe 'make ' . makeArgs
        redraw!
        call s:showError()
    endfun

    fun! s:showError()
        let errMsg = ''
        for error in getqflist()
            if error['valid']
                let errMsg = error['text']
                break " only show the first error
            endif
        endfor
        if errMsg == ''
            call s:showBar('') 
        else
            " strip leading spaces
            let errMsg = substitute(errMsg, '^ *', '', 'g')
            "silent cc!
            "exec ':sbuffer ' . error['bufnr']
            call s:showBar(errMsg) 
        endif
    endfun

    fun! s:showBar(msg)
        let msg = a:msg
        if msg == ''
            let msg = 'OK'
            hi GreenBar term=reverse ctermfg=white ctermbg=green
                        \ guifg=white guibg=green
            echohl GreenBar
        else
            hi RedBar term=reverse ctermfg=white ctermbg=red
                        \ guifg=white guibg=red
            echohl RedBar
        endif
        echon msg repeat(' ', &columns - strlen(msg) - 1)
        echohl None
    endfun

    fun! utils#debugGrep(debugCmd, errorFmt, redirect)
        set lazyredraw
        " Close any existing cwindows.
        cclose
        let l:grepformat_save = &grepformat
        let l:grepprogram_save = &grepprg
        "set grepformat&vim
        set grepformat&vim
        let &grepformat = a:errorFmt
        let &grepprg = a:debugCmd
        if &readonly == 0 | update | endif
        if a:redirect
            silent! grep! < %
        else
            silent! grep! %
        endif
        let &grepformat = l:grepformat_save
        let &grepprg = l:grepprogram_save
        let l:mod_total = 0
        let l:win_count = 1
        " Determine correct window height
        windo let l:win_count = l:win_count + 1
        if l:win_count <= 2 | let l:win_count = 4 | endif
        windo let l:mod_total = l:mod_total + winheight(0)/l:win_count |
                    \ exe 'resize +'.l:mod_total
        " Open cwindow
        exe 'belowright copen '.l:mod_total
        nnoremap <buffer> <silent> c :cclose<CR>
        set nolazyredraw
        redraw!
    endfun

    fun! utils#mapDebugger(key, debugger, args, errorFmt, ...)
        if !executable(a:debugger)
            echomsg 'Cannot find ' . a:debugger
            return -1
        endif
        if (maparg(a:key) != '')
            echomsg 'Key ' . a:key .  ' has already been mapped'
            return -1
        endif
        let l:map="<buffer><" . a:key . "> :call utils#debugGrep('"
                    \. a:debugger . " " . a:args . "', '" 
                    \. a:errorFmt . "'," . a:0 . ")<CR>"
        exe 'map ' . l:map
        exe 'map! ' . l:map
    endfun
" }

" File manipulation {
    fun! utils#savePdf()
        " print to virtual printer
        exe 'silent !cat %  | lp -s -d ' . g:VIRTUAL_PRINTER
        " wait until printing is finished
        exe 'silent !until [ ' . g:PRINT_OUTPUT . ' -nt % ];do sleep 1;done'
        "echomsg 'finished printing'
        redir => printed
        " find the latest modified one
        exe 'silent! !ls -t ' . g:PRINT_OUTPUT . '/*pdf | head -n 1'
        redir END
        let saved = ''
        " strip the first line(command itself) and \r
        "let saved = split(printed, '\r\n')[1]
        for line in split(printed, '\r\n')
            if matchstr(line, ':!') == ''
                let saved = line
                break
            endif
        endfor
        if saved == '' " works only in GVim?
            echoerr 'cannot find printed file'
            return 1
        endif

        " XXX: have to sleep 2 seconds? (even 1 sec does NOT work?)
        exe 'silent !sleep 2 && mv -f ' . saved . ' %'
    endfun
" }
