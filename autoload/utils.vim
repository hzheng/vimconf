" Vim helper

" Environment {
    " the following MUST be put outside the init function due to sfile
    let g:VIMFILES = expand('<sfile>:p:h:h')

    " TODO: support configuration file
    fun! utils#init(conf)
        let g:VIMCONF = a:conf
        let g:FTPLUGIN = g:VIMFILES . "/ftplugin"
        let g:TEMPLATES = g:VIMFILES . "/templates"
        let g:VIMTMP = g:VIMFILES . "/tmp"
        let g:SESSIONS = g:VIMTMP . "/session"

        let g:QUICKFIX_HEIGHT = 20

        call s:loadPlugins()
    endfun
" }
        
" Plugin {
    " NOTE: after adding a new plugin, remember to manually execute :Helptags<CR>
    " TODO: support configuration file to customize plugins
    fun! s:loadPlugins()
        let g:BUNDLE_DIR = "bundle"
        let g:BUNDLE_PATH = g:VIMFILES . "/" . g:BUNDLE_DIR
        " manually(instead auto) load pathogen for sake of git submodule
        exe "runtime " . g:BUNDLE_DIR . "/pathogen/autoload/pathogen.vim"

        let g:pathogen_disabled = []

        " temporarily disable some program- or filetype- specific plugins, 
        " which will be loaded in program.vim or <filetype>.vim under ftplugin
        " program-specific plugins
        call utils#disablePlugins('nerdcommenter', 'taglist', 'tagbar', 'autoclose')
        " python-specific plugins
        call utils#disablePlugins('pydiction', 'pep8')
        " rst-specific plugins
        call utils#disablePlugins('vst')

        if !has("python")
            " disable plugin that needs python 
            call utils#disablePlugins('pyflakes', 'ropevim', 'gundo')
        endif
        if has("ruby")
            call utils#disablePlugins('fuzzyfinder', 'l9') " command-t is enough
        else
            " disable plugin that needs ruby 
            call utils#disablePlugins('command-t')
        endif
        if !executable("ack")
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
        if !isdirectory(g:BUNDLE_PATH . "/" . a:plugin)
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
            echomsg "WARNING: try to load an undelayed plugin: " . a:plugin
            return -1
        endif

        if !has_key(s:delayedPlugins, a:plugin)
            let s:delayedPlugins[a:plugin] = 1
        else " loaded before
            if a:0 == 0 || a:1 == 0
                "echomsg "INFO: skipped an already-loaded plugin: " a:plugin
                return 0
            else
                "echomsg "INFO: reload an already-loaded plugin: " a:plugin
            endif
        endif

        " TODO: not foolproof, probably need improvement
        let dir = g:BUNDLE_PATH . "/" . a:plugin
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
        let pluginSrc = globpath(a:dir, 'plugin/**/*.vim')
        for src in split(pluginSrc, '\n')
            "echomsg 'running ' . src
            exe "so " . src 
        endfor
    endfun
" }

" File {
    fun! GetSessionDir()
        return fnameescape(g:SESSIONS . getcwd())
    endfun

    fun! GetSessionFile()
        return GetSessionDir() . "/session.vim"
    endfun

    fun! utils#SaveSession()
        let sessiondir = GetSessionDir()
        if (filewritable(sessiondir) != 2)
            exe "silent !mkdir -p " sessiondir
            redraw!
        endif
        exe "mksession! " GetSessionFile()
    endfun

    fun! utils#UpdateSession()
        let sessionfile = GetSessionFile()
        if (filereadable(sessionfile))
            exe "mksession! " . sessionfile
            echo "updating session"
        endif
    endfun

    fun! utils#LoadSession()
        if argc() == 0
            let sessionfile = GetSessionFile()
            if (filereadable(sessionfile))
                exe "so" sessionfile
            else
                echo "No session loaded."
            endif
        endif
    endfun

    fun! utils#GetUrl()
        let target = expand('<cfile>')
        if target == ""
            return ""
        endif

        if matchstr(target, '[a-z]*:\/\/[^ ]*') != ""
            return target
        endif

        let target = expand(target)
        if filereadable(target) || isdirectory(target)
            return target
        else " take it as a http site
            return "http://".target
        endif
    endfun

    fun! utils#OpenUrl()
        let url = utils#GetUrl()
        if url == ""
            echo "empty target"
            return
        endif
        
        " mac
        "echo url
        exe "!open ".url
    endfun
