#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/zimg
CONF_FLAGS=(
  --prefix=$BUILD_DIR              # lib installation directory
  --host=wasm32-unknown-emscripten
  --disable-shared                 # build static library
  --disable-tools                  # CMD line utils
  --enable-static                  # enable static library
  --enable-avx512
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
(cd $LIB_PATH && \
  emconfigure ./autogen.sh && \
  CFLAGS=$CFLAGS LDFLAGS=$LDFLAGS emconfigure ./configure "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH clean
emmake make -C $LIB_PATH install -j