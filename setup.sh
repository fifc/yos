#!/bin/sh

if [ ! -d "bin" ]; then
  mkdir bin
fi

dd if=/dev/zero of=bin/yos.img bs=1M count=8

cd fs
autoreconf -fi
./configure
make
mv yfs/yfs ../bin/
cd ..

./build.sh
./format.sh
./install.sh
