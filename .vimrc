" Use vim settings, not vi settings
if &compatible
  set nocompatible
endif

" Number of colors
set t_Co=256

call plug#begin('~/.cache/plugged')

" Needs to be loaded first https://github.com/alampros/vim-styled-jsx/issues/1
Plug 'sheerun/vim-polyglot'

Plug 'NLKNguyen/papercolor-theme'
Plug 'whatyouhide/vim-gotham'
Plug 'embark-theme/vim', { 'as': 'embark' }
Plug 'othree/yajs.vim'
Plug 'HerringtonDarkholme/yats'

Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

Plug 'wellle/tmux-complete.vim'
Plug 'danro/rename.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'kshenoy/vim-signature'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'scrooloose/nerdcommenter'
Plug 'fatih/vim-go'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'rhysd/git-messenger.vim'

if has('nvim')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'machakann/vim-highlightedyank'
else
  Plug 'ajh17/VimCompletesMe'
endif

call plug#end()

let g:python_host_prog = expand('~/.pyenv/shims/python')
let g:python3_host_prog = expand('~/.pyenv/shims/python3')

if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

""" File settings

" The encoding displayed
set encoding=utf-8

" The encoding written to file
set fileencoding=utf-8

" Detect and load plugin/indent file for filetype
filetype plugin indent on

" Allow background files
set hidden

""" Colors

" https://github.com/vim/vim/issues/993#issuecomment-255651605
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Enable syntax highlighting
if !exists("g:syntax_on")
  syntax enable
endif

if has('termguicolors')
  set termguicolors
endif

if $MY_THEME == "light"
  set background=light
  colorscheme PaperColor
else
  set background=dark
  " colorscheme gotham
  colorscheme embark
  let g:embark_terminal_italics = 1
endif


" Make gutter background same as terminal
" highlight SignifySignAdd    ctermfg=green  guifg=#00ff00 cterm=NONE gui=NONE
" highlight SignifySignDelete ctermfg=red    guifg=#ff0000 cterm=NONE gui=NONE
" highlight SignifySignChange ctermfg=yellow guifg=#ffff00 cterm=NONE gui=NONE

" Show extra whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

set fillchars+=vert:│

" Make flow syntax highlighting work
let g:javascript_plugin_flow = 1

" Highlight variables that are the same
let g:go_auto_sameids = 1

" Enable more syntax highlighting for Go
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_types = 1
let g:go_auto_type_info = 1
let g:go_highlight_structs = 0 " 1
let g:go_highlight_operators = 0 " 1
let g:go_highlight_interfaces = 0
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"

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

" Relative line numbers in normal mode, normal in insert
set rnu
autocmd InsertEnter * setl nu
autocmd InsertLeave * setl rnu

" Keep line numbers in terminal mode
" autocmd TermOpen * setl nu

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

" Auto-select first item
" :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

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

nnoremap U :syntax sync fromstart<cr>:redraw!<cr>

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

" Find current word
map <leader>ff :Rg <c-r>=expand("<cword>")<cr><cr>

" Find file
nmap <leader>p :Telescope find_files<CR>

" Find file
nmap <leader>b :Telescope buffers<CR>

" Previous file
nnoremap <leader><leader> <c-^>

nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

" Fix code
nmap <leader>f :Prettier<CR>

" Find bext error
map <leader>ne <Plug>(coc-diagnostic-next-error)

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

au BufRead,BufNewFile *.js.flow setfiletype javascript

nmap <leader>rn <Plug>(coc-rename)

""" Plugins

"" Lightline
let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filepath', 'modified' ] ],
    \ },
    \ 'component': {
    \   'filepath': "%{expand('%:p:h:t')}/%t"
    \ },
    \ 'component_function': {
    \   'filename': 'LightlineFilename',
    \   'gitbranch': 'fugitive#head',
    \ },
    \ 'subseparator': { 'left': '∙', 'right': '∙' }
    \ }

if $MY_THEME == 'light'
  let g:lightline.colorscheme = 'PaperColor'
else
  " let g:lightline.colorscheme = 'gotham'
  let g:lightline.colorscheme = 'embark'
end

" Shortform mode
let g:lightline.mode_map = {
    \ 'n' : 'N',
    \ 'i' : 'I',
    \ 'R' : 'R',
    \ 'v' : 'V',
    \ 'V' : 'V',
    \ "\<C-v>": 'V',
    \ 'c' : 'C',
    \ 's' : 'S',
    \ 'S' : 'S',
    \ "\<C-s>": 'S',
    \ 't': 'T',
    \ }

function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

""" FZF

let g:fzf_preview_window = 'right:60%'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

""" VimCompletesMe

" Make the Enter key select the completion entry instead of creating a new line
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
let g:cm_refresh_length = 2

" Better display for messages
set cmdheight=2

" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

command! -nargs=0 Prettier :CocCommand prettier.formatFile

""" Functions

" Same as :only but removes buffers
function! Buflist()
  redir => bufnames
  silent ls
  redir END
  let list = []
  for i in split(bufnames, "\n")
    let buf = split(i, '"' )
    call add(list, buf[-2])
    |   endfor
  return list
endfunction

function! Only()
  let list = filter(Buflist(), 'v:val != bufname("%")')
  for buffer in list
    exec "bdelete ".buffer
  endfor
endfunction
command! Only :silent call Only()

function! CommonJSToES6()
  s/\<\(var\|let\|const\)\>/import/
  s/= require/from /
  s/(//
  s/)//
endfunction
command! CommonJSToES6 call CommonJSToES6()

" quickfixopenall.vim
"Author:
"   Tim Dahlin
"
"Description:
"   Opens all the files in the quickfix list for editing.
"
"Usage:
"   1. Perform a vimgrep search
"       :vimgrep /def/ *.rb
"   2. Issue QuickFixOpenAll command
"       :QuickFixOpenAll

function!   QuickFixOpenAll()
    if empty(getqflist())
        return
    endif
    let s:prev_val = ""
    for d in getqflist()
        let s:curr_val = bufname(d.bufnr)
        if (s:curr_val != s:prev_val)
            exec "edit " . s:curr_val
        endif
        let s:prev_val = s:curr_val
    endfor
endfunction

command! QuickFixOpenAll         call QuickFixOpenAll()
