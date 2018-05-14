" Transforms a list of MTG card names into a line-separated list
" of words original to MTG.
"
" Source this file and then `:call TransformCardNamesToSpellingEntries()<CR>`
function! TransformCardNamesToSpellingEntries() " {{{
    %s/[")(.]//g
    %s/,\? /\r/g
    %sort u
    %call RemoveCorrectlySpelledWords()
endfunction

" }}}
function! RemoveCorrectlySpelledWords() range " {{{
    set spell
    set spelllang=en
    let l:lines = getline(a:firstline, a:lastline)
    let l:bad_words = []
    for l:line in l:lines
        let l:candidate = spellbadword(l:line)
        if !empty(l:candidate[0])
           call add(l:bad_words, l:line)
        endif
    endfor
    exec a:firstline + 1 . "," . a:lastline . "d"
    call setline(a:firstline, l:bad_words)
endfunction

" }}}
