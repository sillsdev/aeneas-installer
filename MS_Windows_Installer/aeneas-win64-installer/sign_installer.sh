#!/bin/bash

osslsigncode sign -pkcs12 "$HOME/MacInstaller.p12" -askpass -n "Aeneas Tools" -i "http://www.readbeyond.it/aeneas/" -t "http://timestamp.comodoca.com/authenticode" -in "./aeneas-win64-setup-1.7.3.0_3.exe" -out "./aeneas-win64-setup-1.7.3.0_3_signed.exe"
osslsigncode verify "./aeneas-win64-setup-1.7.3.0_3_signed.exe"

