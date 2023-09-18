#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/x265

BASE_FLAGS=(
  -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE
  -DCMAKE_C_FLAGS="$CFLAGS"
  -DCMAKE_CXX_FLAGS="$CXXFLAGS"
  -DX64=1
  -DX86_64=1
  -DENABLE_LIBNUMA=OFF
  -DENABLE_SHARED=OFF
  -DENABLE_CLI=OFF
)

FLAGS_12BIT=(
  "${BASE_FLAGS[@]}"
  -DHIGH_BIT_DEPTH=ON
  -DEXPORT_C_API=OFF
  -DMAIN12=ON
)

FLAGS_10BIT=(
  "${BASE_FLAGS[@]}"
  -DHIGH_BIT_DEPTH=ON
  -DEXPORT_C_API=OFF
)

FLAGS_MAIN=(
  "${BASE_FLAGS[@]}"
  -DCMAKE_INSTALL_PREFIX=$BUILD_DIR
  -DEXTRA_LIB="x265_main10.a;x265_main12.a"
  -DEXTRA_LINK_FLAGS=-L.
  -DLINKED_10BIT=ON
  -DLINKED_12BIT=ON
)

cd $LIB_PATH/source
rm -rf build
mkdir -p build
cd build
mkdir -p main 10bit 12bit

cd 12bit
emmake cmake ../.. -G"Unix Makefiles" "${FLAGS_12BIT[@]}"
emmake make clean
emmake make -j

cd ../10bit 
emmake cmake ../.. -G"Unix Makefiles" "${FLAGS_10BIT[@]}"
emmake make clean
emmake make -j

cd ../main
ln -sf ../10bit/libx265.a libx265_main10.a
ln -sf ../12bit/libx265.a libx265_main12.a
emmake cmake ../.. -G"Unix Makefiles" "${FLAGS_MAIN[@]}"
emmake make clean
emmake make -j
mv libx265.a libx265_main.a

# Merge static libraries
emar -M <<EOF
CREATE libx265.a
ADDLIB libx265_main.a
ADDLIB libx265_main10.a
ADDLIB libx265_main12.a
SAVE
END
EOF
emmake make install -j

cd $ROOT_DIR
#cp $LIB_PATH/x265.pc $BUILD_DIR/lib/pkgconfig
