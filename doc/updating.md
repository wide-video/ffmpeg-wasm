# Updating

## 1 ffmpeg repo

1. `git clone git@github.com:wide-video/ffmpeg.git`
2. `git remote add ffmpeg git@github.com:FFmpeg/FFmpeg.git`
3. `git fetch --all`
4. `git checkout -b wide.video-tmp 2a6f847`(create branch named *wide.video-tmp* based on latest from ffmpeg origin)
5. `git push origin wide.video-tmp`

## 2 ffmpeg-wasm repo

1. update *ffmpeg-wasm/.gitmodules* to use *wide.video-tmp* branch
2. `git submodule sync --recursive`
3. `git submodule update --init --recursive --remote`
4. clean, build test it with app (see *Build* section on top)

## 3 ffmpeg repo

1. `git checkout wide.video-tmp`
2. `git branch -D wide.video` (delete local branch)
3. `git push origin --delete wide.video-tmp` (delete remote branch)
4. `git branch -m wide.video` (rename current branch *wide.video-tmp* to *wide.video*)
5. `git push -f origin wide.video`
6. `git tag wv0.11.1`
7. `git push origin wv0.11.1`

## 4 ffmpeg-wasm repo

1. update *ffmpeg-wasm/.gitmodules* to use *wide.video* branch
2. `git tag 0.11.1`
3. `git push origin 0.11.1`