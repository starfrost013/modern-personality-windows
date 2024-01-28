;
; External Entry #57 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GETPROFILEINT
GETPROFILEINT   proc far                ; CODE XREF: BOOTDONE+F↓p
                                        ; BOOTDONE+2A↓p ...

arg_0           = word ptr  6
arg_2           = word ptr  8
arg_4           = word ptr  0Ah
arg_6           = word ptr  0Ch
arg_8           = word ptr  0Eh

                inc     bp              ; KERNEL_57
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                push    cs
                pop     ds
                assume ds:cseg01
                push    [bp+arg_8]
                push    [bp+arg_6]
                push    [bp+arg_4]
                push    [bp+arg_2]
                call    GETSTRING
                mov     si, ax
                mov     ax, [bp+arg_0]
                cmp     cx, 0FFFFh
                jz      short loc_4CFC
                push    ds
                mov     ds, dx
                assume ds:nothing
                xor     ax, ax

loc_4CE3:                               ; CODE XREF: GETPROFILEINT+3D↓j
                mov     dx, 0Ah
                mov     bl, [si]
                sub     bl, 30h ; '0'
                jb      short loc_4CFB
                cmp     bl, 0Ah
                jnb     short loc_4CFB
                inc     si
                mul     dx
                xor     bh, bh
                add     ax, bx
                loop    loc_4CE3

loc_4CFB:                               ; CODE XREF: GETPROFILEINT+2F↑j
                                        ; GETPROFILEINT+34↑j
                pop     ds

loc_4CFC:                               ; CODE XREF: GETPROFILEINT+20↑j
                push    ax
                call    UNLOCKBUFFER
                pop     ax
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    0Ah
GETPROFILEINT   endp

;
; External Entry #58 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GETPROFILESTRING
GETPROFILESTRING proc far

arg_0           = word ptr  6
arg_2           = dword ptr  8
arg_6           = dword ptr  0Ch
arg_A           = word ptr  10h
arg_C           = word ptr  12h
arg_E           = word ptr  14h
arg_10          = word ptr  16h

                inc     bp              ; KERNEL_58
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                push    cs
                pop     ds
                assume ds:cseg01
                mov     ax, [bp+arg_A]
                mov     dx, [bp+arg_C]
                or      ax, dx
                jnz     short loc_4D38
                push    [bp+arg_10]
                push    [bp+arg_E]
                push    word ptr [bp+arg_2+2]
                push    word ptr [bp+arg_2]
                push    [bp+arg_0]
                call    GETKEYS
                jnb     short loc_4D93
                jmp     short loc_4D52
; ---------------------------------------------------------------------------
                align 2

loc_4D38:                               ; CODE XREF: GETPROFILESTRING+11↑j
                push    [bp+arg_10]
                push    [bp+arg_E]
                push    [bp+arg_C]
                push    [bp+arg_A]
                call    GETSTRING
                cmp     cx, 0FFFFh
                jz      short loc_4D52
                mov     word ptr [bp+arg_6+2], dx
                mov     word ptr [bp+arg_6], ax

