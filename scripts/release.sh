#!/bin/bash

set -eo pipefail

mkdir -p ./wasm
rm -rf ./wasm/*

SCRIPT_ROOT=$(dirname $0)

export FFMPEG_SIMD=true
$SCRIPT_ROOT/clean.sh
$SCRIPT_ROOT/build.sh

export FFMPEG_SIMD=false
$SCRIPT_ROOT/clean.sh
$SCRIPT_ROOT/build.sh