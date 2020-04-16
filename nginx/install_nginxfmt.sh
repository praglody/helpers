#! /bin/bash

[ -s ngxfmt.py ] || curl -fsSL https://raw.githubusercontent.com/fangpsh/ngxfmt/master/ngxfmt.py > nginxfmt.py

if [ $? -ne 0 ]; then
    echo "curl error"
    exit 1
fi

[ -x ngxfmt.py ] || chmod +x ngxfmt.py

cp ngxfmt.py /usr/local/bin/ngxfmt

