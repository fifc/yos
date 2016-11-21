# NuFS

Utility for accessing a disk or disk image formatted with NeOS File System (NuFS).


## Prerequisites

GCC (C compiler) and Automake are required for building the NuFS disk utility.

In Ubuntu this can be completed with the following command:

	sudo apt-get install gcc automake


## Building NuFS

    autoreconf -fi
    ./configure
    make
    sudo make install


## Creating a new, formatted disk image

    nufs disk.image initialize 128M


## Creating a new disk image that boots NeOS

    nufs disk.image initialize 128M path/to/nufs_mbr.sys path/to/pure64.sys path/to/kernel64.sys

or if the Pure64 boot loader and NeOS kernel are combined into one file:

    nufs disk.image initialize 128M path/to/nufs_mbr.sys path/to/software.sys


## Formatting a disk image

	nufs disk.image format

In Linux/Unix/Mac OS X you can also format a physical drive by passing the correct path.

	sudo nufs /dev/sdc format


## Display NuFS disk contents

	nufs disk.image list

Sample output:

	C:\baremetal>utils\nufs NuFS-256-flat.vmdk list
	Disk Size: 256 MiB
	Name                            |            Size (B)|      Reserved (MiB)
	==========================================================================
	test.app                                           31                    2
	AnotherFile.app                                     1                    2
	helloc.app                                        800                    2


## Create a new file and reserve space for it

	nufs disk.image create FileName.Ext

You will be prompted for the size to reserve.

Alternately, you can specify the reserved size after the file name. The reserved size is given in Megabytes and will automatically round up to an even number.

	nufs disk.image create FileName.Ext 4


## Read from NuFS to a local file

	nufs disk.image read FileName.Ext


## Write a local file to NuFS

	nufs disk.image write FileName.Ext


## Delete a file on NuFS

	nufs disk.image delete FileName.Ext

