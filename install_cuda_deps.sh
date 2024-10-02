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

# Install thrust
THRUST_DIR_NAME="thrust"
THRUST_GIT_REPO="https://github.com/NVIDIA/thrust.git"
THRUST_GIT_BRANCH="1.15.0"
THRUST_CMAKE_ARGS=""
standard_build_and_install $THRUST_DIR_NAME $THRUST_GIT_REPO $THRUST_GIT_BRANCH "$THRUST_CMAKE_ARGS"
