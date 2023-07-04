#!/bin/bash

pkgutil --pkgs | grep "pkg.Packages"
if [ $? = 0 ]; then
  if [ ! -f "./Packages.dmg" ]; then
    wget --trust-server-names -N http://s.sudre.free.fr/Software/files/Packages.dmg
  fi
  mkdir -p /tmp/packages-installer/
  hdiutil attach Packages.dmg -mountpoint /tmp/packages-installer/
  sudo installer -pkg  /tmp/packages-installer/ -target /
  hdiutil detach /tmp/packages-installer/
fi

source ./build_env.sh

bash ./sign_packages.sh

cat Aeneas_Installer_TEMPLATE.pkgproj |\
       	sed -e 's/\[FFMPEG_VER\]/'$FFMPEG_VER'/g' |\
       	sed -e 's/\[ESPEAK_VER\]/'$ESPEAK_VER'/g' |\
       	sed -e 's/\[PYTHON_VER\]/'$PYTHON_VER'/g' |\
       	sed -e 's/\[NUMPY_VER\]/'$NUMPY_VER'/g' |\
       	sed -e 's/\[LXML_VER\]/'$LXML_VER'/g' |\
       	sed -e 's/\[BS4_VER\]/'$BS4_VER'/g' |\
       	sed -e 's/\[AENEAS_VER\]/'$AENEAS_VER'/g' |\
       	sed -e 's/\[INSTALLER_VER\]/'$VERSION'/g' |\
       	sed -e 's/\[USER\]/'$USER'/g' |\
	tee Aeneas_Installer.pkgproj

packagesbuild -v Aeneas_Installer.pkgproj
[ $? = 0 ] || exit 1

if [ -f "aeneas-mac-setup-$VERSION.pkg" ]; then
	echo -e "Resulting Installer program filename is:\n$(pwd)/aeneas-mac-setup-$VERSION.pkg"
	productsign --timestamp --sign "Developer ID Installer" aeneas-mac-setup-$VERSION.pkg /tmp/aeneas-mac-setup-$VERSION.pkg
	cp -v /tmp/aeneas-mac-setup-$VERSION.pkg ./
	xcrun notarytool submit --keychain-profile "notarytool" --wait aeneas-mac-setup-$VERSION.pkg
	xcrun stapler staple aeneas-mac-setup-$VERSION.pkg
fi

exit 0
