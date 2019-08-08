#!/bin/sh

cd programs/

nasm $1.asm -o ../bin/$1

if [ $? -ne 0 ]; then
	echo "Error"
else
	cd ../bin
	./yfs yos.img create $1 2
	./yfs yos.img write $1
	cd ..
fi
