#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH

python -m ensurepip 2> /dev/null
pip install -U /Users/Shared/numpy-1.10.1-cp27-none-macosx_10_6_intel.whl

