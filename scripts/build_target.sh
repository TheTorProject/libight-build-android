#!/bin/sh -e

export SYSROOT=${ANDROID_TOOLCHAIN}/sysroot
 
export TOOL_PATH=${ANDROID_TOOLCHAIN}/bin/${arch}
 
# XXX: this pattern does not work on x86, where the bin prefix (i686) is
# different from the `make-standalone-toolchain.sh` parameter (x86)
export CPP=${TOOL_PATH}-cpp
export AR=${TOOL_PATH}-ar
export AS=${TOOL_PATH}-as
export NM=${TOOL_PATH}-nm
export CC=${TOOL_PATH}-clang
export CXX=${TOOL_PATH}-clang++
export LD=${TOOL_PATH}-ld
export RANLIB=${TOOL_PATH}-ranlib
export STRIP=${TOOL_PATH}-strip
 
export CFLAGS="${CFLAGS} --sysroot=${SYSROOT} -I${SYSROOT}/usr/include -I${ANDROID_TOOLCHAIN}/include"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="${LDFLAGS} -L${SYSROOT}/usr/lib -L${ANDROID_TOOLCHAIN}/lib -lc++_static -latomic -lm"

cd libight
make clean
echo "Running configure with --host=${arch} and toolchain ${ANDROID_TOOLCHAIN}"
test -x ./configure || autoreconf -i
./configure --host=${arch} --with-sysroot=${SYSROOT} --with-libevent=builtin --with-yaml-cpp=builtin --with-libboost=builtin --disable-shared "$@" 
make
make check
echo "Installing library in ${BASE_DIR}/build/${ANDROID_TOOLCHAIN}"
make install DESTDIR=${BASE_DIR}/build/${ANDROID_TOOLCHAIN} # XXX: this path is relative to ${SYSROOT}
cd ..
