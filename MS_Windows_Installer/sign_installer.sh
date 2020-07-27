#!/bin/bash

osslsigncode sign -pkcs12 "$HOME/MacInstaller.p12" -askpass -n "Aeneas Tools" -i "http://www.readbeyond.it/aeneas/" -t "http://timestamp.comodoca.com/authenticode" -in "$HOME/aeneas-windows-setup-1.7.3.0_2.exe" -out "$HOME/aeneas-windows-setup-1.7.3.0_2_signed.exe"
osslsigncode verify "$HOME/aeneas-windows-setup-1.7.3.0_2_signed.exe"

