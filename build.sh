#!/bin/sh

cd boot
./build.sh
mv *.sys ../bin/
cd ..

cd kernel
nasm -f elf64 kernel64.asm -o kernel64.o
ld -T kernel64.ld kernel64.o -z max-page-size=0x1000 -o ../bin/kernel64.sys
strip ../bin/kernel64.sys
