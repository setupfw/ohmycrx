#!/bin/bash
SRC=https://gitee.com/mirrors/gooreplacer.git
TAG=v3.12.0
BUILDNAME=gooreplacer

source ./_common.sh

git_clone_repo

disto=$(create_dist_path)

(at_repo && cp -r legacy-js-src/src/* "$disto")

pack_by_chromium
