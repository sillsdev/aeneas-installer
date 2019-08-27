#!/bin/bash

#export PATH=/usr/libexec/git-core/:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
cd $CURDIR

#HOMEBREW_BUILD_FROM_SOURCE=true

echo Running brew update
brew update

brew install danielbair/tap/espeak ffmpeg python

export espeak_ver=`brew info danielbair/tap/espeak | grep Cellar | cut -d' ' -f1 | cut -d'/' -f6`
export ffmpeg_ver=`brew info ffmpeg | grep Cellar | cut -d' ' -f1 | cut -d'/' -f6`
export python_ver=`brew info python | grep Cellar | cut -d' ' -f1 | cut -d'/' -f6`

if [ ! -f "aeneas-mac-installer-packages/espeak-$espeak_ver.pkg" ]; then
        echo ""
        install_name_tool -id /usr/local/lib/libespeak.dylib /usr/local/lib/libespeak.dylib 
        install_name_tool /usr/local/lib/libportaudio.2.dylib -id /usr/local/lib/libportaudio.2.dylib 
        install_name_tool /usr/local/lib/libespeak.dylib -change /usr/local/opt/portaudio/lib/libportaudio.2.dylib /usr/local/lib/libportaudio.2.dylib 
        brew pkg --with-deps --without-kegs --postinstall-script="./installer-scripts/postinstall_espeak.sh" danielbair/tap/espeak
        [ $? = 0 ] || exit 1
	mv espeak*.pkg aeneas-mac-installer-packages/
else
        echo "Found espeak-$espeak_ver.pkg"
fi
if [ ! -f "aeneas-mac-installer-packages/ffmpeg-$ffmpeg_ver.pkg" ]; then
        echo ""
        brew pkg --with-deps --without-kegs --postinstall-script="./installer-scripts/postinstall_ffmpeg.sh" ffmpeg
        [ $? = 0 ] || exit 1
	mv ffmpeg*.pkg aeneas-mac-installer-packages/
else
        echo "Found ffmpeg-$ffmpeg_ver.pkg"
fi
if [ ! -f "aeneas-mac-installer-packages/python-$python_ver.pkg" ]; then
        echo ""
        brew pkg --identifier-prefix="org.python" --with-deps --without-kegs --preinstall-script="./installer-scripts/preinstall_python.sh" --postinstall-script="./installer-scripts/postinstall_python.sh" python
        [ $? = 0 ] || exit 1
	mv python*.pkg aeneas-mac-installer-packages/
else
        echo "Found python-$python_ver.pkg"
fi

python3 -m ensurepip
pip3 wheel pip
pip_ver=`pip3 show pip | grep Version | cut -d' ' -f2`
rm -f aeneas-mac-installer-packages/pip-*.whl
mv -v pip-$pip_ver*.whl aeneas-mac-installer-packages/

pip3 install -U numpy
pip3 install -U aeneas

export aeneas_ver=`pip3 show aeneas | grep Version | cut -d' ' -f2`
export numpy_ver=`pip3 show numpy | grep Version | cut -d' ' -f2`
export lxml_ver=`pip3 show lxml | grep Version | cut -d' ' -f2`
export bs4_ver=`pip3 show beautifulsoup4 | grep Version | cut -d' ' -f2`
export soupsieve_ver=`pip3 show soupsieve | grep Version | cut -d' ' -f2`

python3 -m aeneas.diagnostics
python3 -m aeneas.tools.synthesize_text list "This is a test|with two lines" eng -v /tmp/test.wav
python3 -m aeneas.diagnostics

if [ ! -f "aeneas-mac-installer-packages/aeneas-$aeneas_ver.pkg" ]; then
	echo ""
	pip3 wheel aeneas
	BUILDTMP="$(mktemp -d -t aeneas.tmp.XXXXXXXX)"
	mkdir -p $BUILDTMP/Payload/usr/local/share/aeneas_tools/
	cp -v aeneas-$aeneas_ver*.whl $BUILDTMP/Payload/usr/local/share/aeneas_tools/
	mv -v aeneas-$aeneas_ver*.whl python_wheels/
	mkdir -p $BUILDTMP/Scripts/
	cp -v installer-scripts/postinstall_aeneas.sh $BUILDTMP/Scripts/postinstall
	cp -v installer-scripts/preinstall_aeneas.sh $BUILDTMP/Scripts/preinstall
	pkgbuild --quiet --root "$BUILDTMP/Payload" --identifier "org.python.python.aeneas" --version "$aeneas_ver" --scripts "$BUILDTMP/Scripts" "aeneas-$aeneas_ver.pkg"
	[ $? = 0 ] || exit 1
	mv aeneas*.pkg aeneas-mac-installer-packages/
	rm -rf $BUILDTMP
else
	echo "Found aeneas-$aeneas_ver.pkg"
