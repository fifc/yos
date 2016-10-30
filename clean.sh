#!/bin/sh

pwd=`pwd`
rm -rf bin/
rm -rf newlib/
rm -f kernel/*.o
cd fs && make distclean
cd ${pwd}


