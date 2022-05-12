#!/bin/bash
src=https://gitee.com/mirrors/replacegooglecdn
tag=v0.9.0
dst=~/crxbuild

mkdir -p "$dst"
cd "$(mktemp -d)" && git clone -b "$tag" --depth=1 "$src" .
cp -r extension "$dst/replacegooglecdn"
(cd "$dst" && rm -rf "replacegooglecdn*" && chromium --pack-extension=replacegooglecdn)
