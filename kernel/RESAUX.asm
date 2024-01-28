

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

MYRESALLOC      proc near               ; CODE XREF: LOADRESOURCE+11A↑p

arg_0           = word ptr  4
arg_2           = word ptr  6

                push    bp
                mov     bp, sp
                xor     ax, ax
                mov     bx, [bp+arg_2]
                or      bl, 7
                push    bx
                push    ax
                push    ax
                call    MYALLOC
                test    dl, 1
                jnz     short loc_2E60
                mov     es, cs:PGLOBALHEAP
                mov     bx, dx
                test    byte ptr es:[bx+2], 40h
                jz      short loc_2E60
                mov     ax, [bp+arg_0]
                mov     es:[bx], ax
                jmp     short $+2
; ---------------------------------------------------------------------------

loc_2E60:                               ; CODE XREF: MYRESALLOC+14↑j
                                        ; MYRESALLOC+22↑j ...
                mov     ax, dx
                mov     sp, bp
                pop     bp
                retn    4
MYRESALLOC      endp

;
; External Entry #66 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public ALLOCRESOURCE
ALLOCRESOURCE   proc far                ; CODE XREF: RESALLOC+14↓p

arg_0           = word ptr  6
arg_2           = word ptr  8
arg_4           = word ptr  0Ah
arg_6           = word ptr  0Ch

                inc     bp              ; KERNEL_66
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    [bp+arg_6]
                call    GETEXEPTR
                or      ax, ax
                jz      short loc_2EF0
                mov     es, ax
                push    es
                mov     si, [bp+arg_4]
                mov     bx, es:[si+4]
                or      bl, 7
                push    bx
                push    word ptr es:[si+2]
                mov     bx, es:24h
                mov     cx, es:[bx]
                mov     dx, [bp+arg_0]
                or      dx, [bp+arg_2]
                jz      short loc_2EB2
                pop     dx
                push    cx
                mov     dx, [bp+arg_2]
                xor     ax, ax
                not     ax
                shl     ax, cl
                not     ax
                add     ax, [bp+arg_0]

loc_2EAA:                               ; CODE XREF: ALLOCRESOURCE+46↓j
                shr     dx, 1
                rcr     ax, 1
                loop    loc_2EAA
                pop     cx
                push    ax

loc_2EB2:                               ; CODE XREF: ALLOCRESOURCE+30↑j
                cmp     word ptr es:[si+8], 0
                jz      short loc_2EDD
                pop     ax
                pop     dx
                xor     dx, dx
                jcxz    short loc_2EC5

loc_2EBF:                               ; CODE XREF: ALLOCRESOURCE+5B↓j
                shl     ax, 1
                rcl     dx, 1
                loop    loc_2EBF

loc_2EC5:                               ; CODE XREF: ALLOCRESOURCE+55↑j
                xor     cx, cx
                push    word ptr es:[si+8]
                push    dx
                push    ax
                push    cx
                nop
                push    cs
                call    near ptr GLOBALREALLOC
                push    ax
                nop
                push    cs
                call    near ptr GLOBALHANDLE
                xchg    ax, dx
                jmp     short loc_2EE1
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_2EDD:                               ; CODE XREF: ALLOCRESOURCE+4F↑j
                push    cx
                call    MYALLOC

loc_2EE1:                               ; CODE XREF: ALLOCRESOURCE+72↑j
                pop     cx
                or      ax, ax
                jz      short loc_2EF0
                dec     ax
                mov     es, ax
                inc     ax
                mov     es:1, cx
                xchg    ax, dx

loc_2EF0:                               ; CODE XREF: ALLOCRESOURCE+E↑j
                                        ; ALLOCRESOURCE+7C↑j
                mov     cx, ax
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    8
ALLOCRESOURCE   endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

RESALLOC        proc near               ; CODE XREF: DEFAULTRESOURCEHANDLER+30↓p
                                        ; PRELOADRESOURCES+55↓p ...

var_2           = word ptr -2
arg_0           = word ptr  4
arg_2           = word ptr  6
arg_4           = dword ptr  8

                push    bp
                mov     bp, sp
                sub     sp, 2
                push    si
                push    di
                xor     ax, ax
                push    word ptr [bp+arg_4+2]
                push    word ptr [bp+arg_4]
                push    ax
                push    ax
                nop
                push    cs
                call    near ptr ALLOCRESOURCE
                les     si, [bp+arg_4]
                mov     [bp+var_2], ax
                mov     ax, dx
                mov     bx, es:24h
                mov     cx, es:[bx]
                mov     dx, es:[si+2]
                xor     bx, bx
                cmp     [bp+var_2], bx
                jnz     short loc_2F33
                jmp     short loc_2FA7
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_2F33:                               ; CODE XREF: RESALLOC+30↑j
                                        ; RESALLOC+39↓j
                shl     dx, 1
                rcl     bx, 1
                loop    loc_2F33
                push    ds
                mov     cx, dx
                mov     bx, [bp+arg_2]
                cmp     [bp+arg_0], bx
                jz      short loc_2F57
                mov     ds, bx
                mov     bx, es
                xor     si, si
                xor     di, di
                mov     es, ax
                cld
                rep movsb
                mov     ds, ax
                mov     es, bx
                jmp     short loc_2F65
; ---------------------------------------------------------------------------

loc_2F57:                               ; CODE XREF: RESALLOC+44↑j
                xor     dx, dx
                mov     ds, ax
                mov     ah, 3Fh ; '?'
                int     21h             ; DOS - 2+ - READ FROM FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to read
                                        ; DS:DX -> buffer
                jb      short loc_2F6B
                cmp     ax, cx
                jnz     short loc_2F6B

loc_2F65:                               ; CODE XREF: RESALLOC+57↑j
                pop     ds
                mov     ax, [bp+var_2]
                jmp     short loc_2FA7
; ---------------------------------------------------------------------------

loc_2F6B:                               ; CODE XREF: RESALLOC+61↑j
                                        ; RESALLOC+65↑j
                mov     bx, ds
                pop     ds
                push    bx
                call    MYFREE
                xor     bx, bx
                mov     ax, 505h
                push    ax
                mov     ax, offset SZERRCANTREADRESOURCE ; "Unable to read resource from "
                push    cs
                push    ax
                push    word ptr [bp+arg_4+2]
                push    bx
                call    KERNELERROR
                jmp     short loc_2FA5
; ---------------------------------------------------------------------------
SZERRCANTREADRESOURCE db 'Unable to read resource from ',0
                                        ; DATA XREF: RESALLOC+7A↑o
                db 24h
; ---------------------------------------------------------------------------

loc_2FA5:                               ; CODE XREF: RESALLOC+86↑j
                xor     ax, ax

loc_2FA7:                               ; CODE XREF: RESALLOC+32↑j
                                        ; RESALLOC+6B↑j
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    8
RESALLOC        endp
