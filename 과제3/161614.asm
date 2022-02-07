INCLUDE irvine32.inc

.data
INCLUDE hw3.inc

ex1 DWORD 0A0E82095h 
;	32 bit, 10100000 / 11101000 / 00100000 / 10010101
;			 A0/E8/20/95

CODE_A BYTE 1
CODE_B BYTE 01
CODE_C BYTE 000
CODE_D BYTE 0011
CODE_E BYTE 0010
BUFF BYTE 32 DUP(0)
DATAS DWORD 5 DUP(0)

.code

main PROC

	mov esi, 0

	mov edx, CODE01
	mov [DATAS], edx

	mov edx, CODE02
	mov [DATAS+4], edx

	mov edx, CODE03
	mov [DATAS+8], edx

	mov edx, CODE04
	mov [DATAS+12], edx

	mov edx, CODE05
	mov [DATAS+16], edx


							;	mov eax, CODE01

	L0:
	
	mov eax, [DATAS+esi]
	mov ebx, 0	; for codeCount
	mov edi, 0	; of buff index

	; need to init the BUFF
	; init BUFF with edi, and let's make edi to 0 again.
	
	mov ecx, 32
	Linit:
		mov [Buff+edi],0
		add edi, 1
		loop Linit




	mov edi, 0

	Lcompare:

	; let's get 1 bit, to see if it's '1'

	rol eax, 1
	jc codeA		; if '1', goto codeA

	; let's get 2 bit, to see if its 01
	ror eax, 1	; else, restore 
	rol eax, 2		; rotate left 2, and two biggest bit become smallest two bit
	
	mov edx, eax
	and edx, 3	; 11b, to find two rightmost bit
	cmp edx, 1	; if '01'
	je codeB

	; let's get 3 bit, to see if its 000		
	ror eax, 2	; to restore done before
	rol eax, 3		; rotate left three, and three big -> smallest two bit
	mov edx, eax
	and edx, 7	; 111b, to find three rightmost bit
	cmp edx, 0	; if '000'
	je codeC

	; let's get 4 bit, to see if it's 0011
	ror eax, 3	; to restore done before
	rol eax, 4		; rotate 4
	mov edx, eax
	and edx, 15	; 1111b, to find four rightmost bit
	cmp edx, 3	; if '0011'
	je codeD

	;lets get 4 bit, to see if it's 0010
	ror eax, 4	; to restore done before
	rol eax, 4		; rot 4
	mov edx, eax
	and edx, 15	; 1111b
	cmp edx, 2	; if '0010'
	je codeE

	codeA:
		ror eax, 1	; rotate again, restore
		shl eax, 1	; shift left by 1.
		mov BUFF[edi], 'A'		; move 'A' to buff[edi]
		inc edi
		add ebx, 1	; we checked one bit
		cmp ebx, 32
		jne Lcompare		; go back if count!=32
		je DONE

	codeB:
		ror eax, 2	; rotate again, restore
		shl eax, 2	; shift left by 2.
		mov BUFF[edi],'B'	; move 'B' to buff[edi]
		inc edi
		add ebx, 2	; we checked two bit
		cmp ebx, 32
		jne Lcompare		; go back if count!=32 -> we haven't saw total 32 bit.
		je DONE

	codeC:
		ror eax, 3	; rotate again, restore
		shl eax, 3	; shift left by 3
		mov BUFF[edi],'C'	; move 'C' to buff[edi]
		inc edi
		add ebx, 3	; we checked three bit
		cmp ebx, 32
		jne Lcompare
		je DONE

	codeD:
		ror eax, 4	; restore
		shl eax, 4	; shift left by 4
		mov BUFF[edi],'D'	; move 'D' to buff[edi]
		inc edi
		add ebx, 4	; checked 4
		cmp ebx,32
		jne Lcompare
		je DONE

	codeE:
		ror eax,4		; restore
		shl eax,4		; shift left by 4
		mov BUFF[edi],'E'	; move 'E' to buff[edi]
		inc edi
		add ebx, 4	; checked 4 bit
		cmp ebx,32
		jne Lcompare
		je DONE

	DONE:
		mov edx, OFFSET BUFF
		call WriteString
		call Crlf

		; need to init, buff
		
		
		add esi, 4
		cmp esi, 20
		je REALDONE
		jne L0

	REALDONE:
		
main ENDP
END main
