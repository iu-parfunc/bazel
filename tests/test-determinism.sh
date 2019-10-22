#!/bin/bash
set -xe

DETCMD=$1
BAZEL=$2
TARGET=$3
BAZEL_BUILD_ARGS=$4

for suffix in {first,second}; do
  DETCMD=${DETCMD}   ${BAZEL} clean && \
    DETCMD=${DETCMD} ${BAZEL} build ${TARGET} ${BAZEL_BUILD_ARGS} && \
    hashdeep -lr bazel-bin/ > out.${suffix}
done

hashdeep -ravvl -k out.first bazel-bin/
