#!/bin/sh
cd neos/programs/
nasm $1.asm -o ../../bin/$1.app
if [ $? -eq 0 ]; then
	cd ../../bin
	./nefs neos.image create $1.app 2
	./nefs neos.image write $1.app
	cd ..
else
	echo "Error"
fi
