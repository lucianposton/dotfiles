" vim: foldmethod=marker
" {{{ Notes
"===================================================================================
"  (nore) prefix -- non-recursive
"  (un)   prefix -- Remove a mode-specific map
"  Commands                        Mode
"  --------                        ----
"  map                             Normal, Visual, Select, Operator Pending modes
"  nmap, nnoremap, nunmap          Normal mode
"  imap, inoremap, iunmap          Insert and Replace mode
"  vmap, vnoremap, vunmap          Visual and Select mode
"  xmap, xnoremap, xunmap          Visual mode
"  smap, snoremap, sunmap          Select mode
"  cmap, cnoremap, cunmap          Command-line mode
"  omap, onoremap, ounmap          Operator pending mode
"
" :h key-notation
" Keys         Notation
" -----        ---------
" <C-s>        Ctrl + s
" <A-s>        Alt + s
" <M-s>        Meta + s
" <BS>         Backspace
" <Tab>        Tab
" <CR>         Enter
" <Esc>        Escape
" <Space>      Space
" <Up>         Up arrow
" <Down>       Down arrow
" <Left>       Left arrow
" <Right>      Right arrow
" <F1> - <F12> Function keys 1 to 12
" <Insert>     Insert
" <Del>        Delete
" <Home>       Home
" <End>        End
"===================================================================================
" }}}

set nocompatible " Sets many options, so should go first

set formatoptions+=j
set formatoptions+=1
set formatoptions+=n
if executable("par-format")
    set formatprg=par-format\ -rqe
endif
set nojoinspaces
set autoread
set backspace=indent,eol,start
set history=1000
set tabpagemax=50
set viminfo^=!
set viminfo-=h
set sessionoptions-=options
set sessionoptions+=localoptions
set ruler
set lazyredraw
set showcmd
set incsearch
set hlsearch

set undofile
set undodir=~/.vim/undo
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

if has("x11") && has("unnamedplus")
    set clipboard=autoselect,autoselectplus,unnamed,unnamedplus,exclude:cons\|linux
endif

set tabstop=4
set shiftwidth=4
filetype plugin on
if exists("+omnifunc")
   autocmd Filetype *
               \	if &omnifunc == "" |
               \		setlocal omnifunc=syntaxcomplete#Complete |
               \	endif
endif

filetype indent on
set synmaxcol=400
if !exists("g:syntax_on") && ( &t_Co > 2 || has("gui_running") )
    syntax enable
endif

if exists('+colorcolumn')
    set colorcolumn=+1
endif
set textwidth=78
set scrolloff=3          " Lines of context on vertical scroll
set sidescrolloff=3      " Columns of context on horizontal scroll

set expandtab
set autoindent
set smartindent
"set cindent
set smarttab

set laststatus=2 " Always display the statusline in all windows
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

set ignorecase
set smartcase

set splitright
set splitbelow
set winheight=3
set winminheight=3
set winminwidth=3

set relativenumber
set number

set list
set listchars=tab:├·,trail:␣,nbsp:⍽,extends:►,precedes:◄
let &showbreak='↳ '
set breakindent
set breakindentopt=min:60,shift:2
set fillchars=vert:\|,fold:·
set display=uhex,truncate

set path+=**
set wildmenu
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.o,.lo

set timeout
set timeoutlen=1000
set ttimeout
set ttimeoutlen=25


" Should go in .vim/
autocmd! BufWritePost $MYVIMRC source $MYVIMRC
autocmd! BufRead,BufNewFile *.mi set filetype=mason


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap Q <nop>
"nnoremap X <nop>
nnoremap <C-Left> <nop>
nnoremap <C-Right> <nop>
nnoremap <C-Up> <nop>
nnoremap <C-Down> <nop>
nnoremap <M-Left> <nop>
nnoremap <M-Right> <nop>
nnoremap <M-Up> <nop>
nnoremap <M-Down> <nop>
nnoremap <Home> <nop>
nnoremap <End> <nop>
nnoremap <S-Home> <nop>
nnoremap <S-End> <nop>
nnoremap <Insert> <nop>
nnoremap <Del> <nop>
nnoremap <PageUp> <nop>
nnoremap <PageDown> <nop>

