set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc


" Plugins List
call plug#begin()
    " UI related
    Plug 'chriskempson/base16-vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " Better Visual Guide
    Plug 'Yggdroot/indentLine'
    " syntax check
    Plug 'w0rp/ale'
"    " Autocomplete: ncm2
"    Plug 'ncm2/ncm2'
"    Plug 'roxma/nvim-yarp'
"    Plug 'ncm2/ncm2-bufword'
"    Plug 'ncm2/ncm2-path'
"    Plug 'ncm2/ncm2-jedi'
    " Autocomplete: deoplete
    if has('nvim')
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
    let g:deoplete#enable_at_startup = 1

    " Snippets
    " Track the engine.
    Plug 'SirVer/ultisnips'
    " Snippets are separated from the engine. Add this if you want them:
    Plug 'honza/vim-snippets'
    " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<c-b>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"
    " If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsEditSplit="vertical"

    " Formater
    Plug 'Chiel92/vim-autoformat'

    " --------- adding the following three plugins for Latex ---------
    Plug 'lervag/vimtex'
    "Plug 'Konfekt/FastFold'
    Plug 'matze/vim-tex-fold'
    " Formater
    Plug 'Chiel92/vim-autoformat'

    Plug 'arcticicestudio/nord-vim'
    Plug 'preservim/nerdtree'
    Plug 'khaveesh/vim-fish-syntax'
    Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
call plug#end()

" This is new style
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'tex': g:vimtex#re#deoplete
      \})

let g:tex_flavor  = 'latex'
let g:tex_conceal = ''
let g:vimtex_fold_manual = 1
let g:vimtex_latexmk_continuous = 1
let g:vimtex_compiler_progname = 'nvr'
" use SumatraPDF if you are on Windows
let g:vimtex_view_method = 'skim'


" Configurations Part
" UI configuration
syntax on
syntax enable
" colorscheme
let base16colorspace=256
colorscheme nord
set background=dark
" True Color Support if it's avaiable in terminal
if has("termguicolors")
    set termguicolors
endif
if has("gui_running")
  set guicursor=n-v-c-sm:block,i-ci-ve:block,r-cr-o:blocks
endif
set number
set relativenumber
set hidden
set mouse=a
set noshowmode
set noshowmatch
set nolazyredraw
" Turn off backup
"set nobackup
"set noswapfile
"set nowritebackup
" Search configuration
set ignorecase                    " ignore case when searching
set smartcase                     " turn on smartcase
" Tab and Indent configuration
set expandtab
set tabstop=4
set shiftwidth=4
" cycle through completion list with tab/shift+tab
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <s-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
" vim-autoformat
noremap <F3> :Autoformat<CR>
"" NCM2
"augroup NCM2
"  autocmd!
"  " enable ncm2 for all buffers
"  autocmd BufEnter * call ncm2#enable_for_buffer()
"  " :help Ncm2PopupOpen for more information
"  set completeopt=noinsert,menuone,noselect
"  " When the <Enter> key is pressed while the popup menu is visible, it only
"  " hides the menu. Use this mapping to close the menu and also start a new line.
"  inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
"  autocmd Filetype tex call ncm2#register_source({
"            \ 'name': 'vimtex',
"            \ 'priority': 8,
"            \ 'scope': ['tex'],
"            \ 'mark': 'tex',
"            \ 'word_pattern': '\w+',
"            \ 'complete_pattern': g:vimtex#re#ncm2,
"            \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
"            \ })
"augroup END
" Ale
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {'python': ['flake8']}
" Airline
let g:airline_left_sep  = ''
let g:airline_right_sep = ''
let g:airline#extensions#ale#enabled = 1
let airline#extensions#ale#error_symbol = 'E:'
let airline#extensions#ale#warning_symbol = 'W:'
hi Normal guibg=NONE ctermbg=NONE


" NERDTree bépo re-mapping
let g:NERDTreeMapJumpLastChild = "T"
let g:NERDTreeMapJumpFirstChild = "S"
let g:NERDTreeMapOpenInTab = "j"
let g:NERDTreeMapOpenInTabSilent = "J"
let g:NERDTreeMapOpenVSplit = "k"
let g:NERDTreeMapChangeRoot = "L"
let g:NERDTreeMapRefresh = "h"
let g:NERDTreeMapRefreshRoot = "H"


" Settings for Firenvim (nvim editing in Firefox)
if exists('g:started_by_firenvim')
    highlight Normal guibg=#2e3440
    set guifont=monospace:h10
endif
