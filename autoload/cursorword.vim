"SPDX-FileCopyrightText: 2024 Ash <contact@ash.fail>
"SPDX-License-Identifier: MIT

"MIT License

" Copyright (c) 2024 Ash contact@ash.fail

"Permission is hereby granted, free of charge, to any person obtaining a copy
"of this software and associated documentation files (the "Software"), to deal
"in the Software without restriction, including without limitation the rights
"to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
"copies of the Software, and to permit persons to whom the Software is
"furnished to do so, subject to the following conditions:

"The above copyright notice and this permission notice (including the next
"paragraph) shall be included in all copies or substantial portions of the
"Software.

"THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
"IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
"FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
"AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
"LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
"OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
"SOFTWARE.

let s:previous_match = ''
let s:timer = -1

function! s:cursorword_delete() abort
    let s:previous_match=''
    silent! call matchdelete(w:cursorword_match_id)
endfunction

function! s:cursorword_add_callback(...) abort
    " return if no word character under cursor
    if match(strcharpart(getline('.'), col('.') - 1, 1), '\m\w') == -1
        call s:cursorword_delete()
        return
    endif

    let cword = expand('<cword>')
    if cword ==# s:previous_match
        return
    endif

    call s:cursorword_delete()
    let s:previous_match=cword

    let max_len = get(g:, 'cursorword_max_len', 32)
    if len(cword) != 0 && (max_len == 0 || len(cword) <= max_len)
    let w:cursorword_match_id =
        \matchadd('CursorWord', '\m\V\C\<' . escape(cword, '/\') . '\>', -1)
    endif
endfunction

function! s:cursorword_add() abort
    if get(b:, 'cursorword_disable', get(g:, 'cursorword_disable'))
        return
    endif

    let delay = get(g:, 'cursorword_delay', 0)
    if delay == 0
        call s:cursorword_add_callback()
    else
        call timer_stop(s:timer)
        let s:timer = timer_start(delay, 's:cursorword_add_callback')
    endif
endfunction

function! cursorword#setup() abort
    if !exists('g:cursorword_delay')
        let g:cursorword_delay = 100
    endif

    hi default CursorWord cterm=underline gui=underline
    augroup cursorword
        au!
        au BufEnter,CursorMoved,CursorHold,InsertLeave * call s:cursorword_add()
        au BufLeave,InsertEnter,WinLeave * call s:cursorword_delete()
    augroup end
endfunction
