#!/bin/bash

# run this as `source ./scripts/init-emscripten.sh`

# 3.1.47 https://github.com/emscripten-core/emscripten/issues/22008#issuecomment-2141336106
EMSDK_VERSION="3.1.73"

MODULE_ROOT=$(dirname $(dirname $0))/modules/emsdk

(cd $MODULE_ROOT && ./emsdk install $EMSDK_VERSION)
(cd $MODULE_ROOT && ./emsdk activate $EMSDK_VERSION)
source $MODULE_ROOT/emsdk_env.sh

emcc -v
