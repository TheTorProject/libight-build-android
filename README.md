# Build measurement-kit for Android

This repository contains the scripts needed to cross compile
measurement-kit for Android platforms.

## Installing the NDK

The first step to compile measurement-kit for Android is to download the
NDK (Native Development Kit) from [developer.android.com](
https://developer.android.com/tools/sdk/ndk/index.html).  We have tested
this repository with version 10d of the NDK.

Then copy the downloaded file to `$HOME/Android` and from inside this directory
run the downloaded file to unpack the NDK:

    $ pwd
    /home/simone/Android
    $ ./android-ndk-r10d-linux-x86_64.bin

## Creating a custom toolchain

Next, you need to [create a custom toolchain](
http://www.kandroid.org/ndk/docs/STANDALONE-TOOLCHAIN.html)
for the platform and API level that you want to target
using the `./scripts/make_toolchain.sh` command. For
example, the following command creates a standalone
toolchain in `./toolchain/` for ARM-based Android devices
using API level 9 (i.e., Android 2.3).

    $ ./scripts/make_toolchain.sh arm-linux-androideabi 9

## Cross-compiling

Once you created a custom toolchain, you can cross compile
measurement-kit using that toolchain using the `./scripts/build_target.sh`
script, which accepts the same command line parameters as the
script used to create a custom toolchain. For example,

    $ ./scripts/build_target.sh arm-linux-androideabi 9

this script cross compiles measurement-kit under `./build` and puts
the compiled libraries and haders under `./dist`.

Note that the above script also compiles the tests, which however
will fail because they cannot be executed on the build suystem.

*XXX* The current master branch of measurement-kit does not cross compile
for `android-x86` and MIPS because some small fixes are needed
to convince `boost` to compile with `libcxx` STL and `gabi++` ABI.

## TODO next

What is missing to continue this work is to compile and link
with measurement-kit and all its dependencies JNI code that can be
accessed from Java to use measurement-kit.
