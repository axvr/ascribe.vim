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

function! ascribe#configure_buffer(file)
    let global = get(g:, 'ascribe_handlers', {})
    let local  = get(b:, 'ascribe_handlers', {})
    let handlers = extend(copy(local), global, "keep")

    unlet! b:attributes
    let b:attributes = s:get_attributes(keys(handlers), a:file)

    for attr in keys(b:attributes)
        call handlers[attr](b:attributes[attr])
    endfor

    lockvar 2 b:attributes
endfunction

function! <SID>get_attributes(attrs, file)
    let attr_str = join(map(copy(a:attrs), '"\"" . v:val .  "\""'), ' ')
    let path = shellescape(fnamemodify(a:file, ':h'))
    let fname = shellescape(fnamemodify(a:file, ':t'))
    let cmd = 'git -C ' . path . ' check-attr ' . attr_str . ' -- ' . fname

    silent let result = systemlist(cmd)

    let attr_dict = {}

    " Check if Git is installed and in Git repo.
    if v:shell_error
        return attr_dict
    endif

    " Error reporting
    let idx = 0
    for ln in result
        if ln =~# 'is not a valid attribute name:'
            echohl Warning
            echomsg ln
            echohl None
            let idx = idx + 1
        else
            let result = result[idx:]
            break
        endif
    endfor

    let item = 0

    for a in a:attrs
        let match = matchlist(result[item], '\m\C: \([0-9a-zA-Z_.-]*\)$')

        let item = item + 1

        let value = match[1]

        if value ==# 'unspecified'
            continue
        elseif value ==# 'set'
            let value = 1
        elseif value ==# 'unset'
            let value = 0
        endif

        let attr_dict[a] = value
    endfor

    return attr_dict
endfunction
