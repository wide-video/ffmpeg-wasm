#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/ffmpeg

if [[ "$FFMPEG_ST" == "yes" ]]; then
  EXTRA_FLAGS=(
    --disable-pthreads
	--disable-w32threads
	--disable-os2threads
  )
else
  EXTRA_FLAGS=()  
fi

FLAGS=(
  --target-os=none        # use none to prevent any os specific configurations
  --arch=x86_32           # use x86_32 to achieve minimal architectural optimization
  --enable-cross-compile
  --enable-version3
  --enable-zlib
  --enable-libaom
  --enable-libopenh264
  --enable-libkvazaar
  --enable-libvpx
  --enable-libmp3lame
  --enable-libtheora
  --enable-libvorbis
  --enable-libopus
  --enable-libwebp
  --enable-librubberband
  --disable-x86asm
  --disable-inline-asm
  --disable-stripping
  --disable-programs      # disable programs build (incl. ffplay, ffprobe & ffmpeg)
  --disable-doc
  --disable-debug
  --disable-runtime-cpudetect
  --disable-autodetect    # disable external libraries auto detect
  --extra-cflags="$CFLAGS"
  --extra-cxxflags="$CFLAGS"
  --extra-ldflags="$LDFLAGS"
  --pkg-config-flags="--static"
  --nm="llvm-nm"
  --ar=emar
  --ranlib=emranlib
  --cc=emcc
  --cxx=em++
  --objcc=emcc
  --dep-cc=emcc
  ${EXTRA_FLAGS[@]}
)

sed -i 's/    librubberband//g' $LIB_PATH/configure
sed -i 's/    vapoursynth/librubberband\nvapoursynth/g' $LIB_PATH/configure

echo "FFMPEG_CONFIG_FLAGS=${FLAGS[@]}"
(cd $LIB_PATH && \
    PKG_CONFIG_PATH=$PWD/build/lib/pkgconfig && \
    emconfigure ./configure "${FLAGS[@]}")
