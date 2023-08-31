function! s:DiffSaved()
    let filetype=&filetype

    diffthis
    vnew
    read #
    normal! ggdd
    diffthis
    setlocal buftype=nofile bh=wipe nobl noswf ro
    let &filetype=filetype

    wincmd h
endfunction

com! DiffSaved call s:DiffSaved()
