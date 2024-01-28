
; =============== S U B R O U T I N E =======================================


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
                retn
GETCHKSUMADDR   endp


; =============== S U B R O U T I N E =======================================


CHECKSEGCHKSUM  proc near               ; CODE XREF: LOADSEGMENT+155↓p
                                        ; PATCHTHUNKS+8↓p ...
                push    ax
                call    GETCHKSUMADDR
                pop     ax
                jcxz    short locret_E1F
                shl     cx, 1
                shl     cx, 1
                shl     cx, 1
                push    ds
                push    si
                mov     ds, ax
                xor     si, si
                xor     dx, dx
                cld

loc_DDE:                                ; CODE XREF: CHECKSEGCHKSUM+19↓j
                lodsw
                xor     dx, ax
                loop    loc_DDE
                mov     ax, ds
                pop     si
                pop     ds
                mov     cx, dx
                xchg    cx, es:[bx]
                jcxz    short locret_E1F
                cmp     cx, dx
                jz      short locret_E1F

BADSEGCONT:
                mov     bx, ax
                mov     ax, 409h
                push    ax
                mov     ax, offset SZSEGMENTCONTENTSTRASHED ; "Segment contents trashed "
                push    cs
                push    ax
                push    es
                push    bx
                call    KERNELERROR
                jmp     short locret_E1F
; ---------------------------------------------------------------------------
SZSEGMENTCONTENTSTRASHED db 'Segment contents trashed ',0
                                        ; DATA XREF: CHECKSEGCHKSUM+30↑o
                db 24h
; ---------------------------------------------------------------------------

locret_E1F:                             ; CODE XREF: CHECKSEGCHKSUM+5↑j
                                        ; CHECKSEGCHKSUM+24↑j ...
                retn
CHECKSEGCHKSUM  endp


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
                retn    4
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
                retn    2
ALLOCALLSEGS    endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

SEGLOAD         proc near               ; CODE XREF: LOADSEGMENT+B6↓p
                                        ; LOADFIXEDSEG+8F↓p

var_8           = word ptr -8
var_6           = word ptr -6
var_4           = word ptr -4
var_2           = word ptr -2
arg_0           = word ptr  4
arg_2           = word ptr  6
arg_4           = word ptr  8
arg_6           = dword ptr  0Ah

                push    bp
                mov     bp, sp
                sub     sp, 8
                push    si
                push    di
                mov     [bp+var_8], 1
                les     si, [bp+arg_6]
                push    es
                push    word ptr es:[si+8]
                call    MYLOCK
                pop     es
                or      ax, ax
                jnz     short loc_FB6
                push    es
                xor     ax, ax
                push    word ptr es:[si+8]
                push    ax
                push    word ptr es:[si+6]
                push    ax
                nop
                push    cs
                call    near ptr GLOBALREALLOC
                pop     es
                cmp     es:[si+8], ax
                jz      short loc_FA9

loc_FA6:                                ; CODE XREF: SEGLOAD+44↓j
                jmp     loc_1033
; ---------------------------------------------------------------------------

loc_FA9:                                ; CODE XREF: SEGLOAD+34↑j
                push    es
                push    word ptr es:[si+8]
                call    MYLOCK
                pop     es
                or      ax, ax
                jz      short loc_FA6

loc_FB6:                                ; CODE XREF: SEGLOAD+1B↑j
                mov     [bp+var_2], ax

loc_FB9:                                ; CODE XREF: SEGLOAD+15F↓j
                push    es
                push    si
                push    ds
                mov     di, es:[si+2]
                mov     bx, [bp+arg_2]
                cmp     [bp+arg_0], bx
                jz      short loc_FEA
                push    di
                mov     [bp+var_6], di
                and     [bp+var_6], 0Fh
                mov     cl, 4
                shr     di, cl
                add     di, bx
                mov     [bp+var_4], di
                pop     cx
                mov     ds, bx
                mov     es, [bp+var_2]
                xor     si, si
                xor     di, di
                cld
                rep movsb
                jmp     loc_1070
; ---------------------------------------------------------------------------

loc_FEA:                                ; CODE XREF: SEGLOAD+56↑j
                mov     ax, es:[si]
                xor     dx, dx
                mov     cx, es:32h

