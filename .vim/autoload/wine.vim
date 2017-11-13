" Usage:
"
" 1) Copy the VTBL spec from the C header to the C source file
"
"    BEGIN_INTERFACE
"
"    /*** IUnknown methods ***/
"    HRESULT (STDMETHODCALLTYPE *QueryInterface)(
"    ...
"
"    END_INTERFACE
"
" 2) :call wine#stub_interface()
"
" 3) Do these substitutions using your new object name:
"
" :%s/@SWAPPREFIX@/dll_object/g
" :%s/@SWAPIFACE@/IDLLObject/g
"
" Clean up formatting, fix AddRef, Release, return values, etc.

function! wine#stub_interface()
    " Make copy of vtable spec
    :0/BEGIN_INTERFACE/;/END_INTERFACE/co 0/END_INTERFACE/

    " Transform first copy into function stubs
    :0/BEGIN_INTERFACE/+1;/END_INTERFACE/-1g/\/\*.*\*\//d
    :0/BEGIN_INTERFACE/+1;/END_INTERFACE/-1s/^\s*\(.*\) (STDMETHODCALLTYPE \*/static \1 WINAPI @SWAPPREFIX@_/
    :0/BEGIN_INTERFACE/+1;/END_INTERFACE/-1s/)(/(/
    :0/BEGIN_INTERFACE/+1;/END_INTERFACE/-1s/This/iface/
    :0/BEGIN_INTERFACE/+1;/END_INTERFACE/-1s/;/\r{\r    struct @SWAPPREFIX@ *This = impl_from_@SWAPIFACE@(iface);\r    FIXME("%p stub!\\n", This);\r    return E_NOTIMPL;\r}/
    :0/BEGIN_INTERFACE/s/\s*BEGIN_INTERFACE/
                \WINE_DEFAULT_DEBUG_CHANNEL(dll); \/\/ TODO\r\r
                \struct @SWAPPREFIX@\r
                \{\r
                \    @SWAPIFACE@ @SWAPIFACE@_iface;\r
                \    LONG refcount;\r
                \};\r\r
                \static inline struct @SWAPPREFIX@ *impl_from_@SWAPIFACE@(@SWAPIFACE@ *iface)\r
                \{\r
                \    return CONTAINING_RECORD(iface, struct @SWAPPREFIX@, @SWAPIFACE@_iface);\r
                \}
    :0/END_INTERFACE/d

    " Transform second copy into vtable
    :0/BEGIN_INTERFACE/+1;/END_INTERFACE/-1s/^.*[^\(]$\n//
    :0/BEGIN_INTERFACE/+1;/END_INTERFACE/-1s/^$\n//g
    :0/BEGIN_INTERFACE/+1;/END_INTERFACE/-1s/^.*\*/    @SWAPPREFIX@_/
    :0/BEGIN_INTERFACE/+1;/END_INTERFACE/-1s/)(/,/
    :0/BEGIN_INTERFACE/s/\s*BEGIN_INTERFACE/static const struct @SWAPIFACE@Vtbl @SWAPPREFIX@_vtbl =\r{/
    :0/END_INTERFACE/s/\s*END_INTERFACE/
                \};\r
                \\/\/ :%s\/@SWAPIFACE@\/IDLLObject\/g\r
                \\/\/ :%s\/@SWAPPREFIX@\/dll_object\/g\r
                \\/\/ Clean up formatting, fix AddRef, Release, return values, etc/
endfunction

