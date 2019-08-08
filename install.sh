#!/bin/sh

cd bin
echo Writing Boot+Software
cat boot.sys kernel.sys > software.sys
dd if=software.sys of=yos.img bs=512 seek=16 conv=notrunc
