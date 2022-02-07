INCLUDE Irvine32.inc

.data

MultiplierMsg BYTE "Enter a Multiplier : ",0
MultiplicandMsg BYTE "Enter a Multiplicand : ",0

ProdMsg BYTE "Product : ",0
ByeMsg BYTE "Bye!",0

Multiplicand DWORD ?
Multiplier DWORD ?
Result DWORD ?

.code

L0:
main PROC

mov edx, OFFSET MultiplierMsg
call WriteString
call ReadHex
;call DumpRegs
; input 0, CF become 0
; input enter, CF become 1
jc Bye



mov Multiplicand, eax	; to save values


mov edx, OFFSET MultiplicandMsg
call WriteString
call ReadHex
mov ebx,eax		; EBX contains Multiplicand

mov eax, Multiplicand	; Restore EAX' Multiplier value

call BitMul

mov edx, OFFSET ProdMsg
call WriteString
call WriteHex
call Crlf
call Crlf

jmp L0

Bye:
	mov edx, OFFSET ByeMsg
	call WriteString

main ENDP

;	******** BitwiseMultiplication Process ********

BitMul PROC
	mov edx, eax
	mov eax, 0
	jmp TestZero

TestOne:
	test ebx, 1	; check ebx is valid
	jp	IsEven
	add eax, edx

IsEven:
	shl edx, 1
	shr ebx, 1

TestZero:
	cmp ebx, 0
	ja TestOne
	ret

BitMul ENDP

END main