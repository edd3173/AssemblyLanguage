TITLE TEST code : My first Assembly Assignment.

INCLUDE irvine32.inc

.data

StringBuff BYTE 40 DUP(0)
WordBuff BYTE 40 DUP(0)

StringCount DWORD ?
WordCount DWORD ?

inputString BYTE "Type_A_String : ",0
inputWord BYTE "A_Word_For_Search : ",0

msgTrue BYTE "Found",0
msgFalse BYTE "Not_Found",0
byeMsg BYTE "Bye!", 0

Count DWORD 0
tmpESI DWORD 0
tmpEDI DWORD 0

FrontFlag DWORD 0
BackFlag DWORD 0

.code
main PROC

	L0:		; main Loop, do until not bye.

		mov Count, 0
		mov tmpESI, 0
		mov tmpEDI, 0
		mov FrontFlag, 0
		mov BackFlag, 0

		; INPUTTING STRING

	mov edx, OFFSET inputString
	call WriteString
	
	mov edx, OFFSET StringBuff
	mov ecx, SIZEOF StringBuff

	call ReadString

	cmp eax, 41
	jae L0		; over 41, do again. 

	cmp eax, 0
	je BYE		; no input, say bye.
	jae L1		; otherwise, input string.


	BYE:
		mov edx, OFFSET byeMsg
		call WriteString
		; END OF PROCESS

;	L1, L2 -> Input and Storing String	

	L1:			
		mov StringCount, eax
		mov ecx, StringCount
		mov esi, 0
	; Input

	L2:		
		movzx eax, StringBuff[esi]
		push eax
		inc esi
		loop L2
	; Store


;	Input and Store Word

	mov edx, OFFSET inputWord
	call WriteString

	mov edx, OFFSET WordBuff
	mov ecx, SIZEOF WordBuff

	call ReadString		
	; Inputting word
	
	mov WordCount, eax
	mov ecx, WordCount
	mov esi, 0

	L3:		;	storing word
		movzx eax, WordBuff[esi]
		push eax
		inc esi
		loop L3
	; Storing word.


; COMPARE STRING LEN, WORD LEN 
	mov ecx, StringCount
	cmp ecx, WordCount
	jb L0
	; JMP to L0 if WORD LONGER THAN STRING



; COMPARISON STARTS


	mov esi, OFFSET StringBuff
	mov edi, OFFSET WordBuff

	mov tmpESI, esi
	mov tmpEDI, edi

	L4:		;	main loop compare.

	mov ah, BYTE PTR [esi]	; string data.
	mov bh, BYTE PTR [edi]	; word data.

	cmp ah,bh
	je SAME
	jNE NOTSAME

	
	SAME:
		
		;	check front is null or space (Front Flag)

		sub esi, 1		;	front esi
		mov dh, BYTE PTR [esi]
		inc esi		;	recover

		cmp dh, 0
		je CheckFrontFlag

		cmp dh, 32
		je CheckFrontFlag

		;	if null or space, FrontFlag ON

		FrontFlagDone:

		add Count, 1	; found same char, so inc Count
		inc esi		; inc string pointer.
		inc edi	; inc word pointer
		mov ecx, Count
		mov edx, WordCount

		cmp ecx, edx ; til now, how many char equal?
		je CHECKFLAG		; we found char number of WordCount -> success.
		jne L4		; compare again.



	NOTSAME:

		mov edx, StringCount
		add edx, tmpESI
		sub edx, 1
		cmp esi, edx		; compare string index with, 
		; edx=tmpESI (start) + Strlen(string) - 1 -> end index of string.
		; did we searched whole string?
		
		jae FAIL
		; if we did, we failed.

		; else compare next.
		mov Count,0		; Count initialization.
		mov BackFlag, 0	;	backflag init
		mov FrontFlag, 0	;	frontflag init
		inc esi		; inc string pointer 
		mov edi, tmpEDI	; restore edi.
		jmp L4	; compare again.
	

	
	CHECKFLAG:
		
		; Check BackFlag.

		mov dh, BYTE PTR [esi]	;	already increased in SAME
		sub esi, 1
		cmp dh, 0
		je CheckBackFlag

		cmp dh, 32
		je CheckBackFlag

		; If FrontFlag and BackFlag is ON, success
		; when we CheckFlag, we must decrease esi because L5 make another in esi
		
		
		BackFlagDone:
			mov edx, FrontFlag
			add edx, BackFlag

			cmp edx, 2
			jne NOTSAME
			je SUCCESS

		;	if flag is not, compare next.
		;	if two flag is on, go SUCCESS.

	SUCCESS:
		mov edx, OFFSET msgTrue
		call WriteString
		call Crlf
		jmp L0
		; Print TRUE, and Goto Start

	FAIL:
		mov edx, OFFSET msgFalse
		call WriteString
		call Crlf
		jmp L0
		; Print Flase, and Goto Start

	CheckFrontFlag:
		add FrontFlag, 1
		jmp FrontFlagDone

	CheckBackFlag:
		add BackFlag, 1
		jmp BackFlagDone

main ENDP
END main