/* THIS IS A C FILE */



; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

ADDMODULE       proc near               ; CODE XREF: LOADMODULE+165↑p
                                        ; FASTBOOT+E0↓p

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                mov     es, cs:HEXEHEAD

loc_13E4:                               ; CODE XREF: ADDMODULE+11↓j
                mov     cx, es:6
                jcxz    short loc_13EF
                mov     es, cx
                jmp     short loc_13E4
; ---------------------------------------------------------------------------

loc_13EF:                               ; CODE XREF: ADDMODULE+D↑j
                mov     ax, [bp+arg_0]
                mov     es:6, ax
                mov     es, ax
                cmp     cs:HEXESWEEP, 0
                jnz     short loc_140C
                cmp     word ptr es:30h, 0
                jz      short loc_140C
                mov     cs:HEXESWEEP, ax

loc_140C:                               ; CODE XREF: ADDMODULE+22↑j
                                        ; ADDMODULE+2A↑j
                mov     ax, [bp+arg_0]
                xor     bx, bx
                cmp     cs:FBOOTING, bl
                jnz     short loc_1429
                push    bx
                push    bx
                nop
                push    cs
                call    near ptr GLOBALCOMPACT
                call    CALCMAXNRSEG
                or      ax, ax
                jz      short loc_1429
                mov     ax, [bp+arg_0]

loc_1429:                               ; CODE XREF: ADDMODULE+3A↑j
                                        ; ADDMODULE+48↑j
                mov     sp, bp
                pop     bp
                retn    2
ADDMODULE       endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

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
                retn    2
DELMODULE       endp

;
; External Entry #46 into the Module
; Attributes (0001): Fixed Exported
;
;
; External Entry #96 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public FREEMODULE
FREEMODULE      proc far                ; CODE XREF: LOADMODULE+3DF↑p
                                        ; DOSTerminateHook+C0↓p

var_4           = word ptr -4
arg_0           = word ptr  6

                inc     bp              ; KERNEL_46
                                        ; KERNEL_96
                                        ; FREELIBRARY
                push    bp
                mov     bp, sp
                push    ds
                sub     sp, 2
                push    si
                push    di
                push    [bp+arg_0]
                call    GETEXEPTR
                or      ax, ax
                jz      short loc_14AF
                mov     [bp+var_4], ax
                push    [bp+var_4]
                call    DECEXEUSAGE
                jnz     short loc_14B4
                mov     es, [bp+var_4]
                mov     bx, es:8
                or      bx, bx
                jz      short loc_14A9
                push    word ptr es:[bx+8]
                call    MYFREE

loc_14A9:                               ; CODE XREF: FREEMODULE+29↑j
                push    [bp+var_4]
                call    DELMODULE

loc_14AF:                               ; CODE XREF: FREEMODULE+12↑j
                                        ; FREEMODULE+46↓j
                xor     ax, ax
                jmp     short loc_1519
; ---------------------------------------------------------------------------
                align 2

loc_14B4:                               ; CODE XREF: FREEMODULE+1D↑j
                mov     es, [bp+var_4]
                test    byte ptr es:0Ch, 2
                jz      short loc_14AF
                mov     es, [bp+var_4]
                mov     bx, es:8
                push    word ptr es:[bx+8]
                push    [bp+arg_0]
                call    MYFREE
                pop     dx
                cmp     [bp+arg_0], dx
                jnz     short loc_1519
                mov     es, cs:PGLOBALHEAP
                mov     cx, es:4
                mov     es, word ptr es:6
                xor     bx, bx
                mov     dx, [bp+var_4]

loc_14EB:                               ; CODE XREF: FREEMODULE+92↓j
                cmp     es:[bx+1], dx
                jnz     short loc_1505
                test    byte ptr es:[bx+5], 4
                jz      short loc_1505
                mov     ax, es:[bx+0Ah]
                or      ax, ax
                jnz     short loc_150D
                mov     ax, es
                inc     ax
                jmp     short loc_150D
; ---------------------------------------------------------------------------

loc_1505:                               ; CODE XREF: FREEMODULE+78↑j
                                        ; FREEMODULE+7F↑j
                mov     es, word ptr es:[bx+8]
                loop    loc_14EB
                xor     ax, ax

