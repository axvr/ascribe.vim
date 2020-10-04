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

let g:ascribe_handlers = {
    \   'expand-tab': function('ascribe#handlers#expand_tab'),
    \   'tab-stop': function('ascribe#handlers#tab_stop'),
    \   'eol': function('ascribe#handlers#eol'),
    \   'trim-trailing-whitespace': function('ascribe#handlers#trim_whitespace'),
    \   'final-newline': function('ascribe#handlers#final_newline'),
    \   'line-length': function('ascribe#handlers#line_length'),
    \   'binary': function('ascribe#handlers#binary')
    \ }

augroup ascribe
    autocmd!
    autocmd BufReadPost,BufNewFile * call ascribe#configure_buffer(expand('%:p'))
augroup END

unlockvar g:ascribe_loaded
let g:ascribe_loaded = 1
lockvar g:ascribe_loaded
