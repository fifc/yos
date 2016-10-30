#!/bin/bash

nasm src/bootsectors/bmfs_mbr.asm -o bmfs_mbr.sys
nasm src/bootsectors/pxestart.asm -o pxestart.sys
cd src
	nasm boot.asm -o ../boot.sys
cd ..
