#!/bin/sh
curl -O http://mtgjson.com/json/AllCards.json.zip
unzip AllCards.json.zip
jq -r 'to_entries[] | {"key": .key} | .key' AllCards.json | sort > mtg-cardname-completion-list
