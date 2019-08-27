#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

chown -R $USER:admin /usr/local/*
rm -f /usr/local/share/aeneas_tools/beautifulsoup4-*.whl
rm -f /usr/local/share/aeneas_tools/soupsieve-*.whl
chown -R $USER:admin /usr/local/*

