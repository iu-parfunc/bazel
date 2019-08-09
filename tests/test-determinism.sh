#!/bin/bash
set +x

TARGET=$1
BAZEL=bazel

for suffix in {first,second}; do
  ${BAZEL} clean && ${BAZEL} build ${TARGET} && hashdeep -lr bazel-genfiles/ > out.${suffix}
done

hashdeep -ravvl -k out.first bazel-genfiles/