loc_150D:                               ; CODE XREF: FREEMODULE+87↑j
                                        ; FREEMODULE+8C↑j
                mov     es, [bp+var_4]
                mov     bx, es:8
                mov     es:[bx+8], ax

loc_1519:                               ; CODE XREF: FREEMODULE+3A↑j
                                        ; FREEMODULE+5E↑j
                xor     ax, ax
                push    ax
                push    ax
                nop
                push    cs
                call    near ptr GLOBALCOMPACT
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
FREEMODULE      endp



; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

STARTMODULE     proc near               ; CODE XREF: LOADMODULE+333↓p
                                        ; LOADMODULE+3CF↓p ...

var_8           = dword ptr -8
var_4           = word ptr -4
var_2           = word ptr -2
arg_0           = word ptr  4
arg_2           = word ptr  6
arg_4           = word ptr  8
arg_6           = word ptr  0Ah
arg_8           = word ptr  0Ch

                push    bp
                mov     bp, sp
                sub     sp, 8
                mov     dx, [bp+arg_2]
                sub     ax, ax
                mov     word ptr [bp+var_8], ax
                mov     word ptr [bp+var_8+2], dx
                les     bx, [bp+var_8]
                mov     ax, es:[bx+14h]
                or      ax, es:[bx+16h]
                jz      short loc_337
                cmp     word ptr es:[bx+0Eh], 0
                jz      short loc_337
                push    dx
                push    word ptr es:[bx+0Eh]
                push    [bp+arg_0]
                push    [bp+arg_0]
                call    LOADSEGMENT
                or      ax, ax
                jnz     short loc_337
                cmp     [bp+arg_0], 0FFFFh
                jz      short loc_333
                push    [bp+arg_0]
                nop
                push    cs
                call    near ptr _LCLOSE

loc_333:                                ; CODE XREF: STARTMODULE+3B↑j
                                        ; STARTMODULE+BB↓j
                sub     ax, ax
                jmp     short loc_3AE
; ---------------------------------------------------------------------------

loc_337:                                ; CODE XREF: STARTMODULE+1C↑j
                                        ; STARTMODULE+23↑j ...
                push    [bp+arg_2]
                push    [bp+arg_0]
                call    STARTPROCADDRESS
                mov     [bp+var_4], ax
                mov     [bp+var_2], dx
                cmp     [bp+arg_0], 0FFFFh
                jz      short loc_354
                push    [bp+arg_0]
                nop
                push    cs
                call    near ptr _LCLOSE

loc_354:                                ; CODE XREF: STARTMODULE+5C↑j
                mov     ax, [bp+var_4]
                or      ax, [bp+var_2]
                jz      short loc_3A0
                les     bx, [bp+var_8]
                test    word ptr es:[bx+0Ch], 8000h
                jz      short loc_37B
                push    [bp+arg_2]
                push    [bp+arg_6]
                push    [bp+arg_4]
                push    [bp+var_2]
                push    [bp+var_4]
                call    STARTLIBRARY
                jmp     short loc_3AE
; ---------------------------------------------------------------------------

loc_37B:                                ; CODE XREF: STARTMODULE+77↑j
                push    [bp+arg_2]
                call    GETSTACKPTR
                push    dx
                push    ax
                push    [bp+arg_6]
                push    [bp+arg_4]
                nop
                push    cs
                call    near ptr CREATETASK
                push    ax
                push    [bp+arg_8]
                push    [bp+arg_2]
                push    [bp+var_2]
                push    [bp+var_4]
                call    STARTTASK
                jmp     short loc_3AE
; ---------------------------------------------------------------------------

loc_3A0:                                ; CODE XREF: STARTMODULE+6C↑j
                les     bx, [bp+var_8]
                test    word ptr es:[bx+0Ch], 8000h
                jz      short loc_333
                mov     ax, [bp+arg_2]

loc_3AE:                                ; CODE XREF: STARTMODULE+47↑j
                                        ; STARTMODULE+8B↑j ...
                mov     sp, bp
                pop     bp
                retn    0Ah
STARTMODULE     endp


