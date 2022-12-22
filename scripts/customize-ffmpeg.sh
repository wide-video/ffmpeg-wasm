#!/bin/bash

set -eo pipefail
source $(dirname $0)/var.sh

cp -fr $OUTPUT_PATH $OUTPUT_PATH_WV

# replacing default stack size in ffmpeg.js
STACK_SIZE_SCRIPT_FROM="__emscripten_default_pthread_stack_size(){return 65536}"
STACK_SIZE_SCRIPT_TO="__emscripten_default_pthread_stack_size(){return 2097152}"
if ! grep -qF "$STACK_SIZE_SCRIPT_FROM" "$OUTPUT_PATH_WV"; then
    echo "$OUTPUT_PATH_WV does not contain expected STACK_SIZE_SCRIPT_FROM"
    exit 1
fi
ESCAPED_STACK_SIZE_SCRIPT_FROM=$(printf '%s\n' "$STACK_SIZE_SCRIPT_FROM" | sed -e 's/[]\/$*.^[]/\\&/g');
ESCAPED_STACK_SIZE_SCRIPT_TO=$(printf '%s\n' "$STACK_SIZE_SCRIPT_TO" | sed -e 's/[\/&]/\\&/g');
sed -i -e "s/$ESCAPED_STACK_SIZE_SCRIPT_FROM/$ESCAPED_STACK_SIZE_SCRIPT_TO/g" $OUTPUT_PATH_WV


# replacing stdout write script in ffmpeg.js
STDOUT_SCRIPT_FROM="for(var i=0;i<length;i++){try{output(buffer[offset+i])}catch(e){throw new FS.ErrnoError(29)}}"
STDOUT_SCRIPT_TO="let i = length;try{output(buffer, offset, length)}catch(e){throw new FS.ErrnoError(29)}"
if ! grep -qF "$STDOUT_SCRIPT_FROM" "$OUTPUT_PATH_WV"; then
    echo "$OUTPUT_PATH_WV does not contain expected STDOUT_SCRIPT_FROM"
    exit 1
fi
ESCAPED_STDOUT_SCRIPT_FROM=$(printf '%s\n' "$STDOUT_SCRIPT_FROM" | sed -e 's/[]\/$*.^[]/\\&/g');
ESCAPED_STDOUT_SCRIPT_TO=$(printf '%s\n' "$STDOUT_SCRIPT_TO" | sed -e 's/[\/&]/\\&/g');
sed -i -e "s/$ESCAPED_STDOUT_SCRIPT_FROM/$ESCAPED_STDOUT_SCRIPT_TO/g" $OUTPUT_PATH_WV


# replacing tty write script in ffmpeg.js
TTY_SCRIPT_FROM="try{for(var i=0;i<length;i++){stream.tty.ops.put_char(stream.tty,buffer[offset+i])}}"
TTY_SCRIPT_TO="try{if(Module.tty && Module.tty(stream,buffer,offset,length,pos))var i=length;else for(var i=0;i<length;i++){stream.tty.ops.put_char(stream.tty,buffer[offset+i])}}"
if ! grep -qF "$TTY_SCRIPT_FROM" "$OUTPUT_PATH_WV"; then
    echo "$OUTPUT_PATH_WV does not contain expected TTY_SCRIPT_FROM"
    exit 1
fi
ESCAPED_TTY_SCRIPT_FROM=$(printf '%s\n' "$TTY_SCRIPT_FROM" | sed -e 's/[]\/$*.^[]/\\&/g');
ESCAPED_TTY_SCRIPT_TO=$(printf '%s\n' "$TTY_SCRIPT_TO" | sed -e 's/[\/&]/\\&/g');
sed -i -e "s/$ESCAPED_TTY_SCRIPT_FROM/$ESCAPED_TTY_SCRIPT_TO/g" $OUTPUT_PATH_WV


# replacing stdin read script in ffmpeg.js
STDIN_SCRIPT_FROM="for(var i=0;i<length;i++){var result;try{result=input()}catch(e){throw new FS.ErrnoError(29)}if(result===undefined&&bytesRead===0){throw new FS.ErrnoError(6)}if(result===null||result===undefined)break;bytesRead++;buffer[offset+i]=result}"
STDIN_SCRIPT_TO="var result;try{result=input(length)}catch(e){throw new FS.ErrnoError(29)}if(result===undefined){throw new FS.ErrnoError(6)}bytesRead = result.byteLength;buffer.set(result, offset);"
if ! grep -qF "$STDIN_SCRIPT_FROM" "$OUTPUT_PATH_WV"; then
    echo "$OUTPUT_PATH_WV does not contain expected STDIN_SCRIPT_FROM"
    exit 1
fi
ESCAPED_STDIN_SCRIPT_FROM=$(printf '%s\n' "$STDIN_SCRIPT_FROM" | sed -e 's/[]\/$*.^[]/\\&/g');
ESCAPED_STDIN_SCRIPT_TO=$(printf '%s\n' "$STDIN_SCRIPT_TO" | sed -e 's/[\/&]/\\&/g');
sed -i -e "s/$ESCAPED_STDIN_SCRIPT_FROM/$ESCAPED_STDIN_SCRIPT_TO/g" $OUTPUT_PATH_WV