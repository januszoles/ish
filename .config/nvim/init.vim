" https://dev.to/elvessousa/my-basic-neovim-setup-253l
" article about how to set it up.



"Options
set background=dark
set clipboard=unnamedplus
set completeopt=noinsert,menuone,noselect
set cursorline
set hidden
set inccommand=split
set mouse=a
set number
set relativenumber
set splitbelow splitright
set title
set ttimeoutlen=0
set wildmenu

" Tabs size
set expandtab
set shiftwidth=2
set tabstop=2

" Italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

" True color if available
let term_program=$TERM_PROGRAM

" Check for conflicts with Apple Terminal app
if term_program !=? 'Apple_Terminal'
  set termguicolors
else
  if $TERM !=? 'xterm-256color'
    set termguicolors
  endif
endif

": so %
" --- Plugins
call plug#begin('~/.config/nvim/plugged')
"    Plug '<github-user>/<repo-name>'

" git
    Plug 'airblade/vim-gitgutter'

call plug#end()


