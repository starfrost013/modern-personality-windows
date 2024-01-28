
;
; External Entry #60 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public FINDRESOURCE
FINDRESOURCE    proc far
                push    ds              ; KERNEL_60
                pop     ax
                nop
                inc     bp
                push    bp
                mov     bp, sp
                push    ds
                mov     ds, ax
                sub     sp, 1Ch
                push    si
                push    word ptr [bp+0Eh]
                call    GETEXEPTR
                mov     [bp-1Ch], ax
                mov     dx, ax
                sub     ax, ax
                mov     [bp-1Ah], ax
                mov     [bp-18h], dx
                les     bx, [bp-1Ah]
                mov     ax, es:[bx+24h]
                cmp     es:[bx+26h], ax
                jnz     short loc_2AD4

loc_2ACF:                               ; CODE XREF: FINDRESOURCE+A2↓j
                                        ; FINDRESOURCE+10A↓j
                sub     ax, ax
                jmp     loc_2BBA
; ---------------------------------------------------------------------------

loc_2AD4:                               ; CODE XREF: FINDRESOURCE+2C↑j
                mov     dx, [bp-1Ch]
                sub     ax, ax
                les     bx, [bp-1Ah]
                mov     ax, es:[bx+24h]
                mov     [bp-10h], ax
                mov     [bp-0Eh], dx
                push    word ptr [bp+8]
                push    word ptr [bp+6]
                call    GETRESORD
                mov     [bp-14h], ax
                push    word ptr [bp+0Ch]
                push    word ptr [bp+0Ah]
                call    GETRESORD
                mov     [bp-12h], ax
                mov     ax, [bp-10h]
                mov     dx, [bp-0Eh]
                add     ax, 2

loc_2B07:                               ; CODE XREF: FINDRESOURCE+BF↓j
                mov     [bp-0Ch], ax
                mov     [bp-0Ah], dx
                les     bx, [bp-0Ch]
                mov     si, es:[bx]
                or      si, si
                jz      short loc_2B3A
                add     ax, 8
                mov     [bp-8], ax
                mov     [bp-6], dx
                cmp     word ptr [bp-14h], 0
                jnz     short loc_2B45
                push    word ptr [bp-0Eh]
                push    word ptr [bp-10h]
                push    si
                push    word ptr [bp+8]
                push    word ptr [bp+6]
                call    CMPRESSTR
                or      ax, ax
                jz      short loc_2B45

loc_2B3A:                               ; CODE XREF: FINDRESOURCE+74↑j
                                        ; FINDRESOURCE+AD↓j
                les     bx, [bp-0Ch]
                cmp     word ptr es:[bx], 0
                jnz     short loc_2B62
                jmp     short loc_2ACF
; ---------------------------------------------------------------------------

loc_2B45:                               ; CODE XREF: FINDRESOURCE+83↑j
                                        ; FINDRESOURCE+97↑j
                les     bx, [bp-0Ch]
                mov     ax, [bp-14h]
                cmp     es:[bx], ax
                jz      short loc_2B3A
                mov     ax, 0Ch
                mul     word ptr es:[bx+2]
                add     [bp-8], ax
                mov     ax, [bp-8]
                mov     dx, [bp-6]
                jmp     short loc_2B07
; ---------------------------------------------------------------------------

loc_2B62:                               ; CODE XREF: FINDRESOURCE+A0↑j
                mov     word ptr [bp-16h], 0

loc_2B67:                               ; CODE XREF: FINDRESOURCE+114↓j
                les     bx, [bp-0Ch]
                mov     ax, [bp-16h]
                cmp     es:[bx+2], ax
                jbe     short loc_2B9F
                cmp     word ptr [bp-12h], 0
                jnz     short loc_2B93
                push    word ptr [bp-0Eh]
                push    word ptr [bp-10h]
                les     bx, [bp-8]
                push    word ptr es:[bx+6]
                push    word ptr [bp+0Ch]
                push    word ptr [bp+0Ah]
                call    CMPRESSTR
                or      ax, ax
                jnz     short loc_2B9F

loc_2B93:                               ; CODE XREF: FINDRESOURCE+D6↑j
                les     bx, [bp-8]
                mov     ax, [bp-12h]
                cmp     es:[bx+6], ax
                jnz     short loc_2BAE

