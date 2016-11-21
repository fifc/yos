#!/bin/sh
cd bin
echo Formatting Disk Image
./nufs nuos.image format /force
echo Writing Master Boot Record
dd if=nufs_mbr.sys of=nuos.image bs=512 conv=notrunc
