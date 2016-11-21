#!/bin/sh

cd bin
qemu-img convert -O vdi nuos.image nuos.vdi
dd if=../vdi_uuid.bin of=nuos.vdi count=1 bs=512 conv=notrunc

