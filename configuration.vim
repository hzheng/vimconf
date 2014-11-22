" Configuration file

" define variables according to environment variable VIM
if match($VIM, 'MacVim.*vim$') > 0
    "echomsg 'MacVim'
    "let g:DEFAULT_FULLSCREEN = 1
elseif match($VIM, 'Vim.app.*vim$') > 0
    "echomsg 'lightweight Vim in Mac'
    let g:LOAD_PLUGIN = 0
elseif match($VIM, '/vim$') > 0
    "echomsg 'vim in command line or *nix'
elseif match($VIM, '\\Vim$') > 0
    "echomsg 'Vim in Windows'
endif
