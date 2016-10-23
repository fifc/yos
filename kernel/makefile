AS=$(TARGET)-as
CC=$(TARGET)-gcc
CFLAGS=-std=gnu99 -ffreestanding -O2 -Wall -Wextra

all: neos.bin

neos.bin: boot.o kernel.o
	$(CC) -T linker.ld -o $@ -ffreestanding -O2 -nostdlib $^ -lgcc

clean:
	rm -f *.o neos.bin

