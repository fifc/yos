#!/bin/bash

nasm bootsectors/nufs_mbr.asm -o nufs_mbr.sys
nasm bootsectors/multiboot.asm -o multiboot.sys
nasm bootsectors/pxestart.asm -o pxestart.sys
nasm boot.asm -o boot.sys
