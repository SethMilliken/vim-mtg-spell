#!/bin/sh
add_file="spell/mtg.utf-8.add"
spl_file="spell/mtg.utf-8.spl"
transform_file="mtg-spell-functions.vim"
completion_list="mtg-cardname-completion-list"
curl -O http://mtgjson.com/json/AllCards.json.zip
unzip -u AllCards.json.zip
jq -r 'to_entries[] | {"key": .key} | .key' AllCards.json | sort > ${completion_list}
cp ${completion_list} ${add_file}
vim +":so ${transform_file}" +":MakeMtgSpell" +":q" ${add_file}
ls -al ${spl_file}
