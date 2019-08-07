#!/bin/sh

cd bin
qemu-img convert -O vmdk yos.img yos.vmdk
