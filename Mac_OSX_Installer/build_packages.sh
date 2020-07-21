#!/bin/bash

bash ./build_python_package.sh
bash ./build_ffmpeg_package.sh
bash ./build_espeak_package.sh
bash ./build_aeneas_package.sh

echo -e "\n\nNow run build_installer.sh\n\n"

exit 0
