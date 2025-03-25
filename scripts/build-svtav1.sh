#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/svtav1
CM_FLAGS=(
  -DCMAKE_INSTALL_PREFIX=$BUILD_DIR
  -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE
  -DCMAKE_C_FLAGS="$CFLAGS"
  -DCMAKE_CXX_FLAGS="$CXXFLAGS"
  -DCMAKE_BUILD_TYPE=Release
  -DBUILD_SHARED_LIBS=OFF
  -DBUILD_TESTING=OFF
  -DBUILD_APPS=OFF
  -DBUILD_DEC=OFF

  # wasm
  -DCMAKE_HAVE_LIBC_PTHREAD=On
)
echo "CM_FLAGS=${CM_FLAGS[@]}"

rm -rf $LIB_PATH/Bin
rm -rf $LIB_PATH/Build/CMakeFiles
rm -rf $LIB_PATH/Build/Source
rm -rf $LIB_PATH/Build/third_party
rm -rf $LIB_PATH/Build/CMakeCache.txt
rm -rf $LIB_PATH/Build/cmake_install.cmake
rm -rf $LIB_PATH/Build/install_manifest.txt
rm -rf $LIB_PATH/Build/Makefile
rm -rf $LIB_PATH/Build/SvtAv1Dec.pc
rm -rf $LIB_PATH/Build/SvtAv1Enc.pc

# https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/master/Docs/Build-Guide.md
cd $LIB_PATH
cd Build

emmake cmake .. -G"Unix Makefiles" "${CM_FLAGS[@]}"
emmake make clean -j
emmake make install
cd $ROOT_DIR