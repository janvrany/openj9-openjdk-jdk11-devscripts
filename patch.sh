#!/bin/bash

set -e

HERE=$(realpath $(dirname $0))

function apply() {
	patch_src="${HERE}/$1"
	patch_dst="${HERE}/$2"

	if [ -d "${patch_src}" ]; then
		for p in $(ls ${patch_src}/*.patch | sort); do
			echo "Applying $(basename $p)"
			cd "${patch_dst}" && patch -r - -N -p1 < "${p}"
		done
	fi
}

apply patches/openj9-openjdk-jdk11 openj9-openjdk-jdk11
apply patches/omr                  openj9-openjdk-jdk11/omr
apply patches/openj9               openj9-openjdk-jdk11/openj9