;
; External Entry #45 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public LOADMODULE
LOADMODULE      proc far                ; CODE XREF: LOADMODULE+23E↓p
                                        ; LOADLIBRARY+9↓j ...
                push    ds              ; KERNEL_45
                pop     ax
                nop
                inc     bp
                push    bp
                mov     bp, sp
                push    ds
                mov     ds, ax
                sub     sp, 0A2h
                push    si
                mov     ax, [bp+0Ch]
                sub     dx, dx
                or      ax, dx
                jnz     short loc_3CF
                jmp     loc_488
; ---------------------------------------------------------------------------

loc_3CF:                                ; CODE XREF: LOADMODULE+16↑j
                push    word ptr [bp+0Ch]
                push    word ptr [bp+0Ah]
                nop
                push    cs
                call    near ptr LSTRLEN
                mov     [bp-0Ah], ax
                add     ax, [bp+0Ah]
                mov     dx, [bp+0Ch]
                mov     [bp-10h], ax
                mov     [bp-0Eh], dx

loc_3E9:                                ; CODE XREF: LOADMODULE+AD↓j
                mov     ax, [bp-0Ah]
                dec     word ptr [bp-0Ah]
                or      ax, ax
                jz      short loc_408
                les     bx, [bp-10h]
                mov     al, es:[bx]
                mov     [bp-0A2h], al
                cmp     al, 5Ch ; '\'
                jz      short loc_405
                cmp     al, 3Ah ; ':'
                jnz     short loc_45E

loc_405:                                ; CODE XREF: LOADMODULE+4B↑j
                inc     word ptr [bp-10h]

loc_408:                                ; CODE XREF: LOADMODULE+3D↑j
                mov     word ptr [bp-0Ah], 0

loc_40D:                                ; CODE XREF: LOADMODULE+CC↓j
                les     bx, [bp-10h]
                inc     word ptr [bp-10h]
                mov     al, es:[bx]
                mov     [bp-4], al
                or      al, al
                jz      short loc_421
                cmp     al, 2Eh ; '.'
                jnz     short loc_463

loc_421:                                ; CODE XREF: LOADMODULE+67↑j
                lea     ax, [bp-9Ch]
                push    ss
                push    ax
                push    word ptr [bp-0Ah]
                call    FINDEXEINFO
                mov     [bp-16h], ax
                or      ax, ax
                jnz     short loc_491
                push    word ptr [bp+0Ch]
                push    word ptr [bp+0Ah]
                lea     ax, [bp-9Ch]
                push    ss
                push    ax
                mov     ax, offset loc_2800
                push    ax
                nop
                push    cs
                call    near ptr OPENFILE
                mov     [bp-9Eh], ax
                inc     ax
                jnz     short loc_491
                cmp     word ptr [bp-9Ah], 0
                jz      short loc_482
                mov     ax, [bp-9Ah]
                jmp     loc_7D6
; ---------------------------------------------------------------------------

loc_45E:                                ; CODE XREF: LOADMODULE+4F↑j
                dec     word ptr [bp-10h]
                jmp     short loc_3E9
; ---------------------------------------------------------------------------

loc_463:                                ; CODE XREF: LOADMODULE+6B↑j
                cmp     byte ptr [bp-4], 61h ; 'a'
                jb      short loc_473
                cmp     byte ptr [bp-4], 7Ah ; 'z'
                ja      short loc_473
                add     byte ptr [bp-4], 0E0h

loc_473:                                ; CODE XREF: LOADMODULE+B3↑j
                                        ; LOADMODULE+B9↑j
                mov     si, [bp-0Ah]
                inc     word ptr [bp-0Ah]
                mov     al, [bp-4]
                mov     [bp+si-9Ch], al
                jmp     short loc_40D
; ---------------------------------------------------------------------------

loc_482:                                ; CODE XREF: LOADMODULE+A1↑j
                mov     ax, 1
                jmp     loc_7D6
; ---------------------------------------------------------------------------

loc_488:                                ; CODE XREF: LOADMODULE+18↑j
                push    word ptr [bp+0Ah]
                call    GETEXEPTR
                mov     [bp-16h], ax

loc_491:                                ; CODE XREF: LOADMODULE+7E↑j
                                        ; LOADMODULE+9A↑j
                cmp     word ptr [bp-16h], 0
                jz      short loc_49A
                jmp     loc_712
; ---------------------------------------------------------------------------

