#!/bin/bash

source ./build_env.sh

cd $CURDIR

echo -e "\n\nPreparing python environment for build\n\n"

python3 -m ensurepip
python3 -m pip install -U wheel pip setuptools

python3 -m pip install -U numpy
python3 -m pip install -U aeneas

python3 -m aeneas.diagnostics
#python3 -m aeneas.tools.synthesize_text list "This is a test|with two lines" eng -v /tmp/test.wav

export AENEAS_VER=`python3 -m pip show aeneas | grep "Version:" | cut -d' ' -f2`
export NUMPY_VER=`python3 -m pip show numpy | grep "Version:" | cut -d' ' -f2`
export LXML_VER=`python3 -m pip show lxml | grep "Version:" | cut -d' ' -f2`
export BS4_VER=`python3 -m pip show beautifulsoup4 | grep "Version:" | cut -d' ' -f2`
export SOUPSIEVE_VER=`python3 -m pip show soupsieve | grep "Version:" | cut -d' ' -f2`

if [ ! -f "aeneas-mac-installer-packages/aeneas-$AENEAS_VER.pkg" ]; then
	echo -e "\n\nBuilding aeneas-$AENEAS_VER.pkg\n\n"
	python3 -m pip download aeneas
	rm -rf aeneas-1.7.3.0
	tar -xf aeneas-1.7.3.0.tar.gz
	cd aeneas-1.7.3.0
	patch -p1 < ../aeneas-patches/patch-ttswrapper-mac.diff
	patch -p1 < ../aeneas-patches/patch-py38-utf8-mac.diff
	patch -p1 < ../aeneas-patches/patch-espeak-ng-mac.diff
	mv -v aeneas/cew/speak_lib.h thirdparty/speak_lib.h
	export AENEAS_USE_ESPEAKNG=True
	#python3 setup.py build_ext --inplace
	python3 setup.py bdist_wheel
	cp -v dist/aeneas-$AENEAS_VER*.whl ../
	cd ..
	BUILDTMP="$(mktemp -d -t aeneas.tmp.XXXXXXXX)"
	mkdir -p $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	cp -v aeneas-$AENEAS_VER*.whl $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	mv -v aeneas-$AENEAS_VER*.whl python-wheels/
	mkdir -p $BUILDTMP/Scripts/
        cat postinstall-scripts/postinstall_aeneas | sed 's#@PREFIX@#/opt/usr#g' > $BUILDTMP/Scripts/postinstall
	chmod +x $BUILDTMP/Scripts/postinstall
	pkgbuild --root "$BUILDTMP/Payload" --identifier "org.python.python.aeneas" --version "$AENEAS_VER" --scripts "$BUILDTMP/Scripts" "aeneas-$AENEAS_VER.pkg"
	[ $? = 0 ] || exit 1
	mv aeneas-$AENEAS_VER.pkg aeneas-mac-installer-packages/
	rm -rf $BUILDTMP
else
	echo "Found aeneas-$AENEAS_VER.pkg"
fi
cd $CURDIR
if [ ! -f "aeneas-mac-installer-packages/numpy-$NUMPY_VER.pkg" ]; then
	echo -e "\n\nBuilding numpy-$NUMPY_VER.pkg\n\n"
	python3 -m pip wheel numpy
	BUILDTMP="$(mktemp -d -t numpy.tmp.XXXXXXXX)"
	mkdir -p $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	cp -v numpy-$NUMPY_VER*.whl $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	mv -v numpy-$NUMPY_VER*.whl python-wheels/
	mkdir -p $BUILDTMP/Scripts/
        cat postinstall-scripts/postinstall_numpy | sed 's#@PREFIX@#/opt/usr#g' > $BUILDTMP/Scripts/postinstall
	chmod +x $BUILDTMP/Scripts/postinstall
	pkgbuild --root "$BUILDTMP/Payload" --identifier "org.python.python.numpy" --version "$NUMPY_VER" --scripts "$BUILDTMP/Scripts" "numpy-$NUMPY_VER.pkg"
	[ $? = 0 ] || exit 1
	mv numpy-$NUMPY_VER.pkg aeneas-mac-installer-packages/
	rm -rf $BUILDTMP
else
	echo "Found numpy-$NUMPY_VER.pkg"
fi
if [ ! -f "aeneas-mac-installer-packages/lxml-$LXML_VER.pkg" ]; then
	echo -e "\n\nBuilding lxml-$LXML_VER.pkg\n\n"
	python3 -m pip wheel lxml
	BUILDTMP="$(mktemp -d -t lxml.tmp.XXXXXXXX)"
	mkdir -p $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	cp -v lxml-$LXML_VER*.whl $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	mv -v lxml-$LXML_VER*.whl python-wheels/
	mkdir -p $BUILDTMP/Scripts/
        cat postinstall-scripts/postinstall_lxml | sed 's#@PREFIX@#/opt/usr#g' > $BUILDTMP/Scripts/postinstall
	chmod +x $BUILDTMP/Scripts/postinstall
	pkgbuild --root "$BUILDTMP/Payload" --identifier "org.python.python.lxml" --version "$LXML_VER" --scripts "$BUILDTMP/Scripts" "lxml-$LXML_VER.pkg"
	[ $? = 0 ] || exit 1
	mv lxml-$LXML_VER.pkg aeneas-mac-installer-packages/
	rm -rf $BUILDTMP
else
	echo "Found lxml-$LXML_VER.pkg"
fi
if [ ! -f "aeneas-mac-installer-packages/bs4-$BS4_VER.pkg" ]; then
	echo -e "\n\nBuilding bs4-$BS4_VER.pkg\n\n"
	python3 -m pip wheel beautifulsoup4
	BUILDTMP="$(mktemp -d -t bs4.tmp.XXXXXXXX)"
	mkdir -p $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	cp -v beautifulsoup4-$BS4_VER*.whl $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	mv -v beautifulsoup4-$BS4_VER*.whl python-wheels/
	cp -v soupsieve-$SOUPSIEVE_VER*.whl $BUILDTMP/Payload/opt/usr/share/aeneas_tools/
	mv -v soupsieve-$SOUPSIEVE_VER*.whl python-wheels/
	mkdir -p $BUILDTMP/Scripts/
        cat postinstall-scripts/postinstall_bs4 | sed 's#@PREFIX@#/opt/usr#g' > $BUILDTMP/Scripts/postinstall
	chmod +x $BUILDTMP/Scripts/postinstall
	pkgbuild --root "$BUILDTMP/Payload" --identifier "org.python.python.bs4" --version "$BS4_VER" --scripts "$BUILDTMP/Scripts" "bs4-$BS4_VER.pkg"
	[ $? = 0 ] || exit 1
	mv bs4-$BS4_VER.pkg aeneas-mac-installer-packages/
	rm -rf $BUILDTMP
else
	echo "Found bs4-$BS4_VER.pkg"
fi

cd $CURDIR

#echo -e "\n\nNow run build_installer.sh\n\n"

exit 0
