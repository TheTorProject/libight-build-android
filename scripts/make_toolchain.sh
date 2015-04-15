#!/bin/sh -e

ARCHS="arm-linux-androideabi mipsel-linux-android x86"
APIS="21"

if [ $# -eq 0 ]; then
    NDK=$HOME/Android
elif [ $# -eq 1 ]; then
    NDK=$1
else
    echo "Usage: $0 [/path/to/ndk]" 1>&2
    exit 1
fi

BASEDIR=./toolchain
MAKE_TOOLCHAIN=${NDK}/android-ndk-r10d/build/tools/make-standalone-toolchain.sh

for arch in $ARCHS; do
    for api in $APIS; do
        INSTALL_DIR=$BASEDIR/${arch}-${api}
        echo "Creating toolchain for API ${api} and ARCH ${arch}-4.9 in ${INSTALL_DIR}"
        # Bash is recommended to make the toolchain
        bash $MAKE_TOOLCHAIN \
            --platform=android-${api} \
            --toolchain=${arch}-4.9 \
            --install-dir=${INSTALL_DIR} \
            --llvm-version=3.5 \
            --stl=libc++ \
            --system=linux-x86_64
    done
done
