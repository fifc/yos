#!/bin/sh
cd bin
echo Formatting Disk Image
./yfs yos.img format /force
echo Writing Master Boot Record
dd if=yfs_mbr.sys of=yos.img bs=512 conv=notrunc
