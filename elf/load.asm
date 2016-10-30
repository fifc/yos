USE64

global load_elf

section .text

load_elf:
	mov r8, rdi
	mov r9, rsi
	mov rax, rdi
	cmp dword [rax], 0x464c457f
	jne le_exit
	cmp byte [rax+4], 2
	jne le_exit
	mov rdx, [r8+0x20]
	add rax, rdx
	xor rdx, rdx
	mov dx,  [r8+0x36]
	xor rcx, rcx
	mov cx,  [r8+0x38]
ph_loop:
	cmp dword [rax], 1
	jne ph_continue
	mov rsi, [rax+8]
	add rsi, r8
	mov rdi, [rax+0x10]
	add rdi, r9
	mov r11, rcx
	mov rcx, [rax+0x20]

	rep movsb

	mov rcx, r11
ph_continue:
	add rax, rdx
	loop ph_loop
	sub rdi, r9
	mov rax, rdi
	ret
le_exit:
	xor rax, rax
	ret
