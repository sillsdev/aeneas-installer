#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH

python -m ensurepip 2> /dev/null
pip install -U /Users/Shared/pip-8.1.2-py2.py3-none-any.whl
pip install -U /Users/Shared/beautifulsoup4-4.4.1-py2-none-any.whl

