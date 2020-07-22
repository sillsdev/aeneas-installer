#!/bin/bash

source ./build_env.sh

if [ ! -f "aeneas-mac-installer-packages/python-$PYTHON_VER.pkg" ]; then
        echo ""
        if [ ! -f "./python-$PYTHON_VER-macosx10.9.pkg" ]; then
		wget --trust-server-names https://www.python.org/ftp/python/$PYTHON_VER/python-$PYTHON_VER-macosx10.9.pkg
        fi
        SOURCETMP="$(mktemp -d -t python.src.XXXXXXXX)"
        BUILDTMP="$(mktemp -d -t python.build.XXXXXXXX)"

	pkgutil --expand-full python-$PYTHON_VER-macosx10.9.pkg $SOURCETMP/python-$PYTHON_VER-macosx10.9.pkg
        SOURCETMP="$SOURCETMP/python-$PYTHON_VER-macosx10.9.pkg"

	mkdir -vp $BUILDTMP/Payload
	mkdir -vp $BUILDTMP/Scripts
	touch $BUILDTMP/Scripts/postinstall
	echo "#!/bin/sh" >> $BUILDTMP/Scripts/postinstall
	for pkg in $SOURCETMP/*.pkg; do 
		PKG_ROOT=`cat $pkg/PackageInfo | grep "install-location" | cut -d' ' -f10 | cut -d'=' -f2 | cut -d'"' -f2 | sed 's#/usr/local/bin#/opt/usr/bin#g'` 
		if [ -n "$(grep "install-location" $pkg/PackageInfo)" ]; then
			mkdir -vp $BUILDTMP/Payload$PKG_ROOT
			mv -v $pkg/Payload/* $BUILDTMP/Payload$PKG_ROOT/
		fi
		SCRIPT_NAME="`basename $pkg`-postinstall"
		if [ -f "$pkg/Scripts/postinstall" ]; then
			mv -v $pkg/Scripts/postinstall $BUILDTMP/Scripts/$SCRIPT_NAME
			echo "/bin/sh ./$SCRIPT_NAME" >> $BUILDTMP/Scripts/postinstall
		fi
	done
	chmod +x $BUILDTMP/Scripts/postinstall
	pkgbuild --root "$BUILDTMP/Payload" --identifier "org.python.python" --version "$PYTHON_VER" --scripts "$BUILDTMP/Scripts" "python-$PYTHON_VER.pkg"
        [ $? = 0 ] || exit 1
	sudo installer -pkg python-$PYTHON_VER.pkg -target /
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
