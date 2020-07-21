#!/bin/bash

source ./build_env.sh

if [ ! -f "aeneas-mac-installer-packages/ffmpeg-$FFMPEG_VER.pkg" ]; then
	echo ""
	BUILDTMP="$(mktemp -d -t ffmpeg.tmp.XXXXXXXX)"
	mkdir -vp $BUILDTMP/Payload/opt/usr/opt/
        if [ ! -f "./ffmpeg-$FFMPEG_VER-macos64-static.zip" ]; then
                wget --trust-server-names https://ffmpeg.zeranoe.com/builds/macos64/static/ffmpeg-$FFMPEG_VER-macos64-static.zip
		if [ ! $? ]; then
			unzip ffmpeg-$FFMPEG_VER-macos64-static.zip -d $BUILDTMP/Payload/opt/usr/opt/
			mv -v $BUILDTMP/Payload/opt/usr-$FFMPEG_VER-macos64-static $BUILDTMP/Payload/opt/usr
			mkdir -vp $BUILDTMP/Payload/opt/usr/share/
			mv -v $BUILDTMP/Payload/opt/usr/doc $BUILDTMP/Payload/opt/usr/share/doc
		fi
        fi
        if [ ! -f "./ffmpeg-$FFMPEG_VER-macos64-static.zip" ]; then
                wget --trust-server-names -N https://evermeet.cx/ffmpeg/ffmpeg-$FFMPEG_VER.zip
                wget --trust-server-names -N https://evermeet.cx/ffmpeg/ffprobe-$FFMPEG_VER.zip
                wget --trust-server-names -N https://evermeet.cx/ffmpeg/ffplay-$FFMPEG_VER.zip
                mkdir -vp $BUILDTMP/Payload/opt/usr/bin
                unzip ffmpeg-$FFMPEG_VER.zip -d $BUILDTMP/Payload/opt/usr/bin/
                unzip ffprobe-$FFMPEG_VER.zip -d $BUILDTMP/Payload/opt/usr/bin/
                unzip ffplay-$FFMPEG_VER.zip -d $BUILDTMP/Payload/opt/usr/bin/
                mkdir -vp $BUILDTMP/Payload/opt/usr/share
		wget --trust-server-names -N https://ffmpeg.org/releases/ffmpeg-$FFMPEG_VER.tar.gz
		tar -xzf ffmpeg-$FFMPEG_VER.tar.gz -C $BUILDTMP/
		mv $BUILDTMP/ffmpeg-$FFMPEG_VER/doc $BUILDTMP/Payload/opt/usr/share/
		mv $BUILDTMP/ffmpeg-$FFMPEG_VER/presets $BUILDTMP/Payload/opt/usr/share/
		mv $BUILDTMP/ffmpeg-$FFMPEG_VER/LICENSE.md $BUILDTMP/Payload/opt/usr/share/
		mv $BUILDTMP/ffmpeg-$FFMPEG_VER/README.md $BUILDTMP/Payload/opt/usr/share/
        fi
        mkdir -vp $BUILDTMP/Scripts/
        cat postinstall-scripts/postinstall | sed 's#@PREFIX@#/opt/usr#g' > $BUILDTMP/Scripts/postinstall
        chmod +x $BUILDTMP/Scripts/postinstall
        pkgbuild --root "$BUILDTMP/Payload" --identifier "org.ffmpeg.ffmpeg" --version "$FFMPEG_VER" --scripts "$BUILDTMP/Scripts" "ffmpeg-$FFMPEG_VER.pkg"
        [ $? = 0 ] || exit 1
        sudo installer -pkg ffmpeg-$FFMPEG_VER.pkg -target /
        mv ffmpeg-$FFMPEG_VER.pkg aeneas-mac-installer-packages/
        rm -rf $BUILDTMP
else
        echo "Found ffmpeg-$FFMPEG_VER.pkg"
fi

cd $CURDIR

#echo -e "\n\nNow run build_installer.sh\n\n"

exit 0
