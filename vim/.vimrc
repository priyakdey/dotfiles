""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                    __      _______ __  __    _____ ____  _   _ ______ _____ _____                                "
"                    \ \    / /_   _|  \/  |  / ____/ __ \| \ | |  ____|_   _/ ____|                               "
"                     \ \  / /  | | | \  / | | |   | |  | |  \| | |__    | || |  __ 				               "
"                      \ \/ /   | | | |\/| | | |   | |  | | . ` |  __|   | || | |_ |				               "
"                       \  /   _| |_| |  | | | |___| |__| | |\  | |     _| || |__| |				               "
"                        \/   |_____|_|  |_|  \_____\____/|_| \_|_|    |_____\_____|				               "
"                                                               						                           "               
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"														                                                           "
"  This art work is generated using http://patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something%20   "
"														                                                           "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin settings
set nocompatible                                            " required
filetype off                                                " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/plugins')                         " Install all plugins in the given path

" All plugins go here
Plugin 'gmarik/Vundle.vim'                                  " let Vundle manage Vundle, required
Plugin 'vim-airline/vim-airline'                            " plugin for status line
Plugin 'morhetz/gruvbox'                                    " gruvbox theme
Plugin 'godlygeek/tabular'                                  " for markdown: https://github.com/preservim/vim-markdown
Plugin 'preservim/vim-markdown'

call vundle#end()

filetype plugin on
filetype plugin indent on                                   " required


" basic settings
syntax on

set encoding=utf-8
set noerrorbells
set number
set relativenumber
set smartcase
set tabstop=8
set softtabstop=0
set shiftwidth=4
set nowrap
set noswapfile
set nobackup
set nobackup
set cmdheight=2
set updatetime=2
set splitbelow                                              " split below -    :sp filename
set splitright                                              " split on right - :vs filename
set mouse=a
set smartindent
set incsearch
set expandtab
set smarttab

" color themes
set termguicolors
set background=dark
colorscheme gruvbox

set colorcolumn=80
" https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
highlight ColorColumn ctermbg=0 guifg=#000000
highlight EndOfBuffer ctermbg=black ctermfg=black

" cursor configuration
autocmd InsertEnter,InsertLeave * set cul!


" ============================================================================ "
" ===                           KEY BINDINGS                               === "
" ============================================================================ "
" Mapping Control as Leader Key
let g:mapleader='<CMD>'

" vim split window navigations
nnoremap <M-J> <C-W><C-J>
nnoremap <M-K> <C-W><C-K>
nnoremap <M-H> <C-W><C-H>
nnoremap <M-L> <C-W><C-L>

nnoremap <M-Down> <C-W><C-J>
nnoremap <M-Up> <C-W><C-K>
nnoremap <M-Left> <C-W><C-H>
nnoremap <M-Right> <C-W><C-L>

" Lets you copy selected text in clipboard
vmap <C-c> "+y

" ============================================================================ "
" ===                      PLUGIN CONFIGURATIONS                           === "
" ============================================================================ "
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_y = 'BN: %{bufnr("%")}'
