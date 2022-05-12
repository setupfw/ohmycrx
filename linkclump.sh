#!/bin/bash
src=https://gitclone.com/github.com/benblack86/linkclump
dst=~/crxbuild

mkdir -p "$dst"
cd $(mktemp -d) && git clone --depth=1 $src .
docker run --mount type=bind,source="$(pwd)",target=/app frekele/ant:1.10.3-jdk8u111 ant -f /app/build.xml
unzip linkclump.2.9.1.zip -d "$dst/linkclump"
(cd "$dst" && rm -rf "linkclump*" && chromium --pack-extension=linkclump)
