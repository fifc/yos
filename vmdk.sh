#!/bin/sh

cd bin
qemu-img convert -O vmdk nuos.image nuos.vmdk
