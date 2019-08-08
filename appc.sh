#!/bin/sh
cd programs/
gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -mno-red-zone -o $1.o $1.c
gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -mno-red-zone -o libyos.o libyos.c
ld -T app.ld -o ../bin/$1 $1.o libyos.o

if [ $? -ne 0 ]; then
	echo "Error"
else
	cd ../bin
	./yfs yos.img create $1 2
	./yfs yos.img write $1
	cd ..
fi
