
; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

LOADNRTABLE     proc near               ; CODE XREF: FINDORDINAL+80↑p

var_2           = word ptr -2
arg_0           = word ptr  4
arg_2           = word ptr  6
arg_4           = word ptr  8
arg_6           = word ptr  0Ah

                push    bp
                mov     bp, sp
                sub     sp, 2
                push    si
                push    di
                xor     dx, dx
                mov     [bp+var_2], dx
                mov     es, [bp+arg_6]
                mov     si, [bp+arg_2]
                mov     bx, [bp+arg_4]
                mov     dx, es:[si+2]
                cmp     word ptr es:[si], 0
                jnz     short loc_C51
                jmp     short loc_CBB
; ---------------------------------------------------------------------------
                nop

loc_C51:                                ; CODE XREF: LOADNRTABLE+1E↑j
                inc     bx
                jnz     short loc_C71
                mov     dx, es:0Ah
                mov     bx, 0A400h
                mov     [bp+var_2], dx
                push    es
                push    dx
                push    es
                push    dx
                push    bx
                nop
                push    cs
                call    near ptr OPENFILE
                mov     es, [bp+arg_6]
                inc     bx
                jnz     short loc_C71
                jmp     short loc_CC8
; ---------------------------------------------------------------------------

loc_C71:                                ; CODE XREF: LOADNRTABLE+24↑j
                                        ; LOADNRTABLE+3F↑j
                dec     bx
                mov     dx, es:[si]
                mov     cx, es:[si+2]
                mov     ax, 4200h
                int     21h             ; DOS - 2+ - MOVE FILE READ/WRITE POINTER (LSEEK)
                                        ; AL = method: offset from beginning of file
                jb      short loc_CC8
                mov     ax, [bp+arg_0]
                add     ax, 4
                push    es
                push    bx
                mov     bx, 17h
                xor     cx, cx
                push    bx
                push    ax
                push    cx
                call    MYALLOC
                pop     bx
                mov     cx, ds
                pop     ds
                push    cx
                mov     es, ax
                xor     di, di
                xor     ax, ax
                xchg    ax, [si]
                stosw
                mov     ax, dx
                xchg    ax, [si+2]
                stosw
                mov     cx, [bp+arg_0]
                push    es
                pop     ds
                push    dx
                mov     dx, di
                mov     ah, 3Fh ; '?'
                int     21h             ; DOS - 2+ - READ FROM FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to read
                                        ; DS:DX -> buffer
                pop     dx
                pop     ds
                jb      short loc_CC8
                cmp     ax, cx
                jnz     short loc_CC8

loc_CBB:                                ; CODE XREF: LOADNRTABLE+20↑j
                push    bx
                push    dx
                call    MYLOCK
                pop     bx
                mov     dx, ax
                mov     ax, 4
                jmp     short loc_D10
; ---------------------------------------------------------------------------

loc_CC8:                                ; CODE XREF: LOADNRTABLE+41↑j
                                        ; LOADNRTABLE+50↑j ...
                push    bx
                mov     ax, 412h
                push    ax
                mov     ax, offset SZERRNONRESIDENTNAMETABLE ; "Unable to load non-resident name table "...
                push    cs
                push    ax
                push    [bp+arg_6]
                push    [bp+var_2]
                call    KERNELERROR
                jmp     short loc_D0B
; ---------------------------------------------------------------------------
SZERRNONRESIDENTNAMETABLE db 'Unable to load non-resident name table from ',0
                                        ; DATA XREF: LOADNRTABLE+9F↑o
                db 24h
; ---------------------------------------------------------------------------

loc_D0B:                                ; CODE XREF: LOADNRTABLE+AD↑j
                pop     bx
                xor     ax, ax
                mov     dx, ax

loc_D10:                                ; CODE XREF: LOADNRTABLE+98↑j
                cmp     bx, [bp+arg_4]
                jz      short loc_D1B
                push    ax
                mov     ah, 3Eh ; '>'
                int     21h             ; DOS - 2+ - CLOSE A FILE WITH HANDLE
                                        ; BX = file handle
                pop     ax

loc_D1B:                                ; CODE XREF: LOADNRTABLE+E5↑j
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    8
LOADNRTABLE     endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

FREENRTABLE     proc near               ; CODE XREF: FINDORDINAL+95↑p
                                        ; TRIMEXEHEADER+18↓p

