#!/bin/bash

source ./build_env.sh

if [ "$1" == "sign" ]; then
	mv -v aeneas-mac-setup-$VERSION.pkg aeneas-mac-setup-$VERSION-unsigned.pkg
	productsign --timestamp --sign "Developer ID Installer" aeneas-mac-setup-$VERSION-unsigned.pkg aeneas-mac-setup-$VERSION.pkg
	exit 0
fi

if [ "$1" == "log" ]; then
	xcrun altool --notarization-info $2 --verbose -p "@keychain:altool"
	exit 0
fi

if [ "$1" == "notarize" ]; then
	xcrun altool --notarize-app -f "aeneas-mac-setup-$VERSION.pkg" --primary-bundle-id com.danielbair.pkg.aeneas-mac-setup --verbose -p "@keychain:altool"
	exit 0
fi

if [ "$1" == "staple" ]; then
	xcrun stapler staple "aeneas-mac-setup-$VERSION.pkg"
	spctl -a -vvv -t install "aeneas-mac-setup-$VERSION.pkg"
	exit 0
fi

xcrun notarytool submit "aeneas-mac-setup-$VERSION.pkg" --keychain-profile "notarytool" --wait

