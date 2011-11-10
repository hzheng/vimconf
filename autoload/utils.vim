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
        let g:CTAGS = '/usr/local/bin/ctags'
        let g:TAG_DIR = '~/tags'

        call s:loadPlugins()
    endfun
        
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
    endfun

    fun! utils#enabledPlugin(plugin)
        return globpath(g:BUNDLE_PATH, a:plugin) != '' && index(g:pathogen_disabled, a:plugin) < 0
    endfun
    
    fun! utils#disablePlugins(...)
        for plugin in a:000
            call add(g:pathogen_disabled, plugin)
        endfor
    endfun

    " load disabled plugin manually
    fun! utils#loadPlugin(plugin)
        let index = 0
        let found = 0
        while index < len(g:pathogen_disabled)
            if g:pathogen_disabled[index] == a:plugin
                call remove(g:pathogen_disabled, index)
                let found = 1
                break
            endif
            let index = index + 1
        endwhile
 
        if !found | return 0 | endif

        let dir = g:BUNDLE_PATH . "/" . a:plugin
        if !isdirectory(dir) | return 0 | endif

        " TODO: not foolproof, probably need improvement
        exe 'set rtp^=' . fnameescape(dir)
        let afterDir = dir . '/after'
        if isdirectory(afterDir)
            exe 'set rtp+=' . fnameescape(afterDir)
        endif
        let pluginSrc = globpath(dir, '**/*.vim')
        for src in split(pluginSrc, '\n')
            if src =~ "/autoload/.*\.vim$"
                " skip vim scripts under autoload directory
            else
                exe "so " . src 
            endif
        endfor
        return 1
    endfun
" }

" File {
    " filetype initialization
    fun! utils#FileTypeInit()
        let filename = fnameescape(expand("%"))
        " load extra script
        if s:isProgram()
            exe "so ". g:FTPLUGIN . "/program.vim"
            " set tag file
            exe "set tags=" . g:TAG_DIR . "/" . &filetype
        endif

        if !strlen(filename)  " stdin
            "exe "normal! iempty filename"
        elseif filereadable(filename)
            "exe "normal! i FileTypeInit old:" bufname("%") &filetype 
        elseif &modifiable && &buftype == ""
            " load template for new modifiable normal file
            "au BufNewFile * silent! 0r ~/.vim/templates/%:e | norm G
            "exe "silent! 0r ~/.vim/templates/".&filetype
            call utils#ExpandBuffer(fnameescape(g:TEMPLATES . "/" . &filetype))
            normal! G
        endif
    endfun

    " Reads a file with the variables resolved and writes into buffer
    fun! utils#ExpandBuffer(file)
        if !filereadable(a:file)
            return
        endif

        exe "0r " a:file
        for linenum in range(1, line('$'))
            let line = getline(linenum)
            if line =~ '\$'
                call setline(linenum, expand(line))
            endif
        endfor
    endfun

    fun! s:isProgram()
        " TODO: need improvement
        "return &filetype =~ '^\(c\|cpp\|java\|cs\|objc\|python\|ruby\|perl\|php\|javascript\|vim\|sh\|lisp\|prolog\)$'
        return &filetype !~ '^\(text\|pdf\|zip\|tar\)$'
    endfun

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
        au BufWinEnter quickfix let g:quickfixWin = bufnr("$") | set number
        au BufWinLeave * if exists("g:quickfixWin") && expand("<abuf>") == g:quickfixWin | unlet! g:quickfixWin | endif
    augroup END
" }

" Format {
    fun! utils#ToggleColorColumn()
        if !exists("&colorcolumn")
            return
        endif

        if &colorcolumn == ""
            set colorcolumn=+1
        else
            set colorcolumn=
        endif
    endfun

    fun! utils#ToggleNumber()
        if exists("&relativenumber")
            if &relativenumber
                set number
            elseif &number
                set nonumber
            else
                set relativenumber
            endif
        else
            set number!
        endif
    endfun

    fun! utils#InsertStatuslineColor(mode)
        if a:mode == 'i'
            hi statusline guibg=magenta
        elseif a:mode == 'r'
            hi statusline guibg=blue
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
            exe "normal! i       " date[0]."年".date[1]."月".day
            exe 'normal! o'
        endif
    endfun
" }
