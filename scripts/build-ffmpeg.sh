#!/bin/bash

set -eo pipefail
source $(dirname $0)/var.sh

LIB_PATH=modules/ffmpeg
WASM_DIR=$ROOT_DIR/build/wasm
INFO_FILE=$WASM_DIR/info.txt

mkdir -p $WASM_DIR

FLAGS=(
  $CFLAGS
  -I. -I./fftools -I$BUILD_DIR/include
  -Llibavcodec -Llibavdevice -Llibavfilter -Llibavformat -Llibavresample -Llibavutil -Llibpostproc -Llibswscale -Llibswresample -Lrubberband -Lsamplerate -Lflite -L$BUILD_DIR/lib
  -Wno-deprecated-declarations -Wno-pointer-sign -Wno-implicit-int-float-conversion -Wno-switch -Wno-parentheses -Qunused-arguments
  -lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lpostproc -lm -laom -lx264 -lx265 -lvpx -lmp3lame -lvorbis -lvorbisenc -lvorbisfile -logg -ltheora -ltheoraenc -ltheoradec -lz -lopus -lwebp -lwebpmux -lrubberband -lsamplerate
  fftools/ffmpeg_opt.c fftools/ffmpeg_filter.c fftools/ffmpeg_hw.c fftools/cmdutils.c fftools/ffmpeg.c fftools/opt_common.c fftools/ffmpeg_mux.c
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
  -pthread
  -o $WASM_DIR/ffmpeg.js
)
echo "FFMPEG_EM_FLAGS=${FLAGS[@]}"
(cd $LIB_PATH && \
    emmake make -j && \
    emcc "${FLAGS[@]}")

gzip --force -9 -c $WASM_DIR/ffmpeg.wasm > $WASM_DIR/ffmpeg.wasm.gz
rm $WASM_DIR/ffmpeg.wasm

# replacing stdout write script in ffmpeg.js
STDOUT_SCRIPT_FROM="for(var i=0;i<length;i++){try{output(buffer[offset+i])}catch(e){throw new FS.ErrnoError(29)}}"
STDOUT_SCRIPT_TO="let i = length;try{output(buffer, offset, length)}catch(e){throw new FS.ErrnoError(29)}"
if ! grep -qF "$STDOUT_SCRIPT_FROM" "$WASM_DIR/ffmpeg.js"; then
    echo "ffmpeg.js does not contain expected STDOUT_SCRIPT_FROM"
    exit 1
fi
ESCAPED_STDOUT_SCRIPT_FROM=$(printf '%s\n' "$STDOUT_SCRIPT_FROM" | sed -e 's/[]\/$*.^[]/\\&/g');
ESCAPED_STDOUT_SCRIPT_TO=$(printf '%s\n' "$STDOUT_SCRIPT_TO" | sed -e 's/[]\/$*.^[]/\\&/g');
sed -i -e "s/$ESCAPED_STDOUT_SCRIPT_FROM/$ESCAPED_STDOUT_SCRIPT_TO/g" $WASM_DIR/ffmpeg.js
gzip --force -9 -c $WASM_DIR/ffmpeg.js > $WASM_DIR/ffmpeg.js.gz
rm $WASM_DIR/ffmpeg.js

gzip --force -9 -c $WASM_DIR/ffmpeg.worker.js > $WASM_DIR/ffmpeg.worker.js.gz
rm $WASM_DIR/ffmpeg.worker.js

echo "emcc ${FLAGS[@]}" > $INFO_FILE
echo "" >> $INFO_FILE

git config --get remote.origin.url >> $INFO_FILE
git rev-parse HEAD >> $INFO_FILE
echo "" >> $INFO_FILE

echo "EMCC (emcc -v)" >> $INFO_FILE
emcc -v &>> $INFO_FILE
echo "" >> $INFO_FILE

git submodule foreach 'git config --get remote.origin.url && git rev-parse HEAD && echo ""' >> $INFO_FILE
