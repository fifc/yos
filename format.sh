#!/bin/sh
cd bin
echo Formatting Disk Image
./nefs neos.image format /force
echo Writing Master Boot Record
dd if=nefs_mbr.sys of=neos.image bs=512 conv=notrunc
