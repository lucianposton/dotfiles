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

set splitright

set relativenumber
set number

set list
set listchars=tab:├·,trail:␣,nbsp:⍽,extends:►,precedes:◄

"cindent

cmap w!! w !sudo tee > /dev/null %
nnoremap <Space>b :ls<CR>:b 
inoremap jj <Esc>
inoremap jk <Esc>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

if &t_Co > 2 || has("gui_running")
    syntax on
endif

if exists('+colorcolumn')
    set colorcolumn=80
endif

set t_Co=256

" Should go in .vim/
au! BufWritePost $MYVIMRC source $MYVIMRC
au! BufRead,BufNewFile *.mi set filetype=mason


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Guess whether to toggle 'expandtab' in current buffer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! GuessTabsOrSpaces()
    if getfsize(bufname("%")) > 256000
        " File is very large, just use the default.
        return
    endif

    let numTabs=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^\\t"'))
    let numSpaces=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^ "'))

    if numTabs > numSpaces
        setlocal noexpandtab
    endif
endfunction

" Call the function after opening a buffer
autocmd BufReadPost * call GuessTabsOrSpaces()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" highlight configuration. To see groups, :so $VIMRUNTIME/syntax/hitest.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
highlight clear SignColumn " Clear white background of :sign colum
highlight SpellBad cterm=NONE ctermfg=NONE ctermbg=black
"highlight SpellCap cterm=undercurl ctermfg=NONE ctermbg=black
"highlight SpellLocal cterm=undercurl ctermfg=NONE ctermbg=black
highlight SpellRare cterm=NONE ctermfg=NONE ctermbg=NONE
highlight Search ctermfg=black guifg=black
highlight Comment ctermfg=grey guifg=grey

"highlight WhiteSpaceEOL ctermbg=darkgreen guibg=lightblue
"match WhiteSpaceEol /\s\+$/
"match WhiteSpaceEOL /^\s*\ \s*\|\s\+$/
"match WhiteSpaceEOL /^\ \+\\|\s\+$\\|\ \+\ze\t\\|\t\zs\ \+/

"highlight BadWhiteSpace ctermbg=lightblue guibg=lightblue
"2match BadWhiteSpace /\t\|\s\+$/
"2match BadWhiteSpace /\t\|\s\+$\|\%81v.\+/
"au! BufWinEnter * match BadWhiteSpace /\t\|\s\+$/
"au! InsertEnter * match BadWhiteSpace /\t\|\s\+\%#\@<!$/
"au! InsertLeave * match BadWhiteSpace /\t\|\s\+$/
"au! BufWinLeave * call clearmatches()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-cpp-enhanced-highlight
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:cpp_class_scope_highlight = 1 " Doesn't handle templates, so looks inconsistent
let g:cpp_member_variable_highlight = 1
"let g:cpp_class_decl_highlight = 1 " Inconsistent class and struct names
let g:cpp_concepts_highlight = 1
"let g:cpp_no_function_highlight = 1
"let g:cpp_experimental_simple_template_highlight = 1 " Slow as fuck
"let g:cpp_experimental_template_highlight = 1 " Breaks non-template syntax. See github issue
"let c_no_curly_errors=1 " Disables some curly brace errors. Doesn't work well


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" minimal_gdb
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:mingdb_gdbinit_path = '~/.gdbinit-modules.d/99-mingdb'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ack.vim mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:ack_default_options=" -s -H --nocolor --nogroup --column"

nmap <leader>a :Ack! ""<Left>
nmap <leader>A :Ack! <C-r><C-w><CR>


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
" cscope. See also .vim/plugin/cscope_maps.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <C-\>r :!gen-src-index.sh<CR>:cs reset<CR><CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Powerline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set rtp+=~/dotfiles/setup/submodules/powerline/powerline/bindings/vim


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Quickerfix
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:quickerfix_hotkeys = {
            \ "t": "<C-W><CR><C-W>T",
            \ "T": "<C-W><CR><C-W>TgT<C-W>j",
            \ "o": "<CR>",
            \ "O": "<CR><C-W>p<C-W>c",
            \ "go": "<CR><C-W>p",
            \ "h": "<C-W><CR><C-W>K",
            \ "H": "<C-W><CR><C-W>K<C-W>b",
            \ "v": "<C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t",
            \ "gv": "<C-W><CR><C-W>H<C-W>b<C-W>J",
            \ "q": ":cclose<CR>" }

function! Quickerfix() "{{{
    execute "botright copen"
    nnoremap <buffer> <silent> ? :call <SID>QuickerfixHelp()<CR>
    for key_map in items(s:quickerfix_hotkeys)
        execute printf("nnoremap <buffer> <silent> %s %s", get(key_map, 0), get(key_map, 1))
    endfor
    redraw!
endfunction "}}}

function! s:QuickerfixHelp() "{{{
    execute 'edit' globpath(&rtp, 'doc/quickerfix_quick_help.txt')

    silent normal gg
    setlocal buftype=nofile bufhidden=hide nobuflisted
    setlocal nomodifiable noswapfile
    setlocal filetype=help
    setlocal nonumber norelativenumber nowrap
    setlocal foldmethod=diff foldlevel=20

    nnoremap <buffer> <silent> ? :q!<CR>:call Quickerfix()<CR>
endfunction "}}}
