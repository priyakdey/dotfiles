""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                    __      _______ __  __    _____ ____  _   _ ______ _____ _____                                "
"                    \ \    / /_   _|  \/  |  / ____/ __ \| \ | |  ____|_   _/ ____|                               "
"                     \ \  / /  | | | \  / | | |   | |  | |  \| | |__    | || |  __ 				   "
"                      \ \/ /   | | | |\/| | | |   | |  | | . ` |  __|   | || | |_ |				   "
"                       \  /   _| |_| |  | | | |___| |__| | |\  | |     _| || |__| |				   "
"                        \/   |_____|_|  |_|  \_____\____/|_| \_|_|    |_____\_____|				   "
"                                                               						   " 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"														   "
"  This art work is generated using http://patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something%20   "
"														   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin settings
set nocompatible                                            " required
filetype off                                                " required


" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/plugins')                         " Install all plugins in the passed path

" All plugins go here
Plugin 'gmarik/Vundle.vim'                                  " let Vundle manage Vundle, required
Plugin 'Valloric/YouCompleteMe'                             " python auto complete
Plugin 'fatih/vim-go'                                       " plugin for golang
Plugin 'vim-airline/vim-airline'                            " plugin for status line
Plugin 'scrooloose/nerdtree'                                " for a bootiful file tree
Plugin 'morhetz/gruvbox'                                    " gruvbox theme
Plugin 'pangloss/vim-javascript'                            " JS support
Plugin 'leafgarland/typescript-vim'                         " TS support
Plugin 'maxmellon/vim-jsx-pretty'                           " JSX support
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }       " FZF search
Plugin 'junegunn/fzf.vim'                                   " FZF search
Plugin 'skanehira/preview-markdown.vim'

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
let g:mapleader='<CR>'


" vim split window navigations
nnoremap <M-J> <C-W><C-J>
nnoremap <M-K> <C-W><C-K>
nnoremap <M-H> <C-W><C-H>
nnoremap <M-L> <C-W><C-L> 

nnoremap <M-Down> <C-W><C-J>:q!
nnoremap <M-Up> <C-W><C-K>
nnoremap <M-Left> <C-W><C-H>
nnoremap <M-Right> <C-W><C-L>

" key bindings for fzf
nnoremap <C-f> :Files<Cr>
nnoremap <C-g> :GFiles<Cr>

" ============================================================================ "
" ===                      PLUGIN CONFIGURATIONS                           === "
" ============================================================================ "

let g:ycm_autoclose_preview_window_after_completion = 1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_y = 'BN: %{bufnr("%")}'

" NerdTree Configuration
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFind<CR>

" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

" Close nerdtree when closing the tabs
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Changing the default arrows
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'


"let g:preview_markdown_viewer=/usr/local/bin/mdr
let g:preview_markdown_vertical=1

