# Building failure after switching from 3.1.47 to 3.1.57

https://github.com/emscripten-core/emscripten/issues/22008

execute run.sh in DOCKER:

```
docker run -it -v $(pwd):/ffmpeg-wasm -w /ffmpeg-wasm debian:12.5
./run.sh 2>&1 | tee log.txt
```