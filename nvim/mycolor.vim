" :call Color("ASK")
" # leader h to highlight word under cursor

let bg="black"
" cterm=bold
execute 'hi Red ctermfg=red ctermbg=' . bg
execute 'hi Green ctermfg=green ctermbg=' . bg
execute 'hi Blue ctermfg=blue ctermbg=' . bg

let g:match_counter = 1


function! Color(pattern)
    if g:match_counter == 1
        execute 'match Red /' . a:pattern . '/'
        let g:match_counter = 2
    elseif g:match_counter == 2
        execute '2match Green /' . a:pattern . '/'
        let g:match_counter = 3
    elseif g:match_counter == 3
        execute '3match Blue /' . a:pattern . '/'
        let g:match_counter = 1
    endif
endfunction

function! HighlightCurrentWord()
    let l:word = expand('<cword>')
    call Color(l:word)
endfunction

command! -nargs=1 Color call Color(<f-args>)
nnoremap <silent> <leader>h :call HighlightCurrentWord()<CR>

