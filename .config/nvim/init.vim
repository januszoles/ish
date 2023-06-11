
nnoremap <SPACE> <Nop>
let mapleader=" "

" move line or visually selected block - alt+j/k
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

"–––––––––––––––– SPELL CHECKER –––––—–––––––––––––––––––––––––––————————————
setlocal spell spelllang=pl,en_us      " PL EN Spell Checker

" Toggle spell-checking
function! ToggleSpellCheck()
  set spell!
  if &spell
    echo "Spellcheck ON"
  else
    echo "Spellcheck OFF"
  endif
endfunction

nnoremap <silent> <Leader>sp :call ToggleSpellCheck()<CR>
"————————————————————————————————————————————————————————————————————————————

set clipboard=unnamedplus
set completeopt=noinsert,menuone,noselect
set cursorline
set hidden
set inccommand=split
set mouse=a
"————————————————— SET LINE NUMBERS —————————————————————————————————————————
set number                             " show line numbers
set relativenumber                     " show relative line number
set numberwidth=5                      " width of number column
"————————————————————————————————————————
" toggle relative line number type: \nu
"————————————————————————————————————————
function! ToggleRelativeNumber()
  let &relativenumber = &relativenumber?0:1
  "let &number = &relativenumber? 0:1
endfunction
nnoremap <silent> <Leader>nu :call ToggleRelativeNumber()<cr>
"————————————————————————————————————————
" Toggle line numbers from none at all
" to relative numbering with current line number
noremap <silent> <Leader>nn :set invnumber invrelativenumber<CR>
"————————————————————————————————————————————————————————————————————————————

"——————————————————— SHOW WHITE SPACE ———————————————————————————————————————
set list
set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:» 

" Toggle between invisible character by (space §) `\§`
nmap <leader>§ :set list!<CR>
"————————————————————————————————————————————————————————————————————————————

set splitbelow splitright
set title
set ttimeoutlen=0
set wildmenu

" Tabs size
set expandtab
set shiftwidth=2
set tabstop=2
"For git vimdiff to open in no read only mode
set noro

"redrawtime exceeded syntax highlighting disabled" error 
set re=0

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

" ––––––––––––––– Plugins –––––––––––––––––––––––––––––––––––––––––––––––––––
":so %  <-- remember to source config

call plug#begin('~/.config/nvim/plugged')
"    Plug '<github-user>/<repo-name>'

" git
    Plug 'airblade/vim-gitgutter'

call plug#end()

"–––––––––––––––– Colorscheme –––––––––––––––––––––––––––––––––––––––––––––––
syntax on                               " Syntax highlight
colorscheme tokyonight
set background=dark
