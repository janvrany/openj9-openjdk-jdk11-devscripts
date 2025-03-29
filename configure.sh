#!/bin/bash

HERE=$(realpath $(dirname $0))

. "${HERE}/setup.sh"

extra_configure_args=""

if [[ "${HOST}" != "${TARGET}" ]]; then
	extra_configure_args="${extra_configure_args} --disable-ddr --openjdk-target=$TARGET  --with-sysroot=${SYSROOT}"
fi

pushd openj9-openjdk-jdk11

bash configure \
     --disable-warnings-as-errors \
     --disable-warnings-as-errors-openj9 \
     --with-build-jdk=$JAVA_HOME \
     --with-boot-jdk=$JAVA_HOME \
     --with-noncompressedrefs \
     --with-extra-cflags="${CFLAGS}" \
     --with-extra-cxxflags="${CXXFLAGS}" \
     ${extra_configure_args} \
     --with-debug-level=${CONFIG}
popd
