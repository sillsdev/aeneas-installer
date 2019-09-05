#!/bin/bash

#export PATH=/usr/libexec/git-core/:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
cd $CURDIR

#HOMEBREW_BUILD_FROM_SOURCE=true

#echo Running brew update
#brew update

brew install danielbair/tap/espeak
#brew install ffmpeg
brew install python

export espeak_ver=`brew info danielbair/tap/espeak | grep Cellar | cut -d' ' -f1 | cut -d'/' -f6`
export ffmpeg_ver=`curl -s https://evermeet.cx/ffmpeg/info/ffmpeg/release | jq -r '.version'`
#export ffmpeg_ver=`brew info ffmpeg | grep Cellar | cut -d' ' -f1 | cut -d'/' -f6`
export python_ver=`brew info python | grep Cellar | cut -d' ' -f1 | cut -d'/' -f6`

if [ ! -f "aeneas-mac-installer-packages/espeak-$espeak_ver.pkg" ]; then
        echo ""
        sudo install_name_tool -id /usr/local/lib/libespeak.dylib /usr/local/lib/libespeak.dylib 
        sudo install_name_tool /usr/local/lib/libportaudio.2.dylib -id /usr/local/lib/libportaudio.2.dylib 
        sudo install_name_tool /usr/local/lib/libespeak.dylib -change /usr/local/opt/portaudio/lib/libportaudio.2.dylib /usr/local/lib/libportaudio.2.dylib 
        brew pkg --with-deps --without-kegs --postinstall-script="./installer-scripts/postinstall_espeak.sh" danielbair/tap/espeak
        [ $? = 0 ] || exit 1
	mv espeak-$espeak_ver.pkg aeneas-mac-installer-packages/
else
        echo "Found espeak-$espeak_ver.pkg"
fi
if [ ! -f "aeneas-mac-installer-packages/ffmpeg-$ffmpeg_ver.pkg" ]; then
	echo ""
        if [ ! -f "./ffmpeg-$ffmpeg_ver-macos64-static.zip" ]; then
                wget --trust-server-names https://ffmpeg.zeranoe.com/builds/macos64/static/ffmpeg-$ffmpeg_ver-macos64-static.zip
        fi
        BUILDTMP="$(mktemp -d -t ffmpeg.tmp.XXXXXXXX)"
        mkdir -vp $BUILDTMP/Payload/usr/local/opt/
        unzip ffmpeg-$ffmpeg_ver-macos64-static.zip -d $BUILDTMP/Payload/usr/local/opt/
        mv -v $BUILDTMP/Payload/usr/local/opt/ffmpeg-$ffmpeg_ver-macos64-static $BUILDTMP/Payload/usr/local/opt/ffmpeg
        mkdir -vp $BUILDTMP/Payload/usr/local/opt/ffmpeg/share/
        mv -v $BUILDTMP/Payload/usr/local/opt/ffmpeg/doc $BUILDTMP/Payload/usr/local/opt/ffmpeg/share/doc
        mkdir -vp $BUILDTMP/Scripts/
        cp -v installer-scripts/postinstall_ffmpeg.sh $BUILDTMP/Scripts/postinstall
        pkgbuild --root "$BUILDTMP/Payload" --identifier "org.ffmpeg.ffmpeg" --version "$ffmpeg_ver" --scripts "$BUILDTMP/Scripts" "ffmpeg-$ffmpeg_ver.pkg"
        [ $? = 0 ] || exit 1
	sudo installer -pkg ffmpeg-$ffmpeg_ver.pkg -target /
        mv ffmpeg-$ffmpeg_ver.pkg aeneas-mac-installer-packages/
        rm -rf $BUILDTMP
else
        echo "Found ffmpeg-$ffmpeg_ver.pkg"
