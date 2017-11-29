" -----------------------------------------------------------------------------
"  Additional optional highlighting
" -----------------------------------------------------------------------------

" Operators
"syn match cOperator "[[:alnum:][:blank:]._][><:?|&!~%^=*/+-][[:alnum:][:blank:]._]"ms=s+1,me=e-1
"syn match cOperator "[[:alnum:][:blank:]._]\zs[><:?|&!~%^=*/+-]\ze[[:alnum:][:blank:]._]"
syn match cOperator "\(^\|[][:alnum:][:blank:]._()]\)\@1<=[:?|&!~%^=*/+-]\($\|[[:alnum:][:blank:]._()]\)\@=" " > < . , left out
syn match cOperator display "\(<<\|>>\|[-+*/%&^|]\)=" " <= >= != == left out
syn match cOperator display "::\|&&\|||\|++\|--\|!!\|\*\*" " << >> -> left out
"syn match cOperator	"/[^/*=]"me=e-1
"syn match cOperator	"/$"
syn match cOperator display "[][]"

"" Delimiters
syn match cDelimiter display   "\\"
syn match cSubtle display   "[;,]"
"syn match cBraces display "[{}]"

" Links
hi def link cDelimiter Delimiter
"hi def link cBraces Delimiter

" Colors
hi cSubtle ctermfg=darkgray