loc_49A:                                ; CODE XREF: LOADMODULE+E1↑j
                push    word ptr [bp-9Eh]
                push    word ptr [bp-9Eh]
                lea     ax, [bp-9Ch]
                push    ss
                push    ax
                call    LOADEXEHEADER
                mov     [bp-0A0h], ax
                or      ax, ax
                jnz     short loc_4C2
                push    word ptr [bp-9Eh]
                nop
                push    cs
                call    near ptr _LCLOSE
                mov     ax, 0Bh
                jmp     loc_7D6
; ---------------------------------------------------------------------------

loc_4C2:                                ; CODE XREF: LOADMODULE+FD↑j
                cmp     word ptr [bp-0A0h], 1
                jnz     short loc_4D7

loc_4C9:                                ; CODE XREF: LOADMODULE+14F↓j
                push    word ptr [bp-9Eh]
                nop
                push    cs
                call    near ptr _LCLOSE

loc_4D2:                                ; CODE XREF: LOADMODULE+38B↓j
                                        ; LOADMODULE+40B↓j
                sub     ax, ax
                jmp     loc_7D6
; ---------------------------------------------------------------------------

loc_4D7:                                ; CODE XREF: LOADMODULE+113↑j
                mov     dx, [bp-0A0h]
                sub     ax, ax
                mov     [bp-1Ch], ax
                mov     [bp-1Ah], dx
                les     bx, [bp-1Ch]
                test    word ptr es:[bx+0Ch], 8000h
                jnz     short loc_505
                or      byte ptr es:[bx+0Ch], 2
                cmp     word ptr [bp+8], 0FFFFh
                jnz     short loc_515
                cmp     word ptr [bp+6], 0FFFFh
                jnz     short loc_515
                push    dx

loc_500:                                ; CODE XREF: LOADMODULE+15F↓j
                call    MYFREE
                jmp     short loc_4C9
; ---------------------------------------------------------------------------

loc_505:                                ; CODE XREF: LOADMODULE+138↑j
                les     bx, [bp-1Ch]
                test    byte ptr es:[bx+0Ch], 2
                jz      short loc_515
                push    word ptr [bp-0A0h]
                jmp     short loc_500
; ---------------------------------------------------------------------------

loc_515:                                ; CODE XREF: LOADMODULE+143↑j
                                        ; LOADMODULE+149↑j ...
                push    word ptr [bp-0A0h]
                call    ADDMODULE
                mov     [bp-16h], ax
                or      ax, ax
                jnz     short loc_526
                jmp     loc_634
; ---------------------------------------------------------------------------

loc_526:                                ; CODE XREF: LOADMODULE+16D↑j
                les     bx, [bp-1Ch]
                mov     word ptr es:[bx+2], 8000h
                mov     ax, es:[bx+28h]
                sub     dx, dx
                mov     bx, [bp-0A0h]
                sub     cx, cx
                mov     dx, bx
                mov     [bp-8], ax
                mov     [bp-6], dx
                mov     [bp-18h], cx
                jmp     loc_61F
; ---------------------------------------------------------------------------

loc_549:                                ; CODE XREF: LOADMODULE+277↓j
                cmp     word ptr [bp-16h], 0
                jnz     short loc_552
                jmp     loc_60F
; ---------------------------------------------------------------------------

loc_552:                                ; CODE XREF: LOADMODULE+199↑j
                les     bx, [bp-8]
                mov     si, es:[bx]
                or      si, si
                jnz     short loc_55F
                jmp     loc_60F
; ---------------------------------------------------------------------------

loc_55F:                                ; CODE XREF: LOADMODULE+1A6↑j
                push    word ptr [bp-0A0h]
                push    word ptr [bp-9Eh]
                push    si
                call    GETSTRINGPTR
                mov     [bp-10h], ax
                mov     [bp-0Eh], dx
                les     bx, [bp-10h]
                inc     word ptr [bp-10h]
                mov     al, es:[bx]
                cbw
                mov     [bp-0Ah], ax
                push    dx
                push    word ptr [bp-10h]
                push    ax
                call    FINDEXEINFO
                mov     [bp-16h], ax
                or      ax, ax
                jnz     short loc_5FA
                lea     ax, [bp-9Ch]
                mov     [bp+0Ah], ax
                mov     word ptr [bp+0Ch], ss
                jmp     short loc_5AB