loc_4D52:                               ; CODE XREF: GETPROFILESTRING+27↑j
                                        ; GETPROFILESTRING+3C↑j
                les     di, [bp+arg_6]
                call    loc_51D1
                mov     al, es:[di-1]
                les     di, [bp+arg_6]
                cmp     cx, 2
                jb      short loc_4D77
                mov     ah, es:[di]
                cmp     ah, al
                jnz     short loc_4D77
                cmp     al, 27h ; '''
                jz      short loc_4D73
                cmp     al, 22h ; '"'
                jnz     short loc_4D77

loc_4D73:                               ; CODE XREF: GETPROFILESTRING+5F↑j
                sub     cx, 2
                inc     di

loc_4D77:                               ; CODE XREF: GETPROFILESTRING+54↑j
                                        ; GETPROFILESTRING+5B↑j ...
                mov     dx, [bp+arg_0]
                dec     dx
                cmp     cx, dx
                jbe     short loc_4D81
                mov     cx, dx

loc_4D81:                               ; CODE XREF: GETPROFILESTRING+6F↑j
                push    ds
                push    es
                pop     ds
                assume ds:nothing
                mov     si, di
                push    cx
                les     di, [bp+arg_2]
                rep movsb
                xor     al, al
                mov     es:[di], al
                pop     ax
                pop     ds

loc_4D93:                               ; CODE XREF: GETPROFILESTRING+25↑j
                push    ax
                call    UNLOCKBUFFER
                pop     ax
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    12h
GETPROFILESTRING endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

GETKEYS         proc near               ; CODE XREF: GETPROFILESTRING+22↑p

arg_0           = word ptr  4
arg_2           = dword ptr  6
arg_6           = dword ptr  0Ah

                push    bp
                mov     bp, sp
                push    si
                push    di
                push    ds
                xor     di, di
                call    BUFFERINIT
                push    ds
                xor     cx, cx
                mov     di, ax
                or      ax, dx
                jnz     short loc_4DBC
                jmp     short loc_4E33
; ---------------------------------------------------------------------------
                align 2

loc_4DBC:                               ; CODE XREF: GETKEYS+12↑j
                dec     [bp+arg_0]
                mov     es, dx

loc_4DC1:                               ; CODE XREF: GETKEYS+39↓j
                cmp     byte ptr es:[di], 5Bh ; '['
                jnz     short loc_4DD2
                inc     di
                lds     si, [bp+arg_6]
                mov     bl, 5Dh ; ']'
                call    PROFILESTRINGTOLOWER
                jz      short loc_4DE2

loc_4DD2:                               ; CODE XREF: GETKEYS+20↑j
                mov     al, 0Ah
                mov     cx, 0FFFFh
                repne scasb
                mov     al, es:[di]
                or      al, al
                jnz     short loc_4DC1
                jmp     short loc_4E33
; ---------------------------------------------------------------------------

loc_4DE2:                               ; CODE XREF: GETKEYS+2B↑j
                mov     al, 0Ah
                mov     cx, 0FFFFh
                repne scasb
                lds     si, [bp+arg_2]
                xor     dx, dx

loc_4DEE:                               ; CODE XREF: GETKEYS+55↓j
                                        ; GETKEYS+83↓j
                mov     bx, di

loc_4DF0:                               ; CODE XREF: GETKEYS+5D↓j
                mov     al, es:[di]
                inc     di
                cmp     al, 3Dh ; '='
                jz      short loc_4E06
                cmp     al, 0Ah
                jz      short loc_4DEE
                cmp     al, 5Bh ; '['
                jz      short loc_4E2A
                or      al, al
                jnz     short loc_4DF0
                jmp     short loc_4E2A
; ---------------------------------------------------------------------------

loc_4E06:                               ; CODE XREF: GETKEYS+51↑j
                mov     di, bx

loc_4E08:                               ; CODE XREF: GETKEYS+7A↓j
                mov     al, es:[di]
                inc     di
                cmp     al, 3Dh ; '='
                jnz     short loc_4E12
                xor     al, al

loc_4E12:                               ; CODE XREF: GETKEYS+69↑j
                mov     [si], al
                inc     dx
                inc     si
                cmp     dx, [bp+arg_0]
                jb      short loc_4E1D
                dec     si
                dec     dx

loc_4E1D:                               ; CODE XREF: GETKEYS+74↑j
                or      al, al
                jnz     short loc_4E08
                mov     al, 0Ah
                mov     cx, 0FFFFh
                repne scasb
                jmp     short loc_4DEE
; ---------------------------------------------------------------------------

loc_4E2A:                               ; CODE XREF: GETKEYS+59↑j
                                        ; GETKEYS+5F↑j
                xor     al, al
                mov     [si], al
                mov     ax, dx
                clc
                jmp     short loc_4E34
; ---------------------------------------------------------------------------

loc_4E33:                               ; CODE XREF: GETKEYS+14↑j
                                        ; GETKEYS+3B↑j
                stc

loc_4E34:                               ; CODE XREF: GETKEYS+8C↑j
                pop     ds
                pop     ds
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    0Ah
GETKEYS         endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

GETSTRING       proc near               ; CODE XREF: GETPROFILEINT+15↑p
                                        ; GETPROFILESTRING+36↑p

arg_0           = dword ptr  4
arg_4           = dword ptr  8

                push    bp
                mov     bp, sp
                push    si
                push    di
                push    ds
                xor     di, di
                call    BUFFERINIT
                push    ds
                mov     cx, 0FFFFh
                mov     di, ax
                or      ax, dx
                jz      short loc_4EA9
                mov     es, dx

loc_4E55:                               ; CODE XREF: GETSTRING+34↓j
                cmp     byte ptr es:[di], 5Bh ; '['
                jnz     short loc_4E66
                inc     di
                lds     si, [bp+arg_4]
                mov     bl, 5Dh ; ']'
                call    PROFILESTRINGTOLOWER
                jz      short loc_4E76

loc_4E66:                               ; CODE XREF: GETSTRING+1B↑j
                mov     al, 0Ah
                mov     cx, 0FFFFh
                repne scasb
                mov     al, es:[di]
                or      al, al
                jnz     short loc_4E55
                jmp     short loc_4E88
; ---------------------------------------------------------------------------

loc_4E76:                               ; CODE XREF: GETSTRING+26↑j
                                        ; GETSTRING+57↓j
                mov     al, 0Ah
                mov     cx, 0FFFFh
                repne scasb
                mov     al, es:[di]
                or      al, al
                jz      short loc_4E88
                cmp     al, 5Bh ; '['
                jnz     short loc_4E8D

loc_4E88:                               ; CODE XREF: GETSTRING+36↑j
                                        ; GETSTRING+44↑j
                mov     cx, 0FFFFh
                jmp     short loc_4EA9
; ---------------------------------------------------------------------------

loc_4E8D:                               ; CODE XREF: GETSTRING+48↑j
                lds     si, [bp+arg_0]
                mov     bl, 3Dh ; '='
                call    PROFILESTRINGTOLOWER
                jnz     short loc_4E76
                inc     di
                mov     dx, es
                mov     bx, di
                mov     al, 0Dh
                mov     cx, 0FFFFh
                repne scasb
                inc     cx
                inc     cx
                neg     cx
                mov     ax, bx

loc_4EA9:                               ; CODE XREF: GETSTRING+13↑j
                                        ; GETSTRING+4D↑j
                pop     ds
                pop     ds
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    8
GETSTRING       endp


; =============== S U B R O U T I N E =======================================


PROFILESTRINGTOLOWER proc near          ; CODE XREF: GETKEYS+28↑p
                                        ; GETSTRING+23↑p ...
                mov     al, es:[di]
                cmp     al, bl
                jnz     short loc_4EC0
                mov     al, [si]
                or      al, al
                jmp     short locret_4ED2
; ---------------------------------------------------------------------------

loc_4EC0:                               ; CODE XREF: PROFILESTRINGTOLOWER+5↑j
                call    MYLOWER
                mov     cl, [si]
                xchg    al, cl
                call    MYLOWER
                xchg    cl, al
                inc     si
                inc     di
                cmp     al, cl
                jz      short PROFILESTRINGTOLOWER

locret_4ED2:                            ; CODE XREF: PROFILESTRINGTOLOWER+B↑j
                retn
PROFILESTRINGTOLOWER endp


; =============== S U B R O U T I N E =======================================


BUFFERINIT      proc near               ; CODE XREF: GETKEYS+8↑p
                                        ; GETSTRING+8↑p ...

; FUNCTION CHUNK AT 4F71 SIZE 00000071 BYTES

                push    cs
                pop     ds
                assume ds:cseg01
                mov     ax, BUFFER
                or      ax, ax
                jz      short loc_4EE9
                call    LOCKBUFFER
                mov     bx, ax
                or      bx, dx
                jz      short loc_4EE6
                retn
; ---------------------------------------------------------------------------

loc_4EE6:                               ; CODE XREF: BUFFERINIT+10↑j
                call    BUFFERFREE

loc_4EE9:                               ; CODE XREF: BUFFERINIT+7↑j
                mov     ax, di
                or      di, di
                jz      short loc_4EF1
                mov     ah, 10h

loc_4EF1:                               ; CODE XREF: BUFFERINIT+1A↑j
                mov     dx, 116h
                mov     bx, 0C6h
                cmp     byte ptr [bx], 0
                jz      short loc_4F01
                mov     dx, 138h
                mov     ah, 0A0h

loc_4F01:                               ; CODE XREF: BUFFERINIT+27↑j
                push    ds
                push    dx
                push    ds
                push    bx
                push    ax
                nop
                push    cs
                call    near ptr OPENFILE
                mov     HFILE, ax
                inc     ax
                jz      short loc_4F62
                mov     ax, 4202h
                call    loc_500F
                add     ax, 3
                adc     dx, 0
                mov     bx, 2042h
                push    bx
                push    dx
                push    ax
                nop
                push    cs
                call    near ptr GLOBALALLOC
                mov     BUFFER, ax
                or      ax, ax
                jz      short loc_4F62
                call    LOCKBUFFER
                call    MOVEBUFFERPOINTER
                push    ds
                lds     dx, dword ptr BUFADDR
                assume ds:nothing
                mov     ax, 2020h
                push    si
                mov     si, dx
                mov     [si], ax
                pop     si
                mov     cx, 0FFFFh
                mov     ah, 3Fh ; '?'
                int     21h             ; DOS - 2+ - READ FROM FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to read
                                        ; DS:DX -> buffer
                jb      short loc_4F59
                mov     cx, ax
                pop     ds
                cmp     cx, 2
                jge     short loc_4F57
                mov     cx, 2

loc_4F57:                               ; CODE XREF: BUFFERINIT+7F↑j
                jmp     short loc_4F71
; ---------------------------------------------------------------------------

loc_4F59:                               ; CODE XREF: BUFFERINIT+77↑j
                call    UNLOCKBUFFER
BUFFERINIT      endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


BUFFERFREE      proc near               ; CODE XREF: BUFFERINIT:loc_4EE6↑p
                                        ; WRITEPROFILESTRING+192↓p
                push    si
                nop
                push    cs
                call    near ptr GLOBALFREE

loc_4F62:                               ; CODE XREF: BUFFERINIT+3C↑j
                                        ; BUFFERINIT+5A↑j
                xor     ax, ax
                xor     dx, dx
                mov     ds:22h, ax
                mov     ds:24h, ax
                mov     ds:26h, dx
                retn
BUFFERFREE      endp

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR BUFFERINIT

loc_4F71:                               ; CODE XREF: BUFFERINIT:loc_4F57↑j
                push    ds
                les     di, ds:24h
                lds     si, ds:24h

loc_4F7A:                               ; CODE XREF: BUFFERINIT:loc_4F81↓j
                                        ; BUFFERINIT+C7↓j ...
                lodsb
                cmp     al, 20h ; ' '
                jz      short loc_4F81
                cmp     al, 9

loc_4F81:                               ; CODE XREF: BUFFERINIT+AA↑j
                loope   loc_4F7A
                jcxz    short loc_4FBD
                dec     si
                inc     cx

loc_4F87:                               ; CODE XREF: BUFFERINIT+BF↓j
                                        ; BUFFERINIT+C3↓j ...
                lodsb
                stosb
                dec     cx
                cmp     al, 3Dh ; '='
                jz      short loc_4FA0
                jcxz    short loc_4FBD
                cmp     al, 20h ; ' '
                jz      short loc_4F87
                cmp     al, 9
                jz      short loc_4F87
                cmp     al, 0Ah
                jz      short loc_4F7A
                mov     bx, di
                jmp     short loc_4F87
; ---------------------------------------------------------------------------

loc_4FA0:                               ; CODE XREF: BUFFERINIT+B9↑j
                mov     di, bx
                stosb
                jcxz    short loc_4FBD

loc_4FA5:                               ; CODE XREF: BUFFERINIT:loc_4FAC↓j
                lodsb
                cmp     al, 20h ; ' '
                jz      short loc_4FAC
                cmp     al, 9

loc_4FAC:                               ; CODE XREF: BUFFERINIT+D5↑j
                loope   loc_4FA5
                jcxz    short loc_4FBD
                dec     si
                inc     cx

loc_4FB2:                               ; CODE XREF: BUFFERINIT+E8↓j
                lodsb
                stosb
                dec     cx
                jz      short loc_4FBD
                cmp     al, 0Ah
                jz      short loc_4F7A
                jmp     short loc_4FB2
; ---------------------------------------------------------------------------

loc_4FBD:                               ; CODE XREF: BUFFERINIT+B0↑j
                                        ; BUFFERINIT+BB↑j ...
                dec     di
                cmp     byte ptr es:[di], 1Ah
                jz      short loc_4FBD
                inc     di
                mov     ax, 0A0Dh
                stosw
                xor     ax, ax
                stosb
                pop     ds
                mov     si, ds:22h
                push    si
                nop
                push    cs
                call    near ptr GLOBALUNLOCK
                xor     ax, ax
                push    si
                push    ax
                push    di
                push    ax
                nop
                push    cs
                call    near ptr GLOBALREALLOC
; END OF FUNCTION CHUNK FOR BUFFERINIT

; =============== S U B R O U T I N E =======================================


LOCKBUFFER      proc near               ; CODE XREF: BUFFERINIT+9↑p
                                        ; BUFFERINIT+5C↑p
                mov     si, ax
                push    ax
                nop
                push    cs
                call    near ptr GLOBALLOCK
                mov     ds:24h, ax
                mov     ds:26h, dx
                retn
LOCKBUFFER      endp


; =============== S U B R O U T I N E =======================================


UNLOCKBUFFER    proc near               ; CODE XREF: GETPROFILEINT+41↑p
                                        ; GETPROFILESTRING+86↑p ...
                mov     si, ds:22h
                push    si
                nop
                push    cs
                call    near ptr GLOBALUNLOCK
                mov     bx, 0FFFFh
                xchg    bx, ds:28h
                inc     bx
                jz      short locret_500B
                dec     bx
                mov     ah, 3Eh ; '>'
                int     21h             ; DOS - 2+ - CLOSE A FILE WITH HANDLE
                                        ; BX = file handle

locret_500B:                            ; CODE XREF: UNLOCKBUFFER+12↑j
                retn
UNLOCKBUFFER    endp


; =============== S U B R O U T I N E =======================================


MOVEBUFFERPOINTER proc near             ; CODE XREF: BUFFERINIT+5F↑p
                                        ; WRITEPROFILESTRING+2A↓p
                mov     ax, 4200h

loc_500F:                               ; CODE XREF: BUFFERINIT+41↑p
                mov     bx, ds:28h
                xor     cx, cx
                xor     dx, dx
                int     21h             ; DOS - 2+ - MOVE FILE READ/WRITE POINTER (LSEEK)
                                        ; AL = method: offset from beginning of file
                retn
MOVEBUFFERPOINTER endp

;
; External Entry #59 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public WRITEPROFILESTRING
WRITEPROFILESTRING proc far

var_A           = word ptr -0Ah
var_8           = word ptr -8
var_6           = dword ptr -6
arg_0           = dword ptr  6
arg_4           = dword ptr  0Ah
arg_8           = dword ptr  0Eh

                inc     bp              ; KERNEL_59
                push    bp
                mov     bp, sp
                push    ds
                sub     sp, 8
                push    si
                push    di
                push    cs
                pop     ds
                assume ds:cseg01
                xor     ax, ax
                xchg    ax, BUFFER
                push    ax
                nop
                push    cs
                call    near ptr GLOBALFREE
                mov     di, 2
                call    BUFFERINIT
                mov     di, ax
                or      ax, dx
                jnz     short loc_5041
                jmp     loc_51B2
; ---------------------------------------------------------------------------

loc_5041:                               ; CODE XREF: WRITEPROFILESTRING+22↑j
                push    ds
                mov     es, dx
                call    MOVEBUFFERPOINTER

loc_5047:                               ; CODE XREF: WRITEPROFILESTRING+4A↓j
                cmp     byte ptr es:[di], 5Bh ; '['
                jnz     short loc_5058
                inc     di
                lds     si, [bp+arg_8]
                assume ds:nothing
                mov     bl, 5Dh ; ']'
                call    PROFILESTRINGTOLOWER
                jz      short loc_506D

loc_5058:                               ; CODE XREF: WRITEPROFILESTRING+31↑j
                mov     al, 0Ah
                mov     cx, 0FFFFh
                repne scasb
                mov     al, es:[di]
                or      al, al
                jnz     short loc_5047
                mov     [bp+var_8], 2
                jmp     short loc_509F
; ---------------------------------------------------------------------------

loc_506D:                               ; CODE XREF: WRITEPROFILESTRING+3C↑j
                mov     al, 0Ah
                mov     cx, 0FFFFh
                repne scasb
                jmp     short loc_5087
; ---------------------------------------------------------------------------

loc_5076:                               ; CODE XREF: WRITEPROFILESTRING+76↓j
                lds     si, [bp+arg_4]
                mov     bl, 3Dh ; '='
                call    PROFILESTRINGTOLOWER
                jz      short loc_5099
                mov     al, 0Ah
                mov     cx, 0FFFFh
                repne scasb

loc_5087:                               ; CODE XREF: WRITEPROFILESTRING+5A↑j
                mov     al, es:[di]
                cmp     al, 5Bh ; '['
                jz      short loc_5092
                or      al, al
                jnz     short loc_5076

loc_5092:                               ; CODE XREF: WRITEPROFILESTRING+72↑j
                mov     [bp+var_8], 4
                jmp     short loc_509F
; ---------------------------------------------------------------------------

loc_5099:                               ; CODE XREF: WRITEPROFILESTRING+64↑j
                inc     di
                mov     [bp+var_8], 1

loc_509F:                               ; CODE XREF: WRITEPROFILESTRING+51↑j
                                        ; WRITEPROFILESTRING+7D↑j
                cmp     [bp+var_8], 1
                jz      short loc_50B4

loc_50A5:                               ; CODE XREF: WRITEPROFILESTRING+91↓j
                                        ; WRITEPROFILESTRING+95↓j
                dec     di
                mov     al, es:[di]
                cmp     al, 0Dh
                jz      short loc_50A5
                cmp     al, 0Ah
                jz      short loc_50A5
                add     di, 3

loc_50B4:                               ; CODE XREF: WRITEPROFILESTRING+89↑j
                pop     ds
                push    ds
                mov     bx, ds:28h
                cmp     bx, 0FFFFh
                jnz     short loc_50E0
                mov     dx, 116h
                xor     cx, cx
                mov     ah, 3Ch ; '<'
                int     21h             ; DOS - 2+ - CREATE A FILE WITH HANDLE (CREAT)
                                        ; CX = attributes for file
                                        ; DS:DX -> ASCIZ filename (may include drive and path)
                mov     ds:28h, ax
                mov     bx, ax
                jb      short loc_50D7
                xor     cx, cx
                mov     ah, 40h ; '@'
                int     21h             ; DOS - 2+ - WRITE TO FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to write, DS:DX -> buffer
                jnb     short loc_50E0

loc_50D7:                               ; CODE XREF: WRITEPROFILESTRING+B3↑j
                                        ; BUFFERWRITE+F↓j
                pop     ds
                call    UNLOCKBUFFER
                xor     ax, ax
                jmp     loc_51B2
; ---------------------------------------------------------------------------

loc_50E0:                               ; CODE XREF: WRITEPROFILESTRING+A3↑j
                                        ; WRITEPROFILESTRING+BB↑j
                xor     cx, cx
                mov     [bp+var_A], cx
                mov     word ptr [bp+var_6], di
                mov     word ptr [bp+var_6+2], es
                mov     cx, di
                push    es
                pop     ds
                xor     dx, dx
                call    near ptr BUFFERWRITE
                cmp     [bp+var_8], 2
                jnz     short loc_5125
                pop     ds
                push    ds
                mov     dx, 4CB9h
                mov     cx, 2
                call    near ptr BUFFERWRITE
                mov     dx, 4CB7h
                mov     cx, 1
                call    near ptr BUFFERWRITE
                les     di, [bp+arg_8]
                call    loc_51D1
                lds     dx, [bp+arg_8]
                call    near ptr BUFFERWRITE
                pop     ds
                push    ds
                mov     dx, 4CB8h
                mov     cx, 3
                call    near ptr BUFFERWRITE

loc_5125:                               ; CODE XREF: WRITEPROFILESTRING+DE↑j
                cmp     [bp+var_8], 1
                jz      short loc_5142
                les     di, [bp+arg_4]
                call    loc_51D1
                lds     dx, [bp+arg_4]
                call    near ptr BUFFERWRITE
                pop     ds
                push    ds
                mov     dx, 4CBBh
                mov     cx, 1
                call    near ptr BUFFERWRITE

loc_5142:                               ; CODE XREF: WRITEPROFILESTRING+10F↑j
                les     di, [bp+arg_0]
                call    loc_51D1
                lds     dx, [bp+arg_0]
                call    near ptr BUFFERWRITE
                pop     ds
                push    ds
                mov     dx, 4CB9h
                mov     cx, 2
                call    near ptr BUFFERWRITE
                les     di, [bp+var_6]
                cmp     [bp+var_8], 1
                jnz     short loc_5169
                mov     al, 0Ah
                mov     cx, 0FFFFh
                repne scasb

loc_5169:                               ; CODE XREF: WRITEPROFILESTRING+146↑j
                mov     dx, di
                xor     al, al
                mov     cx, 0FFFFh
                repne scasb
                sub     di, 3
                sub     di, dx
                mov     cx, di
                or      cx, cx
                jle     short loc_51A3
                mov     si, dx
                mov     dx, cx
                add     dx, [bp+var_A]
                xor     cx, cx
                mov     ax, 4200h
                int     21h             ; DOS - 2+ - MOVE FILE READ/WRITE POINTER (LSEEK)
                                        ; AL = method: offset from beginning of file
                xor     cx, cx
                call    near ptr BUFFERWRITE
                mov     dx, [bp+var_A]
                xor     cx, cx
                mov     ax, 4200h
                int     21h             ; DOS - 2+ - MOVE FILE READ/WRITE POINTER (LSEEK)
                                        ; AL = method: offset from beginning of file
                push    es
                pop     ds
                mov     cx, di
                mov     dx, si
                call    near ptr BUFFERWRITE

loc_51A3:                               ; CODE XREF: WRITEPROFILESTRING+161↑j
                xor     cx, cx
                call    near ptr BUFFERWRITE
                pop     ds
                call    UNLOCKBUFFER
                call    BUFFERFREE
                mov     ax, 1

loc_51B2:                               ; CODE XREF: WRITEPROFILESTRING+24↑j
                                        ; WRITEPROFILESTRING+C3↑j
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    0Ch
WRITEPROFILESTRING endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


BUFFERWRITE     proc far                ; CODE XREF: WRITEPROFILESTRING+D7↑p
                                        ; WRITEPROFILESTRING+E8↑p ...
                mov     ah, 40h ; '@'
                int     21h             ; DOS - 2+ - WRITE TO FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to write, DS:DX -> buffer
                jb      short loc_51CD
                cmp     ax, cx
                jnz     short loc_51CD
                add     [bp-0Ah], cx
                retn
; ---------------------------------------------------------------------------

loc_51CD:                               ; CODE XREF: BUFFERWRITE+4↑j
                                        ; BUFFERWRITE+8↑j
                pop     ax
                jmp     loc_50D7
; ---------------------------------------------------------------------------

loc_51D1:                               ; CODE XREF: GETPROFILESTRING+47↑p
                                        ; WRITEPROFILESTRING+F7↑p ...
                mov     cx, di
                dec     di

loc_51D4:                               ; CODE XREF: BUFFERWRITE+1A↓j
                inc     di
                cmp     byte ptr es:[di], 0Dh
                ja      short loc_51D4
                neg     cx
                add     cx, di
                retn
BUFFERWRITE     endp ; sp-analysis failed