#!/bin/bash

set -e

HERE=$(realpath $(dirname $0))

. "${HERE}/setup.sh"

make JOBS=1 -C openj9-openjdk-jdk11 all

arch="${TARGET%%-*}"
builddir="${HERE}/openj9-openjdk-jdk11/build/$(ls "${HERE}/openj9-openjdk-jdk11/build" | grep "linux-${arch}-*")"

if test "${HOST}" != "${TARGET}"; then
	qemu=$(type -P qemu-${arch}-static)
	if [[ -z "${qemu}" ]]; then
		"WARN: no ${qemu} found, cannot test / output 'java -version'!"
	else
		${qemu} -L "${SYSROOT}" "${builddir}/images/jdk/bin/java" -version
	fi
else
	"${builddir}/images/jdk/bin/java" -version
fi