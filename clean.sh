#!/bin/sh

pwd=`pwd`
rm -rf bin/
rm -f kernel/*.o
rm -rf newlib/build
cd fs && make distclean
cd ${pwd}


