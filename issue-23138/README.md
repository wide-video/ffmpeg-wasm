# Using -mavx for libsndfile fails

https://github.com/emscripten-core/emscripten/issues/23138

execute run.sh in DOCKER:

```sh
docker run -it -v $(pwd):/ffmpeg-wasm -w /ffmpeg-wasm debian:12.5
cd issue-23138
./run.sh 2>&1 | tee log.txt
```