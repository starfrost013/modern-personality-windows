
; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

FINDFREESEG     proc near               ; CODE XREF: FASTBOOT+AA↓p
                                        ; FASTBOOT+192↓p ...

arg_0           = dword ptr  4

                push    bp
                mov     bp, sp
                push    si
                push    di
                push    es
                call    GENTER

loc_84D1:                               ; CODE XREF: FINDFREESEG+CB↓j
                                        ; FINDFREESEG+D1↓j ...
                mov     ax, word ptr [bp+arg_0+2]
                mov     bx, word ptr [bp+arg_0]
                cmp     ax, 10h
                jbe     short loc_84F8
                les     si, [bp+arg_0]
                assume es:nothing
                mov     ax, es:[si+4]
                mov     bx, es:[si+6]
                cmp     si, es:8
                jnz     short loc_84F8
                add     bx, es:12h
                add     bx, es:10h

loc_84F8:                               ; CODE XREF: FINDFREESEG+12↑j
                                        ; FINDFREESEG+24↑j
                add     bx, 0Fh
                mov     cl, 4
                shr     bx, cl
                add     bx, 1
                call    HEND
                mov     cx, [di+4]
                mov     es, word ptr [di+6]
                mov     bx, 8
                test    al, 10h
                jz      short loc_8518
                mov     es, word ptr [di+8]
                mov     bx, 6

loc_8518:                               ; CODE XREF: FINDFREESEG+48↑j
                                        ; FINDFREESEG+71↓j
                cmp     es:[di+1], di
                jnz     short loc_852C
                mov     ax, es:[di+3]
                inc     ax
                cmp     ax, dx
                jb      short loc_852C
                xor     cx, cx
                jmp     loc_85B7
; ---------------------------------------------------------------------------

loc_852C:                               ; CODE XREF: FINDFREESEG+54↑j
                                        ; FINDFREESEG+5D↑j
                mov     ax, cs:SEGINITMEM
                dec     ax
                cmp     es:[bx], ax
                jz      short loc_853E
                mov     es, word ptr es:[bx]
                loop    loc_8518
                jmp     short loc_85B7
; ---------------------------------------------------------------------------
                align 2

loc_853E:                               ; CODE XREF: FINDFREESEG+6C↑j
                mov     ax, cs:word_84B8
                cmp     ax, 1
                jbe     short loc_859C
                cmp     bl, 6
                jz      short loc_8596
                cmp     es:[di+1], di
                jnz     short loc_8596
                and     al, 0FEh
                sub     cs:word_84B8, ax
                add     cs:CPSHRUNK, ax
                add     es:[di+3], ax
                push    ds
                push    di
                mov     ds, word ptr es:[di+8]
                sub     [di+3], ax
                add     es:[di+8], ax
                mov     es, word ptr es:[di+8]
                xor     si, si
                xor     di, di
                mov     cx, 8
                cld
                rep movsw
                pop     di
                mov     ds, word ptr es:[di+8]
                mov     word ptr [di+6], es
                pop     ds
                mov     bx, es:[di+0Ah]
                mov     ax, es
                inc     ax
                mov     [bx], ax
                mov     cs:SEGINITMEM, ax
                jmp     loc_84D1
; ---------------------------------------------------------------------------

loc_8596:                               ; CODE XREF: FINDFREESEG+82↑j
                                        ; FINDFREESEG+88↑j
                call    SHRINK
                jmp     loc_84D1
; ---------------------------------------------------------------------------

loc_859C:                               ; CODE XREF: FINDFREESEG+7D↑j
                mov     cx, es
                cmp     es:[di+1], di
                jz      short loc_85B7
                xor     dx, dx
                call    GCOMPACT
                mov     bx, cs:HINITMEM
                mov     ax, [bx]
                mov     cs:SEGINITMEM, ax
                jmp     loc_84D1
; ---------------------------------------------------------------------------

