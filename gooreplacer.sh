#!/bin/bash
src=https://gitee.com/mirrors/gooreplacer.git
tag=3.12.0
dst=~/crxbuild

mkdir -p "$dst"
cd $(mktemp -d) && git clone -b $tag --depth=1 $src .
cp -r legacy-js-src/src "$dst/gooreplacer"
(cd "$dst" && rm -rf "gooreplacer*" && chromium --pack-extension=gooreplacer)
