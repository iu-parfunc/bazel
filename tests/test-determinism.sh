#!/bin/bash
set +x

DETCMD=$1
BAZEL=$2
TARGET=$3

for suffix in {first,second}; do
  DETCMD=${DETCMD} ${BAZEL} clean && DETCMD=${DETCMD} ${BAZEL} build ${TARGET} && hashdeep -lr bazel-genfiles/ > out.${suffix}
done

hashdeep -ravvl -k out.first bazel-genfiles/
