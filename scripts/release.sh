#!/bin/bash

set -eo pipefail

mkdir -p ./wasm
rm -rf ./wasm/*

SCRIPT_ROOT=$(dirname $0)

export FFMPEG_LGPL=true
export FFMPEG_SKIP_LIBS=false
$SCRIPT_ROOT/clean.sh
$SCRIPT_ROOT/build.sh

export FFMPEG_LGPL=false
export FFMPEG_SKIP_LIBS=true
$SCRIPT_ROOT/build.sh