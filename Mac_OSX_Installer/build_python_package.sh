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
	#cat $SOURCETMP/*.pkg/PackageInfo | grep "install-location" | cut -d' ' -f10 | cut -d'=' -f2
	#for pkg in $SOURCETMP/*.pkg; do echo $pkg; cat $pkg/PackageInfo | grep "install-location" | cut -d' ' -f10 | cut -d'=' -f2; done

	rm -rf $SOURCETMP/Python_Applications.pkg
	rm -rf $SOURCETMP/Python_Documentation.pkg

	mkdir -vp $BUILDTMP/Payload/opt/usr/bin
	mkdir -vp $BUILDTMP/Payload/Library/Frameworks/Python.framework
	mv -v $SOURCETMP/Python_Command_Line_Tools.pkg/Payload/* $BUILDTMP/Payload/opt/usr/bin/
	mv -v $SOURCETMP/Python_Framework.pkg/Payload/* $BUILDTMP/Payload/Library/Frameworks/Python.framework/
	mkdir -vp $BUILDTMP/Scripts
	touch $BUILDTMP/Scripts/postinstall
	cat $SOURCETMP/*.pkg/Scripts/postinstall | sed -e 's/exit 0/#exit 0/g' > $BUILDTMP/Scripts/postinstall
	cat ./postinstall-scripts/python_postinstall >> $BUILDTMP/Scripts/postinstall
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
