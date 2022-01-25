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

1. On *ffmpeg* repo create branch named *yscene-tmp* based on latest from ffmpeg origin
2. Merge *yscene-init* into *yscene-tmp*
3. update *yscene-ffmpeg/.gitmodules* to use *yscene-tmp* branch
4. clean, build test it with yscene
5. override `yscene` by `yscene-new` (delete it) and create tag i.e. `y1.2.3`

## Misc

```
git submodule add -f -b main https://github.com/emscripten-core/emsdk.git modules/emsdk
git submodule add -f -b yscene https://github.com/jozefchutka/fdk-aac modules/fdk-aac
git submodule add -f -b yscene https://github.com/jozefchutka/ffmpeg modules/ffmpeg
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


## Issues

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 467B942D3A79BD29
https://github.com/hashicorp/consul/issues/11162