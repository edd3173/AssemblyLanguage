INCLUDE irvine32.inc


.data
buff BYTE 40 DUP(0)
byteCount DWORD ?
inputMsg BYTE "Type A String To Reverse : ",0
outputMsg BYTE "Reversed String : ",0
byeMsg BYTE "Bye!", 0

.code

main PROC

	L0:

	mov edx, OFFSET inputMsg
	call WriteString

	mov edx, OFFSET buff
	mov ecx, SIZEOF buff
	
	call ReadString 
	; readstring, pass offset of buff in edx, set ecx to max of number user can enter
	; return count of number in eax

	; call DumpRegs

	cmp eax, 41
	jae L0		; over 40, go L0.

	cmp eax, 0
	je BYE
	jae L3

	BYE:
		mov edx, OFFSET byeMsg
		call WriteString
		
	L3:

		call Init
	;	mov byteCount, eax ; number of char in string input : 5
	;	mov ecx,byteCount ; to use as loop, ecx become 5
	;	mov esi,0 ; to indirect accessing.

	
	L1:
		movzx eax, buff[esi] ; from str[0] move to eax
		push eax ; push into eax
		inc esi
		loop L1 ; until ECX become 0, not bytecount.

	mov ecx, byteCount ; ecx equals 5. ??? because ecx has bytecount of 5
	mov esi, 0 ; esi initial

	L2:
		pop eax ; pop from stack eax
		mov buff[esi], al

		cmp buff[esi],32
		je SPACE

		cmp buff[esi],46
		je COMMA

		cmp buff[esi],'a'
		jb UPPER
		jae LOWER
	
	COMMA:
		jmp DONE

	SPACE:
		jmp DONE

	UPPER:
		add buff[esi],32
		jmp DONE

	LOWER:
		sub buff[esi],32
		jmp DONE

	DONE:
		call IncEsi
		loop L2 

	mov eax, OFFSET buff
	mov edx, OFFSET outputMsg
	call WriteString

	mov edx, eax
	call WriteString

	call Crlf
	jmp L0

main ENDP

IncEsi PROC
	inc esi
	ret
IncEsi ENDP

Init PROC
	mov byteCount, eax
	mov ecx, byteCount
	mov esi,0
	ret
Init ENDP
	

END main

