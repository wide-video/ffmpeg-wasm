# WebAssembly port of FFmpeg

This repository hosts scripts and commands to build WebAssembly port of FFmpeg powering [wide.video | Free Online Video Editor](https://wide.video) and [ffmpeg.wide.video | FFmpeg Online](https://ffmpeg.wide.video).

## Build

Default build procedure using docker will produce multiple (gpl, lgpl, simd) artifacts in `./wasm` folder:

```shell
scripts\docker-run.bat
	./scripts/docker-init.sh    # execute in container shell
	./scripts/release.sh        # execute in container shell
```

Alternatively, non-container build can be executed similarly:

```shell
sudo -s
./scripts/release.sh
```

Release script further executes configuration and build of each submodule, which can be called manually as follows:

```shell
sudo -s
export FFMPEG_SIMD=true              # release.sh
export FFMPEG_LGPL=true              # release.sh
export FFMPEG_SKIP_LIBS=false        # release.sh
./scripts/clean.sh                   # release.sh
./scripts/init-dependencies.sh       # build.sh
source ./modules/emsdk/emsdk_env.sh  # build.sh
./scripts/build-zlib.sh              # build.sh
./scripts/configure-ffmpeg.sh        # build.sh
./scripts/build-ffmpeg.sh            # build.sh
./scripts/customize-ffmpeg.sh        # build.sh
```

## Known Issues

- Google shell [Encountered a section with no Package: header](https://github.com/hashicorp/consul/issues/11162) can be resolved by calling `sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 467B942D3A79BD29`
- [Single thread version is not buildable](https://trac.ffmpeg.org/ticket/10009) as FFmpeg [depends upon threading](http://git.videolan.org/?p=ffmpeg.git;a=commitdiff;h=760ce4bc0bd11f74f0851c0a662dd5cae888df83).