# EhlOS

### About

EhlOS is a simple OS designed to be virtualized. EhlOS is buildt using C and the GNU development tools for operating systems.

### How to install tools for OS work:

The source code of most packages can be found [here](https://ftp.gnu.org/gnu/)

**Preparation**
Please run this in your current terminal:

```
sudo apt install libgmp3-dev
sudo apt install libmpc-dev
sudo apt install libmpfr-dev
sudo apt install texinfo
sudo apt install bison
sudo apt install flex
export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"
```

**Binutils**

```
cd $HOME/src

mkdir build-binutils
cd build-binutils
../binutils-x.y.z/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install
```

**GDB**

```
../gdb.x.y.z/configure --target=$TARGET --prefix="$PREFIX" --disable-werror
make all-gdb
make install-gdb
```

**GCC**

```
cd $HOME/src

# The $PREFIX/bin dir _must_ be in the PATH. We did that above.
which -- $TARGET-as || echo $TARGET-as is not in the PATH

mkdir build-gcc
cd build-gcc
../gcc-x.y.z/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc
```

**Adding to PATH**
Please add `export PATH="$HOME/opt/cross/bin:$PATH"` to `~/.profile`.
