#!/bin/bash
set +x

DETTRACE=$1
BAZEL=$2
TARGET=$3

for suffix in {first,second}; do
  DETTRACE=${DETTRACE} ${BAZEL} clean && DETTRACE=${DETTRACE} ${BAZEL} build ${TARGET} && hashdeep -lr bazel-genfiles/ > out.${suffix}
done

hashdeep -ravvl -k out.first bazel-genfiles/
