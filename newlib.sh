#!/bin/sh

cd newlib

if [ ! -d "newlib-2.4.0.20160923" ]; then
	echo Downloading Newlib
	curl -O ftp://sourceware.org/pub/newlib/newlib-2.4.0.20160923.tar.gz
	tar zxf newlib-2.4.0.20160923.tar.gz
fi
mkdir -p build

echo Configuring Newlib

cd newlib-2.4.0.20160923
patch < ../patches/config.sub.patch
cd newlib
patch < ../../patches/configure.host.patch
cd libc/sys
patch < ../../../../patches/configure.in.patch
cd ../../../..

mkdir newlib-2.4.0.20160923/newlib/libc/sys/neos
cp neos/* newlib-2.4.0.20160923/newlib/libc/sys/neos/

cd newlib-2.4.0.20160923/newlib/libc/sys
autoconf
cd neos
autoreconf
cd ../../../../../build

../newlib-2.4.0.20160923/configure --target=x86_64-pc-neos --disable-multilib

sed -i 's/TARGET=x86_64-pc-neos-/TARGET=/g' Makefile
sed -i 's/WRAPPER) x86_64-pc-neos-/WRAPPER) /g' Makefile

echo Building Newlib

make

echo Build complete!

cd x86_64-pc-neos/newlib/
cp libc.a ../../..
cp libm.a ../../..
cp crt0.o ../../..
cd ../../..

echo Compiling test application...

gcc -I newlib-2.4.0.20160923/newlib/libc/include/ -c test.c -o test.o
ld -T app.ld -o test.app crt0.o test.o libc.a

cp ../programs/libneos.* .
gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -mno-red-zone -o libneos.o libneos.c

echo Complete!
