"--- SOURCING ----------------------------------------------------------------
"Automatically reloads neovim configuration file on write (w)
"autocmd! bufwritepost init.vim source %

" set leader to space
nnoremap <SPACE> <Nop>
let mapleader=" "

noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
" this don't work.
noremap <Right> <C-    " never buy an apple keybord without right CTRL key

nnoremap <leader>v :set invpaste paste?<CR>
set pastetoggle=<leader>v
set showmode


" move line or visually selected block - alt+j/k
fun SwitchLine(src_line_idx, direction)
  if a:direction ==# 'up'
    if a:src_line_idx == 1
      return
    endif
    move-2
    echo "Line UP"
  elseif a:direction ==# 'down'
    if a:src_line_idx == line('$')
      return
    endif
    move+1
    echo "Line DOWN"
  endif
endf

nnoremap <silent> <leader>kk :call SwitchLine(line('.'), 'up')<CR>
nnoremap <silent> <leader>jj :call SwitchLine(line('.'), 'down')<CR>

" No success with remaping alt on iOS (iSH.app)
"nnoremap <A-j> :m+<CR>
"nnoremap <A-k> :m--<CR>
"inoremap <A-j> <Esc>:m+<CR>
"inoremap <A-k> <Esc>:m--<CR>
"vnoremap <A-j> :m '>+<CR>
"vnoremap <A-k> :m '<--<CR>

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

" make a vertical column in the background at 80 characters
set colorcolumn=80

"––––––––––––––––––– FINDINGS FILES –––––––––––––––––––––––––––––––––––––––––
" Seachr down into subfolders
" Provides tab-completion for all file-related tasks
"set path+=**
set path=.,,**
" Display all matching files when tab complete
set wildmenu
"————————————————————————————————————————————————————————————————————————————
set noerrorbells                        "No sounds
set nowrap                              "No soft wrap text
set ignorecase                          "Ignore case of searches
set incsearch                           "Incremental search as you type
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

"--- JOURNAL -----------------------------------------------------------------

" autocmd VimEnter */journal/**   setlocal complete=k/root/journal/**/*

" set header title for journal & enter writing mode
function! JournalMode()
  execute 'normal gg'
  let journal_heading = strftime('# %F %H:%M, %a') 
" let nowtime = strftime('%H:%M')
" let filename = '#' . ' ' . expand('%:r') . ' ' . nowtime
" call setline(1, filename)
  call setline(1, journal_heading)
  execute 'normal o'
  "execute 'Goyo'
endfunction

" work flow for daily journal
augroup journal
    autocmd!
    " populate journal template
    autocmd VimEnter */journal/**   0r ~/.config/nvim/templates/journal.skeleton

    " set header for the particular journal
    autocmd VimEnter */journal/**   :call JournalMode()

    " https://stackoverflow.com/questions/12094708/include-a-directory-recursively-for-vim-autocompletion
    autocmd VimEnter */journal/**   set complete=k/root/journal/**/*
  augroup END

