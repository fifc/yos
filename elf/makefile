CC=gcc
#CFLAGS=-fPIC
LDFLAGS=-z max-page-size=0x1000

all: load

load: main.o load.o
	gcc $(LDFLAGS) -o $@ $^

load.o: load.asm
	nasm -f elf64 $<

clean:
	rm -f load *.o

run: load
	@echo ""
	@./load
	@echo ""
