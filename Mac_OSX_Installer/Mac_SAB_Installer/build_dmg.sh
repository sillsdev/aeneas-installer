#!/bin/bash

if [ ! -f "/usr/local/bin/node" ]; then
	brew install node
fi
if [ ! -f "/usr/local/bin/appdmg" ]; then
	npm install -g appdmg
fi

rm -vf ./Scripture\ App\ Builder-1.11.1.dmg
appdmg appdmg.json ./Scripture\ App\ Builder-1.11.1.dmg
open -R ./Scripture\ App\ Builder-1.11.1.dmg
open ./Scripture\ App\ Builder-1.11.1.dmg

