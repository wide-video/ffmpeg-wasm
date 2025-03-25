#!/bin/bash

set -eo pipefail
source $(dirname $0)/var.sh

cp -fr $OUTPUT_PATH $OUTPUT_PATH_WV

replace()
{
	if ! grep -qF "$1" "$3"; then
		echo "$3 does not contain expected $1"
		exit 1
	fi
	ESCAPED_FROM=$(printf '%s\n' "$1" | sed -e 's/[]\/$*.^[]/\\&/g');
	ESCAPED_TO=$(printf '%s\n' "$2" | sed -e 's/[\/&]/\\&/g');
	sed -i -e "s/$ESCAPED_FROM/$ESCAPED_TO/g" $3
}

# replacing stdout write script in ffmpeg.js
replace "for(var i=0;i<length;i++){try{output(buffer[offset+i])}catch(e){throw new FS.ErrnoError(29)}}" \
	"let i = length;try{output(buffer, offset, length)}catch(e){throw new FS.ErrnoError(29)}" \
	$OUTPUT_PATH_WV

# replacing tty write script in ffmpeg.js
replace "try{for(var i=0;i<length;i++){stream.tty.ops.put_char(stream.tty,buffer[offset+i])}}" \
	"try{if(Module.tty && Module.tty(stream,buffer,offset,length,pos))var i=length;else for(var i=0;i<length;i++){stream.tty.ops.put_char(stream.tty,buffer[offset+i])}}" \
	$OUTPUT_PATH_WV

# replacing stdin read script in ffmpeg.js
replace "for(var i=0;i<length;i++){var result;try{result=input()}catch(e){throw new FS.ErrnoError(29)}if(result===undefined&&bytesRead===0){throw new FS.ErrnoError(6)}if(result===null||result===undefined)break;bytesRead++;buffer[offset+i]=result}" \
	"if(input===Module.stdin){var result;try{result=input(length)}catch(e){throw new FS.ErrnoError(29)}if(result===undefined){throw new FS.ErrnoError(6)}bytesRead = result.byteLength;buffer.set(result, offset);}else{for(var i=0;i<length;i++){var result;try{result=input()}catch(e){throw new FS.ErrnoError(29)}if(result===undefined&&bytesRead===0){throw new FS.ErrnoError(6)}if(result===null||result===undefined)break;bytesRead++;buffer[offset+i]=result}}" \
	$OUTPUT_PATH_WV