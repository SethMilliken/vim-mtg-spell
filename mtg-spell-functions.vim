" Transforms a buffer of words from various MTG sources (e.g. card
" names, set names, rules text) into a line-separated list of words
" original to MTG and uses this list to generate a vim spell-file.
"
" Source this file and then `:MakeMtgSpell<CR>`
command! MakeMtgSpell :call MakeMtgSpell()

let s:script_path = expand('<sfile>:p:h')

function! MakeMtgSpell() " {{{
    call TransformBufferWordsToSpellingEntries()
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
function! TransformBufferWordsToSpellingEntries() " {{{
    " Remove non-word characters
    %s/[".]//ge
    %s/[)(:—]/ /ge
    " Every word on a separate line
    %s/,\? /\r/ge
    call RemoveSpecialCases()
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
function! RemoveSpecialCases() " {{{
    " Onay igpay atinlay
    g/^\(\l\|-\)*ay$/d
    g/Oubleday/d
    " Don't need pi
    %s/π//ge
    " Remove Augment names
    g/-$/d
    " No
    g/AskUrza/d
    " Remove Alchemy versions
    g/^A-/d
    " Remove mispellings
    g/creatire/d
    g/palys/d
endfunction

" }}}
