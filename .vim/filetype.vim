if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au BufRead,BufNewFile *.bats                set filetype=bash
    au BufRead,BufNewFile *.mw                  set filetype=mediawiki
    au BufRead,BufNewFile *.wiki                set filetype=mediawiki
    au BufRead,BufNewFile *.wikipedia.org*      set filetype=mediawiki
    au BufRead,BufNewFile *.wikibooks.org*      set filetype=mediawiki
    au BufRead,BufNewFile *.wikimedia.org*      set filetype=mediawiki
augroup END
