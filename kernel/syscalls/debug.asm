; =============================================================================
; BareMetal -- a 64-bit OS written in Assembly for x86-64 systems
; Copyright (C) 2008-2016 Return Infinity -- see LICENSE.TXT
;
; Debug functions
; =============================================================================

align 16
db 'DEBUG: DEBUG    '
align 16


; -----------------------------------------------------------------------------
; os_dump_sys_reg -- Dump the values on the sys registers to the screen
;  IN:	Nothing
; OUT:	Nothing, all registers preserved
os_dump_sys_reg:
	push rax		; Push the registers used by this function
	mov rsi, odsr_gdtr_msg
	call os_output
	sgdt [odsr_sysreg_save]
	mov rax,  [odsr_sysreg_save+2]
	call os_debug_dump_rax
	mov al, ':'
	call os_output_char
	mov ax,  [odsr_sysreg_save]
	call os_debug_dump_ax

	mov rsi, odsr_ldtr_msg
	call os_output
	sldt rax
	call os_debug_dump_rax
	
	mov rsi, odsr_idtr_msg
	call os_output
	sidt [odsr_sysreg_save]
	mov rax,  [odsr_sysreg_save+2]
	call os_debug_dump_rax
	mov al, ':'
	call os_output_char
	mov ax,  [odsr_sysreg_save]
	call os_debug_dump_ax

	call os_print_newline
	call os_dump_cr_reg
os_dump_sys_reg_done:
	pop rax
	ret
odsr_sysreg_save dq 0
		 dw 0
odsr_cr_msg      db ' Cx:',0
odsr_gdtr_msg    db ' GDTR: ',0
odsr_ldtr_msg    db ' LDTR: ',0
odsr_idtr_msg    db ' IDTR: ',0

os_dump_cr_reg0:
	mov rax, cr0
	mov rbx, os_dump_cr_reg1
	jmp near os_dump_cr_reg_print
os_dump_cr_reg1:
	or ecx, 0x80000000
	mov rbx, os_dump_cr_reg2
	jmp near os_dump_cr_reg_print
os_dump_cr_reg2:
	mov rax, cr2
	mov rbx, os_dump_cr_reg3
	jmp near os_dump_cr_reg_print
os_dump_cr_reg3:
	mov rax, cr3
	mov rbx, os_dump_cr_reg4
	jmp near os_dump_cr_reg_print
os_dump_cr_reg4:
	mov rax, cr4
	mov rbx, os_dump_cr_reg5
	jmp near os_dump_cr_reg_print
os_dump_cr_reg5:
	or ecx, 0x80000000
	mov rbx, os_dump_cr_reg6
	jmp near os_dump_cr_reg_print
os_dump_cr_reg6:
	or ecx, 0x80000000
	mov rbx, os_dump_cr_reg7
	jmp near os_dump_cr_reg_print
os_dump_cr_reg7:
	or ecx, 0x80000000
	mov rbx, os_dump_cr_reg8
	jmp near os_dump_cr_reg_print
os_dump_cr_reg8:
	mov rax, cr8
	mov rbx, os_dump_cr_reg9
	jmp near os_dump_cr_reg_print
os_dump_cr_reg9:
	or ecx, 0x80000000
	mov rbx, os_dump_cr_reg10
	jmp near os_dump_cr_reg_print
os_dump_cr_reg10:
	or ecx, 0x80000000
	mov rbx, os_dump_cr_reg11
	jmp near os_dump_cr_reg_print
os_dump_cr_reg11:
	or ecx, 0x80000000
	mov rbx, os_dump_cr_reg12
	jmp near os_dump_cr_reg_print
os_dump_cr_reg12:
	or ecx, 0x80000000
	mov rbx, os_dump_cr_reg13
	jmp near os_dump_cr_reg_print
os_dump_cr_reg13:
	or ecx, 0x80000000
	mov rbx, os_dump_cr_reg14
	jmp near os_dump_cr_reg_print
os_dump_cr_reg14:
	or ecx, 0x80000000
	mov rbx, os_dump_cr_reg15
	jmp near os_dump_cr_reg_print
os_dump_cr_reg15:
	or ecx, 0x80000000
	mov rbx, 0
	jmp near os_dump_cr_reg_print

os_dump_cr_reg_step equ os_dump_cr_reg1 - os_dump_cr_reg0
os_dump_cr_reg:
	push rax
	push rbx
	push rcx
	push rdx
	mov dx,  '0'
	mov ecx,  0
	mov rbx, os_dump_cr_reg0
os_dump_cr_loop:
	jmp rbx
os_dump_cr_reg_print:
	test ecx, ecx
	js near os_dump_cr_reg_na
	cmp dx, '9' + 1
	jne os_dump_cr_go
	mov dx, 'a'
os_dump_cr_go:
	mov byte [odsr_cr_msg+2], dl
	mov rsi, odsr_cr_msg
	call os_output
	call os_debug_dump_rax
