#!/bin/bash

source ./build_env.sh

CURDIR=`pwd`
cd "$CURDIR"

if [ ! -f "aeneas-mac-installer-packages/python-$PYTHON_VER.pkg" ]; then
        echo -e "\n\nBuilding python-$PYTHON_VER.pkg\n\n"
	#sudo port -Npfu uninstall --follow-dependents python38
	#sudo port -Npfk install --no-rev-upgrade python38
	#sudo port select --set python python38
	#sudo port select --set python3 python38
	sudo port -Npf mpkg python38
        SOURCETMP="$(mktemp -d -t python.src.XXXXXXXX)"
        BUILDTMP="$(mktemp -d -t python.build.XXXXXXXX)"
	pkgutil --expand-full `port work python38`/python38-$PYTHON_VER.mpkg $SOURCETMP/python38-$PYTHON_VER.mpkg
        SOURCETMP="$SOURCETMP/python38-$PYTHON_VER.mpkg"
	mkdir -vp $BUILDTMP/Payload
	mkdir -vp $BUILDTMP/Scripts
	for PKG in $SOURCETMP/*.pkg; do 
		#cp -va $PKG/Payload/* $BUILDTMP/Payload/
		ditto -v $PKG/Payload $BUILDTMP/Payload
	done
        cat postinstall-scripts/postinstall_python | sed 's#@PREFIX@#/opt/usr#g' > $BUILDTMP/Scripts/postinstall
	chmod +x $BUILDTMP/Scripts/postinstall
	cd "$BUILDTMP"
	#find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf
	for file in `find Payload -type f | perl -lne 'print if -B'`; do
		codesign -s "Developer ID Application" -v --force --entitlements "$CURDIR/entitlements.plist" --deep --options hard "$file"
	done
	cd "$CURDIR"
	pkgbuild --prior `port work python38`/python38-$PYTHON_VER-component.pkg --version "$PYTHON_VER" --root "$BUILDTMP/Payload" --scripts "$BUILDTMP/Scripts" "python-$PYTHON_VER.pkg"
        [ $? = 0 ] || exit 1
	sudo installer -pkg python-$PYTHON_VER.pkg -target / -dumplog -verboseR
        [ $? = 0 ] || exit 1
	mv python-$PYTHON_VER.pkg aeneas-mac-installer-packages/
	rm -rf $SOURCETMP
        rm -rf $BUILDTMP
else
        echo "Found python-$PYTHON_VER.pkg"
fi

sudo -H /opt/usr/bin/python3 -m ensurepip
sudo -H /opt/usr/bin/python3 -m pip install -U setuptools pip wheel

cd $CURDIR

#echo -e "\n\nNow run build_installer.sh\n\n"

exit 0
