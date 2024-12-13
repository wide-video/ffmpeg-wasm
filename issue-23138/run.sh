#!/bin/bash

apt-get update
apt-get install -y git python3.11 build-essential cmake autoconf autogen automake libtool pkg-config ragel wget
git config --global pull.rebase false
ln -sf /usr/bin/python3.11 /usr/bin/python

# EMSDK
git clone --depth=1 --branch main https://github.com/emscripten-core/emsdk/
(cd emsdk && ./emsdk install 3.1.73)
(cd emsdk && ./emsdk activate 3.1.73)
source ./emsdk/emsdk_env.sh

# SETUP
export PATH=$PATH:$EMSDK/upstream/bin
ROOT_DIR=$PWD
WASM_DIR=$ROOT_DIR/wasm
BUILD_DIR=$ROOT_DIR/build
PKG_CONFIG_PATH=$BUILD_DIR/lib/pkgconfig
export EM_PKG_CONFIG_PATH=$PKG_CONFIG_PATH
TOOLCHAIN_FILE=$EMSDK/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake
export CFLAGS="-O3 -flto -I$BUILD_DIR/include -pthread -msimd128 -mavx"
export CXXFLAGS=$CFLAGS
export LDFLAGS="$CFLAGS -L$BUILD_DIR/lib"
mkdir -p $WASM_DIR

# libsndfile
git clone --depth=1 --branch master https://github.com/libsndfile/libsndfile
(cd libsndfile && \
  emconfigure autoreconf -vif && \
  CFLAGS="${CFLAGS/-mavx/}" emconfigure ./configure \
    --prefix=$BUILD_DIR \
    --host=i686-gnu \
    --enable-shared=no \
    --disable-asm \
    --disable-rtcd \
    --disable-doc \
    --disable-extra-programs \
    --disable-stack-protector)
emmake make -C libsndfile clean
emmake make -C libsndfile install