#!/bin/sh

pwd=`pwd`
rm -rf bin/
rm -rf newlib/
rm -f neos/os/*.o
cd fs && make distclean
cd ${pwd}


