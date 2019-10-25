#!/bin/bash
set -xe

DETCMD=$1
DETCMD_ARGS=$2
BAZEL=$3
TARGET=$4
BAZEL_BUILD_ARGS=$5

BAZEL_BIN_DIR=`DETCMD=${DETCMD} DETCMD_ARGS=${DETCMD_ARGS} ${BAZEL} info bazel-bin`

for suffix in {first,second}; do
  DETCMD=${DETCMD}   DETCMD_ARGS=${DETCMD_ARGS} ${BAZEL} clean && \
    DETCMD=${DETCMD} DETCMD_ARGS=${DETCMD_ARGS} ${BAZEL} build ${TARGET} ${BAZEL_BUILD_ARGS} && \
    hashdeep -lr ${BAZEL_BIN_DIR} > out.${suffix}
done

if [ -z "$(ls -A ${BAZEL_BIN_DIR})" ]; then
  echo "No build output detected, skipping hashdeep"
else
  hashdeep -ravvl -k out.first ${BAZEL_BIN_DIR}
fi
