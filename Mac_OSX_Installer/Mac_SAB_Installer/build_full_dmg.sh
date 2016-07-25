#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
echo cd $CURDIR
cd $CURDIR

brew install danielbair/tap/create-dmg

mkdir -p aeneas-mac-uninstall-scripts
cp ../_*.sh aeneas-mac-uninstall-scripts
# VERSION="1.5.0.3"
VERSION="1.5.1.0"
DMGFILE="Scripture_App_Builder-1.11.1.dmg"
BUILDTMP="$(mktemp -d -t createdmg.tmp.XXXXXXXX)"
cp -r /Applications/Scripture\ App\ Builder.app $BUILDTMP
rm -f "$DMGFILE"
create-dmg --volname Scripture_App_Builder \
	--icon-size 80 \
	--window-pos 20 20 \
	--window-size 800 480 \
	--background background.png \
	--icon 'Scripture App Builder.app' 142 344 \
	--app-drop-link 398 344 \
	--add-file aeneas-mac-setup-$VERSION.pkg ../aeneas-mac-setup-$VERSION.pkg 654 344 \
	--add-folder aeneas-mac-uninstall-scripts aeneas-mac-uninstall-scripts 398 544 \
	$DMGFILE $BUILDTMP
rm -rf aeneas-mac-uninstall-scripts
rm -rf "$BUILDTMP"
open -R "$DMGFILE"
open "$DMGFILE"

