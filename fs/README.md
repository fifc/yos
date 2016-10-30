# NeFS

Utility for accessing a disk or disk image formatted with NeOS File System (NeFS).


## Prerequisites

GCC (C compiler) and Automake are required for building the NeFS disk utility.

In Ubuntu this can be completed with the following command:

	sudo apt-get install gcc automake


## Building NeFS

    autoreconf -fi
    ./configure
    make
    sudo make install


## Creating a new, formatted disk image

    nefs disk.image initialize 128M


## Creating a new disk image that boots NeOS

    nefs disk.image initialize 128M path/to/nefs_mbr.sys path/to/pure64.sys path/to/kernel64.sys

or if the Pure64 boot loader and NeOS kernel are combined into one file:

    nefs disk.image initialize 128M path/to/nefs_mbr.sys path/to/software.sys


## Formatting a disk image

	nefs disk.image format

In Linux/Unix/Mac OS X you can also format a physical drive by passing the correct path.

	sudo nefs /dev/sdc format


## Display NeFS disk contents

	nefs disk.image list

Sample output:

	C:\baremetal>utils\nefs NeFS-256-flat.vmdk list
	Disk Size: 256 MiB
	Name                            |            Size (B)|      Reserved (MiB)
	==========================================================================
	test.app                                           31                    2
	AnotherFile.app                                     1                    2
	helloc.app                                        800                    2


## Create a new file and reserve space for it

	nefs disk.image create FileName.Ext

You will be prompted for the size to reserve.

Alternately, you can specify the reserved size after the file name. The reserved size is given in Megabytes and will automatically round up to an even number.

	nefs disk.image create FileName.Ext 4


## Read from NeFS to a local file

	nefs disk.image read FileName.Ext


## Write a local file to NeFS

	nefs disk.image write FileName.Ext


## Delete a file on NeFS

	nefs disk.image delete FileName.Ext

