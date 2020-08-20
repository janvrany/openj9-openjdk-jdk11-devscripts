#!/bin/bash

HERE=$(realpath $(dirname $0))

. "${HERE}/setup.sh"

extra_configure_args=""

if [[ "${HOST}" != "${TARGET}" ]]; then
	extra_configure_args="${extra_configure_args} --disable-ddr --openjdk-target=$TARGET"
 	if [[ "${TARGET}" == "riscv64-linux-gnu" ]]; then
		extra_configure_args="${extra_configure_args} --with-sysroot=/opt/cross/riscv64"
        fi
fi

pushd openj9-openjdk-jdk11

bash configure \
     --disable-warnings-as-errors \
     --disable-warnings-as-errors-openj9 \
     --with-build-jdk=$JAVA_HOME \
     --with-boot-jdk=$JAVA_HOME \
     --with-freemarker-jar="${HERE}/freemarker-2.3.8/lib/freemarker.jar" \
     --with-extra-cflags='-O0 -ggdb' \
     --with-extra-cxxflags='-O0 -ggdb' \
     ${extra_configure_args} \
     --with-debug-level=${CONFIG}
popd