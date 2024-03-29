#!/bin/bash

set -e

HERE=$(realpath $(dirname $0))

. "${HERE}/setup.sh"

JOBS=4
_params=
while (( "$#" )); do
  case "$1" in
    -j)
      JOBS=$2
      shift
      ;;
    *) # preserve positional arguments
      _params="${_params} $1"
      shift
      ;;
  esac
done

eval set -- ${_params}

make JOBS=$JOBS -C openj9-openjdk-jdk11 all

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
