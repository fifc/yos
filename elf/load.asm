USE64

global load_elf

section .text

load_elf:
	mov rax, rdi
	cmp dword [rax], 0x464c457f
	jne exit
	cmp byte [rax+4], 2
	jne exit
	mov rbx, [rax+0x20]
	add rax, rbx
	mov rax, 8888
	ret
exit:
	xor rax, rax
return:
	ret
