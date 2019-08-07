#!/bin/bash

nasm bootsectors/yfs_mbr.asm -o yfs_mbr.sys
nasm bootsectors/multiboot.asm -o multiboot.sys
nasm bootsectors/pxestart.asm -o pxestart.sys
nasm boot.asm -o boot.sys
