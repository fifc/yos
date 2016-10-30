#!/bin/sh

if [ ! -d "newlib" ]; then
  mkdir newlib
fi
cd newlib

echo Downloading Newlib

wget ftp://sourceware.org/pub/newlib/newlib-src.tar.gz
tar xf newlib-src.tar.gz
mkdir build

echo Configuring Newlib

cd ../kernel/newlib/patches
cp config.sub.patch ../../../newlib/newlib-src/
cp configure.host.patch ../../../newlib/newlib-src/newlib/
cp configure.in.patch ../../../newlib/newlib-src/newlib/libc/sys/
cd ../../../newlib
cd newlib-src
patch < config.sub.patch
cd newlib
patch < configure.host.patch
cd libc/sys
patch < configure.in.patch
cd ../../..

mkdir newlib-src/newlib/libc/sys/neos
cp ../neos/newlib/neos/* newlib-src/newlib/libc/sys/neos/

cd newlib-src/newlib/libc/sys
autoconf
cd neos
autoreconf
cd ../../../../build

../newlib-src/configure --target=x86_64-pc-neos --disable-multilib

sed -i 's/TARGET=x86_64-pc-neos-/TARGET=/g' Makefile
sed -i 's/WRAPPER) x86_64-pc-neos-/WRAPPER) /g' Makefile

echo Building Newlib

make

echo Build complete!

cd x86_64-pc-neos/newlib/
cp libc.a ../../..
cp libm.a ../../..
cp crt0.o ../../..
cd ../..

echo Compiling test application...

cp ../neos/newlib/*.* .

gcc -I newlib-src/newlib/libc/include/ -c test.c -o test.o
ld -T app.ld -o test.app crt0.o test.o libc.a

cp ../neos/programs/libneos.* .
gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -mno-red-zone -o libneos.o libneos.c

echo Complete!
