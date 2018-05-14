# vim-mtg-spell
MTG Spelling Dictionary for Vim

To create this spelling file:

Obtain raw list of MTG card names:
- Ensure `jq` is installed.
- Download http://mtgjson.com/json/AllCards.json.zip
- `jq -r 'to_entries[] | {"key": .key} | .key' AllCards.json > mtg.utf-8.add`

Transform list into spell file:
- `vim mtg.utf-8.add`
- `:source transform_names_to_entries.vim`
- `:call TransformCardNamesToSpellingEntries()`
- `:mkspell! ~/.vim/bundle/vim-mtg-spell/spell/mtg.utf-8.spl ~/.vim/bundle/vim-mtg-spell/spell/mtg.utf-8.add`

To use:
- `set spelllang=en,mtg`
- `set spell`

To enable `<C-n>` completion from the spellfile:
- `set complete+=k`
