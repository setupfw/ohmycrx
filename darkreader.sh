#!/bin/bash
src=https://gitee.com/mirrors/dark-reader.git
tag=v4.9.50
dst=~/crxbuild

cd "$(mktemp -d)" && git clone -b $tag --depth=1 $src .
cat <<END >Dockerfile
FROM node:lts-slim
RUN yarn config set registry https://registry.npmmirror.com
WORKDIR /app
COPY package.json ./
RUN yarn
COPY . .
VOLUME /app/build
CMD yarn build
END
wget -qO- https://gitee.com/littleboyharry-crx/custom/raw/master/darkreader.patch | git apply -
mkdir -p build "$dst"
cid=$(docker build -t crxbuilder -q .)
docker run --rm -v "$(pwd)/build":/app/build "$cid"
cp -r build/release/chrome "$dst/darkreader"
(cd "$dst" && rm -rf "darkreader*" && chromium --pack-extension=darkreader)
echo
echo darkreader build container id: "$cid"
