#!/bin/bash

export PATH=/usr/libexec/git-core/:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
echo cd $CURDIR
cd $CURDIR

echo Running brew update
brew update

brew reinstall danielbair/tap/aeneas

python -m aeneas.diagnostics
python -m aeneas.tools.synthesize_text list "This is a test|with two lines" eng -v /tmp/test.wav

if [ ! -f "ffmpeg30-3.0.2.pkg" ]; then
	brew link --overwrite ffmpeg30
	brew pkg --with-deps --without-kegs --postinstall-script ./install_espeak.sh ffmpeg30
fi
if [ ! -f "espeak148-1.48.04_1.pkg" ]; then
	brew link --overwrite espeak148
	brew pkg --with-deps --without-kegs --postinstall-script ./install_espeak.sh espeak148
fi
#if [ ! -f "aeneas-1.5.0.3.pkg" ]; then
#	brew link --overwrite aeneas
#	brew pkg --with-deps --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_aeneas.sh aeneas
#	mv -v aeneas-1.5.0.3.pkg aeneas-full-1.5.0.3.pkg 
#	brew pkg --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_aeneas.sh aeneas
#fi
if [ ! -f "aeneas-1.5.0.3.pkg" ]; then
	brew link --overwrite aeneas
	brew pkg --with-deps --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_aeneas.sh aeneas
	mv -v aeneas-1.5.1.0.pkg aeneas-full-1.5.1.0.pkg
	brew pkg --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_aeneas.sh aeneas
fi
if [ ! -f "numpy-1.11.1.pkg" ]; then
	brew link --overwrite numpy
	brew pkg --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_numpy.sh numpy
fi
if [ ! -f "lxml-3.6.0.pkg" ]; then
	brew link --overwrite lxml
	brew pkg --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_lxml.sh lxml
fi
if [ ! -f "bs4-4.4.1.pkg" ]; then
	brew link --overwrite bs4
	brew pkg --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_bs4.sh bs4
fi

brew install python

if [ ! -f "python-2.7.12.pkg" ]; then
	brew link --overwrite python
	brew pkg --with-deps --identifier-prefix org.python --postinstall-script ./install_python.sh python
fi

echo cd $CURDIR
cd $CURDIR

packagesbuild -v Aeneas_Installer.pkgproj
if [ -f "aeneas-mac-setup-1.5.1.0.pkg" ]; then
	echo -e "Resulting Installer program filename is:\n$(pwd)/aeneas-mac-setup-1.5.1.0.pkg"
fi
