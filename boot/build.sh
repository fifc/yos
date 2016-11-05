#!/bin/bash

cd src
	nasm bootsectors/nefs_mbr.asm -o ../nefs_mbr.sys
	nasm bootsectors/pxestart.asm -o ../pxestart.sys
	nasm boot.asm -o ../boot.sys
cd ..
