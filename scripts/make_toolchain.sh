#!/bin/sh -e

# If launching directly this script, set path to the NDK
# export NDK=

# If launching directly this script, set path to the base directory where the
# toolchain will be created
# export BASE_DIR=

MAKE_TOOLCHAIN=${NDK}/build/tools/make-standalone-toolchain.sh
CONFIG=config

for arch in $(cat $CONFIG/arch.list); do
    for api in $(cat $CONFIG/api.list); do
        INSTALL_DIR=$BASE_DIR/${arch}-${api}
        echo "Creating toolchain for API ${api} and ARCH ${arch}-4.9 in ${INSTALL_DIR}"
        $MAKE_TOOLCHAIN \
            --platform=android-${api} \
            --toolchain=${arch}-4.9 \
            --install-dir=${INSTALL_DIR} \
            --llvm-version=3.5 \
            --stl=libc++ \
            --system=linux-x86_64
    done
done
