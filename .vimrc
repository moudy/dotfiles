" Use vim settings, not vi settings
if &compatible
  set nocompatible
endif

" Number of colors
set t_Co=256

""" File settings

" The encoding displayed
set encoding=utf-8

" The encoding written to file
set fileencoding=utf-8

" Detect and load plugin/indent file for filetype
filetype plugin indent on

" Allow background files
set hidden

" Enable syntax highlighting
if !exists("g:syntax_on")
  syntax enable
endif

if has('termguicolors')
  set termguicolors
endif

"""" Settings

" Preview substitiution
if exists('&inccommand')
  set inccommand=split
endif

" Highlight all search matches
set hlsearch

" Turn off swap and backup files
set noswapfile
set nobackup
set nowritebackup

set rnu

" Minimal number of columns to use for the line number
set numberwidth=1

" Always show statusline
set laststatus=2

" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase

" Get rid of the delay when pressing O (for example)
" http://stackoverflow.com/questions/2158516/vim-delay-before-o-opens-a-new-line
set timeout timeoutlen=1000 ttimeoutlen=100

" Store lots of :cmdline history
set history=10000

" No sounds
set visualbell

" Fold based on indent
set foldmethod=indent

" Prevent folding by default
set foldlevelstart=20

" Whitespace
set autoindent
set smartindent
set smarttab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Scrolling
set scrolloff=8999
set sidescrolloff=15
set sidescroll=1

" Persistent undo
set undodir=~/.vim/undodir
set undofile

" Prevent Vim from clobbering the scrollback buffer
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

" for CSS
set iskeyword+=-

" Some stuff to ignore
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,DerivedData

""" Auto commands

augroup reload
  autocmd!
  autocmd FocusGained,BufEnter * :silent! !
augroup END

""" Mappings

" Set leader
let mapleader = "\<Space>"

" Faster
nmap ; :
vmap ; :

" Exit to normal mode with 'jj'
inoremap jj <ESC>

" Exit to normal mode from terminal mode with 'escape'
tnoremap <ESC> <C-\><C-n>

" Exit to normal mode from terminal mode with 'jj'
tnoremap jj <C-\><C-n>

" Edit file relative to current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%

" Replace current word
map <leader>rr :%s/<c-r>=expand("<cword>")<cr>/<c-r>=expand("<cword>")<cr>/g

" Previous file
nnoremap <leader><leader> <c-^>

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap } }zz
set scrolloff=10

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

" Equalizing windows
nmap <leader>= <C-W>=

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v
