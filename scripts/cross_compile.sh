#!/bin/sh

CONFIG=config
# export BASE_DIR=/home/alessandro/src/toolchains

for arch in $(cat ${CONFIG}/arch.list); do
    for api in $(cat ${CONFIG}/api.list); do
        ANDROID_TOOLCHAIN=${BASE_DIR}/${arch}-${api}
        export arch
        export api
        export ANDROID_TOOLCHAIN
        echo "Building libight for API ${api} and ARCH ${arch}-4.9"
        ./scripts/build_target.sh
    done
done
