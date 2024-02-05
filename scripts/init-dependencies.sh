#!/bin/bash

cmds=()

# Detect what dependencies are missing.
for cmd in autoconf autogen automake libtool pkg-config ragel
do
  if ! command -v $cmd &> /dev/null
  then
    cmds+=("$cmd")
  fi
done

# Install missing dependencies
if [ ${#cmds[@]} -ne 0 ];
then
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    apt-get update
    apt-get install -y ${cmds[@]}
  else
    brew install ${cmds[@]}
  fi
fi

cd modules/emsdk/
git pull
# figure out the latest https://github.com/emscripten-core/emsdk/issues/547#issuecomment-1359134381
./emsdk install 3.1.47
./emsdk activate 3.1.47
cd ../../