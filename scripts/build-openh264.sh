#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/openh264
CONF_FLAGS=(
  PREFIX=$BUILD_DIR
  OS=linux
  ARCH=x86_32
  CXX=em++
  CC=emcc
  #-U_FORTIFY_SOURCE
  #HAVE_GTEST=No
  #--prefix=$BUILD_DIR           # install library in a build directory for FFmpeg to include
  #--host=i686-gnu               # use i686 linux
  #--enable-static               # enable building static library
  #--disable-cli                 # disable cli tools
  #--disable-asm                 # disable asm optimization
  #--extra-cflags="$CFLAGS -fno-stack-protector"      # flags to use pthread and code optimization
  CFLAGS="$CFLAGS -fno-stack-protector"      # flags to use pthread and code optimization
  ${EXTRA_CONF_FLAGS-}
)
    #echo "CONF_FLAGS=${CONF_FLAGS[@]}"
    #(cd $LIB_PATH && emconfigure ./configure "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH clean

# https://github.com/ttyridal/openh264-js/blob/master/Makefile
# https://stackoverflow.com/questions/58854858/undefined-symbol-stack-chk-guard-in-libopenh264-so-when-building-ffmpeg-wit
# https://github.com/duanyao/codecbox.js/blob/master/Gruntfile.js
emmake make -C $LIB_PATH libraries "${CONF_FLAGS[@]}"
emmake make -C $LIB_PATH install-static "${CONF_FLAGS[@]}"


