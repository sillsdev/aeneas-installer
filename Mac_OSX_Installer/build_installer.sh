#!/bin/bash

#export PATH=/usr/libexec/git-core/:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
cd $CURDIR

#echo Running brew update
#brew update

bash ./sign_packages.sh

export espeak_ver=`brew info danielbair/tap/espeak | grep Cellar | cut -d' ' -f1 | cut -d'/' -f6`
export ffmpeg_ver=`curl -s https://evermeet.cx/ffmpeg/info/ffmpeg/release | jq -r '.version'`
#export ffmpeg_ver=`brew info ffmpeg | grep Cellar | cut -d' ' -f1 | cut -d'/' -f6`
export python_ver=`python3 --version | cut -d' ' -f2`
export aeneas_ver=`pip3 show aeneas | grep "Version:" | cut -d' ' -f2`
export numpy_ver=`pip3 show numpy | grep "Version:" | cut -d' ' -f2`
export lxml_ver=`pip3 show lxml | grep "Version:" | cut -d' ' -f2`
export bs4_ver=`pip3 show beautifulsoup4 | grep "Version:" | cut -d' ' -f2`
export soupsieve_ver=`pip3 show soupsieve | grep "Version:" | cut -d' ' -f2`
export VERSION="$aeneas_ver"_2

cat Aeneas_Installer_TEMPLATE.pkgproj |\
       	sed -e 's/\[FFMPEG_VER\]/'$ffmpeg_ver'/g' |\
       	sed -e 's/\[ESPEAK_VER\]/'$espeak_ver'/g' |\
       	sed -e 's/\[PYTHON_VER\]/'$python_ver'/g' |\
       	sed -e 's/\[NUMPY_VER\]/'$numpy_ver'/g' |\
       	sed -e 's/\[LXML_VER\]/'$lxml_ver'/g' |\
       	sed -e 's/\[BS4_VER\]/'$bs4_ver'/g' |\
       	sed -e 's/\[AENEAS_VER\]/'$aeneas_ver'/g' |\
       	sed -e 's/\[INSTALLER_VER\]/'$VERSION'/g' |\
       	sed -e 's/\[USER\]/'$USER'/g' |\
	tee Aeneas_Installer.pkgproj

packagesbuild -v Aeneas_Installer.pkgproj
[ $? = 0 ] || exit 1
if [ -f "aeneas-mac-setup-$VERSION.pkg" ]; then
	echo -e "Resulting Installer program filename is:\n$(pwd)/aeneas-mac-setup-$VERSION.pkg"
	productsign --timestamp=none --sign "Developer ID Installer" aeneas-mac-setup-$VERSION.pkg /tmp/aeneas-mac-setup-$VERSION.pkg
	cp -v /tmp/aeneas-mac-setup-$VERSION.pkg ./
fi

exit 0
