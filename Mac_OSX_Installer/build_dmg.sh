#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
cd $CURDIR

brew install danielbair/tap/create-dmg

mkdir -p aeneas-mac-uninstall-scripts
cp _*.sh aeneas-mac-uninstall-scripts
VERSION="1.7.1"
DMGFILE="Aeneas_Tools-$VERSION.dmg"
BUILDTMP="$(mktemp -d -t createdmg.tmp.XXXXXXXX)"
rm -f "$DMGFILE"
create-dmg --volname Aeneas_Tools \
	--window-pos 20 20 \
	--icon-size 80 \
	--add-file aeneas-mac-setup-$VERSION.pkg aeneas-mac-setup-$VERSION.pkg 144 144 \
	--add-folder aeneas-mac-uninstall-scripts aeneas-mac-uninstall-scripts 344 144 \
	$DMGFILE $BUILDTMP
rm -rf aeneas-mac-uninstall-scripts
rm -rf "$BUILDTMP"
open -R "$DMGFILE"
open "$DMGFILE"
