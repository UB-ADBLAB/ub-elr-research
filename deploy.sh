#!/bin/bash

if [ x`hostname` != x'cerf' ]; then
    exit 0
fi

cp -r out/* /home/csefaculty/zzhao35/public_html/elrr/

