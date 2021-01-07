#!/bin/bash

: ${openjdk_repo:='https://github.com/janvrany/openj9-openjdk-jdk11.git'}
: ${openjdk_branch:='jv/riscv-devel'}

: ${openj9_repo:='https://github.com/janvrany/openj9'}
: ${openj9_branch:='jv/riscv-devel'}

: ${omr_repo:='https://github.com/janvrany/omr'}
: ${omr_branch:='jv/riscv-devel'}

: ${freemarker_version:='2.3.34'}
: ${freemarker_url:="https://dlcdn.apache.org/freemarker/engine/${freemarker_version}/binaries/apache-freemarker-bin-${freemarker_version}.tgz"}

if [ ! -d openj9-openjdk-jdk11 ]; then
	git clone --branch "$openjdk_branch" "$openjdk_repo" openj9-openjdk-jdk11        --depth 1
else
	git -C openj9-openjdk-jdk11 pull
fi

if [ ! -d openj9-openjdk-jdk11/omr ]; then
	git clone --branch "$omr_branch"     "$omr_repo"     openj9-openjdk-jdk11/omr
else
	git -C openj9-openjdk-jdk11/omr pull
fi

if [ ! -d openj9-openjdk-jdk11/openj9 ]; then
	git clone --branch "$openj9_branch"  "$openj9_repo"  openj9-openjdk-jdk11/openj9
else
	git -C openj9-openjdk-jdk11/openj9 pull
fi

if [ ! -f "freemarker/freemarker.jar" ]; then
	mkdir -p freemarker
       wget -O freemarker/freemarker.tar.gz "${freemarker_url}"
       tar -C freemarker -xf freemarker/freemarker.tar.gz
fi
