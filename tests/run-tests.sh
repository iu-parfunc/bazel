#!/bin/bash
set +x

DETCMD=$1
BAZEL=$2

TEST_DIR=`pwd`

run_test() {
  DIR=$1
  TARGET=$2
  ( cd ${DIR}; ${TEST_DIR}/test-determinism.sh ${DETCMD} ${BAZEL} ${TARGET} )
}

run_test "nondet-genrule" "//main:nondet-genrule"
