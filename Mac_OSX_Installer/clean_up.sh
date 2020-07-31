#!/bin/bash

find . -name "*.mpkg" -print0 -exec rm -vrf "{}" \;
find . -name "*.pkg" -print -delete
find . -name "*.dmg" -print -delete
find . -name "*.zip" -print -delete
find . -name "*.gz" -print -delete
find . -name aeneas-1.7* -type d -print0 -exec rm -vrf "{}" \;
