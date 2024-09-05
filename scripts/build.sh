#!/bin/bash

set -eo pipefail

SCRIPT_ROOT=$(dirname $0)

source $SCRIPT_ROOT/init-emscripten.sh

if [ "$FFMPEG_SKIP_LIBS" = false ] ; then
    $SCRIPT_ROOT/build-zlib.sh
    $SCRIPT_ROOT/build-aom.sh
    $SCRIPT_ROOT/build-lame.sh
    $SCRIPT_ROOT/build-libvpx.sh
    $SCRIPT_ROOT/build-libwebp.sh
    $SCRIPT_ROOT/build-ogg.sh
    $SCRIPT_ROOT/build-opus.sh
    $SCRIPT_ROOT/build-rubberband.sh
    $SCRIPT_ROOT/build-theora.sh
    $SCRIPT_ROOT/build-vorbis.sh
    $SCRIPT_ROOT/build-openh264.sh
    $SCRIPT_ROOT/build-kvazaar.sh
    $SCRIPT_ROOT/build-svtav1.sh

    # GPL
    $SCRIPT_ROOT/build-x264.sh
    $SCRIPT_ROOT/build-x265.sh
fi

$SCRIPT_ROOT/configure-ffmpeg.sh
$SCRIPT_ROOT/build-ffmpeg.sh
$SCRIPT_ROOT/customize-ffmpeg.sh