loc_FF4:                                ; CODE XREF: SEGLOAD+88↓j
                shl     ax, 1
                rcl     dx, 1
                loop    loc_FF4
                mov     cx, dx
                mov     dx, ax
                mov     ax, 4200h
                int     21h             ; DOS - 2+ - MOVE FILE READ/WRITE POINTER (LSEEK)
                                        ; AL = method: offset from beginning of file
                jb      short loc_1030
                mov     cx, di
                mov     ds, [bp+var_2]
                xor     dx, dx
                mov     ah, 3Fh ; '?'
                int     21h             ; DOS - 2+ - READ FROM FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to read
                                        ; DS:DX -> buffer
                jb      short loc_1030
                cmp     ax, cx
                jnz     short loc_1030
                test    word ptr es:[si+4], 100h
                jz      short loc_1070
                push    ss
                pop     ds
                lea     dx, [bp+var_6]
                mov     cx, 2
                mov     ah, 3Fh ; '?'
                int     21h             ; DOS - 2+ - READ FROM FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to read
                                        ; DS:DX -> buffer
                jb      short loc_1030
                cmp     ax, cx
                jz      short loc_1070

loc_1030:                               ; CODE XREF: SEGLOAD+93↑j
                                        ; SEGLOAD+A0↑j ...
                pop     ds
                pop     si
                pop     es

loc_1033:                               ; CODE XREF: SEGLOAD:loc_FA6↑j
                xor     bx, bx
                mov     ax, 409h
                push    ax
                mov     ax, offset SZBADSEGREAD ; "Error reading segment contents from "
                push    cs
                push    ax
                push    es
                push    bx
                call    KERNELERROR
                jmp     short loc_106B
; ---------------------------------------------------------------------------
SZBADSEGREAD    db 'Error reading segment contents from ',0
                                        ; DATA XREF: SEGLOAD+C9↑o
                db 24h
; ---------------------------------------------------------------------------

loc_106B:                               ; CODE XREF: SEGLOAD+D3↑j
                xor     ax, ax
                jmp     loc_120F
; ---------------------------------------------------------------------------

loc_1070:                               ; CODE XREF: SEGLOAD+77↑j
                                        ; SEGLOAD+AC↑j ...
                mov     ax, [bp+var_2]
                dec     ax
                mov     es, ax
                mov     ax, es:3
                mov     cl, 4
                shl     ax, cl
                sub     ax, di
                jz      short loc_108C
                mov     es, [bp+var_2]
                mov     cx, ax
                xor     ax, ax
                cld
                rep stosb

loc_108C:                               ; CODE XREF: SEGLOAD+110↑j
                mov     ds, [bp+var_2]
                xor     si, si
                mov     cx, di
                shr     cx, 1
                xor     dx, dx
                cld

loc_1098:                               ; CODE XREF: SEGLOAD+12B↓j
                lodsw
                xor     dx, ax
                loop    loc_1098
                pop     ds
                pop     si
                pop     es
                mov     ax, es:[si+4]
                and     ax, 1
                jz      short loc_10AC
                jmp     loc_11BD
; ---------------------------------------------------------------------------

loc_10AC:                               ; CODE XREF: SEGLOAD+137↑j
                mov     cx, [bp+arg_4]
                dec     cx
                shl     cx, 1
                shl     cx, 1
                mov     di, es:3Ah
                add     di, cx
                mov     cx, dx
                xchg    cx, es:[di]
                jcxz    short loc_1104
                cmp     cx, dx
                jz      short loc_1104
                dec     [bp+var_8]
                jl      short loc_10D2
                mov     ah, 0Dh
                int     21h             ; DOS - DISK RESET
                jmp     loc_FB9
; ---------------------------------------------------------------------------

loc_10D2:                               ; CODE XREF: SEGLOAD+159↑j
                xor     bx, bx
                mov     ax, 409h
                push    ax
                mov     ax, offset SZSEGMENTCONTENTSINVALID ; "Segment contents invalid "
                push    cs
                push    ax
                push    es
                push    bx
                call    KERNELERROR
                jmp     short loc_10FF
; ---------------------------------------------------------------------------
SZSEGMENTCONTENTSINVALID db 'Segment contents invalid ',0
                                        ; DATA XREF: SEGLOAD+168↑o
                db 24h
; ---------------------------------------------------------------------------

loc_10FF:                               ; CODE XREF: SEGLOAD+172↑j
                xor     ax, ax
                jmp     loc_120F
; ---------------------------------------------------------------------------

