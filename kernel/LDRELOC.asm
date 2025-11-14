; ****** modern:personality project ******
; Reverse engineered code  © 2022-2025 starfrost. See licensing information in the licensing file
; Original code            © 1982-1986 Microsoft Corporation

; LDRELOC.ASM:
; When the memory manager needs to relocate a segment, references in that segment to other segments within the application must be manually fixed up
; (or it would crash immediately due to jumping to garbage)
; This file provides routines to achieve that, and has some debug code to crash Windows with FATALEXIT code 409h if it fails to checksum a segment properly.

; =============== S U B R O U T I N E =======================================
INCLUDE KERNEL.inc
INCLUDE KDATA.inc

externNP MYALLOC
externNP MYFREE
externNP MYLOCK
externNP GLOBALALLOC
externNP GLOBALREALLOC
externNP GLOBALCOMPACT
externNP GLOBALFREE
externNP GLOBALFREEALL
externNP GETEXEPTR
externNP LOCKSEGMENT
externNP GETSTRINGPTR
externNP DECEXEUSAGE
externNP CALCMAXNRSEG
externNP ENTPROCADDRESS
externNP FINDORDINAL
externNP LOADSEGMENT
externNP CHECKSEGCHKSUM
externNP OPENFILE


if KDEBUG
    externNP DEBUGDEFINESEGMENT
endif

sBegin CODE

assumeS CS,CODE
assumeS DS,CODE

GETCHKSUMADDR   proc near               ; CODE XREF: CHECKSEGCHKSUM+1↓p
                                        ; PATCHPROLOG+2C↓p
                push    dx
                xor     bx, bx
                dec     ax
                mov     es, ax
                xor     cx, cx
                mov     ax, es:[bx+0Ah]
                or      ax, ax
                jz      short loc_DC6
                test    byte ptr es:[bx+5], 8
                jz      short loc_DC6
                mov     dx, es:[bx+3]
                mov     es, word ptr es:[bx+1]
                cmp     word ptr es:[bx], 454Eh
                jnz     short loc_DC6
                mov     cx, es:[bx+1Ch]
                jcxz    short loc_DC6
                mov     bx, es:[bx+22h]

loc_DA4:                                ; CODE XREF: GETCHKSUMADDR+39↓j
                cmp     es:[bx+8], ax
                jz      short loc_DB1
                add     bx, 0Ah
                loop    loc_DA4
                jmp     short loc_DC6
; ---------------------------------------------------------------------------

loc_DB1:                                ; CODE XREF: GETCHKSUMADDR+34↑j
                sub     cx, es:1Ch
                neg     cx
                mov     bx, es:3Ah
                shl     cx, 1
                inc     cx
                shl     cx, 1
                add     bx, cx
                mov     cx, dx

loc_DC6:                                ; CODE XREF: GETCHKSUMADDR+E↑j
                                        ; GETCHKSUMADDR+15↑j ...
                pop     dx
                ret
GETCHKSUMADDR   endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

ALLOCSEG        proc near               ; CODE XREF: ALLOCALLSEGS+2A↓p
                                        ; ALLOCALLSEGS+7E↓p ...

arg_0           = dword ptr  4

                push    bp
                mov     bp, sp
                push    si
                les     si, [bp+arg_0]
                mov     bx, es:[si+4]
                mov     ax, es:[si+6]
                cmp     si, es:8
                jnz     short loc_E5D
                cmp     cs:FBOOTING, 0
                jnz     short loc_E4A
                test    word ptr es:0Ch, 80h
                jz      short loc_E4A
                or      bl, 10h

loc_E4A:                                ; CODE XREF: ALLOCSEG+1C↑j
                                        ; ALLOCSEG+25↑j
                add     ax, es:12h
                jb      short loc_E58
                add     ax, es:10h
                jnb     short loc_E5D