arg_0           = word ptr  4
arg_2           = word ptr  6

                push    bp
                mov     bp, sp
                push    si
                push    di
                mov     es, [bp+arg_2]
                mov     di, [bp+arg_0]
                xor     ax, ax
                mov     cx, es:[di+2]
                cmp     word ptr es:[di], 0
                jnz     short loc_D53
                jcxz    short loc_D53
                push    cx
                push    cx
                call    MYLOCK
                pop     cx
                mov     es, [bp+arg_2]
                push    ds
                mov     ds, ax
                xor     si, si
                movsw
                movsw
                pop     ds
                push    cx
                nop
                push    cs
                call    near ptr GLOBALFREE

loc_D53:                                ; CODE XREF: FREENRTABLE+15↑j
                                        ; FREENRTABLE+17↑j
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    4
FREENRTABLE     endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

GETSTRINGPTR    proc near               ; CODE XREF: LOADMODULE+1B4↑p
                                        ; SEGRELOC+A7↓p ...

arg_0           = word ptr  4
arg_4           = word ptr  8

                push    bp
                mov     bp, sp
                push    si
                push    di
                mov     es, [bp+arg_4]
                mov     dx, es
                mov     ax, es:2Ah
                add     ax, [bp+arg_0]
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    6
GETSTRINGPTR    endp


; =============== S U B R O U T I N E =======================================


CALCMAXNRSEG    proc near               ; CODE XREF: ADDMODULE+43↑p
                                        ; DELMODULE+3F↑p ...
                xor     ax, ax
                mov     al, cs:FBOOTING ; turn off the "is system booting?" flag
                or      ax, ax
                jnz     short locret_2558
                push    cs:HEXEHEAD

loc_2513:                               ; CODE XREF: CALCMAXNRSEG+23↓j
                                        ; CALCMAXNRSEG+4F↓j
                pop     cx
                jcxz    short loc_2555
                mov     es, cx
                push    word ptr es:6
                mov     bx, es:22h
                mov     cx, es:1Ch
                jcxz    short loc_2513

loc_2529:                               ; CODE XREF: CALCMAXNRSEG+4D↓j
                test    word ptr es:[bx+4], 1
                jnz     short loc_254E
                test    word ptr es:[bx+4], 0F000h
                jz      short loc_254E
                mov     dx, es:[bx+6]
                add     dx, 0Fh
                shr     dx, 1
                shr     dx, 1
                shr     dx, 1
                shr     dx, 1
                cmp     ax, dx
                jnb     short loc_254E
                mov     ax, dx

loc_254E:                               ; CODE XREF: CALCMAXNRSEG+2B↑j
                                        ; CALCMAXNRSEG+33↑j ...
                add     bx, 0Ah
                loop    loc_2529
                jmp     short loc_2513
; ---------------------------------------------------------------------------

loc_2555:                               ; CODE XREF: CALCMAXNRSEG+10↑j
                call    GRESERVE

locret_2558:                            ; CODE XREF: CALCMAXNRSEG+8↑j
                retn
CALCMAXNRSEG    endp


; ========
;
; External Entry #36 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; =============== S U B R O U T I N E =======================================


GROWSFT         proc near               ; CODE XREF: OPENFILE:loc_1F3A↑p
                                        ; SftThing+A2↓p
                push    ax
                push    bx
                push    cx
                push    dx
                push    si
                push    di
                push    es
                push    ds
                les     bx, cs:PFILETABLE
                mov     di, cs:FILEENTRYSIZE
                mov     ax, 2

loc_383C:                               ; CODE XREF: GROWSFT+34↓j
                les     bx, es:[bx]
                cmp     bx, 0FFFFh
                jz      short loc_385D
                lea     si, [bx+6]
                mov     cx, es:[bx+4]
                add     ah, cl

loc_384D:                               ; CODE XREF: GROWSFT+32↓j
                cmp     byte ptr es:[si], 0
                jnz     short loc_3857
                dec     al
                jz      short loc_38CF

loc_3857:                               ; CODE XREF: GROWSFT+2A↑j
                add     si, di
                loop    loc_384D
                jmp     short loc_383C
; ---------------------------------------------------------------------------

loc_385D:                               ; CODE XREF: GROWSFT+1B↑j
                cmp     ah, 0F5h
                jnb     short loc_38CF
                mov     ax, di
                shl     ax, 1
                shl     ax, 1
                shl     ax, 1
                add     ax, 6
                cwd
                mov     cx, 2040h
                mov     ds, cs:CURTDB
                mov     di, ss
                cmp     di, ds:4
                jz      short loc_389F
                mov     si, sp
                mov     ss, word ptr ds:4
                mov     sp, ds:2
                mov     bp, sp
                add     bp, 10h
                push    cx
                push    dx
                push    ax
                nop
                push    cs
                call    near ptr GLOBALALLOC
                mov     ds:2, sp
                mov     ss, di
                mov     sp, si
                jmp     short loc_38A7
; ---------------------------------------------------------------------------

