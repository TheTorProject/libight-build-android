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

export ANDROID_TOOLCHAIN=${ROOTDIR}/toolchain/${ARCH}-${API}
export SYSROOT=${ANDROID_TOOLCHAIN}/sysroot

# Note: the bin prefix (i686-linux-android) is different from the parameter
# that shall be passed to `make-standalone-toolchain.sh` (x86).
if [ $ARCH = x86 ]; then
    export TOOL_PATH=${ANDROID_TOOLCHAIN}/bin/i686-linux-android
else
    export TOOL_PATH=${ANDROID_TOOLCHAIN}/bin/${ARCH}
fi

export CPP=${TOOL_PATH}-cpp
export AR=${TOOL_PATH}-ar
export AS=${TOOL_PATH}-as
export NM=${TOOL_PATH}-nm
export CC=${TOOL_PATH}-clang
export CXX=${TOOL_PATH}-clang++
export LD=${TOOL_PATH}-ld
export RANLIB=${TOOL_PATH}-ranlib
export STRIP=${TOOL_PATH}-strip

export CPPFLAGS="${CPPFLAGS} --sysroot=${SYSROOT} -I${SYSROOT}/usr/include -I${ANDROID_TOOLCHAIN}/include"
export LDFLAGS="${LDFLAGS} -L${SYSROOT}/usr/lib -L${ANDROID_TOOLCHAIN}/lib -lc++_shared -lm"

(
    cd $ROOTDIR
    git submodule update --init --recursive  # Just in case
    install -d ${ROOTDIR}/build/${ARCH}-${API}
    cd ${ROOTDIR}/build/${ARCH}-${API}
    test -f Makefile && make clean
    echo "Configure with --host=${ARCH} and toolchain ${ANDROID_TOOLCHAIN}"
    test -x ${ROOTDIR}/libight/configure || (cd ../libight/ && autoreconf -i)
    ${ROOTDIR}/libight/configure --host=${ARCH} --with-sysroot=${SYSROOT} \
      --with-libevent=builtin --with-libyaml-cpp=builtin --with-libboost=builtin
    make V=0
    # XXX: We want to see whether tests builds but of course they cannot run
    make check-am V=0 || true
    echo "Installing library in ${BASEDIR}/build/${ANDROID_TOOLCHAIN}"
    make install DESTDIR=${ROOTDIR}/dist/${ARCH}-${API}
)
