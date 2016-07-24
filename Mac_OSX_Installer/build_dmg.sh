#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
echo cd $CURDIR
cd $CURDIR

brew install danielbair/tap/create-dmg

mkdir -p aeneas-mac-uninstall-scripts
cp _*.sh aeneas-mac-uninstall-scripts
DMGFILE="Aeneas_Tools-1.5.0.3.dmg"
BUILDTMP="$(mktemp -d -t createdmg.tmp.XXXXXXXX)"
rm -f "$DMGFILE"
create-dmg --volname Aeneas_Tools \
	--window-pos 20 20 \
	--icon-size 80 \
	--add-file aeneas-mac-setup-1.5.0.3.pkg aeneas-mac-setup-1.5.0.3.pkg 144 144 \
	--add-folder aeneas-mac-uninstall-scripts aeneas-mac-uninstall-scripts 344 144 \
	$DMGFILE $BUILDTMP
rm -rf aeneas-mac-uninstall-scripts
rm -rf "$BUILDTMP"
open -R "$DMGFILE"
open "$DMGFILE"

