; =============================================================================
; BareMetal -- a 64-bit OS written in Assembly for x86-64 systems
; Copyright (C) 2008-2016 Return Infinity -- see LICENSE.TXT
;
; NeFS Functions
; =============================================================================

align 16
db 'DEBUG: NeFS     '
align 16


; -----------------------------------------------------------------------------
; init_nefs -- Initialize the NeFS driver
init_nefs:
	push rdi
	push rdx
	push rcx
	push rax

	mov byte [nefs_directory], 0

	cmp byte [os_DiskEnabled], 0x01
	jne init_nefs_nodisk

	; Read directory to memory
	mov rax, 8			; Start to read from 4K in
	mov rcx, 8			; Read 8 sectors (4KiB)
	xor edx, edx			; Read from drive 0
	mov rdi, nefs_directory
	call readsectors

	; Get total blocks
	mov eax, [hd1_size]		; in mebibytes (MiB)
	shr rax, 1
	mov [nefs_TotalBlocks], rax

init_nefs_nodisk:

	pop rax
	pop rcx
	pop rdx
	pop rdi
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_file_open -- Open a file on disk
; IN:	RSI = File name (zero-terminated string)
; OUT:	RAX = File I/O handler, 0 on error
;	All other registers preserved
os_nefs_file_open:
	push rsi
	push rdx
	push rcx
	push rbx

	; Query the existence
	call os_nefs_file_internal_query
	jc os_nefs_file_open_error
	mov rax, rbx			; Slot #
	add rax, 10			; Files start at 10

	; Is it already open? If not, mark as open
	mov rsi, os_filehandlers
	add rsi, rbx
	cmp byte [rsi], 0		; 0 is closed
	jne os_nefs_file_open_error
	mov byte [rsi], 1		; Set to open

	; Reset the seek
	mov rsi, os_filehandlers_seek
	shl rbx, 3			; Quick multiply by 8
	add rsi, rbx
	xor ebx, ebx			; SEEK_START
	mov qword [rsi], rbx

	jmp os_nefs_file_open_done

os_nefs_file_open_error:
	xor eax, eax

os_nefs_file_open_done:
	pop rbx
	pop rcx
	pop rdx
	pop rsi
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_file_close -- Close an open file
; IN:	RAX = File I/O handler
; OUT:	All registers preserved
os_nefs_file_close:
	push rsi
	push rax

	; Is it in the valid file handler range?
	sub rax, 10			; Subtract the handler offset
	cmp rax, 64			; NeFS has up to 64 files
	jg os_nefs_file_close_error

	; Mark as closed
	mov rsi, os_filehandlers
	add rsi, rax
	mov byte [rsi], 0		; Set to closed

os_nefs_file_close_error:

os_nefs_file_close_done:
	pop rax
	pop rsi
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_nefs_file_read -- Read a number of bytes from a file
; IN:	RAX = File I/O handler
;	RCX = Number of bytes to read (automatically rounded up to next 2MiB)
;	RDI = Destination memory address
; OUT:	RCX = Number of bytes read
;	All other registers preserved
os_nefs_file_read:
	push rdi
	push rsi
	push rdx
	push rcx
	push rbx
	push rax

	; Is it a valid read?
	cmp rcx, 0
	je os_nefs_file_read_error

	; Is it in the valid file handler range?
	sub rax, 10			; Subtract the handler offset
	mov rbx, rax			; Keep the file ID
	cmp rax, 64			; NeFS has up to 64 files
	jg os_nefs_file_read_error

	; Is this an open file?
	mov rsi, os_filehandlers
	add rsi, rax
	cmp byte [rsi], 0
	je os_nefs_file_read_error

	; Get the starting block
	mov rsi, nefs_directory		; Beginning of directory structure
	shl rax, 6			; Quickly multiply by 64 (size of NeFS record)
	add rsi, rax
	add rsi, 32			; Offset to starting block
	lodsq				; Load starting block in RAX

	; Add the current offset
	; Currently always starting from start

	; Round up 'bytes to read' to the next 2MiB block
	add rcx, 2097151		; 2MiB - 1 byte
	shr rcx, 21			; Quick divide by 2097152

	; Read the block(s)
	xor edx, edx			; Drive 0
	call os_nefs_block_read
	jmp os_nefs_file_read_done

os_nefs_file_read_error:
	xor ecx, ecx

os_nefs_file_read_done:

	; Increment the offset

	pop rax
	pop rbx
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_nefs_file_write -- Write a number of bytes to a file
; IN:	RAX = File I/O handler
;	RCX = Number of bytes to write
;	RSI = Source memory address
; OUT:	RCX = Number of bytes written
;	All other registers preserved
os_nefs_file_write:
	push rdi
	push rsi
	push rdx
	push rcx
	push rbx
	push rax

	; Is it a valid write?
	cmp rcx, 0
	je os_nefs_file_write_error

	; Is it in the valid file handler range?
	sub rax, 10			; Subtract the handler offset
	mov rbx, rax			; Keep the file ID
	cmp rax, 64			; NeFS has up to 64 files
	jg os_nefs_file_write_error

	; Is this an open file?
	mov rdi, os_filehandlers
	add rdi, rax
	cmp byte [rdi], 0
	je os_nefs_file_write_error

	; Flush directory to disk

