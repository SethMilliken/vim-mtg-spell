" Transforms a list of MTG card names into a line-separated list
" of words original to MTG.
"
" Source this file and then `:MakeMtgSpell<CR>`
command! MakeMtgSpell :call MakeMtgSpell()

let s:script_path = expand('<sfile>:p:h')

function! MakeMtgSpell() " {{{
    call TransformCardNamesToSpellingEntries()
    call SaveSpellingFile()
endfunction

" }}}
function! SaveSpellingFile() " {{{
    let splfile = s:script_path . "/spell/mtg.utf-8.spl"
    let addfile = s:script_path . "/spell/mtg.utf-8.add"
    exe "saveas! " . addfile
    exe "mkspell! " . splfile . " " . addfile
endfunction

" }}}
function! TransformCardNamesToSpellingEntries() " {{{
    %s/[")(.]//ge
    %s/,\? /\r/ge
    %s/://ge
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
