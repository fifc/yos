#!/bin/sh

newlib_src=newlib-git
newlib_commit_rev=cf6e411f17be3bdce2df24911517798df4172859

cd newlib

if [ ! -d "${newlib_src}" ]; then
	git clone git://sourceware.org/git/newlib-cygwin.git ${newlib_src}
	git checkout ${newlib_commit_rev}
	cd ${newlib_src}
	patch -p1 < ../patch.diff
	cd -
fi
mkdir -p build

echo Configuring Newlib

mkdir ${newlib_src}/newlib/libc/sys/neos
cp neos/* ${newlib_src}/newlib/libc/sys/neos/

cd ${newlib_src}/newlib/libc/sys
autoconf
cd neos
autoreconf
cd ../../../../../build

../${newlib_src}/configure --target=x86_64-pc-neos --disable-multilib

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

gcc -I ${newlib_src}/newlib/libc/include/ -c test.c -o test.o
ld -T app.ld -o test.app crt0.o test.o libc.a

cp ../programs/libneos.* .
gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -mno-red-zone -o libneos.o libneos.c

echo Complete!
