#!/bin/bash


# Superior_URL=https://github.com/TheSuperiorCoin/GUIwallet.git
# Superior_BRANCH=master
CPU_CORE_COUNT=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
pushd $(pwd)
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $ROOT_DIR/utils.sh


INSTALL_DIR=$ROOT_DIR/wallet
Superior_DIR=$ROOT_DIR/Superior


mkdir -p $Superior_DIR/build/release
pushd $Superior_DIR/build/release

# reusing function from "utils.sh"
platform=$(get_platform)

pushd $Superior_DIR/build/release/src/wallet
make -j$CPU_CORE_COUNT
make install -j$CPU_CORE_COUNT
popd

# unbound is one more dependency. can't be merged to the wallet_merged
# since filename conflict (random.c.obj)
# for Linux, we use libunbound shipped with the system, so we don't need to build it

if [ "$platform" != "linux" ]; then
    echo "Building libunbound..."
    pushd $Superior_DIR/build/release/external/unbound
    # no need to make, it was already built as dependency for libwallet
    # make -j$CPU_CORE_COUNT
    make install -j$CPU_CORE_COUNT
    popd
fi

popd