fi
if [ ! -f "aeneas-mac-installer-packages/numpy-$numpy_ver.pkg" ]; then
	echo ""
	pip3 wheel numpy
	BUILDTMP="$(mktemp -d -t numpy.tmp.XXXXXXXX)"
	mkdir -p $BUILDTMP/Payload/usr/local/share/aeneas_tools/
	cp -v numpy-$numpy_ver*.whl $BUILDTMP/Payload/usr/local/share/aeneas_tools/
	mv -v numpy-$numpy_ver*.whl python_wheels/
	mkdir -p $BUILDTMP/Scripts/
	cp -v installer-scripts/postinstall_numpy.sh $BUILDTMP/Scripts/postinstall
	cp -v installer-scripts/preinstall_numpy.sh $BUILDTMP/Scripts/preinstall
	pkgbuild --quiet --root "$BUILDTMP/Payload" --identifier "org.python.python.numpy" --version "$numpy_ver" --scripts "$BUILDTMP/Scripts" "numpy-$numpy_ver.pkg"
	[ $? = 0 ] || exit 1
	mv numpy*.pkg aeneas-mac-installer-packages/
	rm -rf $BUILDTMP
else
	echo "Found numpy-$numpy_ver.pkg"
fi
if [ ! -f "aeneas-mac-installer-packages/lxml-$lxml_ver.pkg" ]; then
	echo ""
	pip3 wheel lxml
	BUILDTMP="$(mktemp -d -t lxml.tmp.XXXXXXXX)"
	mkdir -p $BUILDTMP/Payload/usr/local/share/aeneas_tools/
	cp -v lxml-$lxml_ver*.whl $BUILDTMP/Payload/usr/local/share/aeneas_tools/
	mv -v lxml-$lxml_ver*.whl python_wheels/
	mkdir -p $BUILDTMP/Scripts/
	cp -v installer-scripts/postinstall_lxml.sh $BUILDTMP/Scripts/postinstall
	cp -v installer-scripts/preinstall_lxml.sh $BUILDTMP/Scripts/preinstall
	pkgbuild --quiet --root "$BUILDTMP/Payload" --identifier "org.python.python.lxml" --version "$lxml_ver" --scripts "$BUILDTMP/Scripts" "lxml-$lxml_ver.pkg"
	[ $? = 0 ] || exit 1
	mv lxml*.pkg aeneas-mac-installer-packages/
	rm -rf $BUILDTMP
else
	echo "Found lxml-$lxml_ver.pkg"
fi
if [ ! -f "aeneas-mac-installer-packages/bs4-$bs4_ver.pkg" ]; then
	echo ""
	pip3 wheel beautifulsoup4
	BUILDTMP="$(mktemp -d -t bs4.tmp.XXXXXXXX)"
	mkdir -p $BUILDTMP/Payload/usr/local/share/aeneas_tools/
	cp -v beautifulsoup4-$bs4_ver*.whl $BUILDTMP/Payload/usr/local/share/aeneas_tools/
	mv -v beautifulsoup4-$bs4_ver*.whl python_wheels/
	cp -v soupsieve-$soupsieve_ver*.whl $BUILDTMP/Payload/usr/local/share/aeneas_tools/
	mv -v soupsieve-$soupsieve_ver*.whl python_wheels/
	mkdir -p $BUILDTMP/Scripts/
	cp -v installer-scripts/postinstall_bs4.sh $BUILDTMP/Scripts/postinstall
	cp -v installer-scripts/preinstall_bs4.sh $BUILDTMP/Scripts/preinstall
	pkgbuild --quiet --root "$BUILDTMP/Payload" --identifier "org.python.python.bs4" --version "$bs4_ver" --scripts "$BUILDTMP/Scripts" "bs4-$bs4_ver.pkg"
	[ $? = 0 ] || exit 1
	mv bs4*.pkg aeneas-mac-installer-packages/
	rm -rf $BUILDTMP
else
	echo "Found bs4-$bs4_ver.pkg"
fi
#if [ ! -f "aeneas-mac-installer-packages/soupsieve-$soupsieve_ver.pkg" ]; then
#	echo ""
#	pip3 wheel soupsieve
#	BUILDTMP="$(mktemp -d -t soupsieve.tmp.XXXXXXXX)"
#	mkdir -p $BUILDTMP/Payload/usr/local/share/aeneas_tools/
#	cp -v soupsieve-$soupsieve_ver*.whl $BUILDTMP/Payload/usr/local/share/aeneas_tools/
#	mv -v soupsieve-$soupsieve_ver*.whl python_wheels/
#	mkdir -p $BUILDTMP/Scripts/
#	cp -v installer-scripts/postinstall_soupsieve.sh $BUILDTMP/Scripts/postinstall
#	cp -v installer-scripts/preinstall_soupsieve.sh $BUILDTMP/Scripts/preinstall
#	pkgbuild --quiet --root "$BUILDTMP/Payload" --identifier "org.python.python.soupsieve" --version "$soupsieve_ver" --scripts "$BUILDTMP/Scripts" "soupsieve-$soupsieve_ver.pkg"
#	[ $? = 0 ] || exit 1
#	mv bs4*.pkg aeneas-mac-installer-packages/
#	rm -rf $BUILDTMP
#else
#	echo "Found soupsieve-$soupsieve_ver.pkg"
#fi

cd $CURDIR

