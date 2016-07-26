#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
echo cd $CURDIR
cd $CURDIR

brew install danielbair/tap/create-dmg

# mkdir -p aeneas-mac-uninstall-scripts
# cp _*.sh aeneas-mac-uninstall-scripts
DMGFILE="Scripture_App_Builder-1.11.1.dmg"
BUILDTMP="$(mktemp -d -t createdmg.tmp.XXXXXXXX)"
cp -r /Applications/Scripture\ App\ Builder.app $BUILDTMP
rm -f "$DMGFILE"
create-dmg --volname Scripture_App_Builder \
	--window-pos 20 20 \
	--icon-size 80 \
	--icon 'Scripture App Builder.app' 144 144 \
	--app-drop-link 344 144 \
	$DMGFILE $BUILDTMP
# rm -rf aeneas-mac-uninstall-scripts
rm -rf "$BUILDTMP"
open -R "$DMGFILE"
open "$DMGFILE"

