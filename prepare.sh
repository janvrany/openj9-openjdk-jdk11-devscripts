#!/bin/bash

: ${openjdk_repo:='https://github.com/ibmruntimes/openj9-openjdk-jdk11.git'}
: ${openjdk_branch:='openj9'}

: ${openj9_repo:='https://github.com/eclipse/openj9'}
: ${openj9_branch:='master'}

: ${omr_repo:='https://github.com/eclipse/openj9-omr'}
: ${omr_branch:='openj9'}

: ${freemarker_version:='2.3.8'}
: ${freemarker_url:="https://sourceforge.net/projects/freemarker/files/freemarker/${freemarker_version}/freemarker-${freemarker_version}.tar.gz"}

if [ ! -d openj9-openjdk-jdk11 ]; then
	git clone --branch "$openjdk_branch" "$openjdk_repo" openj9-openjdk-jdk11        --depth 1
fi

if [ ! -d openj9-openjdk-jdk11/omr ]; then
	git clone --branch "$omr_branch"     "$omr_repo"     openj9-openjdk-jdk11/omr
fi

if [ ! -d openj9-openjdk-jdk11/openj9 ]; then
	git clone --branch "$openj9_branch"  "$openj9_repo"  openj9-openjdk-jdk11/openj9
fi

if [ ! -f "freemarker-${freemarker_version}/lib/freemarker.jar" ]; then
       wget -O freemarker.tar.gz "${freemarker_url}"
       tar -xf freemarker.tar.gz
fi
