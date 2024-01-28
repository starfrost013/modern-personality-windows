
;
; External Entry #91 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public INITTASK
INITTASK        proc far
                pop     ax              ; KERNEL_91
                pop     dx
                mov     ss:0Ch, sp
                mov     ss:0Eh, sp
                sub     bx, sp
                neg     bx
                add     bx, 96h
                mov     ss:0Ah, bx
                xor     bp, bp
                push    bp
                mov     bp, sp
                push    dx
                push    ax
                inc     bp
                push    bp
                mov     bp, sp
                push    ds
                jcxz    short loc_29DC
                xor     ax, ax
                push    es
                push    ax
                push    ax
                push    cx
                nop
                push    cs
                call    near ptr LOCALINIT
                pop     es
                jcxz    short loc_2A4B

loc_29DC:                               ; CODE XREF: INITTASK+25↑j
                xor     dx, dx
                xchg    dl, cs:FBOOTING
                or      dx, dx
                jz      short loc_2A0A
                push    es
                push    ds
                nop
                push    cs
                call    near ptr UNLOCKSEGMENT
                call    CALCMAXNRSEG
                xor     dx, dx
                push    dx
                push    dx
                nop
                push    cs
                call    near ptr GLOBALCOMPACT
                xor     dx, dx
                push    dx
                push    dx
                nop
                push    cs
                call    near ptr GLOBALCOMPACT
                push    ds
                nop
                push    cs
                call    near ptr LOCKSEGMENT
                pop     es

loc_2A0A:                               ; CODE XREF: INITTASK+3E↑j
                mov     bx, 80h
                mov     cx, bx
                cmp     bh, es:[bx]
                jz      short loc_2A31

loc_2A14:                               ; CODE XREF: INITTASK+73↓j
                                        ; INITTASK+77↓j
                inc     bx
                mov     al, es:[bx]
                cmp     al, 20h ; ' '
                jz      short loc_2A14
                cmp     al, 9
                jz      short loc_2A14
                mov     cx, bx
                dec     bx

loc_2A23:                               ; CODE XREF: INITTASK+84↓j
                inc     bl
                jz      short loc_2A31
                cmp     byte ptr es:[bx], 0Dh
                jnz     short loc_2A23
                mov     byte ptr es:[bx], 0

loc_2A31:                               ; CODE XREF: INITTASK+6B↑j
                                        ; INITTASK+7E↑j
                mov     bx, cx
                mov     cx, ss:0Ah
                mov     dx, 1
                cmp     word ptr es:5Ch, 2
                jnz     short loc_2A48
                mov     dx, es:5Eh

loc_2A48:                               ; CODE XREF: INITTASK+9A↑j
                mov     ax, 1

loc_2A4B:                               ; CODE XREF: INITTASK+33↑j
                mov     sp, bp
                pop     bp
                dec     bp
                retf
INITTASK        endp



                public GETCURRENTTASK
GETCURRENTTASK  proc far
                mov     ax, cs:CURTDB   ; KERNEL_36
                mov     dx, cs:HEADTDB
                retf
GETCURRENTTASK  endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

CREATETASK      proc far                ; CODE XREF: STARTMODULE+9D↑p

arg_2           = word ptr  8
arg_4           = word ptr  0Ah
arg_6           = word ptr  0Ch

                inc     bp
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                mov     si, [bp+arg_4]
                cmp     [bp+arg_6], 0
                jz      short loc_3677
                xor     si, si

loc_3677:                               ; CODE XREF: CREATETASK+E↑j
                cmp     [bp+arg_2], 0
                jz      short loc_3681
                add     si, 100h

loc_3681:                               ; CODE XREF: CREATETASK+16↑j
                add     si, 8Fh
                xor     ax, ax
                mov     al, cs:FEMM
                add     si, ax
                and     si, 0FFF0h
                mov     di, si
                mov     cl, 4
                shr     si, cl
                xor     dx, dx
                mov     cx, 2040h
                push    cx
                push    dx
                push    di
                nop
                push    cs
                call    near ptr GLOBALALLOC
                or      ax, ax
                jnz     short loc_36AB
                jmp     loc_378F
; ---------------------------------------------------------------------------

loc_36AB:                               ; CODE XREF: CREATETASK+41↑j
                dec     ax
                mov     ds, ax
                inc     ax
                mov     ds:1, ax
                mov     ds, ax
                mov     ax, [bp+arg_4]
                mov     dx, [bp+arg_6]
                or      dx, dx
                jnz     short loc_36D5
                mov     ax, si
                mov     cl, 4
                shl     ax, cl
                mov     dx, ds
                mov     cx, ax
                sub     cx, [bp+arg_4]
                mov     ds:0Ah, cx
                mov     ds:0Eh, ax
                mov     ds:0Ch, ax

