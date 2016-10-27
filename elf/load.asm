USE64

global load_elf

section .text

load_elf:
	mov rax, rdi
	cmp dword [rax], 0x464c457f
	jne exit
	cmp byte [rax+4], 2
	jne exit
	mov rbx, [rdi+0x20]
	add rax, rbx
	mov bx, word [rdi+0x36]
	and rbx, 0xffff
	mov cx, word[rdi+0x38]
	and rcx, 0xffff
ph_loop:
	cmp dword [rax], 1
	jne ph_continue
ph_continue:
	add rax, rbx
	loop ph_loop
	sub rax, rdi
	ret
exit:
	xor rax, rax
return:
	ret
