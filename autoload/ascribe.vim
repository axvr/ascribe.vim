" Ascribe.vim - An alternative to EditorConfig.
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

function ascribe#set_up_buffer(file)
    let l:attrs = s:getAttrs(['expand-tab', 'tab-stop', 'final-newline',
                \ 'line-length', 'trim-trailing-whitespace', 'eol',
                \ 'binary'], a:file)

    if empty(l:attrs)
        return 1
    endif

    " Indentation
    if l:attrs['tab-stop'] !=# 'unspecified'
        call s:setOptVal(['softtabstop', 'shiftwidth', 'tabstop'], l:attrs['tab-stop'])
    endif

    let l:et = l:attrs['expand-tab']
    if l:et !=# 'unspecified'
        if l:et ==# 'unset'
            call s:setOptVal(['softtabstop', 'shiftwidth'], &l:tabstop)
        endif
        call s:setOptBool(['expandtab'], l:et)
    endif

    " Max line length
    call s:setOptVal(['textwidth'], l:attrs['line-length'])

    " EOL - End-of-line character(s) to use
    let l:eol = l:attrs['eol']
    if l:eol ==? 'lf'
        call s:setOptVal(['ff'], 'unix')
    elseif l:eol ==? 'crlf'
        call s:setOptVal(['ff'], 'dos')
    endif

    " EOF - Insert final newline
    call s:setOptBool(['fixeol'], l:attrs['final-newline'])

    " Binary mode
    call s:setOptBool(['binary', 'readonly'], l:attrs['binary'])

    " Trim trailing whitespace
    if l:attrs['trim-trailing-whitespace'] ==# 'set'
        exec 'autocmd! ascribe BufWritePre <buffer> call s:trim_trailing_whitespace()'
    endif
endfunction

function <SID>getAttrs(attrs, file)
    let l:cli_args = join(map(copy(a:attrs), '"\"" . v:val .  "\""'), ' ')
    let l:result = systemlist('git check-attr ' . l:cli_args . ' -- ' . shellescape(a:file))

    " Check if not in a Git repo
    if v:shell_error
        return {}
    endif

    let l:attr_dict = {}
    let l:itt = 0

    for l:a in a:attrs
        let l:match = matchlist(l:result[l:itt], '\m\C: \([0-9a-zA-Z_.-]\+\)$')

        if len(l:match[1]) == 0
            continue
        endif

        let l:attr_dict[l:a] = l:match[1]
        let l:itt = l:itt + 1
    endfor

    return l:attr_dict
endfunction

function <SID>setOptBool(opts, attr)
    for l:opt in a:opts
        if a:attr ==# 'set'
            exec 'silent! setlocal ' . l:opt
        elseif a:attr ==# 'unset'
            exec 'silent! setlocal no' . l:opt
        endif
    endfor
endfunction

function <SID>setOptVal(opts, attr)
    if a:attr !=# 'unspecified'
        for l:opt in a:opts
            exec 'silent! setlocal ' . l:opt . '=' . a:attr
        endfor
    endif
endfunction

function <SID>trim_trailing_whitespace()
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
endfunction
