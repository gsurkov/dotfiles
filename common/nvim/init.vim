call plug#begin('~/.local/share/nvim/plugged')
"Plug 'roxma/nvim-yarp'
"Plug 'ncm2/ncm2'
"Plug 'ncm2/ncm2-jedi'
"Plug 'ncm2/ncm2-bufword'
"Plug 'ncm2/ncm2-path'
"Plug 'ncm2/ncm2-pyclang'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" Automanic file type detection
syntax on
filetype plugin indent on

" Colour scheme
" colorscheme codedark

" General settings
set ts=4
set tabstop=4
set shiftwidth=4
set softtabstop=4

set autoindent
set noundofile
set expandtab
set showmatch
set linebreak
set nobackup
set number
set wrap

set mouse=nicr
set encoding=utf-8
set clipboard+=unnamed

" Disable auto comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Key bindings
inoremap jk <ESC>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Airline
let g:airline_theme='term'
let g:airline_powerline_fonts=1

" NERDTree key bindings
map <C-n> :NERDTreeToggle<CR>

" ncm2
"autocmd BufEnter * call ncm2#enable_for_buffer()
"set completeopt=menuone,noselect,noinsert
"set pumheight=5
"
"let ncm2#popup_delay = 5
"let ncm2#complete_length = [[1,1]]
"
"let g:ncm2#matcher = 'substrfuzzy'
"let g:ncm2_pyclang#args_file_path = ['.clang_complete']

" ncm2 key bindings
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
