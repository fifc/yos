#!/bin/sh

cd boot
./build.sh
mv *.sys ../bin/
cd ..

cd kernel

if ( false ) then
	nasm kernel.asm -o ../bin/kernel.sys
else
	nasm -f elf64 kernel.asm -o kernel.o
	ld -T kernel.ld kernel.o -z max-page-size=0x1000 -o ../bin/kernel.sys
	strip ../bin/kernel.sys
fi

