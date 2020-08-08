#!/bin/bash

HERE=$(realpath $(dirname $0))

. "${HERE}/setup.sh"

pushd openj9-openjdk-jdk11

make all

popd
