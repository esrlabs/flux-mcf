#!/bin/bash

# exit when any command fails
set -e

# Make sure that either 1 or 2 arguments have been supplied
if [ $# -ne 1 ] && [ $# -ne 2 ]
  then
    echo "Please enter <install_directory> (mandatory) and <number_of_cores> (optional)"
    exit 0
fi
SCRIPT_DIR=$( dirname -- $0 )

# If install directory path is relative, prepend script directory.
if [[ "$1" != /* ]] && [[ "$1" != ~* ]]; then
    INSTALL_DIR=${SCRIPT_DIR}/$1
else
    INSTALL_DIR=$1
fi

NUM_CORES=$2
echo $INSTALL_DIR
mkdir -p "${INSTALL_DIR}"

standard_build_and_install () {
  local DIR_NAME=$1
  local GIT_REPO=$2
  local GIT_BRANCH=$3
  local CMAKE_ARGS=$4
  local SOURCE_DIR="${SCRIPT_DIR}/deps/${DIR_NAME}"
  if [ ! -d "${SOURCE_DIR}" ] ; then
    git clone --depth 1 --branch "${GIT_BRANCH}" --recursive "${GIT_REPO}" "${SOURCE_DIR}"
  fi
  (cd "${SOURCE_DIR}" && mkdir -p build)
  (cd "${SOURCE_DIR}/build" && cmake .. -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" ${CMAKE_ARGS})
  (cd "${SOURCE_DIR}/build" && make install -j$NUM_CORES)
}

# Install googletest
GOOGLE_TEST_DIR_NAME="googletest"
GOOGLE_TEST_GIT_REPO="https://github.com/google/googletest.git"
GOOGLE_TEST_GIT_BRANCH="release-1.11.0"
GOOGLE_TEST_CMAKE_ARGS=""
standard_build_and_install $GOOGLE_TEST_DIR_NAME $GOOGLE_TEST_GIT_REPO $GOOGLE_TEST_GIT_BRANCH "$GOOGLE_TEST_CMAKE_ARGS"

# Install libzmq
if [ ! -d "$SCRIPT_DIR/deps/libzmq" ] ; then
    git clone --depth 1 --branch v4.3.4 https://github.com/zeromq/libzmq.git $SCRIPT_DIR/deps/libzmq
fi
(cd $SCRIPT_DIR/deps/libzmq && ./autogen.sh)
(cd $SCRIPT_DIR/deps/libzmq && ./configure)
(cd $SCRIPT_DIR/deps/libzmq && mkdir -p build)
(cd $SCRIPT_DIR/deps/libzmq/build && cmake .. -D WITH_PERF_TOOL=OFF -D ZMQ_BUILD_TESTS=OFF -D ENABLE_CPACK=OFF -D CMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR})
(cd $SCRIPT_DIR/deps/libzmq/build && make -j$NUM_CORES)
(cd $SCRIPT_DIR/deps/libzmq/build && make install)

# Install cppzmq
CPPZMQ_DIR_NAME="cppzmq"
CPPZMQ_GIT_REPO="https://github.com/zeromq/cppzmq.git"
CPPZMQ_GIT_BRANCH="v4.8.1"
CPPZMQ_CMAKE_ARGS="-DCMAKE_PREFIX_PATH=$INSTALL_DIR"
standard_build_and_install $CPPZMQ_DIR_NAME $CPPZMQ_GIT_REPO $CPPZMQ_GIT_BRANCH "$CPPZMQ_CMAKE_ARGS"

# Install msgpack
MSGPACK_DIR_NAME="msgpack-c"
MSGPACK_GIT_REPO="https://github.com/msgpack/msgpack-c.git"
MSGPACK_GIT_BRANCH="cpp-4.0.3"
MSGPACK_CMAKE_ARGS=""
standard_build_and_install $MSGPACK_DIR_NAME $MSGPACK_GIT_REPO $MSGPACK_GIT_BRANCH "$MSGPACK_CMAKE_ARGS"

# Install CLI11
CLI11_DIR_NAME="CLI11"
CLI11_GIT_REPO="https://github.com/CLIUtils/CLI11.git"
CLI11_GIT_BRANCH="v2.1.2"
CLI11_CMAKE_ARGS=""
standard_build_and_install $CLI11_DIR_NAME $CLI11_GIT_REPO $CLI11_GIT_BRANCH "$CLI11_CMAKE_ARGS"

# Install spdlog
SPDLOG_DIR_NAME="spdlog"
SPDLOG_GIT_REPO="https://github.com/gabime/spdlog.git"
SPDLOG_GIT_BRANCH="v1.9.2"
SPDLOG_CMAKE_ARGS=""
standard_build_and_install $SPDLOG_DIR_NAME $SPDLOG_GIT_REPO $SPDLOG_GIT_BRANCH "$SPDLOG_CMAKE_ARGS"

# Install jsoncpp
JSONCPP_DIR_NAME="jsoncpp"
JSONCPP_GIT_REPO="https://github.com/open-source-parsers/jsoncpp.git"
JSONCPP_GIT_BRANCH="1.9.5"
JSONCPP_CMAKE_ARGS=""
standard_build_and_install $JSONCPP_DIR_NAME $JSONCPP_GIT_REPO $JSONCPP_GIT_BRANCH "$JSONCPP_CMAKE_ARGS"