" aliases
"inoremap jj <C-\><C-N>
inoremap jk <C-\><C-N>:update<CR>
inoremap {<CR> {<CR>}<C-G>u<C-\><C-N>O
inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap <expr> ] strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap <CR> <C-G>u<CR>
nnoremap Y y$
nnoremap <Leader>U :syntax sync fromstart<CR>:redraw!<CR>
nnoremap q; q:
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
nnoremap <Leader>vp '[v']
nnoremap <Space>. /<C-r>"<CR>cgn<C-r>.<Esc>
inoremap <C-K><C-K> <C-\><C-N>:help digraph-table<CR>
nnoremap <Leader>eg :vsplit ~/.gitconfig<cr>
nnoremap <Leader>em :vsplit ~/.mutt/neomuttrc<cr>
nnoremap <Leader>et :vsplit ~/.tmux.conf<cr>
nnoremap <Leader>ev :vsplit $MYVIMRC<cr>

" readline-ish aliases
noremap <M-k> :<Up>
noremap <M-j> q:
noremap! <M-k> <Up>
noremap! <M-j> <Down>
noremap! <M-h> <S-Left>
noremap! <M-l> <S-Right>
inoremap <M-d> <C-O>de
cnoremap <expr> <M-d> readline_helper#delete_word()
noremap! <M-BS> <C-W>
inoremap <C-U> <C-G>u<C-U>

" swap commands
nnoremap gQ J
xnoremap gQ J
nnoremap <expr> <C-m> &buftype ==# 'quickfix' \|\| getcmdwintype() != '' ? "\<CR>" : 'K'
vnoremap <C-m> K

" state toggle
nnoremap <F1> :setlocal spell!<CR>
inoremap <F2> <C-o>:setlocal spell!<CR>
nnoremap <F2> :setlocal relativenumber!<CR>:set number!<CR>
inoremap <F2> <C-o>:setlocal relativenumber!<CR><C-o>:set number!<CR>
nnoremap <F3> :nohlsearch<CR>
inoremap <F3> <C-o>:nohlsearch<CR>

" navigation
nnoremap K <C-U>
xnoremap K <C-U>
nnoremap J <C-D>
xnoremap J <C-D>
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'

" file navigation
nnoremap <Space>b :ls<CR>:b 
nnoremap <Space><Space> <C-^>
nnoremap <silent> <Space>- :silent edit <C-R>=empty(expand('%')) ? '.' : expand('%:p:h')<CR><CR>
nnoremap <Space>e :edit <C-R>=expand('%:p:h') . '/'<CR>

" file modification
nnoremap <Space>s :update<CR>
nnoremap <Space>x :xit<CR>
nnoremap <Space>q :quit!<CR>
nnoremap <Space>qq :wqall<CR>
nnoremap <Space>qqq :qall!<CR>

" window management
nnoremap s <C-W>
nnoremap s<Left> :vertical resize -2<CR>
nnoremap s<Right> :vertical resize +2<CR>
nnoremap s<Up> :resize -2<CR>
nnoremap s<Down> :resize +2<CR>

" quickfix navigation https://noahfrederick.com/log/a-list-of-vims-lists
nnoremap <Up> :cprevious<CR>
nnoremap <Down> :cnext<CR>
nnoremap <Left> :cpfile<CR>
nnoremap <Right> :cnfile<CR>
nnoremap <S-Up> :lprevious<CR>
nnoremap <S-Down> :lnext<CR>
nnoremap <S-Left> :lpfile<CR>
nnoremap <S-Right> :lnfile<CR>

" search without jumping
noremap <Space>n  :set hls<CR>:let @/ = '\<' . expand('<cword>') . '\>' <CR>:call histadd('/', @/)<CR>:echo @/<CR>
noremap <Space>gn :set hls<CR>:let @/ = expand('<cword>') <CR>:call histadd('/', @/)<CR>:echo @/<CR>

