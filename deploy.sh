#!/bin/bash

if [ x`hostname` != x'timberlake.cse.buffalo.edu' ]; then
    exit 0
fi

cp -r out/* /home/csefaculty/zzhao35/public_html/elrr/

