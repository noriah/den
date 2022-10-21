" filetype syntax settings
autocmd FileType zsh setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" i3Config based on directory
autocmd BufRead,BufNewFile */i3/* set syntax=i3config

