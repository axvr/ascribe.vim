" Ascribe.vim -- A simpler alternative to EditorConfig.
"
" Written in 2019 by Alex Vear <alex@vear.uk>
"
" To the extent possible under law, the author(s) have dedicated all
" copyright and related and neighboring rights to this software to the
" public domain worldwide. This software is distributed without any
" warranty.
"
" You should have received a copy of the CC0 Public Domain Dedication
" along with this software. If not, see
" <http://creativecommons.org/publicdomain/zero/1.0/>.

" Null handler used to disable behaviour for an attribute.
function! ascribe#handlers#null(v) dict
endfunction

function! ascribe#handlers#binary(value) dict
    call s:set_bool_opt(['binary', 'readonly'], a:value)
endfunction

" EOF - Insert final newline
function! ascribe#handlers#final_newline(value) dict
    call s:set_bool_opt(['fixeol'], a:value)
endfunction

" EOL - End-of-line character(s) to use
function! ascribe#handlers#eol(eol) dict
    if a:eol ==? 'lf'
        call s:set_val_opt(['ff'], 'unix')
    elseif a:eol ==? 'crlf'
        call s:set_val_opt(['ff'], 'dos')
    endif
endfunction

" Max line length
function! ascribe#handlers#line_length(length) dict
    call s:set_val_opt(['textwidth'], a:length)
endfunction

function! ascribe#handlers#tab_stop(width) dict
    call s:set_val_opt(['softtabstop', 'shiftwidth', 'tabstop'], a:width)
endfunction

function! ascribe#handlers#expand_tab(et) dict
    if !a:et && !has_key(b:attributes, 'tab-stop')
        call self['tab-stop'](&l:tabstop)
    endif
    call s:set_bool_opt(['expandtab'], a:et)
endfunction

" Trim trailing whitespace
function! ascribe#handlers#trim_whitespace(trim) dict
    let is_trim_enabled = get(b:, 'ascribe_trim')

    if a:trim
        if !is_trim_enabled
            augroup ascribe_trim
                autocmd BufWritePre <buffer> call s:trim_whitespace()
            augroup END
            let b:ascribe_trim = 1
            lockvar b:ascribe_trim
        endif
    elseif is_trim_enabled
        augroup ascribe_trim
            autocmd! BufWritePre <buffer>
        augroup END
        unlet b:ascribe_trim
    endif
endfunction

function! <SID>trim_whitespace()
    let view = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(view)
endfunction

function! <SID>set_bool_opt(opts, set)
    for l:opt in a:opts
        exec 'silent! setlocal ' . (a:set ? '' : 'no') . l:opt
    endfor
endfunction

function! <SID>set_val_opt(opts, val)
    for l:opt in a:opts
        exec 'silent! setlocal ' . l:opt . '=' . a:val
    endfor
endfunction