loc_E58:                                ; CODE XREF: ALLOCSEG+2F↑j
                xor     ax, ax
                jmp     short loc_EA4
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_E5D:                                ; CODE XREF: ALLOCSEG+14↑j
                                        ; ALLOCSEG+36↑j
                test    bl, 2
                jnz     short loc_E9E
                xor     cx, cx
                push    es
                push    bx
                push    ax
                push    cx
                call    MYALLOC
                pop     es
                or      ax, ax
                jz      short loc_EA4
                mov     es:[si+8], dx
                and     byte ptr es:[si+4], 0FBh
                or      byte ptr es:[si+4], 2
                mov     cx, es
                dec     ax
                mov     es, ax
                mov     es:1, cx
                mov     es, cx
                inc     ax
                cmp     ax, dx
                jz      short loc_E9E
                test    byte ptr es:[si+4], 10h
                jnz     short loc_E9E
                push    es
                push    ax
                nop
                push    cs
                call    near ptr LOCKSEGMENT
                pop     es

loc_E9E:                                ; CODE XREF: ALLOCSEG+40↑j
                                        ; ALLOCSEG+6D↑j ...
                mov     ax, es:[si+8]
                or      ax, ax

loc_EA4:                                ; CODE XREF: ALLOCSEG+3A↑j
                                        ; ALLOCSEG+4E↑j
                pop     si
                mov     sp, bp
                pop     bp
                ret     4
ALLOCSEG        endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

ALLOCALLSEGS    proc near               ; CODE XREF: LOADMODULE+294↑p
                                        ; LOADMODULE+3B3↑p ...

var_2           = word ptr -2
arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                sub     sp, 2
                push    si
                push    di
                mov     es, [bp+arg_0]
                mov     si, es:22h
                xor     di, di
                mov     [bp+var_2], di
                inc     di
                cmp     word ptr es:2, 1
                jz      short loc_EE1
                mov     si, es:8
                and     byte ptr es:[si+4], 0F9h
                push    es
                push    si
                call    ALLOCSEG
                or      ax, ax
                jz      short loc_F39
                inc     [bp+var_2]
                jmp     short loc_F60
; ---------------------------------------------------------------------------

loc_EE1:                                ; CODE XREF: ALLOCALLSEGS+1C↑j
                                        ; ALLOCALLSEGS+8C↓j
                cmp     di, es:1Ch
                ja      short loc_F60
                mov     bx, es:[si+4]
                test    bl, 40h
                jnz     short loc_F27
                test    bl, 2
                jnz     short loc_F33
                test    bl, 10h
                jz      short loc_F33
                xor     cx, cx
                push    es
                push    bx
                push    cx
                push    cx
                call    MYALLOC
                pop     es
                or      dx, dx
                jz      short loc_F39
                mov     es:[si+8], dx
                and     byte ptr es:[si+4], 0FBh
                or      byte ptr es:[si+4], 2
                mov     ax, es
                mov     es, cs:PGLOBALHEAP
                mov     bx, dx
                mov     es:[bx], ax
                mov     es, ax
                jmp     short loc_F33
; ---------------------------------------------------------------------------

loc_F27:                                ; CODE XREF: ALLOCALLSEGS+44↑j
                push    es
                push    si
                call    ALLOCSEG
                or      ax, ax
                jz      short loc_F39
                inc     [bp+var_2]

loc_F33:                                ; CODE XREF: ALLOCALLSEGS+49↑j
                                        ; ALLOCALLSEGS+4E↑j ...
                add     si, 0Ah
                inc     di
                jmp     short loc_EE1
; ---------------------------------------------------------------------------

loc_F39:                                ; CODE XREF: ALLOCALLSEGS+2F↑j
                                        ; ALLOCALLSEGS+5C↑j ...
                xor     ax, ax
                mov     [bp+var_2], ax
                dec     di
                jz      short loc_F68
                sub     si, 0Ah
                test    byte ptr es:[si+4], 2
                jz      short loc_F39
                mov     ax, es:[si+8]
                push    es
                push    ax
                call    MYFREE
                pop     es
                mov     es:[si+8], ax
                xor     byte ptr es:[si+4], 2
                jmp     short loc_F39
; ---------------------------------------------------------------------------

loc_F60:                                ; CODE XREF: ALLOCALLSEGS+34↑j
                                        ; ALLOCALLSEGS+3B↑j
                mov     ax, [bp+var_2]
                or      ax, ax
                jnz     short loc_F68
                dec     ax

