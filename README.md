# yscene-ffmpeg


## Build

```
sudo -s
./scripts/clean.sh
./scripts/build.sh
```

### Single Steps

```
./scripts/init-dependencies.sh
source ./modules/emsdk/emsdk_env.sh
./scripts/build-zlib.sh
./scripts/configure-ffmpeg.sh
./scripts/build-ffmpeg.sh
```

### Artifacts 

- `build/wasm`

## Misc

```
git submodule add -f https://github.com/emscripten-core/emsdk.git modules/emsdk
git submodule add -f -b yscene https://github.com/jozefchutka/fdk-aac modules/fdk-aac
git submodule add -f -b yscene-new https://github.com/jozefchutka/ffmpeg.wasm-core modules/ffmpeg
git submodule add -f -b yscene https://github.com/jozefchutka/lame modules/lame
git submodule add -f -b yscene https://github.com/jozefchutka/libsamplerate modules/libsamplerate
git submodule add -f -b yscene https://github.com/jozefchutka/libsndfile modules/libsndfile
git submodule add -f -b yscene https://github.com/jozefchutka/libvpx modules/libvpx
git submodule add -f -b yscene https://github.com/jozefchutka/libwebp modules/libwebp
git submodule add -f -b yscene https://github.com/jozefchutka/Ogg modules/Ogg
git submodule add -f -b yscene https://github.com/jozefchutka/opus modules/opus
git submodule add -f -b yscene https://github.com/jozefchutka/rubberband modules/rubberband
git submodule add -f -b yscene https://github.com/jozefchutka/theora modules/theora
git submodule add -f -b yscene https://github.com/jozefchutka/vorbis modules/vorbis
git submodule add -f -b yscene https://github.com/jozefchutka/x264 modules/x264
git submodule add -f -b yscene https://github.com/jozefchutka/x265 modules/x265
git submodule add -f -b yscene https://github.com/jozefchutka/zlib modules/zlib
```