#!/bin/sh

cd programs/

nasm $1.asm -o ../bin/$1.app

if [ $? -eq 0 ]; then
	cd ../bin
	./nufs yos.img create $1.app 2
	./nufs yos.img write $1.app
	cd ..
else
	echo "Error"
fi
