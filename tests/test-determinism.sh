#!/bin/bash
set -xe

DETCMD=$1
DETCMD_ARGS=$2
BAZEL=$3
TARGET=$4
BAZEL_BUILD_ARGS=$5

for suffix in {first,second}; do
  DETCMD=${DETCMD}   DETCMD_ARGS=${DETCMD_ARGS} ${BAZEL} clean && \
    DETCMD=${DETCMD} DETCMD_ARGS=${DETCMD_ARGS} ${BAZEL} build ${TARGET} ${BAZEL_BUILD_ARGS} && \
    hashdeep -lr bazel-bin/ > out.${suffix}
done

hashdeep -ravvl -k out.first bazel-bin/
