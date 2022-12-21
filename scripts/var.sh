#!/bin/bash

set -euo pipefail

# Include llvm binaries
export PATH=$PATH:$EMSDK/upstream/bin

ROOT_DIR=$PWD
WASM_DIR=$ROOT_DIR/wasm
BUILD_DIR=$ROOT_DIR/build
EM_PKG_CONFIG_PATH=$BUILD_DIR/lib/pkgconfig
TOOLCHAIN_FILE=$EMSDK/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake

OPTIM_FLAGS="-O3"

CFLAGS_BASE="$OPTIM_FLAGS -I$BUILD_DIR/include -s USE_PTHREADS=1"

if [ "$FFMPEG_SIMD" = true ] ; then
    CFLAGS="$CFLAGS_BASE -msimd128"
	OUTPUT_PATH=$WASM_DIR/ffmpeg-simd.js
	OUTPUT_PATH_WV=$WASM_DIR/ffmpeg-simd-wv.js
else
    CFLAGS="$CFLAGS_BASE"
	OUTPUT_PATH=$WASM_DIR/ffmpeg.js
	OUTPUT_PATH_WV=$WASM_DIR/ffmpeg-wv.js
fi

export CFLAGS=$CFLAGS
export CXXFLAGS=$CFLAGS
export LDFLAGS="$CFLAGS -L$BUILD_DIR/lib"
export STRIP="llvm-strip"
export EM_PKG_CONFIG_PATH=$EM_PKG_CONFIG_PATH

echo "EMSDK=$EMSDK"
echo "CFLAGS(CXXFLAGS)=$CFLAGS"
echo "BUILD_DIR=$BUILD_DIR"
