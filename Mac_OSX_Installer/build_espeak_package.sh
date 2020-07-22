#!/bin/bash

source ./build_env.sh

if [ ! -f "aeneas-mac-installer-packages/espeak-ng-$ESPEAK_VER.pkg" ]; then
        echo ""
	sudo port -qpf deactivate espeakedit espeak
	sudo port -Npf uninstall espeak-ng pcaudiolib sonic
	sudo port -N install espeak-ng
	sudo port -N mpkg espeak-ng
        SOURCETMP="$(mktemp -d -t espeak.src.XXXXXXXX)"
        BUILDTMP="$(mktemp -d -t espeak.build.XXXXXXXX)"
	pkgutil --expand-full `port work espeak-ng`/espeak-ng-$ESPEAK_VER.mpkg $SOURCETMP/espeak-ng-$ESPEAK_VER.mpkg
        SOURCETMP="$SOURCETMP/espeak-ng-$ESPEAK_VER.mpkg"
	mkdir -vp $BUILDTMP/Payload
	mkdir -vp $BUILDTMP/Scripts
	for PKG in $SOURCETMP/*.pkg; do 
		mv -v $PKG/Payload/* $BUILDTMP/Payload/
	done
        cat postinstall-scripts/postinstall_espeak.sh | sed 's#@PREFIX@#/opt/usr#g' > $BUILDTMP/Scripts/postinstall
	chmod +x $BUILDTMP/Scripts/postinstall
	pkgbuild --prior `port work espeak-ng`/espeak-ng-$ESPEAK_VER-component.pkg --root "$BUILDTMP/Payload" --scripts "$BUILDTMP/Scripts" "espeak-ng-$ESPEAK_VER.pkg"
        [ $? = 0 ] || exit 1
	sudo installer -pkg espeak-ng-$ESPEAK_VER.pkg -target /
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
