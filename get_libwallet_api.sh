#!/bin/bash
Superior_URL=https://github.com/TheSuperiorCoin/GUIwallet.git
Superior_BRANCH=master

pushd $(pwd)
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $ROOT_DIR/utils.sh

INSTALL_DIR=$ROOT_DIR/wallet
Superior_DIR=$ROOT_DIR/Superior
BUILD_LIBWALLET=false

# init and update Superior submodule
if [ ! -d $Superior_DIR/src ]; then
    git submodule init Superior
fi
git submodule update
git -C $Superior_DIR fetch --tags
git -C $Superior_DIR checkout v0.10.3.1

# get Superior core tag
get_tag
# create local Superior branch
git -C $Superior_DIR checkout -B $VERSIONTAG

# Merge Superior PR dependencies

# Workaround for git username requirements
# Save current user settings and revert back when we are done with merging PR's
OLD_GIT_USER=$(git -C $Superior_DIR config --local user.name)
OLD_GIT_EMAIL=$(git -C $Superior_DIR config --local user.email)
git -C $Superior_DIR config user.name "Superior GUI"
git -C $Superior_DIR config user.email "gui@Superior.local"
# check for PR requirements in most recent commit message (i.e requires #xxxx)
for PR in $(git log --format=%B -n 1 | grep -io "requires #[0-9]*" | sed 's/[^0-9]*//g'); do
    echo "Merging Superior push request #$PR"
    # fetch pull request and merge
    git -C $Superior_DIR fetch origin pull/$PR/head:PR-$PR
    git -C $Superior_DIR merge --quiet PR-$PR  -m "Merge Superior PR #$PR"
    BUILD_LIBWALLET=true
done

# revert back to old git config
$(git -C $Superior_DIR config user.name "$OLD_GIT_USER")
$(git -C $Superior_DIR config user.email "$OLD_GIT_EMAIL")

# Build libwallet if it doesnt exist
if [ ! -f $Superior_DIR/lib/libwallet_merged.a ]; then
    echo "libwallet_merged.a not found - Building libwallet"
    BUILD_LIBWALLET=true
# Build libwallet if no previous version file exists
elif [ ! -f $Superior_DIR/version.sh ]; then
    echo "Superior/version.h not found - Building libwallet"
    BUILD_LIBWALLET=true
## Compare previously built version with submodule + merged PR's version. 
else
    source $Superior_DIR/version.sh
    # compare submodule version with latest build
    pushd "$Superior_DIR"
    get_tag
    popd
    echo "latest libwallet version: $GUI_Superior_VERSION"
    echo "Installed libwallet version: $VERSIONTAG"
    # check if recent
    if [ "$VERSIONTAG" != "$GUI_Superior_VERSION" ]; then
        echo "Building new libwallet version $GUI_Superior_VERSION"
        BUILD_LIBWALLET=true
    else
        echo "latest libwallet ($GUI_Superior_VERSION) is already built. Remove Superior/lib/libwallet_merged.a to force rebuild"
    fi
fi

if [ "$BUILD_LIBWALLET" != true ]; then
    # exit this script
    return
fi

echo "GUI_Superior_VERSION=\"$VERSIONTAG\"" > $Superior_DIR/version.sh

## Continue building libwallet

# default build type
BUILD_TYPE=$1
if [ -z $BUILD_TYPE ]; then
    BUILD_TYPE=release
fi

STATIC=false
ANDROID=false
if [ "$BUILD_TYPE" == "release" ]; then
    echo "Building libwallet release"
    CMAKE_BUILD_TYPE=Release
elif [ "$BUILD_TYPE" == "release-static" ]; then
    echo "Building libwallet release-static"
    CMAKE_BUILD_TYPE=Release
    STATIC=true
elif [ "$BUILD_TYPE" == "release-android" ]; then
    echo "Building libwallet release-static for ANDROID"
    CMAKE_BUILD_TYPE=Release
    STATIC=true
    ANDROID=true
elif [ "$BUILD_TYPE" == "debug-android" ]; then
    echo "Building libwallet debug-static for ANDROID"
    CMAKE_BUILD_TYPE=Debug
    STATIC=true
    ANDROID=true
elif [ "$BUILD_TYPE" == "debug" ]; then
    echo "Building libwallet debug"
    CMAKE_BUILD_TYPE=Debug
else
    echo "Valid build types are release, release-static, release-android, debug-android and debug"
    exit 1;
fi


echo "cleaning up existing Superior build dir, libs and includes"
#rm -fr $Superior_DIR/build
rm -fr $Superior_DIR/lib
rm -fr $Superior_DIR/include
rm -fr $Superior_DIR/bin


