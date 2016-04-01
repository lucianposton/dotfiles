set nocompatible

set nomodeline
let g:secure_modelines_verbose = 1

set backspace=indent,eol,start
set history=50
set ruler
set showcmd
set incsearch
set hlsearch

set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

set tabstop=4
set shiftwidth=4
filetype plugin on
set ofu=syntaxcomplete#Complete

filetype indent on
set textwidth=78
set scrolloff=3          " Lines of context on vertical scroll
set sidescrolloff=3      " Columns of context on horizontal scroll
set ls=2

set expandtab
set autoindent
set smartindent
set smarttab
set scrolloff=3          " Lines of context on vertical scroll
set sidescrolloff=3      " Columns of context on horizontal scroll

set laststatus=2 " Always display the statusline in all windows
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

set ignorecase
set smartcase

"cindent

nnoremap <Space>b :ls<CR>:b 
inoremap jj <Esc>
inoremap jk <Esc>

if &t_Co > 2 || has("gui_running")
    syntax on
endif

if exists('+colorcolumn')
    set colorcolumn=80
endif

set t_Co=256

highlight Search ctermfg=black guifg=black

highlight Comment ctermfg=grey guifg=grey
"highlight WhiteSpaceEOL ctermbg=darkgreen guibg=lightblue
"match WhiteSpaceEol /\s\+$/
"match WhiteSpaceEOL /^\s*\ \s*\|\s\+$/
"match WhiteSpaceEOL /^\ \+\\|\s\+$\\|\ \+\ze\t\\|\t\zs\ \+/

highlight BadWhiteSpace ctermbg=lightblue guibg=lightblue
2match BadWhiteSpace /\t\|\s\+$/
"2match BadWhiteSpace /\t\|\s\+$\|\%81v.\+/
"au! BufWinEnter * match BadWhiteSpace /\t\|\s\+$/
"au! InsertEnter * match BadWhiteSpace /\t\|\s\+\%#\@<!$/
"au! InsertLeave * match BadWhiteSpace /\t\|\s\+$/
"au! BufWinLeave * call clearmatches()

au! BufWritePost $MYVIMRC source $MYVIMRC
au! BufRead,BufNewFile *.mi set filetype=mason


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ack.vim mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:ack_default_options=" -s -H --nocolor --nogroup --column"

nmap <leader>a :tab split<CR>:Ack ""<Left>
nmap <leader>A :tab split<CR>:Ack <C-r><C-w><CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Selecta Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

function! SelectaFile(path)
  call SelectaCommand("find " . a:path . "/* -type f", "", ":e")
endfunction

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
nnoremap <leader>f :call SelectaFile(".")<cr>
nnoremap <leader>gv :call SelectaFile("app/views")<cr>
nnoremap <leader>gc :call SelectaFile("app/controllers")<cr>
nnoremap <leader>gm :call SelectaFile("app/models")<cr>
nnoremap <leader>gh :call SelectaFile("app/helpers")<cr>
nnoremap <leader>gl :call SelectaFile("lib")<cr>
nnoremap <leader>gp :call SelectaFile("public")<cr>
nnoremap <leader>gs :call SelectaFile("public/stylesheets")<cr>
nnoremap <leader>gf :call SelectaFile("features")<cr>

function! SelectaIdentifier()
" Yank the word under the cursor into the z register
  normal "zyiw
" Fuzzy match files in the current directory, starting with the word under
" the cursor
  call SelectaCommand("find * -type f", "-s " . @z, ":e")
endfunction
nnoremap <c-g> :call SelectaIdentifier()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <C-\>r :!gen-src-index.sh<CR>:cs reset<CR><CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Powerline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set rtp+=~/dotfiles/setup/submodules/powerline/powerline/bindings/vim
