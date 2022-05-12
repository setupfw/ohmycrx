#!/bin/bash
SRC=https://gitee.com/mirrors/replacegooglecdn
TAG=v0.9.0
BUILDNAME=cdn4cn

source ./_common.sh

git_clone_repo

disto=$(create_dist_path)

( at_repo && cp -r extension/* "$disto" )

pack_by_chromium
