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
productsign --timestamp --sign "Developer ID Installer" $file /tmp/$file
cp -v /tmp/$file $file
done

