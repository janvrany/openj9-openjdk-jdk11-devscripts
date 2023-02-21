#!/bin/bash

: ${openjdk_repo:='https://github.com/ibmruntimes/openj9-openjdk-jdk11.git'}
: ${openjdk_branch:='openj9'}

: ${openj9_repo:='https://github.com/eclipse/openj9'}
: ${openj9_branch:='master'}

: ${omr_repo:='https://github.com/eclipse/openj9-omr'}
: ${omr_branch:='openj9'}

: ${freemarker_version:='2.3.32'}
: ${freemarker_url:="https://dlcdn.apache.org/freemarker/engine/${freemarker_version}/binaries/apache-freemarker-${freemarker_version}-bin.tar.gz"}

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

if [ ! -f "apache-freemarker-${freemarker_version}-bin/freemarker.jar" ]; then
       wget -O freemarker.tar.gz "${freemarker_url}"
       tar -xf freemarker.tar.gz
fi
