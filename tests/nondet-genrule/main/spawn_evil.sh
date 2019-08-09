#!/bin/bash

EVIL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo "#ifndef EVIL_H"
echo "#define EVIL_H"
echo "const char *evil = \"${EVIL}\";"
echo "#endif"
