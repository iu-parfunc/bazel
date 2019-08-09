#!/bin/bash
set +x

TEST_DIR=`pwd`

run_test() {
  DIR=$1
  TARGET=$2
  ( cd ${DIR}; ${TEST_DIR}/test-determinism.sh ${TARGET} )
}

run_test "nondet-genrule" "//main:nondet-genrule"
