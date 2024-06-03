#!/bin/bash

# run this as `source ./scripts/init-emscripten.sh`

# figure out the latest https://github.com/emscripten-core/emsdk/issues/547#issuecomment-1359134381
# 3.1.47 OK
# 3.1.48 - 3.1.56 N/A for Mac M2 https://github.com/emscripten-core/emscripten/issues/22008#issuecomment-2138722249
# 3.1.57 BROKEN https://github.com/emscripten-core/emscripten/issues/22008
# 3.1.58 BROKEN https://github.com/emscripten-core/emscripten/issues/21989
EMSDK_VERSION="3.1.47"

MODULE_ROOT=$(dirname $(dirname $0))/modules/emsdk

(cd $MODULE_ROOT && ./emsdk install $EMSDK_VERSION)
(cd $MODULE_ROOT && ./emsdk activate $EMSDK_VERSION)
source $MODULE_ROOT/emsdk_env.sh

emcc -v