" tab while incsearching. Uses 'wildcharm'
set wildcharm=<C-@>
cnoremap <expr> <Tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>/<C-r>/' : '<C-@>'
cnoremap <expr> <S-Tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>?<C-r>/' : '<S-Tab>'

" misc commands
vnoremap . :normal .<CR>
vnoremap @@ :normal @@<CR>
cnoremap w!! execute 'w !sudo tee % >/dev/null' \| if v:shell_error \|
            \ echoe "Write Error" \| else \| :edit! \| endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" keycode mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has("gui_running") && !has('nvim')
    " Mapping terminal keycodes to vim keycodes introduces timeout issues in
    " all vim modes. As mitigation, can use autocmd to limit severity, or can
    " set ttimeoutlen low e.g. <100.
    " https://github.com/tpope/vim-rsi/blob/master/plugin/rsi.vim
    " http://vim.wikia.com/wiki/Mapping_fast_keycodes_in_terminal_Vim
    if &term == "rxvt-unicode-256color" || &term == "screen-256color"
        silent! execute "set <M-j>=\<Esc>j"
        silent! execute "set <M-k>=\<Esc>k"
        silent! execute "set <M-h>=\<Esc>h"
        silent! execute "set <M-l>=\<Esc>l"
        silent! execute "set <M-d>=\<Esc>d"
        silent! exe "set <S-Up>=\<Esc>[a"
        silent! exe "set <S-Down>=\<Esc>[b"
        silent! execute "set <F34>=\<Esc>\<C-?>"
        silent! execute "set <F35>=\<Esc>\<C-H>"
        map! <F34> <M-BS>
        map! <F35> <M-BS>
        map <F34> <M-BS>
        map <F35> <M-BS>
    elseif &term == "xterm"
        set <F34>=
        map! <F34> <M-BS>
        map <F34> <M-BS>
    endif
endif


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
    else
        setlocal expandtab
    endif
endfunction

" Call the function after opening a buffer
autocmd BufReadPost * call GuessTabsOrSpaces()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" highlight configuration. To see groups, :so $VIMRUNTIME/syntax/hitest.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
highlight clear SignColumn " Clear white background of :sign colum
highlight SpellBad cterm=undercurl ctermfg=NONE ctermbg=black
highlight SpellCap cterm=undercurl ctermfg=NONE ctermbg=black
"highlight SpellLocal cterm=undercurl ctermfg=NONE ctermbg=black
highlight SpellRare cterm=NONE ctermfg=NONE ctermbg=NONE
highlight Search ctermfg=black guifg=black
highlight LineNr ctermfg=black guifg=Brown
highlight CursorLineNr ctermfg=black gui=bold guifg=Brown
highlight Comment ctermfg=grey guifg=grey
highlight ColorColumn ctermbg=black guibg=LightRed
highlight DiffAdd ctermfg=cyan ctermbg=black guibg=LightBlue
highlight DiffChange ctermfg=NONE ctermbg=black guibg=LightMagenta
highlight DiffDelete ctermfg=magenta ctermbg=black gui=bold guifg=Blue guibg=LightCyan
highlight DiffText term=reverse cterm=bold ctermbg=red gui=bold guibg=Red
highlight Folded ctermfg=darkcyan ctermbg=NONE guifg=DarkBlue guibg=LightGrey
highlight FoldColumn ctermfg=darkcyan ctermbg=NONE guifg=DarkBlue guibg=Grey

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
" securemodelines
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nomodeline
let g:secure_modelines_verbose = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" matchit.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif


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
" AsyncRun
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:asyncrun_bell=1
let g:asyncrun_open=10

