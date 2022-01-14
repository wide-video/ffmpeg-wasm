# yscene-ffmpeg

## Build

```
sudo -s
./scripts/clean.sh
./scripts/build.sh
```

### Single Steps

```
sudo -s
./scripts/init-dependencies.sh
source ./modules/emsdk/emsdk_env.sh
./scripts/build-zlib.sh
./scripts/configure-ffmpeg.sh
./scripts/build-ffmpeg.sh
```

### Artifacts 

```
./build/wasm
```

## Updating

1. On https://github.com/jozefchutka/ffmpeg create branch named *yscene/1.2.3* based on branch/tag/latest from ffmpeg origin
2. Merge *yscene/init* into *yscene/1.2.3*
3. On https://github.com/jozefchutka/yscene-ffmpeg update `.gitmodules` to use *yscene/1.2.3*
4. clean and build

## Misc

```
git submodule add -f -b main https://github.com/emscripten-core/emsdk.git modules/emsdk
git submodule add -f -b yscene https://github.com/jozefchutka/fdk-aac modules/fdk-aac
git submodule add -f -b yscene/1.2.3 https://github.com/jozefchutka/ffmpeg.wasm-core modules/ffmpeg
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
