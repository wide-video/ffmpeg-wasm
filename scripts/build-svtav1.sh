#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

replace()
{
	if ! grep -qF "$1" "$3"; then
		echo "$3 does not contain expected $1"
		exit 1
	fi
	ESCAPED_FROM=$(printf '%s\n' "$1" | sed -e 's/[]\/$*.^[]/\\&/g');
	ESCAPED_TO=$(printf '%s\n' "$2" | sed -e 's/[\/&]/\\&/g');
	sed -i -e "s/$ESCAPED_FROM/$ESCAPED_TO/g" $3
}

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
rm -rf $LIB_PATH/Build/cmake_install.cmake
rm -rf $LIB_PATH/Build/CMakeCache.txt
rm -rf $LIB_PATH/Build/Makefile
rm -rf $LIB_PATH/Build/SvtAv1Dec.pc
rm -rf $LIB_PATH/Build/SvtAv1Enc.pc

# removing hardcoded stack-protector
# https://gitlab.com/AOMediaCodec/SVT-AV1/-/issues/2108
replace "check_both_flags_add(-fstack-protector-strong)" "" $LIB_PATH/CMakeLists.txt

# https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/master/Docs/Build-Guide.md
cd $LIB_PATH
cd Build

emmake cmake .. -G"Unix Makefiles" "${CM_FLAGS[@]}"
emmake make clean -j
emmake make install
cd $ROOT_DIR