loc_36D5:                               ; CODE XREF: CREATETASK+57↑j
                sub     ax, 16h
                mov     ds:2, ax
                push    dx
                call    MYLOCK
                mov     ds:4, ax
                mov     si, 1
                les     di, [bp+6]
                mov     ax, es
                or      ax, di
                jz      short loc_3744
                xor     ax, ax
                mov     al, cs:FEMM
                add     ax, 8Fh
                mov     cl, 4
                shr     ax, cl
                mov     si, ds
                add     si, ax
                mov     dx, cs:TOPPDB
                mov     bx, di
                mov     cx, 100h
                push    dx
                push    si
                push    es
                push    bx
                push    cx
                nop
                push    cs
                call    near ptr BUILDPDB
                mov     ax, si
                mov     es, ax
                xchg    ax, cs:HEADPDB
                mov     es:42h, ax
                les     di, [bp+6]
                push    ds
                push    si
                lds     si, es:[di+6]
                mov     di, 5Ch ; '\'
                pop     es
                mov     cx, ds
                or      cx, si
                jz      short loc_3741
                mov     cx, [si]
                inc     cx
                inc     cx
                cmp     cx, 24h ; '$'
                jbe     short loc_373F
                mov     cx, 24h ; '$'

loc_373F:                               ; CODE XREF: CREATETASK+D5↑j
                rep movsb

loc_3741:                               ; CODE XREF: CREATETASK+CC↑j
                mov     si, es
                pop     ds

loc_3744:                               ; CODE XREF: CREATETASK+87↑j
                push    ax
                cmp     cs:FEMM, 0
                jz      short loc_3753
                mov     word ptr ds:30h, 80h

loc_3753:                               ; CODE XREF: CREATETASK+E6↑j
                push    ds
                call    SAVESTATE
                push    ds
                call    INSERTTASK
                or      si, si
                jz      short loc_3763
                mov     ds:32h, si

loc_3763:                               ; CODE XREF: CREATETASK+F8↑j
                les     di, ds:2
                mov     ax, ds:32h
                pop     word ptr es:[di+8]
                mov     es:[di+4], ax
                mov     word ptr es:[di+10h], 0
                mov     word ptr ds:34h, 80h
                mov     ds:36h, ax
                mov     word ptr ds:6, 1
                mov     word ptr ds:7Eh, 4454h
                mov     ax, ds

loc_378F:                               ; CODE XREF: CREATETASK+43↑j
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    8
CREATETASK      endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

INSERTTASK      proc near               ; CODE XREF: CREATETASK+F3↑p
                                        ; BOOTSCHEDULE+62↓p ...

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                push    ds
                mov     es, [bp+arg_0]
                mov     ax, cs:HEADTDB
                or      ax, ax
                jnz     short loc_37B2
                mov     cs:CURTDB, es
                jmp     short loc_37C3
; ---------------------------------------------------------------------------

loc_37B2:                               ; CODE XREF: INSERTTASK+D↑j
                mov     ds, ax
                mov     bl, es:8
                cmp     bl, ds:8
                jg      short loc_37CA
                mov     es:0, ax

loc_37C3:                               ; CODE XREF: INSERTTASK+14↑j
                mov     cs:HEADTDB, es
                jmp     short loc_37E7
; ---------------------------------------------------------------------------

loc_37CA:                               ; CODE XREF: INSERTTASK+21↑j
                                        ; INSERTTASK+3E↓j
                mov     ds, ax
                mov     ax, ds:0
                or      ax, ax
                jz      short loc_37DC
                mov     es, ax
                cmp     bl, es:8
                jg      short loc_37CA

loc_37DC:                               ; CODE XREF: INSERTTASK+35↑j
                mov     es, [bp+arg_0]
                mov     word ptr ds:0, es
                mov     es:0, ax

loc_37E7:                               ; CODE XREF: INSERTTASK+2C↑j
                pop     ds
                mov     sp, bp
                pop     bp
                retn    2
INSERTTASK      endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

DELETETASK      proc near               ; CODE XREF: STARTTASK+79↑p
                                        ; BOOTSCHEDULE+5E↓p ...

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                push    ds
                mov     dx, [bp+arg_0]
                mov     ax, cs:HEADTDB
                mov     ds, ax
                cmp     ax, dx
                jnz     short loc_3808
                mov     ax, ds:0
                mov     cs:HEADTDB, ax
                jmp     short loc_381E
; ---------------------------------------------------------------------------