loc_2B9F:                               ; CODE XREF: FINDRESOURCE+D0↑j
                                        ; FINDRESOURCE+F0↑j
                les     bx, [bp-0Ch]
                mov     ax, [bp-16h]
                cmp     es:[bx+2], ax
                jnz     short loc_2BB7
                jmp     loc_2ACF
; ---------------------------------------------------------------------------

loc_2BAE:                               ; CODE XREF: FINDRESOURCE+FC↑j
                inc     word ptr [bp-16h]
                add     word ptr [bp-8], 0Ch
                jmp     short loc_2B67
; ---------------------------------------------------------------------------

loc_2BB7:                               ; CODE XREF: FINDRESOURCE+108↑j
                mov     ax, [bp-8]

loc_2BBA:                               ; CODE XREF: FINDRESOURCE+30↑j
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    0Ah
FINDRESOURCE    endp

;
; External Entry #61 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public LOADRESOURCE
LOADRESOURCE    proc far
                push    ds              ; KERNEL_61
                pop     ax
                nop
                inc     bp
                push    bp
                mov     bp, sp
                push    ds
                mov     ds, ax
                sub     sp, 20h
                push    si
                cmp     word ptr [bp+6], 0
                jnz     short loc_2BDD
                jmp     loc_2D0F
; ---------------------------------------------------------------------------

loc_2BDD:                               ; CODE XREF: LOADRESOURCE+12↑j
                push    word ptr [bp+8]
                call    GETEXEPTR
                mov     [bp-20h], ax
                or      ax, ax
                jnz     short loc_2BED
                jmp     loc_2D0F
; ---------------------------------------------------------------------------

loc_2BED:                               ; CODE XREF: LOADRESOURCE+22↑j
                mov     dx, ax
                sub     ax, ax
                mov     [bp-16h], ax
                mov     [bp-14h], dx
                les     bx, [bp-16h]
                mov     ax, es:[bx+24h]
                cmp     es:[bx+26h], ax
                jnz     short loc_2C07
                jmp     loc_2D0F
; ---------------------------------------------------------------------------

loc_2C07:                               ; CODE XREF: LOADRESOURCE+3C↑j
                sub     ax, ax
                mov     ax, [bp+6]
                mov     [bp-6], ax
                mov     [bp-4], dx
                les     bx, [bp-6]
                cmp     word ptr es:[bx+0Ah], 0
                jz      short loc_2C1F
                jmp     loc_2D39
; ---------------------------------------------------------------------------

loc_2C1F:                               ; CODE XREF: LOADRESOURCE+54↑j
                cmp     word ptr es:[bx+8], 0
                jnz     short loc_2C29
                jmp     loc_2CCB
; ---------------------------------------------------------------------------

loc_2C29:                               ; CODE XREF: LOADRESOURCE+5E↑j
                test    byte ptr es:[bx+4], 4
                jz      short loc_2C4C
                push    word ptr es:[bx+8]
                nop
                push    cs
                call    near ptr GLOBALLOCK
                or      ax, dx
                jz      short loc_2C4C
                les     bx, [bp-6]
                push    word ptr es:[bx+8]
                nop
                push    cs
                call    near ptr GLOBALUNLOCK
                jmp     loc_2D39
; ---------------------------------------------------------------------------

loc_2C4C:                               ; CODE XREF: LOADRESOURCE+68↑j
                                        ; LOADRESOURCE+75↑j ...
                mov     dx, [bp-20h]
                sub     ax, ax
                les     bx, [bp-16h]
                mov     ax, es:[bx+24h]
                mov     [bp-0Eh], ax
                mov     [bp-0Ch], dx
                add     ax, 2

loc_2C61:                               ; CODE XREF: LOADRESOURCE+146↓j
                mov     [bp-0Ah], ax
                mov     [bp-8], dx
                les     bx, [bp-0Ah]
                cmp     word ptr es:[bx], 0
                jnz     short loc_2C73
                jmp     loc_2D0F
; ---------------------------------------------------------------------------

loc_2C73:                               ; CODE XREF: LOADRESOURCE+A8↑j
                add     ax, 8
                mov     [bp-1Ah], ax
                mov     [bp-18h], dx
                mov     ax, es:[bx+4]
                mov     dx, es:[bx+6]
                mov     [bp-1Eh], ax
                mov     [bp-1Ch], dx
                or      ax, dx
                jz      short loc_2CF9
                mov     word ptr [bp-10h], 0

