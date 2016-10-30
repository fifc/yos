#!/bin/sh

cd bin
qemu-img convert -O vmdk neos.image neos.vmdk
