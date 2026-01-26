#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/libjxl
CMBUILD_DIR=build-wasm32

# removing -mavx2, as of 2026-01-23 the build fails
# In file included from /ffmpeg-wasm/modules/libjxl/third_party/skcms/skcms.cc:31:
# /ffmpeg-wasm/modules/emsdk/upstream/lib/clang/22/include/avx512fintrin.h:10:2: error: "Never use <avx512fintrin.h> directly; include <immintrin.h> instead."
#   10 | #error "Never use <avx512fintrin.h> directly; include <immintrin.h> instead."
JPEGXL_CFLAGS=${CFLAGS//-mavx2/}
JPEGXL_CXXFLAGS=${CXXFLAGS//-mavx2/}

# -flto makes libjxl.a grow from 3.2M to 6.9M
JPEGXL_CFLAGS=${JPEGXL_CFLAGS//-flto/}
JPEGXL_CXXFLAGS=${JPEGXL_CXXFLAGS//-flto/}

rm -rf $LIB_PATH/$CMBUILD_DIR
mkdir -p $LIB_PATH/$CMBUILD_DIR

# using `-DJPEGXL_ENABLE_ENCODER=OFF` has no effect on produced 3.2MB libjxl.a (35.0MB ffmpeg.wasm)
(cd $LIB_PATH/$CMBUILD_DIR && emmake cmake .. \
  -G"Unix Makefiles" \
  -DCMAKE_INSTALL_PREFIX=$BUILD_DIR \
  -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_TESTING=OFF \
  -DJPEGXL_ENABLE_TOOLS=OFF \
  -DJPEGXL_BUNDLE_LIBPNG=OFF \
  -DJPEGXL_ENABLE_EXAMPLES=OFF \
  -DCMAKE_C_FLAGS="$JPEGXL_CFLAGS" \
  -DCMAKE_CXX_FLAGS="$JPEGXL_CXXFLAGS")
emmake make -C $LIB_PATH/$CMBUILD_DIR clean
emmake make -C $LIB_PATH/$CMBUILD_DIR install -j$(nproc)

# fix ffmpeg build error
# wasm-ld: error: /ffmpeg-wasm/wasm/ffmpeg-lgpl.wasm.lto.o: undefined symbol:
# skcms_private::baseline::run_program(skcms_private::Op const*, void const**, long, char const*, char*, int, unsigned long, unsigned long)
em++ -c $LIB_PATH/third_party/skcms/src/skcms_TransformBaseline.cc -o $LIB_PATH/$CMBUILD_DIR/skcms_baseline.o 
emar r $BUILD_DIR/lib/libjxl_cms.a $LIB_PATH/$CMBUILD_DIR/skcms_baseline.o
# check if `run_program` symbol exists in .a file
# emnm $BUILD_DIR/lib/libjxl_cms.a | grep run_program
