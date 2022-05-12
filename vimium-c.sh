#!/bin/bash
SRC=https://gitee.com/gdh1995/vimium-c
TAG=v1.98.0
BUILDNAME=vimium-c

source ./_common.sh

git_clone_repo

(
	at_repo &&
		cat <<END >Dockerfile
FROM node:lts-slim
RUN npm config set registry https://registry.npmmirror.com
RUN npm install -g pnpm
WORKDIR /app
COPY package.json ./
RUN pnpm install --ignore-scripts
COPY . .
RUN pnpm install
VOLUME /app/dist
CMD pnpm exec gulp dist
END
)

imgid=$(build_container)

buildto=$(create_build_path)
disto=$(create_dist_path)

docker run --rm -v "$buildto":/app/dist "$imgid"
cp -r "$buildto"/* "$disto"

pack_by_chromium

print_builder "$imgid"
