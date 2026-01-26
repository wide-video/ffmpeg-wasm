#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/kvazaar
CONF_FLAGS=(
  --prefix=$BUILD_DIR           # install library in a build directory for FFmpeg to include
  --host=i686-gnu               # use i686 linux
  --enable-static               # enable building static library
  --disable-shared
  --with-pic
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
(cd $LIB_PATH && \
  emconfigure ./autogen.sh && \
  emconfigure ./configure "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH clean
emmake make -C $LIB_PATH -j$(nproc)
emmake make -C $LIB_PATH install
