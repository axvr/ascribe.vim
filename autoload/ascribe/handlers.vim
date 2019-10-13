" Ascribe.vim -- An alternative to EditorConfig.
"
" Written in 2019 by Alex Vear <av@axvr.io>
"
" To the extent possible under law, the author(s) have dedicated all
" copyright and related and neighboring rights to this software to the
" public domain worldwide. This software is distributed without any
" warranty.
"
" You should have received a copy of the CC0 Public Domain Dedication
" along with this software. If not, see
" <http://creativecommons.org/publicdomain/zero/1.0/>.

function ascribe#handlers#binary(value) dict
    call s:set_bool_opt(['binary', 'readonly'], a:value)
endfunction

" EOF - Insert final newline
function ascribe#handlers#final_newline(value) dict
    call s:set_bool_opt(['fixeol'], a:value)
endfunction

" EOL - End-of-line character(s) to use
function ascribe#handlers#eol(eol) dict
    if a:eol ==? 'lf'
        call s:set_val_opt(['ff'], 'unix')
    elseif a:eol ==? 'crlf'
        call s:set_val_opt(['ff'], 'dos')
    endif
endfunction

" Max line length
function ascribe#handlers#line_length(length) dict
    call s:set_val_opt(['textwidth'], a:length)
endfunction

function ascribe#handlers#tab_stop(width) dict
    call s:set_val_opt(['softtabstop', 'shiftwidth', 'tabstop'], a:width)
endfunction

function ascribe#handlers#expand_tab(et) dict
    if !a:et
        if has_key(b:attributes, 'tab-stop')
            call self['tab-stop'](b:attributes['tab-stop'])
        else
            call self['tab-stop'](&l:tabstop)
        endif
    endif
    call s:set_bool_opt(['expandtab'], a:et)
endfunction

" Trim trailing whitespace
function ascribe#handlers#trim_whitespace(trim) dict
    if a:trim
        exec 'autocmd! ascribe BufWritePre <buffer> call s:trim_whitespace()'
    endif
endfunction

function <SID>trim_whitespace()
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
endfunction

function <SID>set_bool_opt(opts, set)
    for l:opt in a:opts
        exec 'silent! setlocal ' . (a:set ? '' : 'no') . l:opt
    endfor
endfunction

function <SID>set_val_opt(opts, val)
    for l:opt in a:opts
        exec 'silent! setlocal ' . l:opt . '=' . a:val
    endfor
endfunction