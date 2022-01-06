#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/flite
CONF_FLAGS=(
  --prefix=$BUILD_DIR                                 # install library in a build directory for FFmpeg to include
  --host=i686-gnu                                     # use i686 linux
  --enable-shared=no                                  # not to build shared library
  --disable-shared
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"

(cd $LIB_PATH && \
  CFLAGS=$CFLAGS emconfigure ./configure "${CONF_FLAGS[@]}" && \
  emmake make clean && \
  emmake make)

cp $LIB_PATH/build/i386-gnu/lib/* $BUILD_DIR/lib
cp $LIB_PATH/flite.pc $BUILD_DIR/lib/pkgconfig
mkdir -p $BUILD_DIR/include/flite
cp $LIB_PATH/include/* $BUILD_DIR/include/flite
