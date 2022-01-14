#!/bin/bash

set -eo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/ffmpeg
WASM_DIR=$ROOT_DIR/build/wasm
mkdir -p $WASM_DIR

FLAGS=(
  -I. -I./fftools -I$BUILD_DIR/include
  -Llibavcodec -Llibavdevice -Llibavfilter -Llibavformat -Llibavresample -Llibavutil -Llibpostproc -Llibswscale -Llibswresample -Lrubberband -Lsamplerate -Lflite -L$BUILD_DIR/lib
  -Wno-deprecated-declarations -Wno-pointer-sign -Wno-implicit-int-float-conversion -Wno-switch -Wno-parentheses -Qunused-arguments
  -lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lpostproc -lm -lx264 -lx265 -lvpx -lmp3lame -lfdk-aac -lvorbis -lvorbisenc -lvorbisfile -logg -ltheora -ltheoraenc -ltheoradec -lz -lopus -lwebp -lrubberband -lsamplerate
  fftools/ffmpeg_opt.c fftools/ffmpeg_filter.c fftools/ffmpeg_hw.c fftools/cmdutils.c fftools/ffmpeg.c
  -lworkerfs.js
  -s USE_SDL=2                                  # use SDL2
  -s INVOKE_RUN=0                               # not to run the main() in the beginning
  -s EXIT_RUNTIME=1                             # exit runtime after execution
  -s MODULARIZE=1                               # use modularized version to be more flexible
  -s EXPORT_NAME="createFFmpeg"             # assign export name for browser
  -s EXPORTED_FUNCTIONS="[_main, ___wasm_init_memory_flag]"
  -s EXPORTED_RUNTIME_METHODS="[callMain, FS, WORKERFS]"
  -s INITIAL_MEMORY=268435456                   # 64 KB * 1024 * 16 * 2047 = 2146435072 bytes ~= 2 GB, 134217728 = 128 MB
  -s ALLOW_MEMORY_GROWTH=1
  -s MAXIMUM_MEMORY=4gb
  -s ENVIRONMENT=worker
  -s USE_PTHREADS=1                             # enable pthreads support
  -s PROXY_TO_PTHREAD=1                         # detach main() from browser/UI main thread
  -msimd128
  -pthread
  $OPTIM_FLAGS
  -o $WASM_DIR/ffmpeg.js
)
echo "FFMPEG_EM_FLAGS=${FLAGS[@]}"
(cd $LIB_PATH && \
    emmake make -j && \
    emcc "${FLAGS[@]}")

gzip --force -9 -c $WASM_DIR/ffmpeg.wasm > $WASM_DIR/ffmpeg.wasm.gz
rm $WASM_DIR/ffmpeg.wasm