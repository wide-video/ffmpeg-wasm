#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/libwebp
CM_FLAGS=(
  -DCMAKE_INSTALL_PREFIX=$BUILD_DIR
  -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE
  -DBUILD_SHARED_LIBS=OFF
  -DZLIB_LIBRARY=$BUILD_DIR/lib
  -DZLIB_INCLUDE_DIR=$BUILD_DIR/include
  -DWEBP_BUILD_ANIM_UTILS=OFF
  -DWEBP_BUILD_CWEBP=OFF
  -DWEBP_BUILD_DWEBP=OFF
  -DWEBP_BUILD_GIF2WEBP=OFF
  -DWEBP_BUILD_IMG2WEBP=OFF
  -DWEBP_BUILD_VWEBP=OFF
  -DWEBP_BUILD_WEBPINFO=OFF
  -DWEBP_BUILD_WEBPMUX=OFF
  -DWEBP_BUILD_EXTRAS=OFF
  -DWEBP_ENABLE_SIMD=ON
)

echo "CM_FLAGS=${CM_FLAGS[@]}"

cd $LIB_PATH
mkdir -p build
cd build

# common_sse2.h uses `#if defined(WEBP_USE_SSE2)` to define some variables
# and some other .c/.h access these vars under `#if defined(WEBP_USE_SSE43)`,
# however, during build, WEBP_USE_SSE4x is true while WEBP_USE_SSE2 is false.
# Try removing the `-DWEBP_USE_SSE2` when next webp version is used.
emmake cmake .. -DCMAKE_C_FLAGS="$CXXFLAGS -DWEBP_USE_SSE2 -Wno-incompatible-pointer-types" ${CM_FLAGS[@]}
emmake make clean
emmake make install
cd $ROOT_DIR
