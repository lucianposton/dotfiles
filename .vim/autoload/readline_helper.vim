" Useful bits from other plugins:
" https://github.com/ryvnf/readline.vim
" https://github.com/tpope/vim-rsi


" [:alnum:] and [:alpha:] only matches ASCII characters.  But we can use the
" fact that [:upper:] and [:lower:] will match non-ASCII characters to create
" a pattern that will match alphanumeric characters from all encodings.
let s:wordchars = '[[:upper:][:lower:][:digit:]]'

" buffer to hold the previously deleted text
let s:yankbuf = ''

" Get the current cursor position on the edit line.  This differs from
" getcmdpos in that it counts chars intead of bytes and starts counting at 0.
function s:getcur()
  return strchars((getcmdline() . " ")[:getcmdpos() - 1]) - 1
endfunction

" Get end position of next word.  Argument x is the position to search from.
function s:next_word(x)
  let s = getcmdline()
  let n = strchars(s)
  let x = a:x
  while x < n && strcharpart(s, x, 1) !~ s:wordchars
    let x += 1
  endwhile
  while x < n && strcharpart(s, x, 1) =~ s:wordchars
    let x += 1
  endwhile
  return x
endfunction

" Get mapping to delete from cursor to position.  Argument x is the position
" to delete to.  Argument y represents the current cursor position (note that
" this _must_ be in sync with the real cursor position).
function s:delete_to(x, y)
  if a:y == a:x
    return ""
  endif
  if a:y < a:x
    let s:yankbuf = strcharpart(getcmdline(), a:y, a:x - a:y)
    return repeat("\<del>", a:x - a:y)
  endif
  let s:yankbuf = strcharpart(getcmdline(), a:x, a:y - a:x)
  return repeat("\b", a:y - a:x)
endfunction

" get mapping to delete word in front of cursor
function readline_helper#delete_word()
  let x = s:getcur()
  return s:delete_to(s:next_word(x), x)
endfunction
