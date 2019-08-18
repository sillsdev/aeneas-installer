#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
cd $CURDIR
VERSION="1.7.3_1"

brew install danielbair/tap/create-dmg

DMGFILE="Aeneas_Tools-$VERSION.dmg"
BUILDTMP="$(mktemp -d -t createdmg.tmp.XXXXXXXX)"
rm -f "$DMGFILE"
create-dmg --volname Aeneas_Tools \
	--window-pos 20 20 \
	--icon-size 80 \
	--add-file aeneas-mac-setup-$VERSION.pkg aeneas-mac-setup-$VERSION.pkg 244 4 \
	--add-folder aeneas-mac-uninstall-scripts aeneas-mac-uninstall-scripts 344 144 \
	--add-folder aeneas-mac-installer-packages aeneas-mac-installer-packages 144 144 \
	$DMGFILE $BUILDTMP
rm -rf "$BUILDTMP"
open -R "$DMGFILE"
open "$DMGFILE"

cp -v Aeneas_Tools-$VERSION.dmg aeneas-mac-setup-$VERSION.dmg