loc_2C93:                               ; CODE XREF: LOADRESOURCE+131↓j
                les     bx, [bp-0Ah]
                mov     ax, [bp-10h]
                cmp     es:[bx+2], ax
                jbe     short loc_2D06
                mov     ax, [bp-6]
                cmp     [bp-1Ah], ax
                jnz     short loc_2CF0
                les     bx, [bp-6]
                push    word ptr es:[bx+8]
                push    word ptr [bp+8]
                push    word ptr [bp+6]
                call    dword ptr [bp-1Eh]
                mov     si, ax
                or      si, si
                jz      short loc_2CEC
                les     bx, [bp-6]
                mov     es:[bx+8], si
                or      byte ptr es:[bx+4], 4
                jmp     short loc_2D39
; ---------------------------------------------------------------------------

loc_2CCB:                               ; CODE XREF: LOADRESOURCE+60↑j
                les     bx, [bp-6]
                test    word ptr es:[bx+4], 0F000h
                jnz     short loc_2CD9
                jmp     loc_2C4C
; ---------------------------------------------------------------------------

loc_2CD9:                               ; CODE XREF: LOADRESOURCE+10E↑j
                push    word ptr es:[bx+4]
                push    word ptr [bp-20h]
                call    MYRESALLOC
                les     bx, [bp-6]
                mov     es:[bx+8], ax
                jmp     short loc_2D39
; ---------------------------------------------------------------------------

loc_2CEC:                               ; CODE XREF: LOADRESOURCE+F5↑j
                mov     ax, si
                jmp     short loc_2D44
; ---------------------------------------------------------------------------

loc_2CF0:                               ; CODE XREF: LOADRESOURCE+DF↑j
                inc     word ptr [bp-10h]
                add     word ptr [bp-1Ah], 0Ch
                jmp     short loc_2C93
; ---------------------------------------------------------------------------

loc_2CF9:                               ; CODE XREF: LOADRESOURCE+C6↑j
                mov     ax, 0Ch
                les     bx, [bp-0Ah]
                mul     word ptr es:[bx+2]
                add     [bp-1Ah], ax

loc_2D06:                               ; CODE XREF: LOADRESOURCE+D7↑j
                mov     ax, [bp-1Ah]
                mov     dx, [bp-18h]
                jmp     loc_2C61
; ---------------------------------------------------------------------------

loc_2D0F:                               ; CODE XREF: LOADRESOURCE+14↑j
                                        ; LOADRESOURCE+24↑j ...
                or      si, si
                jnz     short loc_2D35
                mov     dx, [bp-20h]
                sub     ax, ax
                mov     [bp-16h], ax
                mov     [bp-14h], dx
                mov     ax, 504h
                push    ax
                mov     ax, 2
                push    ax
                call    GETDEBUGSTRING
                push    dx
                push    ax
                mov     dx, [bp-20h]
                sub     ax, ax
                push    dx
                push    ax
                call    KERNELERROR

loc_2D35:                               ; CODE XREF: LOADRESOURCE+14B↑j
                sub     ax, ax
                jmp     short loc_2D44
; ---------------------------------------------------------------------------

loc_2D39:                               ; CODE XREF: LOADRESOURCE+56↑j
                                        ; LOADRESOURCE+83↑j ...
                les     bx, [bp-6]
                inc     word ptr es:[bx+0Ah]
                mov     ax, es:[bx+8]

loc_2D44:                               ; CODE XREF: LOADRESOURCE+128↑j
                                        ; LOADRESOURCE+171↑j
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    4
LOADRESOURCE    endp

;
; External Entry #67 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public SETRESOURCEHANDLER
SETRESOURCEHANDLER proc far
                push    ds              ; KERNEL_67
                pop     ax
                nop
                inc     bp
                push    bp
                mov     bp, sp
                push    ds
                mov     ds, ax
                sub     sp, 1Ah
                push    si
                push    word ptr [bp+0Eh]
                call    GETEXEPTR
                mov     [bp-1Ah], ax
                mov     dx, ax
                sub     ax, ax
                mov     [bp-18h], ax
                mov     [bp-16h], dx
                les     bx, [bp-18h]
                mov     ax, es:[bx+24h]
                cmp     es:[bx+26h], ax
                jnz     short loc_2D84

