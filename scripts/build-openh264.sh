#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/openh264
CONF_FLAGS=(
  --prefix=$BUILD_DIR           # install library in a build directory for FFmpeg to include
  --host=i686-gnu               # use i686 linux
  --enable-static               # enable building static library
  --disable-cli                 # disable cli tools
  --disable-asm                 # disable asm optimization
  --extra-cflags="$CFLAGS"      # flags to use pthread and code optimization
  ${EXTRA_CONF_FLAGS-}
)
    #echo "CONF_FLAGS=${CONF_FLAGS[@]}"
    #(cd $LIB_PATH && emconfigure ./configure "${CONF_FLAGS[@]}")
#emmake make -C $LIB_PATH clean

#https://github.com/ttyridal/openh264-js/blob/master/Makefile
#emmake make -C $LIB_PATH libraries OS=linux ARCH=x86_32 CXX=em++ CC=emcc HAVE_GTEST=No
emmake make -C $LIB_PATH install-static OS=linux ARCH=x86_32 CXX=em++ CC=emcc PREFIX=$BUILD_DIR