loc_1104:                               ; CODE XREF: SEGLOAD+150↑j
                                        ; SEGLOAD+154↑j
                mov     word ptr es:[di+2], 0
                mov     di, es:8
                or      di, di
                jz      short loc_111C
                push    word ptr es:[di+8]
                call    MYLOCK
                mov     di, ax

loc_111C:                               ; CODE XREF: SEGLOAD+1A1↑j
                mov     es, [bp+var_2]
                push    ds
                push    si
                mov     ds, word ptr [bp+arg_6+2]
                mov     si, ds:4
                xor     ax, ax
                cld

loc_112B:                               ; CODE XREF: SEGLOAD+1C3↓j
                                        ; SEGLOAD+1DA↓j ...
                lodsb
                mov     cx, ax
                jcxz    short loc_1196
                lodsb
                cmp     al, 0
                jz      short loc_112B
                mov     dx, 0Bh
                cmp     al, 0FFh
                jz      short loc_114C
                mov     dx, 3

loc_113F:
                cmp     [bp+arg_4], ax
                jz      short loc_115F
                add     si, cx
                shl     cx, 1
                add     si, cx
                jmp     short loc_112B
; ---------------------------------------------------------------------------

loc_114C:                               ; CODE XREF: SEGLOAD+1CA↑j
                                        ; SEGLOAD+243↓j
                cmp     dx, 0Bh
                jnz     short loc_115F
                cmp     byte ptr [si+6], 0EAh
                jz      short loc_11B1
                mov     al, [si+8]
                cmp     [bp+arg_4], ax
                jnz     short loc_11B1

loc_115F:                               ; CODE XREF: SEGLOAD+1D2↑j
                                        ; SEGLOAD+1DF↑j
                or      di, di
                jz      short loc_11A0
                mov     bx, dx
                mov     bx, [bx+si-2]
                cmp     word ptr es:[bx], 581Eh
                jz      short loc_1176
                cmp     word ptr es:[bx], 0D88Ch
                jnz     short loc_11A0

loc_1176:                               ; CODE XREF: SEGLOAD+1FD↑j
                cmp     byte ptr es:[bx+2], 90h
                jnz     short loc_11A0
                test    byte ptr [si], 2
                jnz     short loc_1198
                test    byte ptr ds:0Ch, 2
                jz      short loc_11A0
                test    byte ptr [si], 1
                jz      short loc_11A0
                mov     word ptr es:[bx], 9090h
                jmp     short loc_11A0
; ---------------------------------------------------------------------------
                align 2

loc_1196:                               ; CODE XREF: SEGLOAD+1BE↑j
                jmp     short loc_11B8
; ---------------------------------------------------------------------------

loc_1198:                               ; CODE XREF: SEGLOAD+210↑j
                mov     byte ptr es:[bx], 0B8h
                mov     es:[bx+1], di

loc_11A0:                               ; CODE XREF: SEGLOAD+1F1↑j
                                        ; SEGLOAD+204↑j ...
                cmp     dx, 3
                jz      short loc_11B1
                mov     byte ptr [si+6], 0EAh
                mov     bx, es
                xchg    bx, [si+9]
                mov     [si+7], bx

loc_11B1:                               ; CODE XREF: SEGLOAD+1E5↑j
                                        ; SEGLOAD+1ED↑j ...
                add     si, dx
                loop    loc_114C
                jmp     loc_112B
; ---------------------------------------------------------------------------

loc_11B8:                               ; CODE XREF: SEGLOAD:loc_1196↑j
                mov     es, word ptr [bp+arg_6+2]
                pop     si
                pop     ds

loc_11BD:                               ; CODE XREF: SEGLOAD+139↑j
                or      byte ptr es:[si+4], 4
                test    word ptr es:[si+8], 1
                jnz     short loc_11D7
                mov     bx, es:3Eh
                add     bx, [bp+arg_4]
                mov     byte ptr es:[bx-1], 0

loc_11D7:                               ; CODE XREF: SEGLOAD+258↑j
                mov     bx, es:26h
                inc     bx
                mov     dx, es:[si+4]
                xor     ax, ax
                and     dx, 1
                jz      short loc_11F7
                test    byte ptr es:0Ch, 2
                jz      short loc_11F7
                mov     al, es:2
                dec     al

