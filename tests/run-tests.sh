#!/bin/bash
set -xe

DETCMD=$1
DETCMD_ARGS=$2
BAZEL=$3
BAZEL_BUILD_ARGS=$4

TEST_DIR=`pwd`

run_test() {
  DIR=$1
  TARGET=$2

  echo "Now running ${DIR} with \`bazel build ${TARGET}\`..."
  ( cd ${DIR}; ${TEST_DIR}/test-determinism.sh ${DETCMD} ${DETCMD_ARGS} ${BAZEL} ${TARGET} ${BAZEL_BUILD_ARGS} )
}

# Try Bazel builds taken from GitHub projects.
# We download them to avoid having to check them in as submodules.
run_github_test() {
  GITHUB_USER=$1
  GITHUB_REPO=$2
  GITHUB_SHA_ABBREV=$3
  TARGET=$4

  GITHUB_TARBALL_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/tarball/${GITHUB_SHA_ABBREV}"
  GITHUB_TARBALL_NAME="${GITHUB_USER}-${GITHUB_REPO}-${GITHUB_SHA_ABBREV}"
  GITHUB_TARBALL_FILE="${GITHUB_TARBALL_NAME}.tar.gz"
  DIR=${GITHUB_REPO}/${GITHUB_TARBALL_NAME}

  if [ ! -f "${GITHUB_TARBALL_FILE}" ]; then
    echo "Downloading ${GITHUB_TARBALL_FILE} from ${GITHUB_TARBALL_URL}..."
    wget -O ${GITHUB_TARBALL_FILE} ${GITHUB_TARBALL_URL}
  fi
  if [ ! -d "${DIR}" ]; then
    echo "Extracting ${GITHUB_TARBALL_FILE} to ${DIR}..."
    mkdir -p ${GITHUB_REPO}
    tar -xvf ${GITHUB_TARBALL_FILE} -C ${GITHUB_REPO}
  fi

  run_test "${DIR}" "${TARGET}"
}

run_test "nondet-genrule" "//main:nondet-genrule"

## Mysteriously fails on Azure
## https://dev.azure.com/iu-parfunc/bazel/_build/results?buildId=369
# run_github_test "abseil" "abseil-cpp" "52e88ee" "//absl/..."

## Takes a LONG time to build
# run_github_test "apache" "incubator-brpc" "9f9f857" "//..."

run_github_test "google" "jsonnet" "552d8ec" "//cmd:all"
run_github_test "meltwater" "served" "f035363" ":served"
