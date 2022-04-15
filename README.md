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

## 1 ffmpeg repo

1. `git clone git@github.com:wide-video/ffmpeg.git`
2. `git remote add ffmpeg git@github.com:FFmpeg/FFmpeg.git`
3. `git fetch --all`
4. `git checkout -b wide.video-tmp ea84eb2`(create branch named *wide.video-tmp* based on latest from ffmpeg origin)
5. `git push origin wide.video-tmp`

## 2 ffmpeg-wasm repo

1. update *ffmpeg-wasm/.gitmodules* to use *wide.video-tmp* branch
2. update *ffmpeg-wasm/scripts/init-dependencies.sh* to use latest emscripten
3. clean, build test it with app (see *Build* section on top)

## 3 ffmpeg repo

1. `git checkout wide.video-tmp`
2. `git branch -D wide.video` (delete local branch)
3. `git push origin --delete wide.video-tmp` (delete remote branch)
4. `git branch -m wide.video` (rename current branch *wide.video-tmp* to *wide.video*)
5. `git push -f origin wide.video`
6. `git tag wv1.2.3`
7. `git push origin wv1.2.3`

## 4 ffmpeg-wasm repo

1. update *ffmpeg-wasm/.gitmodules* to use *wide.video* branch
2. `git tag wv1.2.3`
3. `git push origin wv1.2.3`

## Misc

```
git submodule add -f -b main https://github.com/emscripten-core/emsdk.git modules/emsdk
git submodule add -f -b wide.video https://github.com/wide-video/ffmpeg modules/ffmpeg
```

## Issues

- [Encountered a section with no Package: header](https://github.com/hashicorp/consul/issues/11162) `sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 467B942D3A79BD29`
