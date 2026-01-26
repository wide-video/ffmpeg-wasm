#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/aom
CMBUILD_DIR=aom_build
CM_FLAGS=(
  # common
  -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE        # use emscripten toolchain file
  -DAOM_TARGET_CPU=generic
  -DENABLE_DOCS=0
  -DENABLE_TESTS=0
  -DCONFIG_RUNTIME_CPU_DETECT=0
  -DCONFIG_WEBM_IO=0

  # https://aomedia.googlesource.com/aom/
  #-DENABLE_CCACHE=1
  #-DCONFIG_ACCOUNTING=1
  #-DCONFIG_INSPECTION=1
  #-DCONFIG_MULTITHREAD=0

  # https://github.com/ffmpegwasm/ffmpeg.wasm-core/blob/n4.3.1-wasm/wasm/build-scripts/build-aom.sh
  -DCMAKE_INSTALL_PREFIX=$BUILD_DIR             # assign lib and include install path
  -DBUILD_SHARED_LIBS=0                         # disable shared library build
  -DENABLE_EXAMPLES=0                           # disable examples
  -DENABLE_TOOLS=0                              # disable tools

  # https://github.com/xiph/aomanalyzer/issues/81
  -DCMAKE_BUILD_TYPE=Release
)

echo "CM_FLAGS=${CM_FLAGS[@]}"

rm -rf $LIB_PATH/CMakeCache.txt
rm -rf $LIB_PATH/CMakeFiles
rm -rf $LIB_PATH/$CMBUILD_DIR
mkdir -p $LIB_PATH/$CMBUILD_DIR

(cd $LIB_PATH/$CMBUILD_DIR && emmake cmake .. ${CM_FLAGS[@]} \
  -DAOM_EXTRA_C_FLAGS="$CFLAGS" \
  -DAOM_EXTRA_CXX_FLAGS="$CXXFLAGS" \
  -G"Unix Makefiles")
emmake make -C $LIB_PATH/$CMBUILD_DIR clean
emmake make -C $LIB_PATH/$CMBUILD_DIR install -j$(nproc)
