#!/bin/bash

nasm src/bootsectors/nefs_mbr.asm -o nefs_mbr.sys
nasm src/bootsectors/pxestart.asm -o pxestart.sys
cd src
	nasm boot.asm -o ../boot.sys
cd ..
