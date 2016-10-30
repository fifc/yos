#!/bin/sh

cd bin
echo Writing Pure64+Software
cat boot.sys kernel64.sys > software.sys
dd if=software.sys of=neos.image bs=512 seek=16 conv=notrunc