loc_3808:                               ; CODE XREF: DELETETASK+F↑j
                                        ; DELETETASK+25↓j
                mov     ds, ax
                mov     ax, ds:0
                or      ax, ax
                jz      short loc_381E
                cmp     ax, dx
                jnz     short loc_3808
                mov     es, ax
                mov     ax, es:0
                mov     ds:0, ax

loc_381E:                               ; CODE XREF: DELETETASK+18↑j
                                        ; DELETETASK+21↑j
                mov     ax, dx
                pop     ds
                mov     sp, bp
                pop     bp
                retn    2
DELETETASK      endp

;
; External Entry #33 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public LOCKCURRENTTASK
LOCKCURRENTTASK proc far
                mov     bx, sp          ; KERNEL_33
                mov     ax, ss:[bx+4]
                or      ax, ax
                jz      short loc_3993
                mov     ax, cs:CURTDB

loc_3993:                               ; CODE XREF: LOCKCURRENTTASK+8↑j
                mov     cs:LOCKTDB, ax
                retf    2
LOCKCURRENTTASK endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public BUILDPDB
BUILDPDB        proc far                ; CODE XREF: CREATETASK+AB↑p

var_4           = byte ptr -4
arg_0           = word ptr  6
arg_2           = dword ptr  8
arg_6           = word ptr  0Ch
arg_8           = word ptr  0Eh

                inc     bp              ; KERNEL_44
                push    bp
                mov     bp, sp
                push    ds
                sub     sp, 2
                push    si
                push    di
                mov     ah, 19h
                int     21h             ; DOS - GET DEFAULT DISK NUMBER
                mov     dl, al
                mov     ah, 0Eh
                pushf
                cli
                call    cs:PREVINT21PROC
                mov     [bp+var_4], al
                les     di, cs:PCURRENTPDB
                push    word ptr es:[di]
                mov     bx, [bp+arg_8]
                mov     ah, 50h ; 'P'
                pushf
                cli
                call    cs:PREVINT21PROC
                mov     dx, [bp+arg_6]
                mov     si, [bp+arg_0]
                mov     ah, 55h ; 'U'
                int     21h             ; DOS - 2+ internal - CREATE PSP
                                        ; DX = segment number at which to set up PSP
                                        ; SI = (DOS 3+) value to place in memory size field at DX:[0002h]
                pop     bx
                mov     ah, 50h ; 'P'
                pushf
                cli
                call    cs:PREVINT21PROC
                mov     es, dx
                add     si, dx
                mov     ax, [bp+arg_8]
                mov     es:16h, ax
                mov     es:2, si
                mov     ax, [bp+arg_0]
                cmp     ax, 0FFFh
                jbe     short loc_480E
                mov     ax, 0FFFh

loc_480E:                               ; CODE XREF: BUILDPDB+5A↑j
                sub     ax, 10h
                mov     bx, cs
                mov     cl, 4
                mov     dx, 4046h
                mov     si, dx
                shr     si, cl
                add     bx, si
                sub     bx, ax
                shl     ax, cl
                and     dx, 0Fh
                add     ax, dx
                mov     es:6, ax
                mov     es:8, bx
                mov     es:51h, ax
                mov     es:53h, bx
                mov     word ptr es:0Ah, offset loc_478C
                mov     word ptr es:0Ch, cs
                xor     cx, cx
                mov     es:48h, cx
                mov     es:4Ah, cx
                cld
                lds     si, [bp+arg_2]
                lds     si, [si+6]
                mov     cx, 6
                mov     di, 5Ch ; '\'
                mov     dl, [si]
                rep movsw
                xor     ax, ax
                stosw
                stosw
                lds     si, [bp+arg_2]
                lds     si, [si+0Ah]
                mov     di, 6Ch ; 'l'
                mov     dh, [si]
                mov     cl, 6
                rep movsw
                stosw
                stosw
                lds     si, [bp+arg_2]
                lds     si, [si+2]
                mov     cx, 80h
                mov     di, cx
                rep movsb
                mov     ax, dx
                xor     dx, dx
                mov     dh, [bp+var_4]
                cmp     ah, dh
                mov     ah, dl
                jbe     short loc_4894
                dec     ah

loc_4894:                               ; CODE XREF: BUILDPDB+E1↑j
                cmp     al, dh
                mov     al, dl
                jbe     short loc_489C
                dec     al

loc_489C:                               ; CODE XREF: BUILDPDB+E9↑j
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    0Ah
BUILDPDB        endp

;
; External Entry #37 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public GETCURRENTPDB
GETCURRENTPDB   proc far
                push    ds              ; KERNEL_37
                push    si
                lds     si, cs:PCURRENTPDB
                lodsw
                mov     dx, cs:TOPPDB
                pop     si
                pop     ds
                retf
GETCURRENTPDB   endp