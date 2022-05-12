#!/bin/bash
src=https://gitcode.net/mirrors/violentmonkey/violentmonkey.git
tag=v2.13.0
dst=~/crxbuild

cd $(mktemp -d) && git clone -b $tag --depth=1 $src .
echo yarn.lock >.dockerignore
cat <<END >Dockerfile
FROM node:lts-slim
RUN yarn config set registry https://registry.npmmirror.com
WORKDIR /app
COPY package.json ./
RUN yarn --ignore-scripts
COPY . .
RUN yarn
VOLUME /app/dist
CMD yarn build
END
mkdir -p dist "$dst"
cid=$(docker build -t crxbuilder -q .)
docker run --rm -v $(pwd)/dist:/app/dist $cid
cp -r dist "$dst/violentmonkey"
(cd "$dst" && rm -rf "violentmonkey*" && chromium --pack-extension=violentmonkey)
echo
echo violentmonkey build container id: $cid
