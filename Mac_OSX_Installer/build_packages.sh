#!/bin/bash

source ./build_env.sh

cd $CURDIR

echo -e "\n\nBegining package builds\n\n"

sudo port selfupdate

mkdir -p ./aeneas-mac-installer-packages
mkdir -p ./python-wheels

bash ./build_espeak_package.sh
bash ./build_ffmpeg_package.sh
bash ./build_python_package.sh
bash ./build_aeneas_package.sh

echo -e "\n\nNow run build_installer.sh\n\n"

exit 0
