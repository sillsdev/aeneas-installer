#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
cd $CURDIR

brew install create-dmg
#brew install danielbair/tap/create-dmg

export aeneas_ver=`pip3 show aeneas | grep "Version:" | cut -d' ' -f2`
export VERSION="$aeneas_ver"_2

DMGFILE="Aeneas_Tools-$VERSION.dmg"
BUILDTMP="$(mktemp -d -t createdmg.tmp.XXXXXXXX)"
rm -f "$DMGFILE"
create-dmg --volname Aeneas_Tools \
	--window-pos 20 20 \
	--icon-size 80 \
	--add-file aeneas-mac-setup-$VERSION.pkg aeneas-mac-setup-$VERSION.pkg 144 144 \
	--add-folder aeneas-mac-uninstall-scripts aeneas-mac-uninstall-scripts 344 144 \
	$DMGFILE $BUILDTMP
rm -rf "$BUILDTMP"
open -R "$DMGFILE"
open "$DMGFILE"

cp -v Aeneas_Tools-$VERSION.dmg aeneas-mac-setup-$VERSION.dmg

exit 0
