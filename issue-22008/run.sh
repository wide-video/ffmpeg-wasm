#!/bin/bash

apt-get update
apt-get install -y git python3.11 build-essential cmake autoconf autogen automake libtool pkg-config ragel wget
git config --global pull.rebase false
ln -sf /usr/bin/python3.11 /usr/bin/python

# EMSDK
git clone --depth=1 --branch main https://github.com/emscripten-core/emsdk/
(cd emsdk && ./emsdk install 3.1.57)
(cd emsdk && ./emsdk activate 3.1.57)
source ./emsdk/emsdk_env.sh

# SETUP
export PATH=$PATH:$EMSDK/upstream/bin
ROOT_DIR=$PWD
WASM_DIR=$ROOT_DIR/wasm
BUILD_DIR=$ROOT_DIR/build
PKG_CONFIG_PATH=$BUILD_DIR/lib/pkgconfig
export EM_PKG_CONFIG_PATH=$PKG_CONFIG_PATH
TOOLCHAIN_FILE=$EMSDK/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake
export CFLAGS="-O0 -I$BUILD_DIR/include -pthread -msimd128"
export CXXFLAGS=$CFLAGS
export LDFLAGS="$CFLAGS -L$BUILD_DIR/lib"
mkdir -p $WASM_DIR

# AOM
git clone --depth=1 --branch v3.9.0 https://aomedia.googlesource.com/aom/
rm -rf aom/CMakeCache.txt
rm -rf aom/CMakeFiles
rm -rf aom/aom_build
mkdir -p aom/aom_build
(cd aom/aom_build && emmake cmake .. \
  -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE \
  -DAOM_TARGET_CPU=generic \
  -DENABLE_DOCS=0 -DENABLE_TESTS=0 \
  -DCONFIG_RUNTIME_CPU_DETECT=0 \
  -DCONFIG_WEBM_IO=0 \
  -DCMAKE_INSTALL_PREFIX=$BUILD_DIR \
  -DBUILD_SHARED_LIBS=0 \
  -DENABLE_EXAMPLES=0 \
  -DENABLE_TOOLS=0 \
  -DCMAKE_BUILD_TYPE=Release  \
  -DAOM_EXTRA_C_FLAGS="$CFLAGS" \
  -DAOM_EXTRA_CXX_FLAGS="$CXXFLAGS" \
  -G"Unix Makefiles")
emmake make -C aom/aom_build clean
emmake make -C aom/aom_build install -j

# VPX
git clone --depth=1 --branch v1.14.0 https://github.com/webmproject/libvpx/
(cd libvpx && emconfigure ./configure \
  --prefix=$BUILD_DIR \
  --target=generic-gnu \
  --disable-install-bins \
  --disable-examples \
  --disable-tools \
  --disable-docs \
  --disable-unit-tests \
  --disable-dependency-tracking \
  --disable-shared \
  --disable-codec-srcs \
  --disable-debug-libs \
  --extra-cflags="$CFLAGS" \
  --extra-cxxflags="$CXXFLAGS")
emmake make -C libvpx clean
emmake make -C libvpx install STRIP=emstrip -j

## FFmpeg
git clone --depth=1 --branch n7.0.1 https://github.com/FFmpeg/FFmpeg
(cd FFmpeg && emconfigure ./configure \
  --target-os=none \
  --arch=x86_32 \
  --enable-cross-compile \
  --enable-version3 \
  --enable-libaom \
  --disable-encoder=libaom_av1 \
  --enable-libvpx \
  --disable-x86asm \
  --disable-inline-asm \
  --disable-stripping \
  --disable-programs \
  --disable-doc \
  --disable-debug \
  --disable-runtime-cpudetect \
  --disable-autodetect \
  --extra-cflags="$CFLAGS" \
  --extra-cxxflags="$CXXFLAGS" \
  --extra-ldflags="$LDFLAGS" \
  --pkg-config-flags="--static" \
  --nm=emnm \
  --ar=emar \
  --ranlib=emranlib \
  --cc=emcc \
  --cxx=em++ \
  --objcc=emcc \
  --dep-cc=emcc)
emmake make -C FFmpeg -j4
(cd FFmpeg && emcc \
  $LDFLAGS \
  -I. -I./fftools -I$BUILD_DIR/include \
  -Llibavcodec -Llibavdevice -Llibavfilter -Llibavformat -Llibavresample -Llibavutil -Llibswscale -Llibswresample \
  -Wno-deprecated-declarations -Wno-pointer-sign -Wno-implicit-int-float-conversion -Wno-switch -Wno-parentheses -Qunused-arguments \
  -lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lm \
  -laom \
  -lvpx \
  fftools/cmdutils.c \
  fftools/ffmpeg.c \
  fftools/ffmpeg_dec.c \
  fftools/ffmpeg_demux.c \
  fftools/ffmpeg_enc.c \
  fftools/ffmpeg_filter.c \
  fftools/ffmpeg_hw.c \
  fftools/ffmpeg_mux.c \
  fftools/ffmpeg_mux_init.c \
  fftools/ffmpeg_opt.c \
  fftools/ffmpeg_sched.c \
  fftools/objpool.c \
  fftools/opt_common.c \
  fftools/sync_queue.c \
  fftools/thread_queue.c \
  -lworkerfs.js \
  -s USE_SDL=2 \
  -s WASM_BIGINT \
  -s INVOKE_RUN=0 \
  -s EXIT_RUNTIME=1 \
  -s MODULARIZE=1 \
  -s EXPORT_NAME="createFFmpeg" \
  -s EXPORTED_FUNCTIONS="[_main, ___wasm_init_memory_flag]" \
  -s EXPORTED_RUNTIME_METHODS="[callMain, FS, WORKERFS]" \
  -s INITIAL_MEMORY=128mb \
  -s ALLOW_MEMORY_GROWTH=1 \
  -s MAXIMUM_MEMORY=4gb \
  -s ENVIRONMENT=worker \
  -s PROXY_TO_PTHREAD=1 \
  -s STACK_SIZE=5MB \
  -s DEFAULT_PTHREAD_STACK_SIZE=2MB \
  -o $WASM_DIR/ffmpeg-lgpl-simd.js)