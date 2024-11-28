init:	
	global main
	extern ExitProcess, GetStdHandle, WriteConsoleA, ReadConsoleA

	STD_OUTPUT_HANDLE equ -11
	STD_INPUT_HANDLE equ -10

	section .bss

	inputBuffer resb 32
	
	section .data

	helloMessage db "Hello, World!", 0xA, 0xD
	helloLen equ $ - helloMessage

	errorMessage db "Error reading user input.", 0xA, 0xD
	errorMessageLen equ $ - errorMessage
	
	section .text

write_to_console:

	push rbp
	mov rbp, rsp

	push rcx
	
	mov rcx, STD_OUTPUT_HANDLE
	call GetStdHandle

	pop rcx
	
	mov rdx, rcx
	mov rcx, rax
	mov r8, helloLen

	sub rsp, 32 + 8		; Shadow store + 16 byte alignment
	call WriteConsoleA
	add rsp, 32 + 8,	; Remove Shadow store + 16 byte alignment
	
	pop rbp
	RET 	
main:
	sub rsp, 8		; Align stack to 16 bytes
	
	lea rcx, [REL helloMessage]
	mov rdx, helloLen
	call write_to_console
	
	mov rcx, STD_INPUT_HANDLE
	call GetStdHandle

	sub rsp, 16		; Space for out parameter (number of characters written).
	
	mov rcx, rax
	lea rdx, [REL inputBuffer]
	mov r8, 32

	lea r9, [rsp + 16]

	sub rsp, 32		; Allocate Shadow Space
	call ReadConsoleA
	add rsp, 32		; Deallocate Shadow Space

	lea rcx, [REL inputBuffer]
	mov rdx, r9
	call write_to_console
	
	
	add rsp, 16		; Deallocate out parameter
	
	call ExitProcess
