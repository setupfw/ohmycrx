#!/bin/bash

git_clone_repo() {
	[[ -v SRC && -v TAG && -v BUILDNAME ]] || return 1

	mkdir -p repos && cd repos || return
	echo "==> git clone into ./repos: $SRC"
	git clone -b "$TAG" --depth=1 "$SRC" "$BUILDNAME"
	cd ..
}

build_container() {
	[[ -v BUILDNAME ]] || return 1

	docker build -t crxbuilder:"$BUILDNAME" "repos/$BUILDNAME" | tee /dev/tty | tail -1 | cut -d' ' -f3
}

get_repo_path() {
	[[ -v BUILDNAME ]] || return 1

	echo "$(pwd)/repos/$BUILDNAME"
}

create_build_path() {
	[[ -v BUILDNAME ]] || return 1

	rm -rf "build/$BUILDNAME"
	mkdir -p "build/$BUILDNAME"
	echo "$(pwd)/build/$BUILDNAME"
}

create_dist_path() {
	[[ -v BUILDNAME ]] || return 1

	rm -rf "dist/$BUILDNAME"
	mkdir -p "dist/$BUILDNAME"
	echo "$(pwd)/dist/$BUILDNAME"
}

at_repo() {
	cd "$(get_repo_path)" || return 1
}

pack_by_chromium() {
	[[ -v BUILDNAME ]] || return 1

	mkdir -p dist && cd dist || return 1
	rm -rf "$BUILDNAME."*
	chromium --pack-extension="$BUILDNAME"
	cd ..
}

print_builder() {
	[[ -v BUILDNAME ]] || return 1

	echo "==> $BUILDNAME new container: $1"
}
