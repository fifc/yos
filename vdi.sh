#!/bin/sh

cd bin
qemu-img convert -O vdi yos.img yos.vdi
dd if=../vdi_uuid.bin of=yos.vdi count=1 bs=512 conv=notrunc

