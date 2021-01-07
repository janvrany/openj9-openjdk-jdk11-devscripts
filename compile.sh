#!/bin/bash

HERE=$(realpath $(dirname $0))

. "${HERE}/setup.sh"

make JOBS=4 -C openj9-openjdk-jdk11 all
