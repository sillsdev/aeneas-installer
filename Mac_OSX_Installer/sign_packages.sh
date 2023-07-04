#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
cd $CURDIR

bash ./sign_espeak_package.sh
bash ./sign_ffmpeg_package.sh
bash ./sign_python_package.sh
bash ./sign_aeneas_package.sh

cd aeneas-mac-installer-packages
for file in *.pkg; do
	xcrun notarytool submit --keychain-profile "notarytool" --wait $file
	xcrun stapler staple $file
done

