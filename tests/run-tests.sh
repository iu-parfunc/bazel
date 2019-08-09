#!/bin/bash
set +x

DETTRACE=$1
BAZEL=$2

TEST_DIR=`pwd`

run_test() {
  DIR=$1
  TARGET=$2
  ( cd ${DIR}; ${TEST_DIR}/test-determinism.sh ${DETTRACE} ${BAZEL} ${TARGET} )
}

run_test "nondet-genrule" "//main:nondet-genrule"
