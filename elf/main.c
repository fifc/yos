#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int load_elf(const char *image, void *mp);

typedef struct elf64_phdr {
  unsigned int  p_type;
  unsigned int  p_flags;
  unsigned long p_offset; /* Segment file offset */
  unsigned long p_vaddr;  /* Segment virtual address */
  unsigned long p_paddr;  /* Segment physical address */
  unsigned long p_filesz; /* Segment size in file */
  unsigned long p_memsz;  /* Segment size in memory */
  unsigned long p_align;  /* Segment alignment, file & memory */
} prog_hdr;

int dump(const char *image, int image_len)
{
	printf("file size: %d\n", image_len);
	printf("entry: %p\n", *(void**)(image + 0x18));

	prog_hdr *phdr = image + *(long*)(image + 0x20);
	unsigned int phdr_size = *(unsigned short*)(image + 0x36);
	unsigned int phdr_count = *(unsigned short*)(image + 0x38);
	printf("%u,%u,%lu\n",phdr_size, phdr_count,sizeof (prog_hdr));
	return 0;
}

int main(int argc, char *argv[])
{
	int fd = open(argv[0], O_RDONLY);
	if (fd < 0) {
		printf("%s: error open file\n", argv[0]);
		exit(2);
	}
	char *buf = (char *)malloc(1<<20);
	int len = read(fd, buf, 1<<20);
	close(fd);
	dump(buf, len);

	void *prog = malloc(1<<23);
	len = load_elf(buf, prog);
	free(buf);
	printf("size of program: %x\n", len);

	free(prog);
}
