#!/bin/bash

HERE=$(realpath $(dirname $0))

. "${HERE}/setup.sh"

extra_configure_args=""

if [[ "${HOST}" != "${TARGET}" ]]; then
	extra_configure_args="${extra_configure_args} --disable-ddr --openjdk-target=$TARGET"
 	if [[ "${TARGET}" == "riscv64-linux-gnu" ]]; then
          if [ -d "/opt/riscv/sysroot" ]; then
               sysroot="/opt/riscv/sysroot"
          elif [ -d "/opt/cross/riscv64" ]; then
               sysroot="/opt/cross/riscv64"
          else
               echo "ERROR: no cross-compilation sysroot found!"
          fi
          extra_configure_args="${extra_configure_args} --with-sysroot=$sysroot"
        fi
fi

pushd openj9-openjdk-jdk11

bash configure \
     --disable-warnings-as-errors \
     --disable-warnings-as-errors-openj9 \
     --with-build-jdk=$JAVA_HOME \
     --with-boot-jdk=$JAVA_HOME \
     --with-freemarker-jar="${HERE}/freemarker-2.3.8/lib/freemarker.jar" \
     --with-noncompressedrefs \
     --with-extra-cflags="${CFLAGS}" \
     --with-extra-cxxflags="${CXXFLAGS}" \
     ${extra_configure_args} \
     --with-debug-level=${CONFIG}
popd