nnoremap <Leader>a :AsyncRun! rg ""<Left>
nnoremap <Leader>A :AsyncRun! rg <C-r><C-w><CR>
nnoremap <Leader>m :AsyncRun -save=2 -program=make<CR>
nnoremap <Leader>s :AsyncStop<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope. See also .vim/plugin/cscope_maps.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-\>r :!gen-src-index.sh<CR>:cs reset<CR><CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Powerline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set rtp+=~/dotfiles/setup/submodules/powerline/powerline/bindings/vim


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" netrw
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_banner=0
"let g:netrw_browse_split=4 " https://github.com/vim/vim/issues/3276
let g:netrw_altv=1
let g:netrw_liststyle=3
"let g:netrw_special_syntax=1
"let g:netrw_list_hide=netrw_gitignore#Hide()
"let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" <CR>/o/v/t to open selected file in buffer/h-split/v-split/tab
" :h netrw-browse-maps


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" undotree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:undotree_WindowLayout=4
let g:undotree_SetFocusWhenToggle=1
let g:undotree_ShortIndicators=1
"let g:undotree_DiffCommand="diff -u"
"let g:undotree_SplitWidth=40
" syntax : DiffAdd and DiffChange

nnoremap <Leader>u :UndotreeToggle<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fugitive
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nnoremap <space>ga :Git add %:p<CR><CR>
"nnoremap <space>gs :Gstatus<CR>
"nnoremap <space>gc :Gcommit -v -q<CR>
"nnoremap <space>gt :Gcommit -v -q %:p<CR>
"nnoremap <space>gd :Gdiff<CR>
"nnoremap <space>ge :Gedit<CR>
"nnoremap <space>gr :Gread<CR>
"nnoremap <space>gw :Gwrite<CR><CR>
"nnoremap <space>gl :silent! Glog<CR>:bot copen<CR>
"nnoremap <space>gp :Ggrep<Space>
"nnoremap <space>gm :Gmove<Space>
"nnoremap <space>gb :Git branch<Space>
"nnoremap <space>go :Git checkout<Space>
"nnoremap <space>gps :Dispatch! git push<CR>
"nnoremap <space>gpl :Dispatch! git pull<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fancy foldtext
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! GetWinPadding() abort
  let lpadding = &foldcolumn
  if &signcolumn ==# 'auto'
    redir => signs
    execute 'silent sign place buffer=' . bufnr('%')
    redir End
    let lpadding += signs =~# 'id=' ? 2 : 0
  else
    let lpadding += &signcolumn ==# 'yes' ? 2 : 0
  endif
  if &number
    let lpadding += max([&numberwidth, strlen(line('$')) + 1])
  elseif exists('+relativenumber') && &relativenumber
    let lpadding += max([&numberwidth, strlen(winheight('.')) + 1])
  endif
  return lpadding
endfunction

function! FoldPretty() abort
  let lpadding = GetWinPadding()

  " Expand tabs
  let start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
  let end = substitute(getline(v:foldend), '\t', repeat(' ', &tabstop), 'g')

  " Remove fold markers
  let marker = strpart(&foldmarker, 0, stridx(&foldmarker, ','))
  let start = substitute(start, marker, '', '')
  let marker = strpart(&foldmarker, stridx(&foldmarker, ',') + 1)
  let end = substitute(end, marker, '', '')

  " Remove comments
  let comment = strpart(&commentstring, 0, stridx(&commentstring, '%s'))
  let start = substitute(start, comment, repeat(' ', strlen(comment)), '')
  let end = substitute(end, comment, '', '')

  " Replace start leading and trailing whitespace with ·
  let start = substitute(start, '^\( \+\)', '\=repeat("·", len(submatch(0)))', '')
  let start = substitute(start, '\( \+\)$', '\=repeat("·", len(submatch(0)))', '')

  " Trim end whitespace
  let end = substitute(end, '^\s*', '', 'g')

  let info = '(' . (v:foldend - v:foldstart) . ')'
  let infolen = strlen(substitute(info, '.', 'x', 'g'))
  let width = winwidth(0) - lpadding - infolen

  let separator = strlen(substitute(end, ' ', '', 'g')) > 0 ? ' … ' : ''
  let separatorlen = strlen(substitute(separator, '.', 'x', 'g'))
  let start = strpart(start, 0, width - strlen(substitute(end, '.', 'x', 'g')) - separatorlen)
  let text = start . separator . end

  return text . repeat('·', width - strlen(substitute(text, '.', 'x', 'g'))) . info
endfunction

set foldtext=FoldPretty()
