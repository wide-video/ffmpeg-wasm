#!/bin/bash

cd modules/emsdk/
git pull


# figure out the latest https://github.com/emscripten-core/emsdk/issues/547#issuecomment-1359134381
# 3.1.47 OK
# 3.1.57 https://github.com/emscripten-core/emscripten/issues/22008
# 3.1.58 https://github.com/emscripten-core/emscripten/issues/21989
EMSDK_VERSION="3.1.47"

./emsdk install $EMSDK_VERSION
./emsdk activate $EMSDK_VERSION
source ./emsdk_env.sh
cd ../../
emcc -v
