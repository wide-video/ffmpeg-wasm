# Build

```
sudo -s
./scripts/clean.sh
./scripts/build.sh
```

## Single Steps

```
sudo -s
./scripts/init-dependencies.sh
source ./modules/emsdk/emsdk_env.sh
./scripts/build-zlib.sh
./scripts/configure-ffmpeg.sh
./scripts/build-ffmpeg.sh
```

## Artifacts 

```
./build/wasm
```

# Updating

1. On *ffmpeg* repo `git fetch --all`
2. On *ffmpeg* repo create branch named *wide.video-tmp* based on latest from ffmpeg origin
3. Merge *wide.video-init* into *wide.video-tmp*
4. update *ffmpeg-wasm/.gitmodules* to use *wide.video-tmp* branch
5. clean, build test it with app
6. override `wide.video` by `wide.video-tmp` (delete it) and create tag i.e. `wv1.2.3`

## Misc

```
git submodule add -f -b main https://github.com/emscripten-core/emsdk.git modules/emsdk
git submodule add -f -b wide.video https://github.com/wide-video/ffmpeg modules/ffmpeg
```

## Issues

- [Encountered a section with no Package: header](https://github.com/hashicorp/consul/issues/11162) `sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 467B942D3A79BD29`
