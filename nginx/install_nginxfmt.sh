#! /bin/bash

source_name="ngxfmt.sh"
[ -s $source_name ] || curl -fsSL https://raw.githubusercontent.com/fangpsh/ngxfmt/master/ngxfmt.py > $source_name

if [ $? -ne 0 ]; then
    echo "curl error"
    exit 1
fi

[ -x $source_name ] || chmod +x $source_name

cp $source_name /usr/local/bin/ngxfmt
