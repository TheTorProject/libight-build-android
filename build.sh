#!/bin/sh

# Set path to NDK
export NDK=<NDK-ROOT>

# set path to the base directory where the toolchain will be created
export BASE_DIR=""

./scripts/make_toolchain.sh
./scripts/cross_compile.sh
