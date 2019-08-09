#!/bin/bash

EVIL=`head -c 10 /dev/urandom`
echo "#ifndef EVIL_H"
echo "#define EVIL_H"
echo "const char *evil = \"${EVIL}\";"
echo "#endif"
