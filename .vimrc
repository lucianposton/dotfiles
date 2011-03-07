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

set tabstop=3
set shiftwidth=3
"set expandtab
filetype plugin on
filetype indent on
set textwidth=78
"set autoindent
"set smartindent
set scrolloff=3          " Lines of context on vertical scroll
set sidescrolloff=3      " Columns of context on horizontal scroll

"set smarttab
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

highlight Comment ctermfg=grey guifg=grey
highlight WhiteSpaceEOL ctermbg=darkgreen guibg=lightgreen
match WhiteSpaceEol /\s\+$/
"match WhiteSpaceEOL /^\s*\ \s*\|\s\+$/
"match WhiteSpaceEOL /^\ \+\\|\s\+$\\|\ \+\ze\t\\|\t\zs\ \+/


set t_Co=256
