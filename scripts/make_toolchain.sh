#!/bin/sh -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 ARCH API" 1>&2
    echo "  ARCH: arm-linux-androideabi mipsel-linux-android x86" 1>&2
    echo "  API: 1 ... 21" 1>&2
    exit 1
fi

ARCH=$1
API=$2
BASEDIR=./toolchain
NDK=$HOME/Android

MAKE_TOOLCHAIN=${NDK}/android-ndk-r10d/build/tools/make-standalone-toolchain.sh

INSTALL_DIR=$BASEDIR/${ARCH}-${API}
echo "Creating toolchain for API ${API} and ARCH ${ARCH}-4.9 in ${INSTALL_DIR}"

# Bash is recommended to make the toolchain
bash $MAKE_TOOLCHAIN \
  --platform=android-${API} \
  --toolchain=${ARCH}-4.9 \
  --install-dir=${INSTALL_DIR} \
  --llvm-version=3.5 \
  --stl=libc++ \
  --system=linux-x86_64
