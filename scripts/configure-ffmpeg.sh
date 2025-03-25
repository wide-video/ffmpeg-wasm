#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/ffmpeg

FLAGS=(
  --target-os=none        # use none to prevent any os specific configurations
  --arch=wasm32
  --cpu=generic
  --enable-cross-compile
  --enable-version3
  --enable-zlib
  --enable-libaom --disable-encoder=libaom_av1
  --enable-libopenh264
  --enable-libkvazaar
  --enable-libvpx
  --enable-libmp3lame
  --enable-libtheora
  --enable-libvorbis
  --enable-libopus
  --enable-libwebp
  --enable-libsvtav1
  --enable-librubberband
  --disable-stripping
  --disable-programs      # disable programs build (incl. ffplay, ffprobe & ffmpeg)
  --disable-doc
  --disable-debug
  --disable-runtime-cpudetect
  --disable-autodetect    # disable external libraries auto detect
  --extra-cflags="$CFLAGS"
  --extra-cxxflags="$CXXFLAGS"
  --extra-ldflags="$LDFLAGS"
  --pkg-config-flags="--static"
  --nm=emnm
  --ar=emar
  --ranlib=emranlib
  --cc=emcc
  --cxx=em++
  --objcc=emcc
  --dep-cc=emcc
)

if [ "$FFMPEG_LGPL" = false ] ; then
    FLAGS+=(
        --enable-gpl
        --enable-libx264
        --enable-libx265
    )
fi

sed -i 's/    librubberband//g' $LIB_PATH/configure
sed -i 's/    vapoursynth/librubberband\nvapoursynth/g' $LIB_PATH/configure

echo "FFMPEG_CONFIG_FLAGS=${FLAGS[@]}"
(cd $LIB_PATH && \
    PKG_CONFIG_PATH=$PWD/build/lib/pkgconfig && \
    emconfigure ./configure "${FLAGS[@]}")
