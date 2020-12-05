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

" Plugins go below. Call PlugInstall to install new 
call plug#begin('~/.config/nvim/plugins')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'ayu-theme/ayu-vim'
Plug 'morhetz/gruvbox'
" Plug 'trevordmiller/nova-vim'
Plug 'preservim/nerdtree'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'junegunn/fzf.vim'
" Plug 'scrooloose/nerdcommenter'

call plug#end()


" basic settings
syntax on

set noerrorbells
set number
set relativenumber
set smartcase
set tabstop=4
set softtabstop=4
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

set colorcolumn=85
highlight ColorColumn ctermbg=0 guibg=lightgrey

" let ayucolor="dark"		" light/mirage/dark
" colorscheme ayu

" Change default arrows in NerdTree
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Use deoplete
" let g:deoplete#enable_at_startup = 1

" Close method preview window
" Someday this shit is gonna make sense to you !!!
" autocmd InsertLeave, CompleteDone * if pumvisible() == 0 | pclose | endif

" Theme
syntax enable
set background=dark
colorscheme gruvbox

let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'

" Key bindings
map <C-b> :NERDTreeToggle<CR>		
map <C-o> :Files<CR>
map <C-G> :GFiles<CR>

