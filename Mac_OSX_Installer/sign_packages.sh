#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
cd $CURDIR

cd aeneas-mac-installer-packages
for file in *.pkg; do
productsign --timestamp=none --sign "Developer ID Installer" $file /tmp/$file
cp -v /tmp/$file $file
done

