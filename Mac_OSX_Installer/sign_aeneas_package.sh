#!/bin/bash

IFS=$'\n'

source ./build_env.sh

CURDIR=`pwd`
cd "$CURDIR"

AENEAS_FILE=$(basename `ls -1 python-wheels/aeneas-$AENEAS_VER*.whl`)
if [ -f "python-wheels/$AENEAS_FILE" ]; then
	BUILDTMP="$(mktemp -d -t aeneas.tmp.XXXXXXXX)"
	cd "$CURDIR"
	unzip python-wheels/$AENEAS_FILE -d $BUILDTMP/$AENEAS_FILE
	cd "$BUILDTMP"
	for file in `find $AENEAS_FILE -type f -not -path "*/espeak-ng-data/*" | perl -lne 'print if -B'`; do
		codesign -s "Developer ID Application" -v --force --entitlements "$CURDIR/entitlements.plist" --deep --options runtime "$file"
	done
	cd $AENEAS_FILE
	zip -r "$CURDIR/$AENEAS_FILE" .
	cd "$CURDIR"
	mkdir -p $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	cp -v aeneas-$AENEAS_VER*.whl $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	mv -v aeneas-$AENEAS_VER*.whl python-wheels/
	mkdir -p $BUILDTMP/Scripts/
        cat postinstall-scripts/postinstall_aeneas | sed 's#@PREFIX@#/opt/usr#g' > $BUILDTMP/Scripts/postinstall
	chmod +x $BUILDTMP/Scripts/postinstall
	pkgbuild --identifier "org.python.python.aeneas" --version "$AENEAS_VER" --root "$BUILDTMP/Payload" --scripts "$BUILDTMP/Scripts" "aeneas-$AENEAS_VER.pkg"
	[ $? = 0 ] || exit 1
	productsign --timestamp --sign "Developer ID Installer" aeneas-$AENEAS_VER.pkg aeneas-mac-installer-packages/aeneas-$AENEAS_VER.pkg
	rm -rf $BUILDTMP
else
	echo "Found aeneas-$AENEAS_VER.pkg"
fi
cd $CURDIR
NUMPY_FILE=$(basename `ls -1 python-wheels/numpy-$NUMPY_VER*.whl`)
if [ -f "python-wheels/$NUMPY_FILE" ]; then
	BUILDTMP="$(mktemp -d -t numpy.tmp.XXXXXXXX)"
	cd "$CURDIR"
	unzip python-wheels/$NUMPY_FILE -d $BUILDTMP/$NUMPY_FILE
	cd "$BUILDTMP"
	for file in `find $NUMPY_FILE -type f | perl -lne 'print if -B'`; do
		codesign -s "Developer ID Application" -v --force --entitlements "$CURDIR/entitlements.plist" --deep --options runtime "$file"
	done
	cd $NUMPY_FILE
	zip -r "$CURDIR/$NUMPY_FILE" .
	cd "$CURDIR"
	mkdir -p $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	cp -v numpy-$NUMPY_VER*.whl $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	mv -v numpy-$NUMPY_VER*.whl python-wheels/
	mkdir -p $BUILDTMP/Scripts/
        cat postinstall-scripts/postinstall_numpy | sed 's#@PREFIX@#/opt/usr#g' > $BUILDTMP/Scripts/postinstall
	chmod +x $BUILDTMP/Scripts/postinstall
	pkgbuild --identifier "org.python.python.numpy" --version "$NUMPY_VER" --root "$BUILDTMP/Payload" --scripts "$BUILDTMP/Scripts" "numpy-$NUMPY_VER.pkg"
	[ $? = 0 ] || exit 1
	productsign --timestamp --sign "Developer ID Installer" numpy-$NUMPY_VER.pkg aeneas-mac-installer-packages/numpy-$NUMPY_VER.pkg
	rm -rf $BUILDTMP
else
	echo "Found numpy-$NUMPY_VER.pkg"
fi
cd $CURDIR
LXML_FILE=$(basename `ls -1 python-wheels/lxml-$LXML_VER*.whl`)
if [ -f "python-wheels/$LXML_FILE" ]; then
	BUILDTMP="$(mktemp -d -t lxml.tmp.XXXXXXXX)"
	cd "$CURDIR"
	unzip python-wheels/$LXML_FILE -d $BUILDTMP/$LXML_FILE
	cd "$BUILDTMP"
	for file in `find $LXML_FILE -type f | perl -lne 'print if -B'`; do
		codesign -s "Developer ID Application" -v --force --entitlements "$CURDIR/entitlements.plist" --deep --options runtime "$file"
	done
	cd $LXML_FILE
	zip -r "$CURDIR/$LXML_FILE" .
	cd "$CURDIR"
	mkdir -p $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	cp -v lxml-$LXML_VER*.whl $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	mv -v lxml-$LXML_VER*.whl python-wheels/
	mkdir -p $BUILDTMP/Scripts/
        cat postinstall-scripts/postinstall_lxml | sed 's#@PREFIX@#/opt/usr#g' > $BUILDTMP/Scripts/postinstall
	chmod +x $BUILDTMP/Scripts/postinstall
	pkgbuild --identifier "org.python.python.lxml" --version "$LXML_VER" --root "$BUILDTMP/Payload" --scripts "$BUILDTMP/Scripts" "lxml-$LXML_VER.pkg"
	[ $? = 0 ] || exit 1
	productsign --timestamp --sign "Developer ID Installer" lxml-$LXML_VER.pkg aeneas-mac-installer-packages/lxml-$LXML_VER.pkg
	rm -rf $BUILDTMP
else
	echo "Found lxml-$LXML_VER.pkg"
fi

cd $CURDIR

#echo -e "\n\nNow run build_installer.sh\n\n"

exit 0