; ---------------------------------------------------------------------------

loc_599:                                ; CODE XREF: LOADMODULE+1FF↓j
                les     bx, [bp-10h]
                inc     word ptr [bp-10h]
                mov     al, es:[bx]
                les     bx, [bp+0Ah]
                inc     word ptr [bp+0Ah]
                mov     es:[bx], al

loc_5AB:                                ; CODE XREF: LOADMODULE+1E3↑j
                mov     ax, [bp-0Ah]
                dec     word ptr [bp-0Ah]
                or      ax, ax
                jnz     short loc_599
                les     bx, [bp+0Ah]
                inc     word ptr [bp+0Ah]
                mov     byte ptr es:[bx], 2Eh ; '.'
                mov     bx, [bp+0Ah]
                inc     word ptr [bp+0Ah]
                mov     byte ptr es:[bx], 45h ; 'E'
                mov     bx, [bp+0Ah]
                inc     word ptr [bp+0Ah]
                mov     byte ptr es:[bx], 58h ; 'X'
                mov     bx, [bp+0Ah]
                inc     word ptr [bp+0Ah]
                mov     byte ptr es:[bx], 45h ; 'E'
                mov     bx, [bp+0Ah]
                mov     byte ptr es:[bx], 0
                lea     ax, [bp-9Ch]
                push    ss
                push    ax
                mov     ax, 0FFFFh
                cwd
                push    dx
                push    ax
                nop
                push    cs
                call    near ptr LOADMODULE
                mov     [bp-16h], ax
                jmp     short loc_600
; ---------------------------------------------------------------------------

loc_5FA:                                ; CODE XREF: LOADMODULE+1D7↑j
                push    word ptr [bp-16h]
                call    INCEXEUSAGE

loc_600:                                ; CODE XREF: LOADMODULE+244↑j
                cmp     word ptr [bp-16h], 0
                jz      short loc_60F
                push    word ptr [bp-16h]
                call    GETEXEPTR
                mov     [bp-16h], ax

loc_60F:                                ; CODE XREF: LOADMODULE+19B↑j
                                        ; LOADMODULE+1A8↑j ...
                les     bx, [bp-8]
                add     word ptr [bp-8], 2
                mov     ax, [bp-16h]
                mov     es:[bx], ax
                inc     word ptr [bp-18h]

loc_61F:                                ; CODE XREF: LOADMODULE+192↑j
                les     bx, [bp-1Ch]
                mov     ax, [bp-18h]
                cmp     es:[bx+1Eh], ax
                jbe     short loc_62E
                jmp     loc_549
; ---------------------------------------------------------------------------

loc_62E:                                ; CODE XREF: LOADMODULE+275↑j
                mov     word ptr es:[bx+2], 1

loc_634:                                ; CODE XREF: LOADMODULE+16F↑j
                cmp     word ptr [bp-16h], 0
                jz      short loc_6AB
                les     bx, [bp-1Ch]
                cmp     word ptr es:[bx+1Ch], 0
                jz      short loc_6AB
                push    word ptr [bp-0A0h]
                call    ALLOCALLSEGS
                mov     [bp-18h], ax
                or      ax, ax
                jle     short loc_6A0
                mov     dx, [bp-0A0h]
                sub     ax, ax
                les     bx, [bp-1Ch]
                mov     ax, es:[bx+22h]
                mov     [bp-14h], ax
                mov     [bp-12h], dx
                mov     word ptr [bp-18h], 1

loc_66A:                                ; CODE XREF: LOADMODULE+2EA↓j
                les     bx, [bp-1Ch]
                mov     ax, [bp-18h]
                cmp     es:[bx+1Ch], ax
                jb      short loc_6AB
                les     bx, [bp-14h]
                test    byte ptr es:[bx+4], 40h
                jz      short loc_697
                push    word ptr [bp-0A0h]
                push    ax
                push    word ptr [bp-9Eh]
                push    word ptr [bp-9Eh]
                call    LOADSEGMENT
                mov     [bp-16h], ax
                or      ax, ax
                jz      short loc_6AB

loc_697:                                ; CODE XREF: LOADMODULE+2CA↑j
                inc     word ptr [bp-18h]
                add     word ptr [bp-14h], 0Ah
                jmp     short loc_66A