loc_2D7E:                               ; CODE XREF: SETRESOURCEHANDLER+95↓j
                sub     ax, ax
                cwd
                jmp     loc_2E28
; ---------------------------------------------------------------------------

loc_2D84:                               ; CODE XREF: SETRESOURCEHANDLER+2C↑j
                mov     dx, [bp-1Ah]
                sub     ax, ax
                les     bx, [bp-18h]
                mov     ax, es:[bx+24h]
                mov     [bp-12h], ax
                mov     [bp-10h], dx
                push    word ptr [bp+0Ch]
                push    word ptr [bp+0Ah]
                call    GETRESORD
                mov     [bp-14h], ax
                mov     ax, [bp-12h]
                mov     dx, [bp-10h]
                add     ax, 2

loc_2DAB:                               ; CODE XREF: SETRESOURCEHANDLER+D6↓j
                mov     [bp-0Eh], ax
                mov     [bp-0Ch], dx
                les     bx, [bp-0Eh]
                mov     si, es:[bx]
                or      si, si
                jz      short loc_2DDE
                add     ax, 8
                mov     [bp-0Ah], ax
                mov     [bp-8], dx
                cmp     word ptr [bp-14h], 0
                jnz     short loc_2E0B
                push    word ptr [bp-10h]
                push    word ptr [bp-12h]
                push    si
                push    word ptr [bp+0Ch]
                push    word ptr [bp+0Ah]
                call    CMPRESSTR
                or      ax, ax
                jz      short loc_2E0B

loc_2DDE:                               ; CODE XREF: SETRESOURCEHANDLER+69↑j
                                        ; SETRESOURCEHANDLER+C4↓j
                les     bx, [bp-0Eh]
                cmp     word ptr es:[bx], 0
                jz      short loc_2D7E
                mov     ax, es:[bx+4]
                mov     dx, es:[bx+6]
                mov     [bp-6], ax
                mov     [bp-4], dx
                mov     ax, [bp+6]
                mov     dx, [bp+8]
                mov     es:[bx+4], ax
                mov     es:[bx+6], dx
                mov     ax, [bp-6]
                mov     dx, [bp-4]
                jmp     short loc_2E28
; ---------------------------------------------------------------------------

loc_2E0B:                               ; CODE XREF: SETRESOURCEHANDLER+78↑j
                                        ; SETRESOURCEHANDLER+8C↑j
                les     bx, [bp-0Eh]
                mov     ax, [bp-14h]
                cmp     es:[bx], ax
                jz      short loc_2DDE
                mov     ax, 0Ch
                mul     word ptr es:[bx+2]
                add     [bp-0Ah], ax
                mov     ax, [bp-0Ah]
                mov     dx, [bp-8]
                jmp     short loc_2DAB
; ---------------------------------------------------------------------------

loc_2E28:                               ; CODE XREF: SETRESOURCEHANDLER+31↑j
                                        ; SETRESOURCEHANDLER+B9↑j
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    0Ah
SETRESOURCEHANDLER endp


;
; External Entry #62 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public LOCKRESOURCE
LOCKRESOURCE    proc far

arg_0           = word ptr  6

                inc     bp              ; KERNEL_62
                push    bp
                mov     bp, sp
                push    ds
                push    si
                mov     ax, [bp+arg_0]
                or      ax, ax
                jz      short loc_309E
                push    ax
                nop
                push    cs
                call    near ptr GLOBALLOCK
                or      cx, cx
                jnz     short loc_30A2
                mov     bx, [bp+arg_0]
                test    bl, 1
                jnz     short loc_309E
                mov     es, cs:PGLOBALHEAP
                mov     bx, es:[bx]
                mov     es, bx
                cmp     word ptr es:0, 454Eh
                jnz     short loc_309E
                mov     bx, es:24h
                cmp     es:26h, bx
                jz      short loc_309E
                mov     dx, [bp+arg_0]
                add     bx, 2

loc_3062:                               ; CODE XREF: LOCKRESOURCE+5E↓j
                cmp     es:[bx], ax
                jz      short loc_309E
                lea     si, [bx+4]
                mov     cx, es:[bx+2]
                add     bx, 8

