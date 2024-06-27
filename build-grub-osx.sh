#!/usr/bin/env bash
set -e

# Checks if brew is installed
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    brew update
fi

export PREFIX="$HOME/opt/"
export TARGET=arm64-elf
export PATH="$PREFIX/bin:$PATH"

mkdir -p $HOME/src/grub-build
mkdir -p $PREFIX

brew install gmp mpfr libmpc pkg-config m4 libtool automake autoconf

echo -e "\nInstalling \`binutils\`\n"

cd $HOME/src/grub-build

if [ ! -d "binutils-2.42" ]; then
    curl -O https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.xz
    tar -xf binutils-2.42.tar.xz
    rm binutils-2.42.tar.xz
    mkdir -p build-binutils-2.42-x86_64-elf
    cd build-binutils-2.42-x86_64-elf
    ../binutils-2.42/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
    make
    make install
fi

echo -e "\nInstalling \`gcc\`\n"

cd $HOME/src/grub-build

if [ ! -d "gcc-13.3.0" ]; then
    curl -O https://ftp.gnu.org/gnu/gcc/gcc-13.3.0/gcc-13.3.0.tar.xz
    tar -xf gcc-13.3.0.tar.xz
    rm gcc-13.3.0.tar.xz
    mkdir -p build-gcc-13.3.0-x86_64-elf
    cd build-gcc-13.3.0-x86_64-elf
    ../gcc-13.3.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
    make all-gcc
    make all-target-libgcc
    make install-gcc
    make install-target-libgcc
fi

echo -e "\nInstalling \`objconv\`\n"

cd $HOME/src/grub-build

if [ ! -d "objconv" ]; then
    curl https://www.agner.org/optimize/objconv.zip > objconv.zip
    mkdir -p build-objconv
    unzip objconv.zip -d build-objconv
    cd build-objconv
    unzip source.zip -d src
    g++ -o objconv -O2 src/*.cpp --prefix="$PREFIX"
    cp objconv $PREFIX/bin
fi

echo -e "\nInstalling \`grub\`\n"

cd $HOME/src/grub-build

if [ ! -d "grub" ]; then
    mkdir -p build-grub
    git clone https://git.savannah.gnu.org/git/grub.git
    cd grub
    ./bootstrap
    cd $HOME/src/grub-build/build-grub
    ../grub/configure --disable-werror TARGET_CC=$TARGET-gcc TARGET_OBJCOPY=$TARGET-objcopy TARGET_STRIP=$TARGET-strip TARGET_NM=$TARGET-nm TARGET_RANLIB=$TARGET-ranlib --target=$TARGET --prefix=$PREFIX
    make
    make install
fi

echo -e "\nFinished\n"