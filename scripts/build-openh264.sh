#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/openh264
CONF_FLAGS=(
  PREFIX=$BUILD_DIR
  ARCH=x86_32
  CXX=em++
  CC=emcc
  AR=emar
  BUILDTYPE=Release
  DEBUGSYMBOLS=False

  # https://stackoverflow.com/questions/58854858/undefined-symbol-stack-chk-guard-in-libopenh264-so-when-building-ffmpeg-wit
  CFLAGS="$CFLAGS -fno-stack-protector"
)

emmake make -C $LIB_PATH clean
emmake make -C $LIB_PATH install-static "${CONF_FLAGS[@]}"
