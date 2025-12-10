#!/bin/bash

EMSDK_VERSION="4.0.21"

MODULE_ROOT=$(dirname $(dirname $0))/modules/emsdk

(cd $MODULE_ROOT && ./emsdk install $EMSDK_VERSION)
(cd $MODULE_ROOT && ./emsdk activate $EMSDK_VERSION)
source $MODULE_ROOT/emsdk_env.sh

emcc -v