" }

" Window {
    " toggles the quickfix window.
    fun! utils#ToggleQuickfix(forced)
        if exists("g:quickfixWin") && a:forced == 0
            cclose
        else
            exe "copen " . g:QUICKFIX_HEIGHT
        endif
    endfun

    " track the quickfix window
    augroup QuickFix
        au!
        au BufWinEnter quickfix let g:quickfixWin = bufnr("$")
        au BufWinLeave * if exists("g:quickfixWin") && expand("<abuf>") == g:quickfixWin | unlet! g:quickfixWin | endif
    augroup END
" }

" Format {
    fun! utils#ToggleColorColumn()
        if !exists("&colorcolumn")
            return
        endif

        if &colorcolumn == ""
            setl colorcolumn=+1
        else
            setl colorcolumn=
        endif
    endfun

    fun! utils#ToggleNumber()
        if exists("&relativenumber")
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

    fun! utils#InsertStatuslineColor(mode)
        if a:mode == 'i'
            hi statusline guibg=magenta
        elseif a:mode == 'r'
            hi statusline guibg=green
        else
            hi statusline guibg=red
        endif
    endfun

    fun! utils#TabLine()
        let res = ''
        let curtab = tabpagenr()
        let i = 0

        if has('win32')
            let pat = '.\+\\'
        else
            let pat = '.\+/'
        endif

        for i in range(1, tabpagenr('$'))
            let res .= ((i == curtab) ? '%#TabLineSel#' : '%#TabLine#')
            let res .= ' '
            let res .= substitute(bufname(tabpagebuflist(i)[0]), pat, '', 'g')
            let res .= ' '
            let i += 1
        endfor

        let res .= '%#TabLineFill#'
        return res
    endfun

    fun! utils#GuiTabLabel()
        let label = ''
        let bufnrlist = tabpagebuflist(v:lnum)
        " Add '+' if one of the buffers in the tab page is modified
        for bufnr in bufnrlist
            if getbufvar(bufnr, "&modified")
                let label .= '+'
                break
            endif
        endfor
        " Append the tab number
        let label .= v:lnum . ': '
        " Append the buffer name
        let name = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
        if name == ''
            " give a name to no-name documents
            if &buftype == 'quickfix'
                let name = '[Quickfix List]'
            else
                let name = '[No Name]'
            endif
        else
            " get only the file name
            let name = fnamemodify(name, ":t")
        endif
        let label .= name
        " Append the number of windows in the tab page if more than 1
        let wincount = tabpagewinnr(v:lnum, '$')
        if wincount > 1
            let label .= " [" . wincount . "]"
        endif
        return label
    endfun

    fun! utils#GuiTabToolTip()
        let tip = ''
        for bufnr in tabpagebuflist(v:lnum)
            " separate buffer entries
            if tip != ''
                let tip .= " \n "
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
            if getbufvar(bufnr, "&modified")
                let tip .= ' [+]'
            endif
            if getbufvar(bufnr, "&modifiable") == 0
                let tip .= ' [-]'
            endif
        endfor
        return tip
    endfun
" }

" Calendar {
    fun! utils#CalInit()
        exe "read ". g:TEMPLATES . "/diary"
        call InsertChineseDate()
    endfun

    fun! InsertChineseDate()
        exe 'normal! ggdd'
        let path = split(expand("%"), "/")
        if len(path) > 3
            let date = path[len(path) - 3 :]
            let day = substitute(date[2], ".cal", "日", "g")
            exe "norm! i       " date[0]."年".date[1]."月".day
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
        exe "make " . makeArgs
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
            let errMsg = substitute(errMsg, '^ *', '', 'g') " strip leading spaces
            ""silent cc!
            "exec ":sbuffer " . error['bufnr']
            call s:showBar(errMsg) 
        endif
    endfun

    fun! s:showBar(msg)
        let msg = a:msg
        if msg == ''
            let msg = 'OK'
            hi GreenBar term=reverse ctermfg=white ctermbg=green guifg=white guibg=green
            echohl GreenBar
        else
            hi RedBar   term=reverse ctermfg=white ctermbg=red guifg=white guibg=red
            echohl RedBar
        endif
        echon msg repeat(' ', &columns - strlen(msg) - 1)
        echohl None
    endfun
" }
