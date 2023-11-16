source ~/.vimrc_bepo

noremap gr :grep <cword> *<CR>
noremap gR :grep <cword> %<CR><CR>:copen<CR>
highlight NbSp ctermbg=lightgray guibg=lightred

vmap <C-c> "+y

if &shell =~# 'fish$'
    set shell=sh
endif

"set number
"syntax on
"set shiftwidth=4
"set tabstop=4
"set autoindent
"set expandtab
"set softtabstop=4
"set encoding=utf-8
"set fileencoding=utf-8
"
"" colorise les nbsp
"highlight NbSp ctermbg=lightgray guibg=lightred
"match NbSp /\%xa0/
"
"call plug#begin()
"Plug 'preservim/NERDTree'
"Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
"call plug#end()
