#!/bin/sh

if [ ! -d "$bin" ]; then
  mkdir bin
fi

dd if=/dev/zero of=bin/nuos.image bs=1M count=8

cd fs
autoreconf -fi
./configure
make
mv src/nufs ../bin/
cd ..

./build.sh
./format.sh
./install.sh