loc_F68:                                ; CODE XREF: ALLOCALLSEGS+94↑j
                                        ; ALLOCALLSEGS+BA↑j
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                ret     2
ALLOCALLSEGS    endp

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                PUBLIC DELMODULE
DELMODULE       proc near               ; CODE XREF: LOADMODULE+358↑p
                                        ; DECEXEUSAGE+46↑p ...

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                mov     es, [bp+arg_0]
                mov     dx, es:6
                mov     ax, cs:HEXEHEAD
                cmp     [bp+arg_0], ax
                jnz     short loc_144A
                mov     cs:HEXEHEAD, dx
                jmp     short loc_145E
; ---------------------------------------------------------------------------

loc_144A:                               ; CODE XREF: DELMODULE+12↑j
                                        ; DELMODULE+28↓j
                or      ax, ax
                jz      short loc_145E
                mov     es, ax
                mov     ax, es:6
                cmp     [bp+arg_0], ax
                jnz     short loc_144A
                mov     es:6, dx

loc_145E:                               ; CODE XREF: DELMODULE+19↑j
                                        ; DELMODULE+1D↑j
                mov     es, [bp+arg_0]
                mov     word ptr es:0, 0
                push    es
                nop
                push    cs
                call    near ptr GLOBALFREEALL
                call    CALCMAXNRSEG
                mov     sp, bp
                pop     bp
                ret     2
DELMODULE       endp
; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                PUBLIC SEGRELOC
SEGRELOC        proc near               ; CODE XREF: LOADSEGMENT+13B↑p
                                        ; LOADFIXEDSEG+B7↓p

var_10          = byte ptr -10h
var_8           = word ptr -8
var_6           = word ptr -6
var_4           = word ptr -4
var_2           = word ptr -2
arg_0           = word ptr  4
arg_2           = word ptr  6
arg_4           = word ptr  8
arg_6           = word ptr  0Ah
arg_8           = word ptr  0Ch
arg_A           = word ptr  0Eh
arg_C           = word ptr  10h
arg_E           = word ptr  12h

                push    bp
                mov     bp, sp
                sub     sp, 10h
                push    si
                push    di
                mov     si, [bp+arg_8]
                mov     cx, [bp+arg_A]
                or      cx, [bp+arg_C]
                jnz     short loc_1556
                xor     dx, dx
                xor     cx, cx
                mov     bx, [bp+arg_0]
                mov     ax, 4201h
                int     21h             ; DOS - 2+ - MOVE FILE READ/WRITE POINTER (LSEEK)
                                        ; AL = method: offset from present location
                jb      short loc_1589
                mov     [bp+var_6], dx
                mov     [bp+var_8], ax

loc_1556:                               ; CODE XREF: SEGRELOC+11↑j
                                        ; SEGRELOC+172↓j
                mov     ax, [bp+arg_A]
                or      ax, ax
                jnz     short loc_1599
                mov     ax, [bp+arg_C]
                or      ax, ax
                jnz     short loc_1595
                mov     cx, [bp+var_6]
                mov     dx, [bp+var_8]
                mov     bx, [bp+arg_0]
                mov     ax, 4200h
                int     21h             ; DOS - 2+ - MOVE FILE READ/WRITE POINTER (LSEEK)
                                        ; AL = method: offset from beginning of file
                jb      short loc_1589
                push    ds
                push    ss
                pop     ds
                lea     dx, [bp+var_10]
                mov     cx, 8
                add     [bp+var_8], cx
                adc     [bp+var_6], 0
                mov     ah, 3Fh ; '?'
                int     21h             ; DOS - 2+ - READ FROM FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to read
                                        ; DS:DX -> buffer
                pop     ds

loc_1589:                               ; CODE XREF: SEGRELOC+1F↑j
                                        ; SEGRELOC+43↑j
                jb      short loc_1600
                cmp     ax, cx
                jnz     short loc_1600
                push    ss
                pop     ax
                mov     si, dx
                jmp     short loc_1599
; ---------------------------------------------------------------------------

loc_1595:                               ; CODE XREF: SEGRELOC+33↑j
                push    ax
                call    MYLOCK

loc_1599:                               ; CODE XREF: SEGRELOC+2C↑j
                                        ; SEGRELOC+64↑j
                mov     es, ax
                mov     di, es:[si+2]
                mov     ax, es:[si+6]
                xor     cx, cx
                mov     [bp+var_4], cx
                mov     cl, 3
                and     cl, es:[si+1]
                jcxz    short loc_1606
                mov     bx, es:[si+4]
                sub     bx, 1
                jb      short loc_1600
                shl     bx, 1
                push    es
                mov     es, [bp+arg_E]
                add     bx, es:28h
                mov     bx, es:[bx]
                pop     es
                mov     [bp+var_2], bx
                loop    loc_15CF
                jmp     short loc_15E8