loc_3071:                               ; CODE XREF: LOCKRESOURCE+5C↓j
                cmp     es:[bx+8], dx
                jz      short loc_307E
                add     bx, 0Ch
                loop    loc_3071
                jmp     short loc_3062
; ---------------------------------------------------------------------------

loc_307E:                               ; CODE XREF: LOCKRESOURCE+57↑j
                cmp     word ptr es:[si+2], 0
                jz      short loc_309E
                push    es
                push    bx
                push    dx
                push    es
                push    bx
                call    dword ptr es:[si]
                push    ax
                nop
                push    cs
                call    near ptr GLOBALLOCK
                pop     bx
                pop     es
                jcxz    short loc_309E
                or      byte ptr es:[bx+4], 4
                jmp     short loc_30A2
; ---------------------------------------------------------------------------

loc_309E:                               ; CODE XREF: LOCKRESOURCE+B↑j
                                        ; LOCKRESOURCE+1D↑j ...
                xor     dx, dx
                xor     ax, ax

loc_30A2:                               ; CODE XREF: LOCKRESOURCE+15↑j
                                        ; LOCKRESOURCE+7E↑j
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
LOCKRESOURCE    endp

;
; External Entry #63 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public FREERESOURCE
FREERESOURCE    proc far

arg_0           = word ptr  6

                inc     bp              ; KERNEL_63
                push    bp
                mov     bp, sp
                push    ds
                push    si
                mov     ax, [bp+arg_0]
                or      ax, ax
                jz      short loc_3135
                push    ax
                call    MYLOCK
                or      ax, ax
                jnz     short loc_30DA
                mov     ds, cs:PGLOBALHEAP
                mov     bx, [bp+arg_0]
                test    bl, 1
                jnz     short loc_3132
                test    byte ptr [bx+2], 40h
                jz      short loc_3132
                mov     ds, word ptr [bx]
                jmp     short loc_30E3
; ---------------------------------------------------------------------------

loc_30DA:                               ; CODE XREF: FREERESOURCE+13↑j
                dec     ax
                mov     ds, ax
                xor     ax, ax
                mov     ds, word ptr ds:1

loc_30E3:                               ; CODE XREF: FREERESOURCE+2A↑j
                cmp     word ptr ds:0, 454Eh
                jnz     short loc_312A
                mov     bx, ds:24h
                cmp     ds:26h, bx
                jz      short loc_312A
                mov     dx, [bp+arg_0]
                add     bx, 2

loc_30FB:                               ; CODE XREF: FREERESOURCE+61↓j
                cmp     [bx], ax
                jz      short loc_312A
                mov     cx, [bx+2]
                add     bx, 8

loc_3105:                               ; CODE XREF: FREERESOURCE+5F↓j
                cmp     [bx+8], dx
                jz      short loc_3111
                add     bx, 0Ch
                loop    loc_3105
                jmp     short loc_30FB
; ---------------------------------------------------------------------------

loc_3111:                               ; CODE XREF: FREERESOURCE+5A↑j
                cmp     word ptr [bx+0Ah], 0
                jz      short loc_312A
                dec     word ptr [bx+0Ah]
                jg      short loc_3135
                test    word ptr [bx+4], 0F000h
                jnz     short loc_3132
                mov     [bx+8], ax
                and     byte ptr [bx+4], 0FBh

loc_312A:                               ; CODE XREF: FREERESOURCE+3B↑j
                                        ; FREERESOURCE+45↑j ...
                push    [bp+arg_0]
                nop
                push    cs
                call    near ptr GLOBALFREE

loc_3132:                               ; CODE XREF: FREERESOURCE+20↑j
                                        ; FREERESOURCE+26↑j ...
                mov     [bp+arg_0], ax

loc_3135:                               ; CODE XREF: FREERESOURCE+B↑j
                                        ; FREERESOURCE+6C↑j
                mov     ax, [bp+arg_0]
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
FREERESOURCE    endp

;
; External Entry #65 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public SIZEOFRESOURCE
SIZEOFRESOURCE  proc far