loc_85B7:                               ; CODE XREF: FINDFREESEG+61↑j
                                        ; FINDFREESEG+73↑j ...
                call    GLEAVE
                pop     es
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    4
FINDFREESEG     endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

LOADFIXEDSEG    proc near               ; CODE XREF: FASTBOOT+271↓p

arg_0           = word ptr  4
arg_2           = word ptr  6
arg_4           = dword ptr  8
arg_8           = word ptr  0Ch
arg_A           = word ptr  0Eh

                push    bp
                mov     bp, sp
                push    si
                push    di
                call    GENTER
                les     si, [bp+arg_4]
                mov     cx, es:[si+6]
                mov     ax, cs:SEGINITMEM
                dec     ax
                mov     es, ax
                xor     bx, bx
                push    word ptr es:[bx+3]
                push    word ptr es:[bx+8]
                push    word ptr es:[bx+0Ah]
                push    word ptr es:[bx+0Ch]
                push    word ptr es:[bx+0Eh]
                mov     ax, [bp+arg_0]
                mov     es, ax
                mov     dx, [bp+arg_A]
                mov     es:[bx+1], dx
                mov     es:[bx+5], bl
                mov     es:[bx+0Ah], bx
                mov     es:[bx+0Ch], bx
                mov     es:[bx+0Eh], bx
                add     cx, 0Fh
                mov     bx, cx
                mov     cl, 4
                shr     bx, cl
                add     bx, 1
                call    HEND
                dec     dx
                xor     bx, bx
                mov     es:[bx+3], dx
                mov     ax, es
                add     dx, ax
                inc     dx
                mov     es:[bx+8], dx
                inc     ax
                les     si, [bp+arg_4]
                or      byte ptr es:[si+4], 2
                mov     es:[si+8], ax
                mov     bx, [bp+arg_8]
                add     bx, cs:SEGINITMEM
                sub     bx, cs:CPSHRUNK
                mov     ax, 0FFFFh
                push    word ptr [bp+arg_4+2]
                push    word ptr [bp+arg_4]
                push    [bp+arg_2]
                push    bx
                push    ax
                call    SEGLOAD
                les     si, [bp+arg_4]
                mov     bx, es:[si+4]
                test    bx, 100h
                jz      short loc_867D
                mov     es, dx
                mov     si, cx
                mov     cx, ax
                cld
                lods    word ptr es:[si]
                xor     bx, bx
                mov     dx, 0FFFFh
                push    [bp+arg_A]
                push    bx
                push    es
                push    si
                push    ax
                push    cx
                push    bx
                push    dx
                call    SEGRELOC

loc_867D:                               ; CODE XREF: LOADFIXEDSEG+9D↑j
                mov     es, [bp+arg_0]
                xor     bx, bx
                mov     dx, es:[bx+8]
                mov     es, dx
                pop     word ptr es:[bx+0Eh]
                pop     word ptr es:[bx+0Ch]
                pop     word ptr es:[bx+0Ah]
                pop     ax
                pop     cx
                mov     es:[bx+8], ax
                mov     es, ax
                mov     es:[bx+6], dx
                mov     es, dx
                sub     ax, dx
                dec     ax
                mov     es:[bx+3], ax
                sub     cx, ax
                add     cs:CPSHRUNK, cx
                mov     dx, [bp+arg_0]
                mov     es:[bx+6], dx
                mov     word ptr es:[bx+1], 0FFFFh
                mov     es:[bx+5], bl
                mov     byte ptr es:[bx], 4Dh ; 'M'
                mov     bx, es:[bx+0Ah]
                mov     ax, es
                inc     ax
                mov     [bx], ax
                mov     cs:SEGINITMEM, ax
                call    GLEAVE
                mov     ax, [bp+arg_0]
                inc     ax
                call    CHECKSEGCHKSUM
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    0Ch
LOADFIXEDSEG    endp

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
