#!/bin/bash

source ./build_env.sh

CURDIR=`pwd`
cd "$CURDIR"

if [ ! -f "aeneas-mac-installer-packages/espeak-ng-$ESPEAK_VER.pkg" ]; then
        echo -e "\n\nBuilding espeak-ng-$ESPEAK_VER.pkg\n\n"
	sudo port -Npf uninstall espeak-ng pcaudiolib sonic
	sudo port -Npf install espeak-ng
	sudo port -Npf mpkg espeak-ng
        SOURCETMP="$(mktemp -d -t espeak.src.XXXXXXXX)"
        BUILDTMP="$(mktemp -d -t espeak.build.XXXXXXXX)"
	pkgutil --expand-full `port work espeak-ng`/espeak-ng-$ESPEAK_VER.mpkg $SOURCETMP/espeak-ng-$ESPEAK_VER.mpkg
        SOURCETMP="$SOURCETMP/espeak-ng-$ESPEAK_VER.mpkg"
	mkdir -vp $BUILDTMP/Payload
	mkdir -vp $BUILDTMP/Scripts
	for PKG in $SOURCETMP/*.pkg; do 
		cp -va $PKG/Payload/* $BUILDTMP/Payload/
	done
        cat postinstall-scripts/postinstall_espeak | sed 's#@PREFIX@#/opt/usr#g' > $BUILDTMP/Scripts/postinstall
	chmod +x $BUILDTMP/Scripts/postinstall
	cd "$BUILDTMP"
	for file in `find Payload -type f | perl -lne 'print if -B'`; do
		codesign -s "Developer ID Application" -v --force --entitlements "$CURDIR/entitlements.plist" --deep --options hard "$file"
	done
	cd "$CURDIR"
	pkgbuild --prior `port work espeak-ng`/espeak-ng-$ESPEAK_VER-component.pkg --root "$BUILDTMP/Payload" --scripts "$BUILDTMP/Scripts" "espeak-ng-$ESPEAK_VER.pkg"
        [ $? = 0 ] || exit 1
	sudo installer -pkg espeak-ng-$ESPEAK_VER.pkg -target / -dumplog -verboseR
        [ $? = 0 ] || exit 1
	mv espeak-ng-$ESPEAK_VER.pkg aeneas-mac-installer-packages/
	rm -rf $SOURCETMP
        rm -rf $BUILDTMP
else
        echo "Found espeak-ng-$ESPEAK_VER.pkg"
fi

cd $CURDIR

#echo -e "\n\nNow run build_installer.sh\n\n"

exit 0
