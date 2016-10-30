#!/bin/sh

cd bin
qemu-img convert -O vdi neos.image neos.vdi
dd if=../vdi_uuid.bin of=neos.vdi count=1 bs=512 conv=notrunc

