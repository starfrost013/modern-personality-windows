; ****** modern:personality project ******
; Reverse engineered code  © 2022-2025 starfrost. See licensing information in the licensing file
; Original code            © 1982-1986 Microsoft Corporation

; KERNSTUB.ASM:
; An app prepended to the Kernel during compilation
; It verifies that the kernel is legitimate and that it has a valid New Executable header before booting it.
		
; This is the Windows entry point.
; It's the MZ component of the multi-mode executable.
; The sole purpose is to validate and load KERNEL. 
; Specifically, it validates the NE header, does paragraph alignment 
; and then loads the first code segment (which in KERNEL is the entry point) and jumps to it.

; This is a tiny model program. CS=DS

;.model compact ; ????
SWAPPRO = 0

; for cmacros
WIN=1 
?DF=1 ; Prevent implicit creation of segments


INCLUDE cmacros.inc
INCLUDE NEWEXE.inc

; Disassembled binary has a _TEXT section
createSeg   STACK,STACK,PARA,STACK,STACK
createSeg   _TEXT,CODE,PARA,PUBLIC,CODE 


sBegin STACK
	DB 128 DUP (?)
sEnd STACK


; /libw/inc
;include newexe.inc
; Segment type: Pure code

sBegin  CODE
assumes CS,CODE
assumes DS,CODE

start PROC FAR
	push    cs
	pop     ds
	mov     si, 180h
	; the MP kernstub is larger than the retail microsoft one. so we just do this.
	;add     si, 1FFh 
	;and     si, 0FE00h ; 0x200 - location of NE header in binary
	cmp     word ptr [si], 454Eh ; check for NE header magic
	jnz     short call_boot_failure ; jump to fail code if it is not 0x4E45 ("NE")
	mov     ax, ds
	cli		; Disable interrupts
	mov     ss, ax
	assume ss:STACK ; si -> pointer to NE header
	mov     sp, si
	sti		; Enable interrupts
	mov     bx, [si].ne_autodata ; segment # of automatic data segment
	dec     bx
	jl      short load_segment
	shl     bx, 1
	shl     bx, 1
	shl     bx, 1
	add     bx, [si].ne_segtab ;  NE relative offset to segment table
	mov     ax, [bx+si]
	cmp     word ptr [si].ne_align, 0
	jnz     short shift_alignment
	mov     word ptr [si].ne_align, NSALIGN ; see newexe.inc, this is the default alignment shifting - 0x09

; shifts the segments to be on x86 paragraph boundaries
; this is only called if the executable header specifically specifies extra alignment count is requried
shift_alignment: 
	mov     cx, [si].ne_align
	sub     cx, 4 ; convert to paragraph boundaries (instead of 64-byte "sectors")
	shl     ax, cl
	mov     di, cs
	sub     di, 20h 
	add     di, ax

load_segment:
	mov     bx, word ptr [si].ne_csip+2 ; number of code segments 
	dec     bx ; decrement bx 
	jl      short call_boot_failure ; fail to boot if there are no code segments
	; we are now booting
	; load the initial code segment, perform default alignment from the segment table so we can far return to the kernel entrypoint
	shl     bx, 1
	shl     bx, 1
	shl     bx, 1
	add     bx, [si].ne_segtab ; get the address of the NE segment table (get the first code segment)
	mov     ax, [bx+si] ; find the segment table
	mov     cx, [si].ne_align ; alignment shift count (so that segments can be aligned on a paragraph boundary)
	sub     cx, 4 ; segment table address is in paragraphs (16-bytes)
	shl     ax, cl
	mov     dx, cs
	sub     dx, 28h ; 20h for larger MP kernstub, 8h 
	add     dx, ax
	push    dx
	push    word ptr [si].ne_csip ; initial CSIP value from our first code segment
	mov     ds, di
	mov     cx, si
	add     cx, 200h ; NE header location added to initial CS value (so that we don't execute the header)
	jmp     short boot

; DEBUG message so that we can see if we booted properly.
boot:
	;push cs
	;pop ds
	;mov dx, word ptr lol_msg
	;mov ah, 9
	;int 21h
	
	; this is RETF because this is a far proc
	ret ; return to the code segment we just set up, which is the kernel entry point we determined from the NE header. Therefore we will now boot windows.

call_boot_failure:
call	boot_failure
; Attributes: noreturn

; Run on invalid NE header present during boot (no code segments or no NE magic). 
; Prints message using DOS API and exits.

; error message
boot_failure_msg	db 'KERNSTUB: Error during boot',13,10,'$'

; funny message
lol_msg				db 'KERNSTUB: ModernPersonality trying to boot (c)2025 starfrost',13,10,'$'

boot_failure:
	pop     dx
	push    cs
	pop     ds
	mov     ah, 9
	int     21h             ; DOS - PRINT STRING
                        ; DS:DX -> string terminated by "$"
	mov     ax, 4C01h		; exit code is 1
	int     21h             ; DOS - 2+ - QUIT WITH EXIT CODE (EXIT)

	db 4Ch, 0
start ENDP
sEnd    CODE

END start
; THIS LINE IS REQUIRED DUE TO MASM 4.0 BEING A COMPLETELY STUPID COMPILER THAT IS TWICE MY AGE