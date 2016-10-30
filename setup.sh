#!/bin/sh

if [ ! -d "$bin" ]; then
  mkdir bin
fi

dd if=/dev/zero of=bin/neos.image bs=1M count=8

cd fs
autoreconf -fi
./configure
make
mv src/nefs ../bin/
cd ..

./build.sh
./format.sh
./install.sh
