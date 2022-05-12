#!/bin/bash
src=https://gitcode.net/mirrors/gorhill/uBlock.git
assets=https://gitcode.net/mirrors/uBlockOrigin/uAssets.git
tag=1.42.4
dst=~/crxbuild

cd "$(mktemp -d)" && git clone -b "$tag" --depth=1 "$src" .
sed -n "/url =/ s#=.*#= $assets#" .gitmodules
cat <<END >Dockerfile
FROM ubuntu:latest
WORKDIR /app
RUN sed -i -E "s#http://((cn.)?archive|security).ubuntu.com#http://mirrors.cloud.tencent.com#g" /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y ca-certificates
RUN sed -i -E "s#http://mirrors.cloud.tencent.com#https://mirrors.cloud.tencent.com#g" /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y make git python-is-python3
COPY . .
VOLUME /app/dist/build
CMD make chromium
END
mkdir -p build "$dst"
cid=$(docker build -t crxbuilder -q .)
docker run --rm -v "$(pwd)/build":/app/dist/build "$cid"
cp -r build/uBlock0.chromium "$dst/uBlock"
(cd "$dst" && rm -rf "uBlock*" && chromium --pack-extension=uBlock)
echo
echo uBlock build container id: "$cid"
