python
import os
def load_my_gdb_modules():
    for root, dirs, files in os.walk(os.path.expanduser('~/.gdbinit-modules.d/')):
        dirs.sort()
        for init in sorted(files):
            path = os.path.join(root, init)
            _, ext = os.path.splitext(path)
            if ext != '.disabled':
                gdb.execute('source ' + path)
load_my_gdb_modules()
del load_my_gdb_modules
end


# enable auto-load universally
#set auto-load safe-path /

# use intel assembly syntax over att syntax
set disassembly-flavor intel

set history filename ~/.gdb_history
set history save
set confirm off
set verbose off

set print pretty on
set print array off
set print array-indexes on

set output-radix 10.
set input-radix 10.
#set output-radix 010
#set input-radix 010
#set output-radix 0x10
#set input-radix 0x10
