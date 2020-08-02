#!/bin/bash

IFS=$'\n'

source ./build_env.sh

cd $CURDIR

echo -e "\n\nBegining package signing\n\n"

mkdir -p ./aeneas-mac-installer-packages
mkdir -p ./python-wheels

bash ./sign_espeak_package.sh
bash ./sign_ffmpeg_package.sh
bash ./sign_python_package.sh
bash ./sign_aeneas_package.sh

echo -e "\n\nNow run build_installer.sh\n\n"

exit 0
