""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                   _   ___      _______ __  __       _____ ____  _   _ ______ _____ _____                         "
"                  | \ | \ \    / /_   _|  \/  |     / ____/ __ \| \ | |  ____|_   _/ ____|                        "
"                  |  \| |\ \  / /  | | | \  / |    | |   | |  | |  \| | |__    | || |  __                         "
"                  | . ` | \ \/ /   | | | |\/| |    | |   | |  | | . ` |  __|   | || | |_ |                        "
"                  | |\  |  \  /   _| |_| |  | |    | |___| |__| | |\  | |     _| || |__| |                        "
"                  |_| \_|   \/   |_____|_|  |_|     \_____\____/|_| \_|_|    |_____\_____|                        "
"                                                                                                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  This art work is generated using http://patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something%20   "
"  																									               "
"  The configurations are referred/insprired from:   															   "
"  		- https://jdhao.github.io/2018/12/24/centos_nvim_install_use_guide_en/									   "
"  		- https://github.com/benawad/dotfiles   																   "
"  		- https://github.com/benawad/dotfiles  																	   "
"  		- https://blog.pabuisson.com/2018/06/favorite-color-schemes-modern-vim-neovim/ 							   "
"  																												   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugins go below. 
call plug#begin('~/.config/nvim/plugins')

" Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'morhetz/gruvbox'

Plug 'preservim/nerdtree'

" Autocompletion Engine
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Python auto-completion
Plug 'zchee/deoplete-jedi'

" Status bar plugin
Plug 'vim-airline/vim-airline'

" Status bar theme plugin
Plug 'vim-airline/vim-airline-themes'

" Plug 'sheerun/vim-polyglot'

Plug 'jiangmiao/auto-pairs'

" Commenter
Plug 'scrooloose/nerdcommenter'

" Code Checker Plugin
Plug 'neomake/neomake'

" Golang
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()


" basic settings
syntax on

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
set hidden
set nowritebackup
set cmdheight=2
set updatetime=300
set termguicolors		" enable true color support
set splitbelow			" preview windows opens below
set mouse=a			" enable mouse scroll
set smartindent
set incsearch
set expandtab
set smarttab

set colorcolumn=85
highlight ColorColumn ctermbg=0 guibg=lightgrey

" let ayucolor="dark"		" light/mirage/dark
" colorscheme ayu

" Change default arrows in NerdTree
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Use deoplete
let g:deoplete#enable_at_startup = 1
let g:python_host_prog = 'python'
let g:python3_host_prog = 'python3'


" Close method preview window
autocmd InsertLeave, CompleteDone * if pumvisible() == 0 | pclose | endif


" Python Linter
let g:neomake_python_enabled_makers = ['flake8']


" Theme
syntax enable
set background=dark
colorscheme gruvbox

let g:airline_theme = 'solarized'
let g:airline_solarized_bg = 'dark'

" Golang  Settings
" let g:go_highlight_fields = 1
" let g:go_highlight_functions = 1
" let g:go_highlight_function_call = 1
" let g:go_highlight_extra_types = 1
" let g:go_highlight_operators = 1


" ============================================================================ "
" ===                           KEY BINDINGS                               === "
" ============================================================================ "

" Remap leader key to ,
let g:mapleader='<CR>'

map <C-b> :NERDTreeToggle<CR>		
map <C-o> :Files<CR>


" Split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"

