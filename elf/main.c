#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int load_elf(const char *image, void *mp);

int dump(const char *image, int image_len)
{
	printf("file size: %d\n", image_len);
	printf("entry: %p\n", *(void**)(image + 0x18));
/*
	for (int j = 0; j < 4; ++j) {
		for (int i = 0; i < 4; ++i) {
			printf("%08x ", ((int*)image)[j*4 + i]);
		}
		printf("\n");
	}
*/
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
	printf("size of program: %d\n", len);

	free(prog);
}