loc_11F7:                               ; CODE XREF: SEGLOAD+277↑j
                                        ; SEGLOAD+27F↑j
                mov     cx, [bp+arg_4]
                dec     cx
                push    es
                push    bx
                push    cx
                push    [bp+var_2]
                push    ax
                push    dx
                call    DEBUGDEFINESEGMENT
                mov     dx, [bp+var_4]
                mov     cx, [bp+var_6]
                mov     ax, [bp+var_2]

loc_120F:                               ; CODE XREF: SEGLOAD+FD↑j
                                        ; SEGLOAD+191↑j
                or      ax, ax
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    0Ah
SEGLOAD         endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

LOADSEGMENT     proc near               ; CODE XREF: STARTMODULE+30↑p
                                        ; LOADMODULE+2D9↑p ...

var_A           = word ptr -0Ah
var_8           = word ptr -8
var_6           = word ptr -6
var_4           = word ptr -4
var_2           = word ptr -2
arg_0           = word ptr  4
arg_2           = word ptr  6
arg_4           = word ptr  8
arg_6           = word ptr  0Ah

                push    bp
                mov     bp, sp
                sub     sp, 0Ah
                push    si
                push    di
                xor     ax, ax
                mov     [bp+var_4], ax
                not     ax
                mov     [bp+var_2], ax
                mov     es, [bp+arg_6]
                mov     si, [bp+arg_4]
                dec     si
                cmp     es:1Ch, si
                jbe     short loc_1284
                shl     si, 1
                mov     bx, si
                shl     si, 1
                shl     si, 1
                add     si, bx
                add     si, es:22h
                test    word ptr es:[si+4], 400h
                jz      short loc_1270
                mov     bx, es:8
                test    byte ptr es:[bx+4], 44h
                jnz     short loc_1270
                push    es
                mov     bx, 0FFFFh
                push    es
                push    word ptr es:0Eh
                push    bx
                push    bx
                call    LOADSEGMENT
                pop     es
                or      ax, ax
                jz      short loc_1284

loc_1270:                               ; CODE XREF: LOADSEGMENT+35↑j
                                        ; LOADSEGMENT+41↑j
                mov     bx, es:[si+4]
                test    bl, 2
                jnz     short loc_1286
                push    bx
                push    es
                push    si
                call    ALLOCSEG
                pop     bx
                or      ax, ax
                jnz     short loc_1295

loc_1284:                               ; CODE XREF: LOADSEGMENT+1E↑j
                                        ; LOADSEGMENT+55↑j
                jmp     short loc_12C2
; ---------------------------------------------------------------------------

loc_1286:                               ; CODE XREF: LOADSEGMENT+5E↑j
                test    bl, 4
                jz      short loc_1295
                mov     ax, es:[si+8]
                mov     [bp+var_8], ax

loc_1292:                               ; CODE XREF: LOADSEGMENT+C7↓j
                                        ; LOADSEGMENT+D1↓j
                jmp     loc_13B4
; ---------------------------------------------------------------------------

loc_1295:                               ; CODE XREF: LOADSEGMENT+69↑j
                                        ; LOADSEGMENT+70↑j
                mov     ax, [bp+arg_2]
                inc     ax
                jz      short loc_12A3
                dec     ax
                cmp     [bp+arg_0], ax
                jnz     short loc_12C5
                jmp     short loc_12B7
; ---------------------------------------------------------------------------

loc_12A3:                               ; CODE XREF: LOADSEGMENT+80↑j
                mov     dx, es:0Ah
                mov     bx, 0A400h
                push    es
                push    es
                push    dx
                push    es
                push    dx
                push    bx
                nop
                push    cs
                call    near ptr OPENFILE
                pop     es

loc_12B7:                               ; CODE XREF: LOADSEGMENT+88↑j
                mov     [bp+var_2], ax
                mov     [bp+arg_0], ax
                cmp     ax, 0FFFFh
                jnz     short loc_12C5

loc_12C2:                               ; CODE XREF: LOADSEGMENT:loc_1284↑j
                jmp     loc_13BC
; ---------------------------------------------------------------------------

loc_12C5:                               ; CODE XREF: LOADSEGMENT+86↑j
                                        ; LOADSEGMENT+A7↑j
                push    es
                push    es
                push    si
                push    [bp+arg_4]
                push    ax
                push    [bp+arg_0]
                call    SEGLOAD
                push    cx
                push    dx
                push    ax
                call    MYLOCK
                mov     [bp+var_8], dx
                pop     dx
                pop     cx
                pop     es
                or      ax, ax
                jz      short loc_1292
                mov     bx, es:[si+4]
                test    bx, 100h
                jz      short loc_1292
                and     bx, 1
                mov     [bp+var_A], bx
                push    es
                push    si
                mov     bx, [bp+var_2]
                inc     bx
                jnz     short loc_1306
                mov     es, dx
                mov     si, cx
                lods    word ptr es:[si]
                mov     [bp+var_6], ax
                jmp     short loc_1340
