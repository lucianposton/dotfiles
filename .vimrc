set nocompatible

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

"cindent

nnoremap <Space>b :ls<CR>:b 
inoremap jj <Esc>
inoremap jk <Esc>

if has('mouse')
	set mouse=a
endif

if &t_Co > 2 || has("gui_running")
	syntax on
endif

if exists('+colorcolumn')
    set colorcolumn=80
endif

set t_Co=256

au BufRead,BufNewFile *.mi set filetype=mason

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

au! BufWritePost .vimrc source %

