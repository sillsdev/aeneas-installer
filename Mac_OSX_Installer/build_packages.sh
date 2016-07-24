#!/bin/bash

export PATH=/usr/libexec/git-core/:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
echo cd $CURDIR
cd $CURDIR

echo Running brew update
brew update

brew install danielbair/tap/aeneas

python -m aeneas.diagnostics
python -m aeneas.tools.synthesize_text list "This is a test|with two lines" eng -v /tmp/test.wav

brew pkg --with-deps --without-kegs --postinstall-script ./install_espeak.sh ffmpeg30
brew pkg --with-deps --without-kegs --postinstall-script ./install_espeak.sh espeak148
brew pkg --with-deps --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_aeneas.sh aeneas
mv aeneas-1.5.0.3.pkg aeneas-full-1.5.0.3.pkg 
brew pkg --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_numpy.sh numpy
brew pkg --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_lxml.sh lxml
brew pkg --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_bs4.sh bs4
brew pkg --identifier-prefix org.python.python --without-kegs --postinstall-script ./install_aeneas.sh aeneas

brew install python
brew pkg --with-deps --identifier-prefix org.python --postinstall-script ./install_python.sh python

echo cd $CURDIR
cd $CURDIR

packagesbuild -v Aeneas_Installer.pkgproj
if [ -f "aeneas-mac-setup-1.5.0.3.pkg" ]; then
	echo -e "Resulting Installer program filename is:\n$(pwd)/aeneas-mac-setup-1.5.0.3.pkg"
fi
