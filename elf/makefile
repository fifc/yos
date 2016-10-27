CC=gcc

all: load

load: main.o load.o
	gcc -o $@ -z max-page-size=0x1000 $^

load.o: load.asm
	nasm -f elf64 $<

clean:
	rm -f load *.o

run: load
	@echo ""
	@./load
	@echo ""
