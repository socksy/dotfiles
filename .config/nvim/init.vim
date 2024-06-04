let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
set nocompatible

filetype plugin on
filetype plugin indent on

au BufNewFile,BufRead *.boot set filetype=clojure
au BufNewFile,BufRead *.bb set filetype=clojure

if $COLORTERM == 'gnome-terminal' || $COLORTERM == 'xfce4-terminal'
  set t_Co=256
endif

"sensible defaults
syntax enable

set autoindent
set number
set ruler
set ignorecase
set smartcase
set incsearch
set hlsearch

set tabstop=2
set shiftwidth=2
set expandtab

cmap w!! %!sudo tee > /dev/null %

call plug#begin('~/.vim/plugged')

"Plug 'junegunn/seoul256.vim'
Plug 'sainnhe/everforest'
Plug 'tpope/vim-surround'
Plug 'kien/rainbow_parentheses.vim'
Plug 'rking/ag.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'

"Plug 'tpope/vim-salve', { 'for' : 'clojure' }
"Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'Olical/conjure'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'mattn/emmet-vim'
Plug 'airblade/vim-gitgutter'
Plug 'hellerve/carp-vim'

Plug 'mrcjkb/rustaceanvim'
Plug 'LnL7/vim-nix'
Plug 'jasonccox/vim-wayland-clipboard'
call plug#end()

"Colorscheme
colo everforest

"RainbowParents always on
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

let &t_ut=''
