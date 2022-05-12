#!/bin/bash
SRC=https://gitclone.com/github.com/benblack86/linkclump
TAG=master
BUILDNAME=linkclump

source ./_common.sh

git_clone_repo

disto=$(create_dist_path)

(at_repo &&
	rm -rf linkclump.*.zip &&
	docker run -v "$(pwd)":/app frekele/ant:1.10.3-jdk8u111 ant -f /app/build.xml &&
	unzip linkclump.*.zip -d "$disto")

pack_by_chromium
