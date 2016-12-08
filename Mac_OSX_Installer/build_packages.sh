#!/bin/bash

export PATH=/usr/libexec/git-core/:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
cd $CURDIR

#HOMEBREW_BUILD_FROM_SOURCE=true

echo Running brew update
brew update

if [ -d "/usr/local/Cellar/python" ]; then
brew uninstall python
fi

brew reinstall danielbair/tap/numpy
brew reinstall danielbair/tap/aeneas

python -m aeneas.diagnostics
python -m aeneas.tools.synthesize_text list "This is a test|with two lines" eng -v /tmp/test.wav

if [ ! -f "ffmpeg-3.2.2.pkg" ]; then
	echo ""
	brew pkg --with-deps --without-kegs --postinstall-script ./install_package.sh ffmpeg
	[ $? = 0 ] || exit 1
else
	echo "Found ffmpeg-3.2.2.pkg"
fi
if [ ! -f "espeak-1.48.04_1.pkg" ]; then
	echo ""
	sudo install_name_tool -id /usr/local/lib/libespeak.dylib /usr/local/lib/libespeak.dylib
	sudo install_name_tool /usr/local/lib/libportaudio.2.dylib -id /usr/local/lib/libportaudio.2.dylib
	sudo install_name_tool /usr/local/lib/libespeak.dylib -change /usr/local/opt/portaudio/lib/libportaudio.2.dylib /usr/local/lib/libportaudio.2.dylib
	brew pkg --with-deps --without-kegs --postinstall-script ./install_package.sh espeak
	[ $? = 0 ] || exit 1
else
	echo "Found espeak-1.48.04_1.pkg"
fi
if [ ! -f "aeneas-1.7.0.pkg" ]; then
	echo ""
	brew pkg --identifier-prefix org.python.python --with-deps --without-kegs --postinstall-script ./install_aeneas.sh aeneas
	mv -v aeneas-1.7.0.pkg aeneas-full-1.7.0.pkg
	brew pkg --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_aeneas.sh danielbair/tap/aeneas
	[ $? = 0 ] || exit 1
else
	echo "Found aeneas-1.7.0.pkg"
fi
if [ ! -f "numpy-1.11.2.pkg" ]; then
	echo ""
	brew pkg --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_numpy.sh danielbair/tap/numpy
	[ $? = 0 ] || exit 1
else
	echo "Found numpy-1.11.2.pkg"
fi
if [ ! -f "lxml-3.6.0.pkg" ]; then
	echo ""
	brew pkg --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_lxml.sh danielbair/tap/lxml
	[ $? = 0 ] || exit 1
else
	echo "Found lxml-3.6.0.pkg"
fi
if [ ! -f "bs4-4.5.1.pkg" ]; then
	echo ""
	brew pkg --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_bs4.sh danielbair/tap/bs4
	[ $? = 0 ] || exit 1
else
	echo "Found bs4-4.5.1.pkg"
fi

brew install python

if [ ! -f "python-2.7.12.pkg" ]; then
	echo ""
	brew pkg --identifier-prefix org.python --with-deps --without-kegs --postinstall-script ./install_python.sh python
	[ $? = 0 ] || exit 1
fi

echo cd $CURDIR
cd $CURDIR

packagesbuild -v Aeneas_Installer_v1.7.0.pkgproj
[ $? = 0 ] || exit 1
if [ -f "aeneas-mac-setup-1.7.0.pkg" ]; then
	echo -e "Resulting Installer program filename is:\n$(pwd)/aeneas-mac-setup-1.7.0.pkg"
fi
