#!/bin/bash

if [ ! -f "/usr/local/bin/node" ]; then
	brew install node
fi
if [ ! -f "/usr/local/bin/appdmg" ]; then
	npm install -g appdmg
fi

rm -vf ./build/Scripture\ App\ Builder-1.11.1.dmg
appdmg appdmg.json ./build/Scripture\ App\ Builder-1.11.1.dmg
open -R ./build/Scripture\ App\ Builder-1.11.1.dmg
open ./build/Scripture\ App\ Builder-1.11.1.dmg