mkdir -p $Superior_DIR/build/release
pushd $Superior_DIR/build/release

# reusing function from "utils.sh"
platform=$(get_platform)
# default make executable
make_exec="make"

## OS X
if [ "$platform" == "darwin" ]; then
    echo "Configuring build for MacOS.."
    if [ "$STATIC" == true ]; then
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D ARCH="x86-64" -D BUILD_64=ON -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR"  ../..
    else
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE  -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR"  ../..
    fi

## LINUX 64
elif [ "$platform" == "linux64" ]; then
    echo "Configuring build for Linux x64"
    if [ "$ANDROID" == true ]; then
        echo "Configuring build for Android on Linux host"
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D ARCH="armv7-a" -D ANDROID=true -D BUILD_GUI_DEPS=ON -D USE_LTO=OFF -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR"  ../..
    elif [ "$STATIC" == true ]; then
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D ARCH="x86-64" -D BUILD_64=ON -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR"  ../..
    else
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D BUILD_GUI_DEPS=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR"  ../..
    fi

## LINUX 32
elif [ "$platform" == "linux32" ]; then
    echo "Configuring build for Linux i686"
    if [ "$STATIC" == true ]; then
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D ARCH="i686" -D BUILD_64=OFF -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR"  ../..
    else
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D BUILD_GUI_DEPS=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR"  ../..
    fi

## LINUX ARMv7
elif [ "$platform" == "linuxarmv7" ]; then
    echo "Configuring build for Linux armv7"
    if [ "$STATIC" == true ]; then
        cmake -D BUILD_TESTS=OFF -D ARCH="armv7-a" -D STATIC=ON -D BUILD_64=OFF  -D BUILD_GUI_DEPS=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR"  ../..
    else
        cmake -D BUILD_TESTS=OFF -D ARCH="armv7-a" -D -D BUILD_64=OFF  -D BUILD_GUI_DEPS=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR"  ../..
    fi

## LINUX other 
elif [ "$platform" == "linux" ]; then
    echo "Configuring build for Linux general"
    if [ "$STATIC" == true ]; then
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR"  ../..
    else
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D BUILD_GUI_DEPS=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR"  ../..
    fi

## Windows 64
## Windows is always static to work outside msys2
elif [ "$platform" == "mingw64" ]; then
    # Do something under Windows NT platform
    echo "Configuring build for MINGW64.."
    BOOST_ROOT=/mingw64/boost
    cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D BOOST_ROOT="$BOOST_ROOT" -D ARCH="x86-64" -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR" -G "MSYS Makefiles" ../..

## Windows 32
elif [ "$platform" == "mingw32" ]; then
    # Do something under Windows NT platform
    echo "Configuring build for MINGW32.."
    BOOST_ROOT=/mingw32/boost
    cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D Boost_DEBUG=ON -D BOOST_ROOT="$BOOST_ROOT" -D ARCH="i686" -D BUILD_64=OFF -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR" -G "MSYS Makefiles" ../..
    make_exec="mingw32-make"
else
    echo "Unknown platform, configuring general build"
    if [ "$STATIC" == true ]; then
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D BUILD_GUI_DEPS=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR"  ../..
    else
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D BUILD_GUI_DEPS=ON -D CMAKE_INSTALL_PREFIX="$Superior_DIR"  ../..
    fi
fi

# set CPU core count
# thanks to SO: http://stackoverflow.com/a/20283965/4118915
if test -z "$CPU_CORE_COUNT"; then
  CPU_CORE_COUNT=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
fi

# Build libwallet_merged
pushd $Superior_DIR/build/release/src/wallet
eval $make_exec version -C ../..
eval $make_exec  -j$CPU_CORE_COUNT
eval $make_exec  install -j$CPU_CORE_COUNT
popd

# Build Superiord
# win32 need to build daemon manually with msys2 toolchain
if [ "$platform" != "mingw32" ] && [ "$ANDROID" != true ]; then
    pushd $Superior_DIR/build/release/src/daemon
    eval make  -j$CPU_CORE_COUNT
    eval make install -j$CPU_CORE_COUNT
    popd
fi

# build install epee
eval make -C $Superior_DIR/build/release/contrib/epee all install


# Install libunwind
echo "Installing libunbound..."
pushd $Superior_DIR/build/release/external/unbound
# no need to make, it was already built as dependency for libwallet
# make -j$CPU_CORE_COUNT
$make_exec install -j$CPU_CORE_COUNT
popd


popd
