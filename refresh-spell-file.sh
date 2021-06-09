#!/bin/sh
add_file="spell/mtg.utf-8.add"
spl_file="spell/mtg.utf-8.spl"
transform_file="mtg-spell-functions.vim"
completion_list="mtg-cardname-completion-list"
candidate_list="mtg-raw-word-list"
mtgjson_home="https://mtgjson.com/api/v5"

if [ $# == 0 ]; then
curl -L -O ${mtgjson_home}/AtomicCards.json.zip
curl -L -O ${mtgjson_home}/AllPrintings.json.zip
curl -L -O ${mtgjson_home}/SetList.json
fi
unzip -u AtomicCards.json.zip
unzip -u AllPrintings.json.zip

# Card Names
jq -r '.data[] | to_entries[] | .value | .name' AtomicCards.json | sort | tee ${completion_list} > ${candidate_list}

# Set Names
jq -r '.data[] | .name' SetList.json | sort >> ${candidate_list}

# Set Codes
jq -r '.data[] | .code | ascii_upcase' SetList.json | sort >> ${candidate_list}

# Card Text
jq -r '.data[] | to_entries[] | .value | .text' AtomicCards.json >> ${candidate_list}

cp ${candidate_list} ${add_file}
vim +":so ${transform_file}" +":MakeMtgSpell" +":q" ${add_file}

ls -al ${spl_file}
