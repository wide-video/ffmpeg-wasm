#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/ffmpeg
FLAGS=(
  "${FFMPEG_CONFIG_FLAGS_BASE[@]}"
  --enable-gpl            # required by x264
  --enable-version3
  --enable-zlib
  --enable-libx264
  --enable-libx265
  --enable-libvpx
  --enable-libmp3lame
  --enable-libtheora
  --enable-libvorbis
  --enable-libopus
  --enable-libwebp
  --enable-librubberband
)
echo "FFMPEG_CONFIG_FLAGS=${FLAGS[@]}"
(cd $LIB_PATH && \
    PKG_CONFIG_PATH=$PWD/build/lib/pkgconfig && \
    emconfigure ./configure "${FLAGS[@]}")
