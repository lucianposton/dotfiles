#!/bin/sh

# diff is called by git with 7 parameters:
# $1   $2       $3      $4       $5       $6      $7
# path old-file old-hex old-mode new-file new-hex new-mode

echo "diff binary $1"

cmp -l "$2" "$5" |
awk 'function oct2dec(oct,     dec) {
          for (i = 1; i <= length(oct); i++) {
              dec *= 8;
              dec += substr(oct, i, 1)
          };
          return dec
      }
      {
          printf "%08X %02X %02X\n", $1, oct2dec($2), oct2dec($3)
      }' |
cat
