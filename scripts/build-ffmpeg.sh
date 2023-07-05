#!/bin/bash

set -eo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/ffmpeg
INFO_FILE=$WASM_DIR/info.txt

mkdir -p $WASM_DIR

FLAGS=(
  $CFLAGS

  # Common
  -I. -I./fftools -I$BUILD_DIR/include
  -Llibavcodec -Llibavdevice -Llibavfilter -Llibavformat -Llibavresample -Llibavutil -Llibswscale -Llibswresample -L$BUILD_DIR/lib
  -Wno-deprecated-declarations -Wno-pointer-sign -Wno-implicit-int-float-conversion -Wno-switch -Wno-parentheses -Qunused-arguments
  -lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lm
  fftools/cmdutils.c fftools/ffmpeg.c fftools/ffmpeg_dec.c fftools/ffmpeg_demux.c fftools/ffmpeg_enc.c fftools/ffmpeg_filter.c fftools/ffmpeg_hw.c fftools/ffmpeg_mux.c fftools/ffmpeg_mux_init.c fftools/ffmpeg_opt.c fftools/objpool.c fftools/opt_common.c fftools/sync_queue.c fftools/thread_queue.c

  # Features
  -laom
  -lSvtAv1Dec -lSvtAv1Enc -LSvtAv1Dec -LSvtAv1Enc -Llibstvav1
  -lopenh264
  -lkvazaar
  -lvpx
  -lmp3lame
  -lvorbis -lvorbisenc -lvorbisfile
  -logg
  -ltheora -ltheoraenc -ltheoradec
  -lz
  -lopus
  -lwebp -lwebpmux
  -lsharpyuv
  -lrubberband -lsamplerate -Lrubberband -Lsamplerate

  # Emscripten
  -lworkerfs.js
  -s USE_SDL=2
  -s INVOKE_RUN=0
  -s EXIT_RUNTIME=1
  -s MODULARIZE=1
  -s EXPORT_NAME="createFFmpeg"
  -s EXPORTED_FUNCTIONS="[_main, ___wasm_init_memory_flag]"
  -s EXPORTED_RUNTIME_METHODS="[callMain, FS, WORKERFS]"
  -s INITIAL_MEMORY=128mb
  -s ALLOW_MEMORY_GROWTH=1
  -s MAXIMUM_MEMORY=4gb
  -s ENVIRONMENT=worker
  -s PROXY_TO_PTHREAD=1
  -s STACK_SIZE=5MB                     # required since 3.1.27 (Uncaught Infinity runtime error)
  -s DEFAULT_PTHREAD_STACK_SIZE=2MB     # required since 3.1.27 (Uncaught Infinity runtime error)
  -pthread
  -o $OUTPUT_PATH
)

if [ "$FFMPEG_LGPL" = false ] ; then
    OUTPUT_FILENAME="$OUTPUT_FILENAME-lgpl"
    FLAGS+=(
        -lx264
        -lx265
        -Llibpostproc
        -lpostproc
    )
fi

echo "FFMPEG_EM_FLAGS=${FLAGS[@]}"
(cd $LIB_PATH && \
    emmake make -j4 && \
    emcc "${FLAGS[@]}")

echo "emcc ${FLAGS[@]}" > $INFO_FILE
echo "" >> $INFO_FILE

git config --get remote.origin.url >> $INFO_FILE
git rev-parse HEAD >> $INFO_FILE
echo "" >> $INFO_FILE

echo "EMCC (emcc -v)" >> $INFO_FILE
emcc -v &>> $INFO_FILE
echo "" >> $INFO_FILE

git submodule foreach 'git config --get remote.origin.url && git rev-parse HEAD && echo ""' >> $INFO_FILE
