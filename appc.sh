#!/bin/sh
cd programs/
gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -mno-red-zone -o $1.o $1.c
gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -mno-red-zone -o libnufs.o libnufs.c
ld -T app.ld -o $1.app $1.o libnufs.o
mv $1.app ../bin/
if [ $? -eq 0 ]; then
	cd ../bin
	./nufs nufs.image create $1.app 2
	./nufs nufs.image write $1.app
	cd ..
else
	echo "Error"
fi