; ---------------------------------------------------------------------------

loc_1306:                               ; CODE XREF: LOADSEGMENT+E0↑j
                dec     bx
                mov     [bp+var_6], cx
                shl     cx, 1
                shl     cx, 1
                shl     cx, 1
                push    bx
                push    cx
                mov     ax, 22h ; '"'
                xor     bx, bx
                push    ax
                push    bx
                push    cx
                nop
                push    cs
                call    near ptr GLOBALALLOC
                mov     [bp+var_4], ax
                push    ax
                call    MYLOCK
                pop     cx
                pop     bx
                or      ax, ax
                jz      short loc_133C
                push    ds
                mov     ds, ax
                xor     dx, dx
                mov     ah, 3Fh ; '?'
                int     21h             ; DOS - 2+ - READ FROM FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to read
                                        ; DS:DX -> buffer
                pop     ds
                jb      short loc_1374
                cmp     ax, cx
                jnz     short loc_1374

loc_133C:                               ; CODE XREF: LOADSEGMENT+111↑j
                xor     si, si
                mov     es, si
                assume es:cseg01

loc_1340:                               ; CODE XREF: LOADSEGMENT+EB↑j
                push    [bp+arg_6]
                push    [bp+var_4]
                push    es
                push    si
                push    [bp+var_6]
                push    [bp+var_8]
                push    [bp+var_A]
                push    [bp+var_2]
                call    SEGRELOC

loc_1357:                               ; CODE XREF: LOADSEGMENT+199↓j
                push    ax
                push    [bp+var_4]
                nop
                push    cs
                call    near ptr GLOBALFREE
                pop     ax
                pop     si
                pop     es
                assume es:nothing
                or      ax, ax
                jz      short loc_13BC
                push    es
                push    [bp+var_8]
                call    MYLOCK
                call    CHECKSEGCHKSUM
                pop     es
                jmp     short loc_13B4
; ---------------------------------------------------------------------------

loc_1374:                               ; CODE XREF: LOADSEGMENT+11D↑j
                                        ; LOADSEGMENT+121↑j
                xor     bx, bx
                mov     ax, 410h
                push    ax
                mov     ax, offset SZBADRELOCATIONRECORDS ; "Error reading relocation records from "
                push    cs
                push    ax
                push    [bp+arg_6]
                push    bx
                call    KERNELERROR
                jmp     short loc_13B0
; ---------------------------------------------------------------------------
SZBADRELOCATIONRECORDS db 'Error reading relocation records from ',0
                                        ; DATA XREF: LOADSEGMENT+161↑o
                db 24h
; ---------------------------------------------------------------------------

loc_13B0:                               ; CODE XREF: LOADSEGMENT+16D↑j
                xor     ax, ax
                jmp     short loc_1357
; ---------------------------------------------------------------------------

loc_13B4:                               ; CODE XREF: LOADSEGMENT:loc_1292↑j
                                        ; LOADSEGMENT+159↑j
                push    es
                push    [bp+var_8]
                call    MYLOCK
                pop     es

loc_13BC:                               ; CODE XREF: LOADSEGMENT:loc_12C2↑j
                                        ; LOADSEGMENT+14C↑j
                mov     cx, [bp+var_2]
                inc     cx
                jz      short loc_13D2
                dec     cx
                cmp     [bp+arg_2], cx
                jz      short loc_13D2
                mov     bx, cx
                mov     cx, ax
                mov     ah, 3Eh ; '>'
                int     21h             ; DOS - 2+ - CLOSE A FILE WITH HANDLE
                                        ; BX = file handle
                mov     ax, cx

loc_13D2:                               ; CODE XREF: LOADSEGMENT+1A7↑j
                                        ; LOADSEGMENT+1AD↑j
                mov     cx, ax
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    8
LOADSEGMENT     endp


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
                align 2

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
                align 2

loc_177C:                               ; CODE XREF: SEGRELOC+D4↑j
                                        ; SEGRELOC:loc_16A4↑j ...
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    10h
SEGRELOC        endp