; ---------------------------------------------------------------------------

loc_6A0:                                ; CODE XREF: LOADMODULE+29C↑j
                cmp     word ptr [bp-18h], 0
                jnz     short loc_6AB
                mov     word ptr [bp-16h], 0

loc_6AB:                                ; CODE XREF: LOADMODULE+284↑j
                                        ; LOADMODULE+28E↑j ...
                cmp     word ptr [bp-16h], 0
                jz      short loc_6BC
                push    word ptr [bp-0A0h]
                push    word ptr [bp-9Eh]
                call    PRELOADRESOURCES

loc_6BC:                                ; CODE XREF: LOADMODULE+2FB↑j
                cmp     word ptr [bp-16h], 0
                jz      short loc_6EF
                cmp     word ptr [bp+8], 0FFFFh
                jnz     short loc_6D6
                cmp     word ptr [bp+6], 0FFFFh
                jnz     short loc_6D6
                sub     ax, ax
                mov     [bp+8], ax
                mov     [bp+6], ax

loc_6D6:                                ; CODE XREF: LOADMODULE+312↑j
                                        ; LOADMODULE+318↑j
                sub     ax, ax
                push    ax
                push    word ptr [bp+8]
                push    word ptr [bp+6]
                push    word ptr [bp-0A0h]
                push    word ptr [bp-9Eh]
                call    STARTMODULE
                mov     [bp-16h], ax
                jmp     short loc_6F8
; ---------------------------------------------------------------------------

loc_6EF:                                ; CODE XREF: LOADMODULE+30C↑j
                push    word ptr [bp-9Eh]
                nop
                push    cs
                call    near ptr _LCLOSE

loc_6F8:                                ; CODE XREF: LOADMODULE+339↑j
                push    word ptr [bp-0A0h]
                call    TRIMEXEHEADER
                cmp     word ptr [bp-16h], 0
                jz      short loc_708
                jmp     loc_7D3
; ---------------------------------------------------------------------------

loc_708:                                ; CODE XREF: LOADMODULE+34F↑j
                push    word ptr [bp-0A0h]
                call    DELMODULE
                jmp     loc_7D3
; ---------------------------------------------------------------------------

loc_712:                                ; CODE XREF: LOADMODULE+E3↑j
                mov     ax, [bp-16h]
                mov     [bp-0A0h], ax
                mov     word ptr [bp-16h], 0
                mov     dx, ax
                sub     ax, ax
                mov     [bp-1Ch], ax
                mov     [bp-1Ah], dx
                cmp     word ptr [bp+8], 0FFFFh
                jnz     short loc_748
                cmp     word ptr [bp+6], 0FFFFh
                jnz     short loc_748
                les     bx, [bp-1Ch]
                test    word ptr es:[bx+0Ch], 8000h
                jnz     short loc_742
                jmp     loc_4D2
; ---------------------------------------------------------------------------

loc_742:                                ; CODE XREF: LOADMODULE+389↑j
                mov     [bp+8], ax
                mov     [bp+6], ax

loc_748:                                ; CODE XREF: LOADMODULE+378↑j
                                        ; LOADMODULE+37E↑j
                les     bx, [bp-1Ch]
                test    byte ptr es:[bx+0Ch], 2
                jz      short loc_7A1
                push    word ptr [bp-0A0h]
                call    GETINSTANCE
                mov     [bp-0Ch], ax
                push    word ptr [bp-0A0h]
                call    INCEXEUSAGE
                push    word ptr [bp-0A0h]
                call    ALLOCALLSEGS
                mov     [bp-0Ah], ax
                cmp     ax, 1
                jnz     short loc_798
                push    word ptr [bp-0Ch]
                push    word ptr [bp+8]
                push    word ptr [bp+6]
                push    word ptr [bp-0A0h]
                mov     ax, 0FFFFh
                push    ax
                call    STARTMODULE
                mov     [bp-16h], ax
                or      ax, ax
                jnz     short loc_7D3
                push    word ptr [bp-0A0h]
                nop
                push    cs
                call    near ptr FREEMODULE
                jmp     short loc_7D3
; ---------------------------------------------------------------------------

loc_798:                                ; CODE XREF: LOADMODULE+3BC↑j
                push    word ptr [bp-0A0h]
                call    DECEXEUSAGE
                jmp     short loc_7D3
