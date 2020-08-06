#!/bin/bash

source ./build_env.sh

CURDIR=`pwd`
cd "$CURDIR"

if [ ! -f "aeneas-mac-installer-packages/python-$PYTHON_VER.pkg" ]; then
        echo -e "\n\nBuilding python-$PYTHON_VER.pkg\n\n"
        if [ ! -f "./python-$PYTHON_VER-macosx10.9.pkg" ]; then
		wget --trust-server-names https://www.python.org/ftp/python/$PYTHON_VER/python-$PYTHON_VER-macosx10.9.pkg
        fi
        SOURCETMP="$(mktemp -d -t python.src.XXXXXXXX)"
        BUILDTMP="$(mktemp -d -t python.build.XXXXXXXX)"

	pkgutil --expand-full python-$PYTHON_VER-macosx10.9.pkg $SOURCETMP/python-$PYTHON_VER-macosx10.9.pkg
        SOURCETMP="$SOURCETMP/python-$PYTHON_VER-macosx10.9.pkg"

	mkdir -vp $BUILDTMP/Payload
	mkdir -vp $BUILDTMP/Scripts
	#touch $BUILDTMP/Scripts/postinstall
	echo "#!/bin/sh" > $BUILDTMP/Scripts/postinstall
	PKGS="Python_Framework.pkg
Python_Command_Line_Tools.pkg
Python_Shell_Profile_Updater.pkg
Python_Install_Pip.pkg
Python_Documentation.pkg
Python_Applications.pkg"
	for PKG in $PKGS; do 
		PKG_ROOT=`cat $SOURCETMP/$PKG/PackageInfo | grep "install-location" | cut -d' ' -f10 | cut -d'=' -f2 | cut -d'"' -f2` 
		if [ -n "$PKG_ROOT" ]; then
			#mkdir -vp $BUILDTMP/Payload$PKG_ROOT
			ditto -v $SOURCETMP/$PKG/Payload $BUILDTMP/Payload$PKG_ROOT
		fi
		SCRIPT_NAME="`basename $PKG`-postinstall"
		if [ -f "$SOURCETMP/$PKG/Scripts/postinstall" ]; then
			cp -va $SOURCETMP/$PKG/Scripts/postinstall $BUILDTMP/Scripts/$SCRIPT_NAME
			echo "/bin/sh ./$SCRIPT_NAME" >> $BUILDTMP/Scripts/postinstall
		fi
	done
	echo "exit 0" >> $BUILDTMP/Scripts/postinstall
	chmod +x $BUILDTMP/Scripts/postinstall
	cd "$BUILDTMP"
	for file in `find Payload -type f | perl -lne 'print if -B'`; do
		codesign -s "Developer ID Application" -v --force --entitlements "$CURDIR/entitlements.plist" --deep --options hard "$file"
	done
	cd "$CURDIR"
	pkgbuild --root "$BUILDTMP/Payload" --identifier "org.python.python" --version "$PYTHON_VER" --scripts "$BUILDTMP/Scripts" "python-$PYTHON_VER.pkg"
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
