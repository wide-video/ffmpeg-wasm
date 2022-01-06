#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/ffmpeg
FLAGS=(
  "${FFMPEG_CONFIG_FLAGS_BASE[@]}"
  --enable-gpl            # required by x264
  --enable-nonfree        # required by fdk-aac
  --enable-zlib           # enable zlib
  --enable-libx264        # enable x264
  --enable-libx265        # enable x265
  --enable-libvpx         # enable libvpx / webm
  --enable-libmp3lame     # enable libmp3lame
  --enable-libfdk-aac     # enable libfdk-aac
  --enable-libflite       # enable libflite
  --enable-libtheora      # enable libtheora
  --enable-libvorbis      # enable libvorbis
  --enable-libopus        # enable opus
  --enable-libwebp        # enable libwebp
  --enable-librubberband  # enable librubberband
)
echo "FFMPEG_CONFIG_FLAGS=${FLAGS[@]}"
(cd $LIB_PATH && \
    PKG_CONFIG_PATH=$PWD/build/lib/pkgconfig && \
    emconfigure ./configure "${FLAGS[@]}")