arg_0           = word ptr  6
arg_2           = word ptr  8

                inc     bp              ; KERNEL_65
                push    bp
                mov     bp, sp
                push    ds
                push    [bp+arg_2]
                call    GETEXEPTR
                mov     es, ax
                mov     bx, [bp+arg_0]
                mov     ax, es:[bx+2]
                xor     dx, dx
                mov     bx, es:24h
                mov     cx, es:[bx]

loc_3162:                               ; CODE XREF: SIZEOFRESOURCE+22↓j
                shl     ax, 1
                rcl     dx, 1
                loop    loc_3162
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    4
SIZEOFRESOURCE  endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

DEFAULTRESOURCEHANDLER proc far         ; DATA XREF: PRELOADRESOURCES+24↓o

arg_0           = word ptr  6
arg_2           = word ptr  8
arg_4           = word ptr  0Ah

                inc     bp
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                push    [bp+arg_2]
                call    GETEXEPTR
                or      ax, ax
                jz      short loc_31AE
                mov     si, ax
                push    [bp+arg_4]
                nop
                push    cs
                call    near ptr GLOBALHANDLE
                or      dx, dx
                jnz     short loc_31AE
                push    si
                push    [bp+arg_0]
                nop
                push    cs
                call    near ptr ACCESSRESOURCE
                mov     di, ax
                push    si
                push    [bp+arg_0]
                push    di
                push    di
                call    RESALLOC
                push    ax
                push    di
                nop
                push    cs
                call    near ptr _LCLOSE
                pop     ax

loc_31AE:                               ; CODE XREF: DEFAULTRESOURCEHANDLER+F↑j
                                        ; DEFAULTRESOURCEHANDLER+1D↑j
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    6
DEFAULTRESOURCEHANDLER endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

PRELOADRESOURCES proc near              ; CODE XREF: LOADMODULE+305↑p

arg_0           = word ptr  4
arg_2           = word ptr  6

                push    bp
                mov     bp, sp
                push    si
                push    di
                mov     es, [bp+arg_2]
                mov     si, es:24h
                cmp     es:26h, si
                jz      short loc_3222
                mov     di, es:[si]
                add     si, 2

loc_31D5:                               ; CODE XREF: PRELOADRESOURCES+65↓j
                cmp     word ptr es:[si], 0
                jz      short loc_3222
                mov     cx, es:[si+2]
                mov     word ptr es:[si+4], offset DEFAULTRESOURCEHANDLER
                mov     word ptr es:[si+6], cs
                add     si, 8

loc_31EC:                               ; CODE XREF: PRELOADRESOURCES+63↓j
                push    cx
                mov     ax, es:[si+4]
                test    al, 40h
                jz      short loc_321A
                mov     dx, es:[si]
                xor     ax, ax
                mov     cx, di

loc_31FC:                               ; CODE XREF: PRELOADRESOURCES+45↓j
                shl     dx, 1
                rcl     ax, 1
                loop    loc_31FC
                mov     cx, ax
                mov     ax, 4200h
                mov     bx, [bp+arg_0]
                int     21h             ; DOS - 2+ - MOVE FILE READ/WRITE POINTER (LSEEK)
                                        ; AL = method: offset from beginning of file
                push    es
                push    si
                push    bx
                push    bx
                call    RESALLOC
                mov     es, [bp+arg_2]
                mov     es:[si+8], ax

loc_321A:                               ; CODE XREF: PRELOADRESOURCES+38↑j
                add     si, 0Ch
                pop     cx
                loop    loc_31EC
                jmp     short loc_31D5
; ---------------------------------------------------------------------------

loc_3222:                               ; CODE XREF: PRELOADRESOURCES+12↑j
                                        ; PRELOADRESOURCES+1E↑j
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    4
PRELOADRESOURCES endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

GETRESORD       proc near               ; CODE XREF: FINDRESOURCE+4B↑p
                                        ; FINDRESOURCE+57↑p ...

arg_0           = dword ptr  4

                push    bp
                mov     bp, sp
                push    si
                les     si, [bp+arg_0]
                mov     cx, si
                mov     ax, es
                or      ax, ax
                jz      short loc_325C
                xor     cx, cx
                cld
                lods    byte ptr es:[si]
                cmp     al, 23h ; '#'
                jnz     short loc_325C

