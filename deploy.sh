#!/bin/bash

if [ x`hostname` != x'timberlake.cse.buffalo.edu' ]; then
    exit 1
fi

cp out/* /home/csefaculty/zzhao35/public_html/elrr/

