#!/bin/bash

set -eo pipefail

mkdir -p ./wasm
rm -rf ./wasm/*

SCRIPT_ROOT=$(dirname $0)

export FFMPEG_SIMD=true
export FFMPEG_LGPL=true
$SCRIPT_ROOT/clean.sh
$SCRIPT_ROOT/build.sh

export FFMPEG_SIMD=true
export FFMPEG_LGPL=false
$SCRIPT_ROOT/clean.sh
$SCRIPT_ROOT/build.sh

export FFMPEG_SIMD=false
export FFMPEG_LGPL=true
$SCRIPT_ROOT/clean.sh
$SCRIPT_ROOT/build.sh

export FFMPEG_SIMD=false
export FFMPEG_LGPL=false
$SCRIPT_ROOT/clean.sh
$SCRIPT_ROOT/build.sh