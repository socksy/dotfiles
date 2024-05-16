if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
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

Plug 'junegunn/seoul256.vim'
Plug 'tpope/vim-surround'
Plug 'kien/rainbow_parentheses.vim'
Plug 'rking/ag.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'

"Plug 'tpope/vim-salve', { 'for' : 'clojure' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

Plug 'mattn/emmet-vim'
Plug 'airblade/vim-gitgutter'
Plug 'hellerve/carp-vim'
Plug 'LnL7/vim-nix'
Plug 'jasonccox/vim-wayland-clipboard'
call plug#end()

"Colorscheme
colo seoul256

"RainbowParents always on
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

let &t_ut=''