fi
#if [ ! -f "aeneas-mac-installer-packages/ffmpeg-$ffmpeg_ver.pkg" ]; then
#        echo ""
#        brew pkg --with-deps --without-kegs --postinstall-script="./installer-scripts/postinstall_ffmpeg.sh" ffmpeg
#        [ $? = 0 ] || exit 1
#	mv ffmpeg-$ffmpeg_ver.pkg aeneas-mac-installer-packages/
#else
#        echo "Found ffmpeg-$ffmpeg_ver.pkg"
#fi
if [ ! -f "aeneas-mac-installer-packages/python-$python_ver.pkg" ]; then
        echo ""
        if [ ! -f "./python-$python_ver-macosx10.9.pkg" ]; then
		wget --trust-server-names https://www.python.org/ftp/python/$python_ver/python-$python_ver-macosx10.9.pkg
        fi
        SOURCETMP="$(mktemp -d -t python.tmp.XXXXXXXX)"
        BUILDTMP="$(mktemp -d -t python.tmp.XXXXXXXX)"

	pkgutil --expand-full python-$python_ver-macosx10.9.pkg $SOURCETMP/python-$python_ver-macosx10.9.pkg
        SOURCETMP="$SOURCETMP/python-$python_ver-macosx10.9.pkg"
	#cat $SOURCETMP/*.pkg/PackageInfo | grep "install-location" | cut -d' ' -f10 | cut -d'=' -f2
	#for pkg in $SOURCETMP/*.pkg; do echo $pkg; cat $pkg/PackageInfo | grep "install-location" | cut -d' ' -f10 | cut -d'=' -f2; done

	rm -rf $SOURCETMP/Python_Applications.pkg
	rm -rf $SOURCETMP/Python_Documentation.pkg

	mkdir -vp $BUILDTMP/Payload/usr/local/bin
	mkdir -vp $BUILDTMP/Payload/Library/Frameworks/Python.framework
	mv -v $SOURCETMP/Python_Command_Line_Tools.pkg/Payload/* $BUILDTMP/Payload/usr/local/bin/
	mv -v $SOURCETMP/Python_Framework.pkg/Payload/* $BUILDTMP/Payload/Library/Frameworks/Python.framework/
	mkdir -vp $BUILDTMP/Scripts
	cat $SOURCETMP/*.pkg/Scripts/postinstall | sed -e 's/exit 0/#exit 0/g' > $BUILDTMP/Scripts/postinstall
	echo -e "\nexit 0" >> $BUILDTMP/Scripts/postinstall
	chmod +x $BUILDTMP/Scripts/postinstall
	pkgbuild --root "$BUILDTMP/Payload" --identifier "org.python.python" --version "$python_ver" --scripts "$BUILDTMP/Scripts" "python-$python_ver.pkg"
        [ $? = 0 ] || exit 1
	sudo installer -pkg python-$python_ver.pkg -target /
	mv python-$python_ver.pkg aeneas-mac-installer-packages/
	rm -rf $SOURCETMP
        rm -rf $BUILDTMP
else
        echo "Found python-$python_ver.pkg"
fi
#if [ ! -f "aeneas-mac-installer-packages/python-$python_ver.pkg" ]; then
#        echo ""
#        brew pkg --identifier-prefix="org.python" --with-deps --without-kegs --preinstall-script="./installer-scripts/preinstall_python.sh" --postinstall-script="./installer-scripts/postinstall_python.sh" python
#        [ $? = 0 ] || exit 1
#	mv python-$python_ver.pkg aeneas-mac-installer-packages/
#else
#        echo "Found python-$python_ver.pkg"
#fi

python3 -m ensurepip
pip3 install -U wheel pip setuptools
#pip_ver=`pip3 show pip | grep "Version:" | cut -d' ' -f2`
#rm -f aeneas-mac-installer-packages/pip-*.whl
#mv -v pip-$pip_ver*.whl aeneas-mac-installer-packages/

pip3 install -U numpy
pip3 install -U aeneas

python3 -m aeneas.diagnostics
python3 -m aeneas.tools.synthesize_text list "This is a test|with two lines" eng -v /tmp/test.wav
python3 -m aeneas.diagnostics

export aeneas_ver=`pip3 show aeneas | grep "Version:" | cut -d' ' -f2`
export numpy_ver=`pip3 show numpy | grep "Version:" | cut -d' ' -f2`
export lxml_ver=`pip3 show lxml | grep "Version:" | cut -d' ' -f2`
export bs4_ver=`pip3 show beautifulsoup4 | grep "Version:" | cut -d' ' -f2`
export soupsieve_ver=`pip3 show soupsieve | grep "Version:" | cut -d' ' -f2`

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
	pkgbuild --root "$BUILDTMP/Payload" --identifier "org.python.python.aeneas" --version "$aeneas_ver" --scripts "$BUILDTMP/Scripts" "aeneas-$aeneas_ver.pkg"
	[ $? = 0 ] || exit 1
	mv aeneas-$aeneas_ver.pkg aeneas-mac-installer-packages/
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
	pkgbuild --root "$BUILDTMP/Payload" --identifier "org.python.python.numpy" --version "$numpy_ver" --scripts "$BUILDTMP/Scripts" "numpy-$numpy_ver.pkg"
	[ $? = 0 ] || exit 1
	mv numpy-$numpy_ver.pkg aeneas-mac-installer-packages/
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
	pkgbuild --root "$BUILDTMP/Payload" --identifier "org.python.python.lxml" --version "$lxml_ver" --scripts "$BUILDTMP/Scripts" "lxml-$lxml_ver.pkg"
	[ $? = 0 ] || exit 1
	mv lxml-$lxml_ver.pkg aeneas-mac-installer-packages/
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
	pkgbuild --root "$BUILDTMP/Payload" --identifier "org.python.python.bs4" --version "$bs4_ver" --scripts "$BUILDTMP/Scripts" "bs4-$bs4_ver.pkg"
	[ $? = 0 ] || exit 1
	mv bs4-$bs4_ver.pkg aeneas-mac-installer-packages/
	rm -rf $BUILDTMP
else
	echo "Found bs4-$bs4_ver.pkg"
fi

cd $CURDIR

echo -e "\n\nNow run build_installer.sh\n\n"

exit 0
