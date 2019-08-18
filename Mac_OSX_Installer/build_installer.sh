#!/bin/bash

#export PATH=/usr/libexec/git-core/:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
cd $CURDIR

echo Running brew update
brew update

echo cd $CURDIR
cd $CURDIR

VERSION="1.7.3_1"

bash ./sign_packages.sh
packagesbuild -v Aeneas_Installer.pkgproj
[ $? = 0 ] || exit 1
if [ -f "aeneas-mac-setup-$VERSION.pkg" ]; then
	echo -e "Resulting Installer program filename is:\n$(pwd)/aeneas-mac-setup-$VERSION.pkg"
	productsign --timestamp=none --sign "Developer ID Installer" aeneas-mac-setup-$VERSION.pkg /tmp/aeneas-mac-setup-$VERSION.pkg
	cp -v /tmp/aeneas-mac-setup-$VERSION.pkg ./
fi

