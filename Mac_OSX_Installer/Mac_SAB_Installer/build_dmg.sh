#!/bin/bash

if [ ! -f "/usr/local/bin/node" ]; then
	brew install node
fi
if [ ! -f "/usr/local/bin/appdmg" ]; then
	npm install -g appdmg
fi
if [ ! -f "/Applications/Scripture App Builder.app" ]; then
	open "https://drive.google.com/uc?export=download&id=0BzKJe4QoGwmXZHFQOXNTT2w4eHc"
	echo "Cannot find /Applications/Scripture App Builder.app"
	exit
fi

rm -vf ./Scripture\ App\ Builder-1.11.1.dmg
appdmg appdmg.json ./Scripture\ App\ Builder-1.11.1.dmg
open -R ./Scripture\ App\ Builder-1.11.1.dmg
open ./Scripture\ App\ Builder-1.11.1.dmg

