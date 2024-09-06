# Using -flto llvm-strip error: The file was not recognized as a valid object file

https://github.com/emscripten-core/emscripten/issues/22524

execute run.sh in DOCKER:

```sh
docker run -it -v $(pwd):/ffmpeg-wasm -w /ffmpeg-wasm debian:12.5
cd issue-22524
./run.sh 2>&1 | tee log.txt
```