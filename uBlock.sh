#!/bin/bash
SRC=https://gitcode.net/mirrors/gorhill/uBlock.git
ASSETS=https://gitcode.net/mirrors/uBlockOrigin/uAssets.git
TAG=1.42.4
BUILDNAME=uBlock

source ./_common.sh

git_clone_repo

(
	at_repo &&
		sed -n "/url =/ s#=.*#= $ASSETS#" .gitmodules &&
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
)

imgid=$(build_container)

buildto=$(create_build_path)
disto=$(create_dist_path)

docker run --rm -v "$buildto":/app/dist/build "$imgid"
cp -r "$buildto/uBlock0.chromium/*" "$disto"

pack_by_chromium

print_builder "$imgid"