os_dump_cr_reg_na:
	cmp rbx, 0
	je os_dump_cr_reg_exit
	and ecx, 0x7fffffff
	inc cx
	inc dx
	jmp near os_dump_cr_loop
	
os_dump_cr_reg_exit:
	call os_print_newline
	pop rdx
	pop rcx
	pop rbx
	pop rax
	ret

; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; os_debug_dump_reg -- Dump the values on the registers to the screen (For debug purposes)
;  IN:	Nothing
; OUT:	Nothing, all registers preserved
os_debug_dump_reg:
	pushfq				; Push the registers used by this function
	push rsi
	push rbx
	push rax

	pushfq				; Push the flags to the stack
	push r15			; Push all of the registers to the stack
	push r14
	push r13
	push r12
	push r11
	push r10
	push r9
	push r8
	push rsp
	push rbp
	push rdi
	push rsi
	push rdx
	push rcx
	push rbx
	push rax

	mov byte [os_debug_dump_reg_stage], 0x00	; Reset the stage to 0 since we are starting
os_debug_dump_reg_next:
	mov rsi, os_debug_dump_reg_string00
	xor rax, rax
	xor rbx, rbx
	mov al, [os_debug_dump_reg_stage]
	mov bl, 5					; Each string is 5 bytes
	mul bl						; AX = BL x AL
	add rsi, rax					; Add the offset to get to the correct string
	call os_output					; Print the register name
	pop rax						; Pop the register from the stack
	call os_debug_dump_rax				; Print the hex string value of RAX
	inc byte [os_debug_dump_reg_stage]
	cmp byte [os_debug_dump_reg_stage], 0x11	; Check to see if all 16 registers as well as the flags are displayed
	jne os_debug_dump_reg_next
	
os_debug_dump_reg_done:
	call os_print_newline
	pop rax
	pop rbx
	pop rsi
	popfq
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_debug_dump_mem -- Dump some memory content to the screen
;  IN:	RSI = Start of memory address to dump
;	RCX = Number of bytes to dump
; OUT:	Nothing, all registers preserved
os_debug_dump_mem:
	push rsi
	push rcx			; Counter
	push rdx			; Total number of bytes to display
	push rax

	test rcx, rcx			; Bail out if no bytes were requested
	jz os_debug_dump_mem_done
	mov rax, rsi
	and rax, 0x0F			; Isolate the low 4 bytes of RSI
	add rcx, rax			; Add to round up the number of bytes needed
	mov rdx, rcx			; Save the total number of bytes to display
	add rdx, 15			; Make sure we print out another line if needed

	and cl, 0xF0
	and dl, 0xF0

	shr rsi, 4			; Round the starting memory address
	shl rsi, 4

os_debug_dump_mem_print_address:
	mov rax, rsi
	call os_debug_dump_rax

	push rsi
	mov rsi, divider4
	call os_output
	pop rsi

os_debug_dump_mem_print_contents:
	lodsq
	bswap rax			; Switch Endianness
	call os_debug_dump_rax
	push rsi
	mov rsi, divider2
	call os_output
	pop rsi
	lodsq
	bswap rax			; Switch Endianness
	call os_debug_dump_rax

	push rsi
	mov rsi, divider4
	call os_output
	pop rsi

os_debug_dump_mem_print_ascii:
	sub rsi, 0x10
	xor rcx, rcx			; Clear the counter
os_debug_dump_mem_print_ascii_next:
	lodsb
	call os_output_char
	inc rcx
	cmp rcx, 16
	jne os_debug_dump_mem_print_ascii_next
	
	sub rdx, 16
	test rdx, rdx
	jz os_debug_dump_mem_done
	call os_print_newline
	jmp os_debug_dump_mem_print_address

os_debug_dump_mem_done:
	pop rax
	pop rcx
	pop rdx
	pop rsi
	ret

divider4: db '    ', 0
divider2: db '  ', 0
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_debug_dump_(rax|eax|ax|al) -- Dump content of RAX, EAX, AX, or AL to the screen in hex format
;  IN:	RAX = content to dump
; OUT:	Nothing, all registers preserved
os_debug_dump_rax:
	rol rax, 8
	call os_debug_dump_al
	rol rax, 8
	call os_debug_dump_al
	rol rax, 8
	call os_debug_dump_al
	rol rax, 8
	call os_debug_dump_al
	rol rax, 32
os_debug_dump_eax:
	rol eax, 8
	call os_debug_dump_al
	rol eax, 8
	call os_debug_dump_al
	rol eax, 16
os_debug_dump_ax:
	rol ax, 8
	call os_debug_dump_al
	rol ax, 8
os_debug_dump_al:
	push rbx
	push rax
	mov rbx, hextable
	push rax			; Save RAX since we work in 2 parts
	shr al, 4			; Shift high 4 bits into low 4 bits
	xlatb
	call os_output_char
	pop rax
	and al, 0x0f			; Clear the high 4 bits
	xlatb
	call os_output_char
	pop rax
	pop rbx
	ret
; -----------------------------------------------------------------------------


; =============================================================================
; EOF
