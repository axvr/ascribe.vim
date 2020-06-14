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

function! ascribe#configure_buffer(file)
    let b:attributes = s:get_attributes(keys(g:ascribe_handlers), a:file)

    for l:attr in keys(b:attributes)
        call g:ascribe_handlers[l:attr](b:attributes[l:attr])
    endfor
endfunction

function! <SID>get_attributes(attrs, file)
    let l:cli_args = join(map(copy(a:attrs), '"\"" . v:val .  "\""'), ' ')
    let l:result = systemlist('git check-attr ' . l:cli_args . ' -- ' . shellescape(a:file))

    let l:attr_dict = {}

    " Check if not in a Git repo
    if v:shell_error
        return l:attr_dict
    endif

    let l:item = 0

    for l:a in a:attrs
        let l:match = matchlist(l:result[l:item], '\m\C: \([0-9a-zA-Z_.-]*\)$')

        let l:item = l:item + 1

        let l:value = l:match[1]

        if l:value ==# 'unspecified'
            continue
        elseif l:value ==# 'set'
            let l:value = 1
        elseif l:value ==# 'unset'
            let l:value = 0
        endif

        let l:attr_dict[l:a] = l:value
    endfor

    return l:attr_dict
endfunction
