#!/bin/bash
SRC=https://gitcode.net/mirrors/violentmonkey/violentmonkey.git
TAG=v2.13.0
BUILDNAME=violentmonkey

source ./_common.sh

git_clone_repo

(
	at_repo &&
		echo yarn.lock >.dockerignore &&
		echo Dockerfile >>.dockerignore &&
		echo sharp_binary_host=https://npmmirror.com/mirrors/sharp >.npmrc &&
		echo sharp_libvips_binary_host=https://npmmirror.com/mirrors/sharp-libvips >>.npmrc &&
		cat <<END >Dockerfile
FROM node:lts-slim
RUN yarn config set registry https://registry.npmmirror.com
WORKDIR /app
COPY package.json ./
RUN yarn --ignore-scripts
COPY . .
RUN yarn add sharp
VOLUME /target
CMD NODE_ENV=production yarn exec gulp build && cp -r dist/* /target
END
)

imgid=$(build_container)

buildto=$(create_build_path)
disto=$(create_dist_path)

docker run --rm -v "$buildto":/target "$imgid"
cp -r "$buildto"/* "$disto"

pack_by_chromium

print_builder "$imgid"
