INCLUDE Irvine32.inc

.data
CaseTable	BYTE		'1'		; lookup value
		DWORD	Process_AND	; address of procedure
EntrySize = ($ - CaseTable)
		BYTE		'2'
		DWORD	Process_OR
		BYTE		'3'
		DWORD Process_NOT
		BYTE		'4'
		DWORD	Process_XOR
		BYTE		'5'
		DWORD Process_END

EntryNumber=($-CaseTable)/EntrySize

startMsg BYTE " ",0Dh,0Ah
		BYTE	"1. x AND y",0Dh,0Ah
		BYTE	"2. x OR y",0Dh,0Ah
		BYTE	"3. NOT x",0Dh,0Ah
		BYTE	"4. x XOR y",0Dh,0Ah
		BYTE "5. Exit program",0

modeMsg BYTE "Choose Calculation Mode : ",0
modeChg BYTE "Do you want to change the mode (Y/N)? : ",0 

xMsg BYTE "Enter x : ",0
yMsg BYTE "Enter y : ",0
xData DWORD ?
yData DWORD ?

resultAND BYTE "Result of x AND y : ",0
resultOR BYTE "Result of x OR y : ",0
resultXOR BYTE "Result of x XOR y : ", 0
resultNOT BYTE "Result of NOT x : ",0

modeNumber BYTE 0
modeDecide BYTE 0


.code


main PROC
L0:
	mov edx, OFFSET startMsg
	call WriteString
	call Crlf
L1:
	call Crlf
	mov edx, OFFSET modeMsg
	call WriteString
	call ReadChar	;	choose action
	call WriteChar
	call DumpRegs
	call Crlf
	cmp al, '5'			;	
	ja L1		;	If al is bigger, 

mov ebx, OFFSET CaseTable
mov ecx, EntryNumber



FindCase:
	cmp al, [ebx]
	jne Continue
	L2:
	call NEAR PTR [ebx+1]
	call Crlf
	jmp done

Continue:
	add ebx, EntrySize
	loop FindCase

done:
	mov edx, OFFSET modeChg
	call WriteString
	call ReadChar
	call WriteChar
	call Crlf
	cmp al, 'Y'
	je L0
	cmp al, 'N'
	je L2


main ENDP

;	***** AND PROCESS *****		;

Process_AND PROC
	
	call GetX
	call GetY

	mov edx, OFFSET resultAND
	call WriteString

	mov eax, xData
	and eax, yData
	call WriteHex
	call Crlf
	ret
Process_AND ENDP


;	***** OR PROCESS	 ***** ;

Process_OR PROC
	
	call GetX
	call GetY

	mov edx, OFFSET resultOR
	call WriteString

	mov eax, xData
	or eax, yData
	call WriteHex
	call Crlf
	ret
Process_OR ENDP

;	***** XOR PROCESS *****;

Process_XOR PROC
	
	call GetX
	call GetY

	mov edx, OFFSET resultXOR
	call WriteString

	mov eax, xData
	xor eax, yData
	call WriteHex
	call Crlf
	ret
Process_XOR ENDP


;	***** NOT PROCESS *****		;

Process_NOT PROC
	
	call GetX

	mov edx, OFFSET resultNOT
	call WriteString

	mov eax, xData
	not eax
	call WriteHex
	call Crlf
	ret
Process_NOT ENDP

;	***** END PROCESS ******

Process_END PROC
	exit
	ret
Process_END ENDP

;	***** GetX PROCESS *****		;
GetX PROC
	;call Crlf
	mov edx, OFFSET xMsg
	call WriteString
	call ReadHex
	mov xData, eax
	ret
GetX ENDP

;	 **** GetY PROCESS *****
GetY PROC
	;call Crlf
	mov edx, OFFSET yMsg
	call WriteString
	call ReadHex
	mov yData, eax
	ret
GetY ENDP

END main

