#!/bin/bash
src=https://gitee.com/gdh1995/vimium-c
tag=v1.98.0
dst=~/crxbuild

cd $(mktemp -d) && git clone -b $tag --depth=1 $src .
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
mkdir -p dist "$dst"
cid=$(docker build -t crxbuilder -q .)
docker run --rm -v $(pwd)/dist:/app/dist $cid
cp -r dist "$dst/vimium-c"
(cd "$dst" && rm -rf "vimium-c*" && chromium --pack-extension=vimium-c)
echo
echo vimium-c build container id: $cid
