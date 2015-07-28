#!/bin/sh -e

ROOTDIR=$(cd $(dirname $(dirname $0)); pwd)

if [ $# -ne 2 ]; then
    echo "Usage: $0 ARCH API" 1>&2
    echo "  ARCH: arm-linux-androideabi mipsel-linux-android x86" 1>&2
    echo "  API: 1 ... 21" 1>&2
    exit 1
fi

ARCH=$1
API=$2

(
    cd $ROOTDIR
    if [ ! -d toolchain/${ARCH}-${API} ]; then
        ./scripts/make_toolchain.sh ${ARCH} ${API}
    fi
    ./scripts/build_target.sh ${ARCH} ${API}
)
