#!/bin/sh
cd programs/
gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -mno-red-zone -o $1.o $1.c
gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -mno-red-zone -o libneos.o libneos.c
ld -T app.ld -o $1.app $1.o libneos.o
mv $1.app ../bin/
if [ $? -eq 0 ]; then
	cd ../bin
	./nefs neos.image create $1.app 2
	./nefs neos.image write $1.app
	cd ..
else
	echo "Error"
fi
