# EhlOS

### About

EhlOS is a simple OS designed to be virtualized. EhlOS is buildt using C and the GNU development tools for operating systems.

### How to install tools for OS work:

The source code of most packages can be found [here](https://ftp.gnu.org/gnu/)

**Preparation** <br/>
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

**Adding to PATH** <br/>
Please add `export PATH="$HOME/opt/cross/bin:$PATH"` to `~/.profile`.

### Compiling the OS

The command used to assemble boot.s is `i686-elf-as boot.s -o boot.o`

This command uses the boot assembler we created earlier in [How to install tools for OS work](#how-to-install-tools-for-os-work)

You can compile the kernel by running `i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra`

The kernel can then be linked to the bootloader by running `i686-elf-gcc -T linker.ld -o ehlos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc`

You can verify that `ehlos.bin` is multiboot compliant by moving to the `src` directory and running `./check-multiboot.sh`

To create the ISO, run `grub-mkrescue -o ehlos.iso iso` from the root directory of this repo

### Running the OS

To run a virtual version of the system, run the following command: `qemu-system-i386 -cdrom ehlos.iso`

**IMPORTANT**: QEMU must be configured to boot things from BIOS, not just UEFI.