INCLUDE Irvine32.inc

.data

keyData SDWORD 10 DUP (0)
StringLen DWORD 0
keyString SDWORD  40 DUP (0)

plainMsg BYTE "Enter a plain text : ",0
keyMsg BYTE "Enter a key : ",0
origMsg BYTE "Original Text : ",0
encMsg BYTE "Encrypted Text : ",0
decMsg BYTE "Decrypted Text : ",0
byeMsg BYTE "bye!",0
Msg1 BYTE 40 DUP(0)
Msg2 BYTE 40 DUP(0)
keySize DWORD ?
BufSize DWORD ?
temp DWORD ?


.code

main PROC
	L0:

	mov esi, 0
	mov ecx, 40

	LInit:
		mov al, 0
		mov Msg2[esi], al
		inc esi
		loop LInit



	mov edx, OFFSET plainMsg		; Enter plain
	call WriteString

	mov edx, OFFSET Msg1		;	Input  original text
	mov ecx, SIZEOF Msg1
	call ReadString	

	cmp eax, 0
	je Bye


	mov BufSize, eax
	
	mov ecx, BufSize
	mov esi, 0

	LCopy:
		mov al, Msg1[esi]
		mov Msg2[esi], al
		inc esi
		loop Lcopy

	mov edx, OFFSET keyMsg		; Enter Key 
	call WriteString

	;	Now, we have to input array from console		;

	mov edx, OFFSET keyString
	mov ecx, LENGTHOF keyString


	call ReadString

	


	mov esi, 0
	mov StringLen, eax
	add StringLen, edx
	inc StringLen

	mov ebx, edx

	L1:

	cmp ebx, StringLen
		je RealDone

	call ParseInteger32
	call DumpRegs
	mov keyData[esi], eax

	

	cmp eax, 0
	jge Positive
	jl Negative
	; looks like ... if pos, +2 and neg, +3
	Done:
	loop L1

	Positive:
		.IF eax<10 && eax>=0
			add edx, 2
			add ebx, 1
		.ELSEIF eax>=10 && eax<100
			add edx, 3
			add ebx, 2
		.ELSE
			add edx, 4
			add ebx, 3
		.ENDIF

 		add ebx, 1	; for space.
		add esi, 4
		jmp Done

	Negative:
		mov temp, eax
		neg temp
		

		.IF temp<10 && temp>0
			add edx, 3
			add ebx, 2
		.ELSEIF temp>=10 && temp<100
			add edx, 4
			add ebx, 3
		.ELSE
			add edx, 5
			add ebx, 4
		.ENDIF

	
		inc ebx		; for space
		add esi, 4
		jmp Done

	RealDone:
	call Crlf

	

	mov edx, OFFSET origMsg
	call WriteString

	mov edx, OFFSET Msg1
	call WriteString
	call Crlf

	mov KeySize, esi



	mov esi, OFFSET Msg1
	mov edi, OFFSET keyData
	mov ecx, BufSize


	call Encr

	mov edx, OFFSET encMsg
	mov esi, OFFSET Msg1
	call ShowMsg

	
	mov edx, OFFSET decMsg
	mov esi, OFFSET Msg2
	call ShowMsg
	call Crlf

	jmp L0
	
	Bye:
		mov edx, OFFSET byeMsg
		call WriteString
main ENDP

;	ESI : OFFSET Msg1(Byte)
;   EDI : OFFSET KeyData(DWORD) 
;	ECX : BufSize(Byte) : Msg1's size

Encr PROC

pushad
	mov	edx, 0

EncBytes:
	push	ecx
	mov cl, [edi + edx]	; CL = current character in key
	add edx, 4			; next character in key
	cmp	edx, keySize	; is EDI >= SIZEOF key ?
	jb	Continue		; if not, continue
	sub edx, keySize	; if yes, reset EDI tofirst char of key

Continue:
	or	cl,cl		; set Zero and Sign flags
	je	Done			; if Zero flag is set, CL = 0
	js	IsNeg	; if Sign flag is set, CL < 0
	mov al, BYTE PTR [esi]
	ror BYTE PTR [esi], cl	; CL > 0 so rotate right
	jmp	Done

IsNeg:
	neg	cl			; CL < 0 so rotate left
	mov al, BYTE PTR [esi]
	rol	 BYTE PTR [esi], cl

Done:
	inc 	esi			; point to the next byte
	pop	ecx 
	loop	EncBytes

popad
ret

Encr ENDP






ShowMsg PROC
	pushad
	call WriteString
	mov edx, esi
	call WriteString
	call Crlf
	popad
	ret
ShowMsg ENDP


END main