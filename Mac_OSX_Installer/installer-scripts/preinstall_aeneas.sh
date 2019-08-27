#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

chown -R $USER:admin /usr/local/*
rm -f /usr/local/share/aeneas_tools/aeneas-*.whl
chown -R $USER:admin /usr/local/*

