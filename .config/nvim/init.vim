
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

" Toogle invisible characters  <SPACE>§
nmap <Leader>§ :set list!<CR>
"––––––––––––––––––– FINDINGS FILES –––––––––––––––––––––––––––––––––––––––––
" Seachr down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**
" Display all matching files when tab complete
set wildmenu
"————————————————————————————————————————————————————————————————————————————
set noerrorbells                        "No sounds
set nowrap                              "No soft wrap text
set ignorecase                          "Ignore case of searches
set incsearch                           "Highlight as pattern is typed
set hlsearch                            "Highlight searches
set splitbelow splitright
set title                               "put filename onto terminal heading
set ttimeoutlen=0
set wildmenu
set ruler                               " Show cursor position
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

"––– Print today date
map <leader>D :put =strftime('# %F %H:%M, %a')<ESC>kJo<ESC>
map <leader>dt :r!date "+\%F \%H:\%M, \%a" <ESC>kJo<ESC>


"––– fill rest of line with characters 
function! FillLine( str )
  " set tw to the desired total length
  let tw = &textwidth
  " column width 77 just for iPadMini
  if tw==0 | let tw = 77 | endif
    " strip trailing spaces first
    .s/[[:space:]]*$//
    " calculate total number of 'str's to insert
    let reps = (tw - col("$")) / len(a:str)
    " insert them, if there's room, removing trailing spaces (though forcing
    " there to be one)
  if reps > 0
    .s/$/\=(' '.repeat(a:str,reps))/
  endif
endfunction
map <leader>fl :call FillLine( '-' )
map <leader>fl# :call FillLine( '#' )
