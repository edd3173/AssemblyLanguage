INCLUDE irvine32.inc


.data

StringBuff BYTE 40 DUP(0)
KeyBuff BYTE 10 DUP(0)


StringCount DWORD ?
KeyCount DWORD ?
EdiCount DWORD ?

inputString BYTE "Enter a plain text : ",0
inputKey BYTE "Enter a key : ",0

OrigMsg BYTE "Original text : ",0
EncMsg BYTE "Encrypted text : ",0
DecMsg BYTE "Decrypted text : ", 0
ByeMsg BYTE "Bye!", 0

.code

main PROC

	L0:

	mov StringCount, 0
	mov KeyCount, 0
	mov EdiCount, 0


	mov edx, OFFSET inputString
	call WriteString

	mov edx, OFFSET StringBuff
	mov ecx, SIZEOF StringBuff
	
	call ReadString 
	; readstring, pass offset of buff in edx, set ecx to max of number user can enter
	; return count of number in eax

	cmp eax, 41
	jae L0		; over 40, go L0.

	cmp eax, 0
	je BYE
	jne L1

	BYE:
		mov edx, OFFSET ByeMsg
		call WriteString
		
	L1:

		mov StringCount, eax ; number of char in string input : 5
		mov ecx,StringCount ; to use as loop, ecx become 5
		mov esi,0 ; to indirect accessing.

	
	L2:
		movzx eax, Stringbuff[esi] ; from str[0] move to eax
		push eax ; push into eax
		inc esi
		loop L2 ; until ECX become 0, not bytecount.



;	Input and Store Word

	mov edx, OFFSET inputKey
	call WriteString

	mov edx, OFFSET KeyBuff
	mov ecx, SIZEOF KeyBuff

	call ReadString		
	; Inputting word
	
	mov KeyCount, eax
	mov ecx, KeyCount
	mov esi, 0

	L3:		
		movzx eax, KeyBuff[esi]
		push eax
		inc esi
		loop L3

;	Inputting and Storing Key.
	

;	Printing Original Text		

	mov edx, OFFSET origMsg
	call WriteString

	mov edx, OFFSET StringBuff
	call WriteString
	call Crlf
;		




;	START XORing, Encrypting text.

	mov ecx, StringCount
	mov esi, OFFSET StringBuff
	mov edi, OFFSET KeyBuff
	mov EdiCount, edi


	L6:

		mov ah, BYTE PTR [esi]
		mov bh, BYTE PTR [edi]
		XOR ah, bh 
		cmp ah, 0
		je Null:
		Null:
			mov BYTE PTR[esi], 32
		mov BYTE PTR [esi], ah
		;	store StringBuff XORed values.

		mov edx, EdiCount
		add edx, KeyCount
		sub edx, 1

		cmp edi, edx
		je Init
	;		If in end address, stop inc and initializae edi.

	;		Else, just inc esi and edi.
		jne Go

		Init:		;	Init edi
			mov edi, EdiCount
			sub edi, 1
			jmp Go

		Go:
			inc esi
			inc edi

		loop L6


	; need to init edi, if edi become limit.
	; limit -> edi = EdiCount + KeyCount - 1
	
	mov edx, OFFSET EncMsg
	call WriteString
	
	mov edx, OFFSET StringBuff
	call WriteString
	call Crlf







;	START XORing, Decrypting text.

	mov ecx, StringCount
	mov esi, OFFSET StringBuff
	mov edi, OFFSET KeyBuff
	mov EdiCount, edi


	L7:

		mov ah, BYTE PTR [esi]
		mov bh, BYTE PTR [edi]
		XOR ah, bh 
		mov BYTE PTR [esi], ah
		;	store StringBuff XORed values.

		mov edx, EdiCount
		add edx, KeyCount
		sub edx, 1

		cmp edi, edx
		je Init2
	;		If in end address, stop inc and initializae edi.

	;		Else, just inc esi and edi.
		jne Go2

		Init2:		;	Init edi
			mov edi, EdiCount
			sub edi, 1
			jmp Go2

		Go2:
			inc esi
			inc edi

		loop L7


	mov edx, OFFSET DecMsg
	call WriteString
	
	mov edx, OFFSET StringBuff
	call WriteString
	call Crlf



	jmp L0

main ENDP
END main