; ---------------------------------------------------------------------------

loc_15CF:                               ; CODE XREF: SEGRELOC+9C↑j
                push    [bp+arg_E]
                push    [bp+arg_0]
                push    ax
                call    GETSTRINGPTR
                push    [bp+var_2]
                push    dx
                push    ax
                call    FINDORDINAL
                mov     bx, [bp+var_2]
                or      ax, ax
                jz      short loc_15FD

loc_15E8:                               ; CODE XREF: SEGRELOC+9E↑j
                                        ; SEGRELOC+E3↓j
                push    bx
                push    ax
                call    ENTPROCADDRESS
                mov     es, dx
                cmp     word ptr es:0, 454Eh
                jnz     short loc_1656
                inc     [bp+var_4]
                jmp     short loc_1656
; ---------------------------------------------------------------------------

loc_15FD:                               ; CODE XREF: SEGRELOC+B7↑j
                jmp     loc_1744
; ---------------------------------------------------------------------------

loc_1600:                               ; CODE XREF: SEGRELOC:loc_1589↑j
                                        ; SEGRELOC+5E↑j ...
                jmp     loc_170B
; ---------------------------------------------------------------------------
                jmp     loc_177C
; ---------------------------------------------------------------------------

loc_1606:                               ; CODE XREF: SEGRELOC+7F↑j
                mov     cl, es:[si+4]
                jcxz    short loc_1600
                mov     bx, [bp+arg_E]
                cmp     cl, 0FFh
                jz      short loc_15E8
                mov     es, bx
                mov     bx, cx
                dec     bx
                cmp     es:1Ch, bx
                jbe     short loc_1600
                push    ax
                shl     bx, 1
                mov     ax, bx
                shl     bx, 1
                shl     bx, 1
                add     bx, ax
                add     bx, es:22h
                test    byte ptr es:[bx+4], 40h
                jz      short loc_1646
                push    es
                push    bx
                call    ALLOCSEG
                test    al, 1
                jnz     short loc_1651
                push    ax
                call    MYLOCK
                jmp     short loc_1651
; ---------------------------------------------------------------------------

loc_1646:                               ; CODE XREF: SEGRELOC+106↑j
                push    es
                push    cx
                push    [bp+arg_0]
                push    [bp+arg_0]
                call    LOADSEGMENT

loc_1651:                               ; CODE XREF: SEGRELOC+10F↑j
                                        ; SEGRELOC+115↑j
                mov     dx, ax
                pop     ax
                jcxz    short loc_1600

loc_1656:                               ; CODE XREF: SEGRELOC+C7↑j
                                        ; SEGRELOC+CC↑j
                push    ax
                push    dx
                mov     ax, [bp+arg_A]
                or      ax, ax
                jnz     short loc_166A
                mov     ax, ss
                mov     cx, [bp+arg_C]
                jcxz    short loc_166A
                push    cx
                call    MYLOCK

loc_166A:                               ; CODE XREF: SEGRELOC+12E↑j
                                        ; SEGRELOC+135↑j
                mov     es, ax
                mov     bl, 7
                and     bl, es:[si]
                xor     cx, cx
                mov     cl, 4
                and     cl, es:[si+1]
                push    bx
                push    cx
                push    [bp+arg_4]
                call    MYLOCK
                mov     es, ax
                pop     cx
                pop     bx
                pop     dx
                pop     ax
                cmp     bl, 2
                jz      short loc_16BA
                cmp     bl, 3
                jz      short loc_16D5
                cmp     bl, 5
                jz      short loc_16A7

loc_1696:                               ; CODE XREF: SEGRELOC+17D↓j
                                        ; SEGRELOC+189↓j ...
                mov     ax, 1
                add     si, 8
                dec     [bp+arg_6]
                jle     short loc_16A4
                jmp     loc_1556
; ---------------------------------------------------------------------------

loc_16A4:                               ; CODE XREF: SEGRELOC+170↑j
                jmp     loc_177C
; ---------------------------------------------------------------------------