os_nefs_file_write_error:
	xor ecx, ecx

os_nefs_file_write_done:

	pop rax
	pop rbx
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_nefs_file_seek -- Seek to position in a file
; IN:	RAX = File I/O handler
;	RCX = Number of bytes to offset from origin
;	RDX = Origin
; OUT:	All registers preserved
os_nefs_file_seek:
	; Is this an open file?

	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_nefs_file_internal_query -- Search for a file name and return information
; IN:	RSI = Pointer to file name
; OUT:	RAX = Staring block number
;	RBX = Offset to entry
;	RCX = File size in bytes
;	RDX = Reserved blocks
;	Carry set if not found. If carry is set then ignore returned values
os_nefs_file_internal_query:
	push rdi

	clc				; Clear carry
	mov rdi, nefs_directory		; Beginning of directory structure

os_nefs_file_internal_query_next:
	call os_string_compare
	jc os_nefs_file_internal_query_found
	add rdi, 64			; Next record
	cmp rdi, nefs_directory + 0x1000	; End of directory
	jne os_nefs_file_internal_query_next
	stc				; Set flag for file not found
	pop rdi
	ret

os_nefs_file_internal_query_found:
	clc				; Clear flag for file found
	mov rbx, rdi
	sub rbx, nefs_directory
	shr rbx, 6				; Quick divide by 64 for offset (entry) number
	mov rdx, [rdi + NeFS_DirEnt.reserved]	; Reserved blocks
	mov rcx, [rdi + NeFS_DirEnt.size]	; Size in bytes
	mov rax, [rdi + NeFS_DirEnt.start]	; Starting block number

	pop rdi
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_nefs_file_query -- Search for a file name and return information
; IN:	RSI = Pointer to file name
; OUT:	RCX = File size in bytes
;	Carry set if not found. If carry is set then ignore returned values
os_nefs_file_query:
	push rdi

	clc				; Clear carry
	mov rdi, nefs_directory		; Beginning of directory structure

os_nefs_file_query_next:
	call os_string_compare
	jc os_nefs_file_query_found
	add rdi, 64			; Next record
	cmp rdi, nefs_directory + 0x1000	; End of directory
	jne os_nefs_file_query_next
	stc				; Set flag for file not found
	pop rdi
	ret

os_nefs_file_query_found:
	clc				; Clear flag for file found
	mov rcx, [rdi + NeFS_DirEnt.size]	; Size in bytes

	pop rdi
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_nefs_file_create -- Create a file on the hard disk
; IN:	RSI = Pointer to file name, must be <= 32 characters
;	RCX = File size to reserve (rounded up to the nearest 2MiB)
; OUT:	Carry clear on success, set on failure
; Note:	This function pre-allocates all blocks required for the file
os_nefs_file_create:

	; Flush directory to disk

	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_nefs_file_delete -- Delete a file from the hard disk
; IN:	RSI = File name to delete
; OUT:	Carry clear on success, set on failure
os_nefs_file_delete:
	push rdx
	push rcx
	push rbx
	push rax

	call os_nefs_file_internal_query
	jc os_nefs_file_delete_notfound

	mov byte [rbx + NeFS_DirEnt.filename], 0x01 ; Add deleted marker to file name

	; Flush directory to disk

os_nefs_file_delete_notfound:
	pop rax
	pop rbx
	pop rcx
	pop rdx
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_nefs_block_read -- Read a number of blocks into memory
; IN:	RAX = Starting block #
;	RCX = Number of blocks to read
;	RDI = Memory location to store blocks
; OUT:
os_nefs_block_read:
	cmp rcx, 0
	je os_nefs_block_read_done	; Bail out if instructed to read nothing

	; Calculate the starting sector
	shl rax, 12			; Multiply block start count by 4096 to get sector start count

	; Calculate sectors to read
	shl rcx, 12			; Multiply block count by 4096 to get number of sectors to read
	mov rbx, rcx

os_nefs_block_read_loop:
	mov rcx, 4096			; Read 2MiB at a time (4096 512-byte sectors = 2MiB)
	call readsectors
	sub rbx, 4096
	jnz os_nefs_block_read_loop

os_nefs_block_read_done:
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_nefs_block_write -- Write a number of blocks to disk
; IN:	RAX = Starting block #
;	RCX = Number of blocks to write
;	RSI = Memory location of blocks to store
; OUT:
os_nefs_block_write:
	cmp rcx, 0
	je os_nefs_block_write_done	; Bail out if instructed to write nothing

	; Calculate the starting sector
	shl rax, 12			; Multiply block start count by 4096 to get sector start count

	; Calculate sectors to write
	shl rcx, 12			; Multiply block count by 4096 to get number of sectors to write
	mov rbx, rcx

os_nefs_block_write_loop:
	mov rcx, 4096			; Write 2MiB at a time (4096 512-byte sectors = 2MiB)
	call writesectors
	sub rbx, 4096
	jnz os_nefs_block_write_loop

os_nefs_block_write_done:
	ret
; -----------------------------------------------------------------------------


; =============================================================================
; EOF
