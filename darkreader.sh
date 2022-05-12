#!/bin/bash
SRC=https://gitee.com/mirrors/dark-reader.git
TAG=v4.9.50
BUILDNAME=darkreader

source ./_common.sh

git_clone_repo

(
	at_repo &&
		git apply "../../$BUILDNAME.patch" &&
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
)

imgid=$(build_container)

buildto=$(create_build_path)
disto=$(create_dist_path)

docker run --rm -v "$buildto":/app/build "$imgid"
cp -r "$buildto/release/chrome/"* "$disto"

pack_by_chromium

print_builder "$imgid"