loc_389F:                               ; CODE XREF: GROWSFT+55↑j
                push    cx
                push    dx
                push    ax
                nop
                push    cs
                call    near ptr GLOBALALLOC

loc_38A7:                               ; CODE XREF: GROWSFT+76↑j
                jcxz    short loc_38CF
                les     bx, cs:PFILETABLE
                mov     cx, 0FFFFh

loc_38B1:                               ; CODE XREF: GROWSFT+90↓j
                les     bx, es:[bx]
                cmp     es:[bx], cx
                jnz     short loc_38B1
                mov     word ptr es:[bx], 0
                mov     es:[bx+2], ax
                mov     es, ax
                mov     word ptr es:[bx+4], 8
                mov     es:0, cx

loc_38CF:                               ; CODE XREF: GROWSFT+2E↑j
                                        ; GROWSFT+39↑j ...
                pop     ds
                pop     es
                pop     di
                pop     si
                pop     dx
                pop     cx
                pop     bx
                pop     ax

locret_38D7:                            ; CODE XREF: CLOSEOPENFILES+1F↓j
                retn
GROWSFT         endp


; =============== S U B R O U T I N E =======================================


CLOSEOPENFILES  proc near               ; CODE XREF: PROMPT+11↑p
                push    ax
                mov     ah, 0Dh
                int     21h             ; DOS - DISK RESET
                pop     ax
                sub     al, 41h ; 'A'
                cmp     cs:DOS_VERSION, 3
                jnb     short loc_38EA
                inc     al

loc_38EA:                               ; CODE XREF: CLOSEOPENFILES+E↑j
                les     bx, cs:PFILETABLE
                xor     dx, dx

loc_38F1:                               ; CODE XREF: CLOSEOPENFILES+A9↓j
                les     bx, es:[bx]
                cmp     bx, 0FFFFh
                jz      short locret_38D7
                lea     si, [bx+6]
                mov     cx, es:[bx+4]
                add     dx, cx

loc_3902:                               ; CODE XREF: CLOSEOPENFILES+A7↓j
                cmp     byte ptr es:[si], 0
                jz      short loc_397A
                cmp     cs:DOS_VERSION, 3
                jb      short loc_3922
                test    word ptr es:[si+5], 8080h
                jnz     short loc_397A
                lds     di, es:[si+7]
                cmp     al, [di]
                jnz     short loc_397A
                jmp     short loc_392F
; ---------------------------------------------------------------------------

loc_3922:                               ; CODE XREF: CLOSEOPENFILES+36↑j
                test    byte ptr es:[si+1Bh], 80h
                jnz     short loc_397A
                cmp     al, es:[si+3]
                jnz     short loc_397A

loc_392F:                               ; CODE XREF: CLOSEOPENFILES+48↑j
                push    si
                push    dx
                push    cx
                push    bx
                push    ax
                sub     dl, cl
                lds     di, cs:PCURRENTPDB
                push    word ptr [di]
                mov     ax, cs:HEADPDB

loc_3941:                               ; CODE XREF: CLOSEOPENFILES+96↓j
                mov     ds, ax
                cmp     word ptr ds:4Ah, 0
                jnz     short loc_3969
                mov     si, 18h
                mov     cx, 14h

loc_3950:                               ; CODE XREF: CLOSEOPENFILES:loc_3967↓j
                lodsb
                cmp     dl, al
                jnz     short loc_3967
                mov     bx, ds
                mov     ah, 50h ; 'P'
                int     21h             ; DOS - 2+ internal - SET PSP SEGMENT
                                        ; BX = segment address of new PSP
                mov     bx, si
                sub     bx, 19h
                mov     ah, 3Eh ; '>'
                int     21h             ; DOS - 2+ - CLOSE A FILE WITH HANDLE
                                        ; BX = file handle
                dec     byte ptr [si-1]

loc_3967:                               ; CODE XREF: CLOSEOPENFILES+7B↑j
                loop    loc_3950

loc_3969:                               ; CODE XREF: CLOSEOPENFILES+70↑j
                mov     ax, ds:42h
                or      ax, ax
                jnz     short loc_3941
                pop     bx
                mov     ah, 50h ; 'P'
                int     21h             ; DOS - 2+ internal - SET PSP SEGMENT
                                        ; BX = segment address of new PSP
                pop     ax
                pop     bx
                pop     cx
                pop     dx
                pop     si

loc_397A:                               ; CODE XREF: CLOSEOPENFILES+2E↑j
                                        ; CLOSEOPENFILES+3E↑j ...
                add     si, cs:FILEENTRYSIZE
                loop    loc_3902
                jmp     loc_38F1
; ---------------------------------------------------------------------------
                retn
CLOSEOPENFILES  endp