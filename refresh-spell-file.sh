#!/bin/sh
add_file="spell/mtg.utf-8.add"
spl_file="spell/mtg.utf-8.spl"
transform_file="mtg-spell-functions.vim"
completion_list="mtg-cardname-completion-list"
candidate_list="mtg-raw-word-list"

curl -L -O http://mtgjson.com/json/AllCards.json.zip
curl -L -O http://mtgjson.com/json/AllPrintings.json.zip
curl -L -O http://mtgjson.com/json/SetList.json
unzip -f -u AllCards.json.zip
unzip -f -u AllPrintings.json.zip

# Card Names
jq -r 'to_entries[] | {"key": .key} | .key' AllCards.json | sort | tee ${completion_list} > ${candidate_list}

# Set Names
jq -r '.[].name' SetList.json | sort >> ${candidate_list}

# Set Codes
jq -r '.[].code | ascii_upcase' SetList.json | sort >> ${candidate_list}

# Card Text
jq -r 'to_entries[] | {"text": .value.text} | .text' AllCards.json >> ${candidate_list}

cp ${candidate_list} ${add_file}
vim +":so ${transform_file}" +":MakeMtgSpell" +":q" ${add_file}

ls -al ${spl_file}