loc_3242:                               ; CODE XREF: GETRESORD+30↓j
                lods    byte ptr es:[si]
                or      al, al
                jz      short loc_325C
                sub     al, 30h ; '0'
                cmp     al, 9
                ja      short loc_325C
                xor     ah, ah
                mov     bx, ax
                mov     al, 0Ah
                mul     cx
                add     ax, bx
                mov     cx, ax
                jmp     short loc_3242
; ---------------------------------------------------------------------------

loc_325C:                               ; CODE XREF: GETRESORD+D↑j
                                        ; GETRESORD+16↑j ...
                mov     ax, cx
                jcxz    short loc_3263
                or      ax, 8000h

loc_3263:                               ; CODE XREF: GETRESORD+34↑j
                pop     si
                mov     sp, bp
                pop     bp
                retn    4
GETRESORD       endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

CMPRESSTR       proc near               ; CODE XREF: FINDRESOURCE+92↑p
                                        ; FINDRESOURCE+EB↑p ...

arg_0           = dword ptr  4
arg_4           = word ptr  8
arg_6           = dword ptr  0Ah

                push    bp
                mov     bp, sp
                push    si
                push    ds
                lds     si, [bp+arg_6]
                add     si, [bp+arg_4]
                xor     ax, ax
                cld
                lodsb
                mov     cx, ax
                les     bx, [bp+arg_0]

loc_327E:                               ; CODE XREF: CMPRESSTR+26↓j
                mov     al, es:[bx]
                inc     bx
                or      al, al
                jz      short loc_329D
                call    MYUPPER
                mov     ah, al
                lodsb
                cmp     ah, al
                jnz     short loc_329D
                loop    loc_327E
                xor     ax, ax
                cmp     es:[bx], al
                jnz     short loc_329D
                not     ax
                jmp     short loc_329F
; ---------------------------------------------------------------------------

loc_329D:                               ; CODE XREF: CMPRESSTR+1A↑j
                                        ; CMPRESSTR+24↑j ...
                xor     ax, ax

loc_329F:                               ; CODE XREF: CMPRESSTR+31↑j
                pop     ds
                pop     si
                mov     sp, bp
                pop     bp
                retn    0Ah
CMPRESSTR       endp


;
; External Entry #64 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public ACCESSRESOURCE
ACCESSRESOURCE  proc far                ; CODE XREF: DEFAULTRESOURCEHANDLER+25↓p

arg_0           = word ptr  6
arg_2           = word ptr  8

                inc     bp              ; KERNEL_64
                push    bp
                mov     bp, sp
                push    ds
                push    [bp+arg_2]
                call    GETEXEPTR
                mov     es, ax
                mov     bx, [bp+arg_0]
                push    word ptr es:[bx+2]
                push    word ptr es:[bx]
                mov     ax, es:[bx+4]
                mov     dx, es:0Ah
                mov     bx, es:24h
                mov     cx, es:[bx]
                push    cx
                push    es
                mov     bx, 0A400h
                push    es
                push    dx
                push    es
                push    dx
                push    bx
                nop
                push    cs
                call    near ptr OPENFILE
                pop     es
                pop     cx
                pop     dx
                inc     ax
                jnz     short loc_2FF3
                pop     dx

loc_2FED:                               ; CODE XREF: ACCESSRESOURCE+56↓j
                mov     bx, 0FFFFh
                jmp     short loc_3013
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_2FF3:                               ; CODE XREF: ACCESSRESOURCE+3B↑j
                xor     ax, ax
                push    cx

loc_2FF6:                               ; CODE XREF: ACCESSRESOURCE+4B↓j
                shl     dx, 1
                rcl     ax, 1
                loop    loc_2FF6
                mov     cx, ax
                mov     ax, 4200h
                int     21h             ; DOS - 2+ - MOVE FILE READ/WRITE POINTER (LSEEK)
                                        ; AL = method: offset from beginning of file
                pop     cx
                pop     dx
                jb      short loc_2FED
                xor     ax, ax

loc_3009:                               ; CODE XREF: ACCESSRESOURCE+5E↓j
                shl     dx, 1
                rcl     ax, 1
                loop    loc_3009
                mov     cx, ax
                mov     ax, bx

loc_3013:                               ; CODE XREF: ACCESSRESOURCE+41↑j
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    4
ACCESSRESOURCE  endp