; ---------------------------------------------------------------------------

loc_7A1:                                ; CODE XREF: LOADMODULE+39C↑j
                les     bx, [bp-1Ch]
                cmp     word ptr es:[bx+0Eh], 0
                jz      short loc_7C2
                push    word ptr [bp-0A0h]
                push    word ptr es:[bx+0Eh]
                mov     ax, 0FFFFh
                push    ax
                push    ax
                call    LOADSEGMENT
                or      ax, ax
                jnz     short loc_7C2
                jmp     loc_4D2
; ---------------------------------------------------------------------------

loc_7C2:                                ; CODE XREF: LOADMODULE+3F5↑j
                                        ; LOADMODULE+409↑j
                push    word ptr [bp-0A0h]
                call    INCEXEUSAGE
                push    word ptr [bp-0A0h]
                call    GETINSTANCE
                mov     [bp-16h], ax

loc_7D3:                                ; CODE XREF: LOADMODULE+351↑j
                                        ; LOADMODULE+35B↑j ...
                mov     ax, [bp-16h]

loc_7D6:                                ; CODE XREF: LOADMODULE+A7↑j
                                        ; LOADMODULE+D1↑j ...
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    8
LOADMODULE      endp



; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

STARTLIBRARY    proc near               ; CODE XREF: STARTMODULE+88↑p

arg_2           = word ptr  6
arg_4           = dword ptr  8
arg_8           = word ptr  0Ch

                push    bp
                mov     bp, sp
                push    si
                push    di
                mov     es, [bp+arg_8]
                push    es
                call    GETINSTANCE
                push    word ptr es:10h
                mov     di, ax
                push    [bp+arg_2]
                call    MYLOCK
                mov     [bp+arg_2], ax
                push    di
                call    MYLOCK
                mov     ds, ax
                assume ds:nothing
                pop     cx
                les     si, [bp+arg_4]
                les     si, es:[si+2]
                call    dword ptr [bp+4]
                or      ax, ax
                jz      short loc_2919
                mov     ax, di

loc_2919:                               ; CODE XREF: STARTLIBRARY+2F↑j
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    0Ah
STARTLIBRARY    endp



; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

STARTTASK       proc near               ; CODE XREF: STARTMODULE+AD↑p

arg_2           = word ptr  6
arg_4           = word ptr  8
arg_6           = word ptr  0Ah
arg_8           = word ptr  0Ch

                push    bp
                mov     bp, sp
                push    di
                xor     di, di
                cmp     [bp+arg_8], di
                jz      short loc_298D
                push    ds
                push    [bp+arg_4]
                call    GETINSTANCE
                mov     di, ax
                mov     ds, [bp+arg_8]
                mov     ds:10h, ax
                push    [bp+arg_2]
                call    MYLOCK
                or      ax, ax
                jz      short loc_2996
                mov     [bp+arg_2], ax
                push    di
                call    MYLOCK
                mov     es, [bp+arg_4]
                lds     bx, ds:2
                mov     [bx+0Ah], di
                mov     [bx+0Eh], ax
                mov     cx, [bp+arg_6]
                mov     [bx+0Ch], cx
                mov     ax, es:12h
                mov     [bx+2], ax
                mov     ax, es:10h
                mov     [bx+6], ax
                les     ax, [bp+4]
                mov     word ptr [bx+14h], es
                mov     [bx+12h], ax
                inc     word ptr [bx+10h]
                pop     ds
                cmp     cs:FBOOTING, 0
                jnz     short loc_298D
                push    [bp+arg_4]
                call    TRIMEXEHEADER
                nop
                push    cs
                call    near ptr YIELD

loc_298D:                               ; CODE XREF: STARTTASK+9↑j
                                        ; STARTTASK+5F↑j ...
                mov     ax, di
                pop     di
                mov     sp, bp
                pop     bp
                retn    0Ah
; ---------------------------------------------------------------------------

loc_2996:                               ; CODE XREF: STARTTASK+22↑j
                mov     ds:7Eh, ax
                push    ds
                call    DELETETASK
                push    ds
                nop
                push    cs
                call    near ptr GLOBALFREE
                xor     di, di
                jmp     short loc_298D
STARTTASK       endp