loc_16A7:                               ; CODE XREF: SEGRELOC+165↑j
                jcxz    short loc_16AE
                add     es:[di], ax
                jmp     short loc_1696
; ---------------------------------------------------------------------------

loc_16AE:                               ; CODE XREF: SEGRELOC:loc_16A7↑j
                                        ; SEGRELOC+187↓j
                mov     bx, ax
                xchg    bx, es:[di]
                mov     di, bx
                inc     bx
                jnz     short loc_16AE
                jmp     short loc_1696
; ---------------------------------------------------------------------------

loc_16BA:                               ; CODE XREF: SEGRELOC+15B↑j
                mov     bx, [bp+var_4]
                and     bx, [bp+arg_2]
                jnz     short loc_16F0
                jcxz    short loc_16C9
                add     es:[di], dx
                jmp     short loc_1696
; ---------------------------------------------------------------------------

loc_16C9:                               ; CODE XREF: SEGRELOC+193↑j
                                        ; SEGRELOC+1A2↓j
                mov     bx, dx
                xchg    bx, es:[di]
                mov     di, bx
                inc     bx
                jnz     short loc_16C9
                jmp     short loc_1696
; ---------------------------------------------------------------------------

loc_16D5:                               ; CODE XREF: SEGRELOC+160↑j
                jcxz    short loc_16E0
                add     es:[di], ax
                add     es:[di+2], dx
                jmp     short loc_1696
; ---------------------------------------------------------------------------

loc_16E0:                               ; CODE XREF: SEGRELOC:loc_16D5↑j
                                        ; SEGRELOC+1BD↓j
                mov     bx, ax
                xchg    bx, es:[di]
                mov     es:[di+2], dx
                mov     di, bx
                inc     bx
                jnz     short loc_16E0
                jmp     short loc_1696
; ---------------------------------------------------------------------------

loc_16F0:                               ; CODE XREF: SEGRELOC+191↑j
                jcxz    short loc_16FB
                add     es:[di], dx
                add     es:[di-2], ax
                jmp     short loc_1696
; ---------------------------------------------------------------------------

loc_16FB:                               ; CODE XREF: SEGRELOC:loc_16F0↑j
                                        ; SEGRELOC+1D8↓j
                mov     bx, dx
                xchg    bx, es:[di]
                mov     es:[di-2], ax
                mov     di, bx
                inc     bx
                jnz     short loc_16FB
                jmp     short loc_1696
; ---------------------------------------------------------------------------

loc_170B:                               ; CODE XREF: SEGRELOC:loc_1600↑j
                mov     es, [bp+arg_E]
                xor     bx, bx
                mov     ax, 407h
                push    ax
                mov     ax, offset SZINVALIDRELOCRECORD ; "Invalid relocation record in "
                push    cs
                push    ax
                push    es
                push    bx
                call    KERNELERROR
                jmp     short loc_173F
; ---------------------------------------------------------------------------
SZINVALIDRELOCRECORD db 'Invalid relocation record in ',0
                                        ; DATA XREF: SEGRELOC+1E5↑o
                db 24h
; ---------------------------------------------------------------------------

loc_173F:                               ; CODE XREF: SEGRELOC+1EF↑j
                xor     ax, ax

loc_1741:
                jmp     short loc_177C
; ---------------------------------------------------------------------------
                ;align 2

loc_1744:                               ; CODE XREF: SEGRELOC:loc_15FD↑j
                mov     es, [bp+arg_E]
                xor     bx, bx
                mov     ax, 404h
                push    ax
                mov     ax, offset SZINVALIDENTRYPOINT ; "Invalid entry point name in "
                push    cs
                push    ax
                push    es
                push    bx
                call    KERNELERROR
                jmp     short loc_1777
; ---------------------------------------------------------------------------
SZINVALIDENTRYPOINT db 'Invalid entry point name in ',0
                                        ; DATA XREF: SEGRELOC+21E↑o
                db 24h
; ---------------------------------------------------------------------------

loc_1777:                               ; CODE XREF: SEGRELOC+228↑j
                xor     ax, ax
                jmp     short loc_177C
; ---------------------------------------------------------------------------
                ;align 2

loc_177C:                               ; CODE XREF: SEGRELOC+D4↑j
                                        ; SEGRELOC:loc_16A4↑j ...
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                ret     10h
SEGRELOC        endp

sEnd CODE

end
