# Superior GUI

Copyright (c) 2017-2020, The Superior Project
Copyright (c) 2014-2017 Part of this may Include Source Code from MONERO Project

## Development Resources

- Web: [superior-coin.com](https://superior-coin.com)
- BCT: [BitCoinTalk](https://bitcointalk.org/index.php?topic=2088169.0)
- Mail: [admin@Superior-coin.com](mailto:admin@Superior-coin.com)
- Github: [https://github.com/TheSuperiorCoin/GUIwallet](https://github.com/TheSuperiorCoin/GUIwallet)
- IRC: [#SuperiorCoin on Freenode](irc://chat.freenode.net/#Superiorcoin)
- FB: [https://www.facebook.com/TheSuperiorCoin](https://www.facebook.com/TheSuperiorCoin)

## Introduction

SuperiorCoin is a private, secure, untraceable, decentralised digital currency. You are your bank, you control your funds, and nobody can trace your transfers unless you allow them to do so.

**Privacy:** Superior uses a cryptographically sound system to allow you to send and receive funds without your transactions being easily revealed on the blockchain (the ledger of transactions that everyone has). This ensures that your purchases, receipts, and all transfers remain absolutely private by default.

**Security:** Using the power of a distributed peer-to-peer consensus network, every transaction on the network is cryptographically secured. Individual wallets have a 25 word mnemonic seed that is only displayed once, and can be written down to backup the wallet. Wallet files are encrypted with a passphrase to ensure they are useless if stolen.

**Untraceability:** By taking advantage of ring signatures, a special property of a certain type of cryptography, Superior is able to ensure that transactions are not only untraceable, but have an optional measure of ambiguity that ensures that transactions cannot easily be tied back to an individual user or computer.

## About this Project

This is the GUI for the [core Superior implementation](https://github.com/TheSuperiorCoin/TheSuperiorCoin). It is open source and completely free to use without restrictions, except for those specified in the license agreement below. There are no restrictions on anyone creating an alternative implementation of Superior that uses the protocol and network in a compatible manner.

As with many development projects, the repository on Github is considered to be the "staging" area for the latest changes. Before changes are merged into that branch on the main repository, they are tested by individual developers in their own branches, submitted as a pull request, and then subsequently tested by contributors who focus on testing and code reviews. That having been said, the repository should be carefully considered before using it in a production environment, unless there is a patch in the repository for a particular show-stopping issue you are experiencing. It is generally a better idea to use a tagged release for stability.

## Supporting the Project

Superior development can be supported directly through donations.

Both Superior and Bitcoin donations can be made using address's below

The SuperiorCoin donation address is: `5QaiHzo64sLDo42ky98uXtJ3zswCdpUrk1q5nSidtqovjjiC7FmxRt84Zu3HkpYQX1PLDU72aQMK6Cif4muRxwt3RyZXY6y` (viewkey: `Notupdated`)

The Bitcoin donation address is: `1CuZRQKAs8d2c4A1WW4rGgXCyMkFHsezz2`

Core development funding and/or some supporting services are also graciously provided by sponsors:

## License

See [LICENSE](LICENSE).

## Installing Superior Core from a Package

There are a few pakages availble on the website [SuperiorCoin](http://superior-coin.com)

Packaging for your favorite distribution would be a welcome contribution!

## Compiling Superior Core from Source

### On Linux:

(Tested on Ubuntu 16.04 x86, 16.10 x64 and Linux Mint 18 "Sarah" - Cinnamon x64)

1. Install Superior dependencies.

	`sudo apt install build-essential cmake libboost-all-dev miniupnpc libunbound-dev graphviz doxygen libunwind8-dev pkg-config libssl-dev`

2. Grab an up-to-date copy of the Superior-core repository.

	`git clone https://github.com/TheSuperiorCoin/GUIwallet.git`

3. Go into the repository.

	`cd Superior-core`

4. Use the script to compile the Superior libs necessary to run the GUI.

	`./get_libwallet_api.sh`


5. Install the GUI dependencies.

  - For Ubuntu 16.04 x86

	`sudo apt-get install qtbase5-dev qt5-default qtdeclarative5-dev qml-module-qtquick-controls qml-module-qtquick-xmllistmodel qttools5-dev-tools qml-module-qtquick-dialogs`

  - For Ubuntu 16.04+ x64

     `sudo apt-get install qtbase5-dev qt5-default qtdeclarative5-dev qml-module-qtquick-controls qml-module-qtquick-xmllistmodel qttools5-dev-tools qml-module-qtquick-dialogs qml-module-qt-labs-settings libqt5qml-graphicaleffects`

  - For Linux Mint 18 "Sarah" - Cinnamon x64

     `sudo apt install qml-module-qt-labs-settings qml-module-qtgraphicaleffects`

  - Optional : To build the flag `WITH_SCANNER`

     `sudo apt install qtmultimedia5-dev qml-module-qtmultimedia libzbar-dev`

6. Build the GUI.

	`./build.sh`

7. Run the GUI client.

	`./build/release/bin/Superior-wallet-gui`

### On OS X:

1. Install Xcode from AppStore
2. Install [homebrew](http://brew.sh/)
3. Install [Superior](https://github.com/Superior-project/Superior) dependencies:

  `brew install boost --c++11`

  `brew install openssl` - to install openssl headers

  `brew install pkgconfig`

  `brew install cmake`

  `brew install qt5`  (or download QT 5.8+ from [qt.io](https://www.qt.io/download-open-source/))

  If you have an older version of Qt installed via homebrew, you can force it to use 5.x like so:
  
  `brew link --force --overwrite qt5`

4. Install latest Qt using official installer from [qt.io](https://www.qt.io/download-open-source/) (homebrew version might be outdated).
5. Add Qt bin dir to your path (check first if directory exists; 5.8 is the current version)

    `export PATH=$PATH:$HOME/Qt/5.8/clang_64/bin`

5. Add Qt bin dir to your path.  Example:

    `export PATH=$PATH:/usr/local/opt/qt5/bin`

    make sure this is where Qt 5.x is installed on **your** system eg `$HOME/Qt/5.8/clang_64/bin` if you downloaded from qt.io.

6. Grab an up-to-date copy of the SuperiorCoinGUi repository.

  `git clone https://github.com/TheSuperiorCoin/GUIwallet.git`

7. Go into the repository.

  `cd GUIwallet`

8. Grab an up-to-date copy of the git clone https://github.com/TheSuperiorCoin/TheSuperiorCoin.git

    change the name of that folder to Superior
    cd ..

9. Start the build:

  `./build.sh`

The executable can be found in the `build/release/bin` folder.

**Note:** Workaround for "ERROR: Xcode not set up properly"

Edit `$HOME/Qt/5.7/clang_64/mkspecs/features/mac/default_pre.prf`

replace
`isEmpty($$list($$system("/usr/bin/xcrun -find xcrun 2>/dev/null")))`

with
`isEmpty($$list($$system("/usr/bin/xcrun -find xcodebuild 2>/dev/null")))`

More info: http://stackoverflow.com/a/35098040/1683164


### On Windows:

1. Install [msys2](http://msys2.github.io/), follow the instructions on that page on how to update packages to the latest versions

2. Install Superior dependencies as described in [Superior documentation](https://github.com/Superior-project/Superior) into msys2 environment.
   **As we only build application for x86, install only dependencies for x86 architecture (i686 in package name)**
   ```
   pacman -S mingw-w64-i686-toolchain make mingw-w64-i686-cmake mingw-w64-i686-boost

   ```

3. Install git into msys2 environment:

    ```
    pacman -S git
    ```

4. Install Qt5 from [official site](https://www.qt.io/download-open-source/).
   - download unified installer, run and select following options:
       - Qt > Qt 5.7 > MinGW 5.3.0 32 bit
       - Tools > MinGW 5.3.0
   - continue with installation

5. Open ```MinGW-w64 Win32 Shell``` shell:

   ```%MSYS_ROOT%\msys2_shell.cmd -mingw32```

   Where ```%MSYS_ROOT%``` will be ```c:\msys32``` if your host OS is x86-based or ```c:\msys64``` if your host OS
   is x64-based

6. Install the latest version of boost, specificly the required static libraries:
    ```
    cd
    wget http://sourceforge.net/projects/boost/files/boost/1.64.0/boost_1_64_0.tar.bz2
    tar xjf boost_1_64_0.tar.bz2
    cd boost_1_64_0
    ./bootstrap.sh mingw
    ../b2 --prefix=/mingw32/boost --layout=tagged --without-mpi --without-python toolset=gcc address-model=32 variant=debug,release link=static threading=multi runtime-link=static -j$(nproc) install 
    ```

7. Clone repository:
    ```
    cd
    git clone https://github.com/TheSuperiorCoin/GUIwallet.git
    ```
8.  cd GUIwallet
    git clone https://github.com/TheSuperiorCoin/TheSuperiorCoin.git
    Rename to Superior
    cd

8. Build the GUI:
    ```
    cd GUIwallet
    export PATH=$(ls -rd /c/Qt/5.[6,7,8]/mingw53_32/bin | head -1):$PATH
    ./build.sh
    cd build
    make deploy
    ```
    The resulting executable can be found in ```.\release\bin```
