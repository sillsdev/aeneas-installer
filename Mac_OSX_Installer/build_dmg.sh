#!/bin/bash

source ./build_env.sh

DMGFILE="Aeneas_Tools-$VERSION.dmg"
BUILDTMP="$(mktemp -d -t createdmg.tmp.XXXXXXXX)"

rm -f "$DMGFILE"
./create-dmg --volname Aeneas_Tools \
	--window-pos 20 20 \
	--icon-size 80 \
	--add-file aeneas-mac-setup-$VERSION.pkg aeneas-mac-setup-$VERSION.pkg 244 4 \
	--add-folder aeneas-mac-uninstall-scripts aeneas-mac-uninstall-scripts 344 184 \
	--add-folder aeneas-mac-installer-packages aeneas-mac-installer-packages 144 184 \
	$DMGFILE $BUILDTMP
rm -rf "$BUILDTMP"
open -R "$DMGFILE"
open "$DMGFILE"

cp -v Aeneas_Tools-$VERSION.dmg aeneas-mac-setup-$VERSION.dmg

exit 0
