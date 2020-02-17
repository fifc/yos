#!/bin/sh

cd bin
qemu-system-x86_64 -vga std -smp 4 -m 256 -drive id=disk,file=yos.img,if=none,format=raw -device ahci,id=ahci0 -device ide-hd,drive=disk,bus=ahci0.0 -name "YOS" -net nic,model=i82551
