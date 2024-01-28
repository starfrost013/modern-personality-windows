; ---------------------------------------------------------------------------
dword_6FBF      dd 0FBh                 ; DATA XREF: DEBUGINIT+2B↓r
                                        ; DEBUGDEFINESEGMENT+27↓r ...
aSegdebug       db 'SEGDEBUG',0

; =============== S U B R O U T I N E =======================================


DEBUGINIT       proc near               ; CODE XREF: BOOTSTRAP+D0↓p
                push    si
                push    di
                push    es
                xor     ax, ax
                mov     es, ax
                assume es:cseg01
                mov     bx, es:HHANDLE
                mov     es, bx
                assume es:nothing
                mov     di, 100h
                mov     si, 6FC3h
                mov     cx, 9
                cld
                repe cmps byte ptr cs:[si], byte ptr es:[di]
                jnz     short loc_6FFF
                mov     word ptr cs:dword_6FBF+2, bx
                mov     ax, cs:PGLOBALHEAP
                push    ax
                mov     ax, 3
                push    ax
                call    cs:dword_6FBF
                add     sp, 4

loc_6FFF:                               ; CODE XREF: DEBUGINIT+1B↑j
                pop     es
                pop     di
                pop     si
                retn
DEBUGINIT       endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

DEBUGDEFINESEGMENT proc near            ; CODE XREF: SEGLOAD+293↑p

arg_0           = word ptr  4
arg_2           = word ptr  6
arg_4           = word ptr  8
arg_6           = word ptr  0Ah
arg_8           = dword ptr  0Ch

                push    bp
                mov     bp, sp
                push    es
                cmp     word ptr cs:dword_6FBF+2, 0
                jz      short loc_7032
                test    [bp+arg_2], 0FFFCh
                jnz     short loc_7032
                push    [bp+arg_0]
                push    [bp+arg_2]
                push    [bp+arg_4]
                push    [bp+arg_6]
                les     ax, [bp+arg_8]
                push    es
                push    ax
                xor     ax, ax
                push    ax
                call    cs:dword_6FBF
                add     sp, 0Eh

loc_7032:                               ; CODE XREF: DEBUGDEFINESEGMENT+A↑j
                                        ; DEBUGDEFINESEGMENT+11↑j
                pop     es
                mov     sp, bp
                pop     bp
                retn    0Ch
DEBUGDEFINESEGMENT endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

DEBUGMOVEDSEGMENT proc near             ; CODE XREF: GNOTIFY+15↑p
                                        ; GNOTIFY+68↑p

arg_0           = word ptr  4
arg_2           = word ptr  6

                push    bp
                mov     bp, sp
                cmp     word ptr cs:dword_6FBF+2, 0
                jz      short loc_7056
                push    [bp+arg_0]
                push    [bp+arg_2]
                mov     ax, 1
                push    ax
                call    cs:dword_6FBF
                add     sp, 6

loc_7056:                               ; CODE XREF: DEBUGMOVEDSEGMENT+9↑j
                mov     sp, bp
                pop     bp
                retn    4
DEBUGMOVEDSEGMENT endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

DEBUGFREESEGMENT proc near              ; CODE XREF: MYFREE:loc_C0C↑p
                                        ; GLOBALFREEALL+68↑p

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                push    es
                cmp     word ptr cs:dword_6FBF+2, 0
                jz      short loc_7077
                push    [bp+arg_0]
                mov     ax, 2
                push    ax
                call    cs:dword_6FBF
                add     sp, 4

loc_7077:                               ; CODE XREF: DEBUGFREESEGMENT+A↑j
                pop     es
                mov     sp, bp
                pop     bp
                retn    2
DEBUGFREESEGMENT endp


; =============== S U B R O U T I N E =======================================


KERNELDBGMSG    proc near
                or      ax, 60Ah        ; ???
                push    ds
                push    di
                push    si
                push    dx
                push    cx
                push    bx
                push    ax
                push    bp
                mov     bp, sp
                push    cs
                pop     es
                assume es:cseg01
                mov     dx, [bp+12h]
                mov     di, dx
                mov     cx, 0FFFFh
                xor     al, al
                cld
                repne scasb
                neg     cx
                dec     cx
                dec     cx
                mov     [bp+12h], di
                push    cs
                pop     ds
                assume ds:cseg01
                mov     bx, 3
                mov     ah, 40h ; '@'
                int     21h             ; DOS - 2+ - WRITE TO FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to write, DS:DX -> buffer
                mov     ah, 40h ; '@'
                mov     dx, 707Eh
                mov     cx, 2
                int     21h             ; DOS - 2+ - WRITE TO FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to write, DS:DX -> buffer
                mov     sp, bp
                pop     bp
                pop     ax
                pop     bx
                pop     cx
                pop     dx
                pop     si
                pop     di
                pop     ds
                assume ds:nothing
                pop     es
                assume es:nothing
                retn
KERNELDBGMSG    endp ; sp-analysis failed




; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

KERNELERROR     proc near               ; CODE XREF: ENTPROCADDRESS+52↑p
                                        ; FINDORDINAL+AC↑p ...

var_20          = word ptr -20h
var_1E          = byte ptr -1Eh
var_E           = word ptr -0Eh
var_C           = dword ptr -0Ch
var_8           = word ptr -8
var_6           = byte ptr -6
var_4           = dword ptr -4
arg_0           = word ptr  4
arg_2           = word ptr  6
arg_4           = word ptr  8
arg_6           = word ptr  0Ah
arg_8           = word ptr  0Ch

                push    bp
                mov     bp, sp
                sub     sp, 20h
                mov     ax, [bp+arg_4]
                or      ax, [bp+arg_6]
                jz      short loc_761B
                mov     ax, 3
                push    ax
                push    [bp+arg_6]
                push    [bp+arg_4]
                push    [bp+arg_6]
                push    [bp+arg_4]
                nop
                push    cs
                call    near ptr LSTRLEN
                push    ax
                nop
                push    cs
                call    near ptr _LWRITE

loc_761B:                               ; CODE XREF: KERNELERROR+C↑j
                mov     ax, [bp+arg_0]
                or      ax, [bp+arg_2]
                jnz     short loc_7626
                jmp     loc_778D
; ---------------------------------------------------------------------------

loc_7626:                               ; CODE XREF: KERNELERROR+2F↑j
                mov     ax, [bp+arg_2]
                mov     [bp+var_E], ax
                or      ax, ax
                jnz     short loc_7633
                jmp     loc_7719
; ---------------------------------------------------------------------------

loc_7633:                               ; CODE XREF: KERNELERROR+3C↑j
                mov     dx, ax
                sub     ax, ax
                mov     word ptr [bp+var_C], ax
                mov     word ptr [bp+var_C+2], dx
                les     bx, [bp+var_C]
                cmp     word ptr es:[bx], 454Eh
                jz      short loc_764A
                jmp     loc_76DB
; ---------------------------------------------------------------------------

loc_764A:                               ; CODE XREF: KERNELERROR+53↑j
                mov     ax, es:[bx+26h]
                sub     dx, dx
                mov     bx, [bp+var_E]
                sub     cx, cx
                mov     dx, bx
                mov     word ptr [bp+var_4], ax
                mov     word ptr [bp+var_4+2], dx
                les     bx, [bp+var_4]
                inc     word ptr [bp+var_4]
                mov     al, es:[bx]
                sub     ah, ah
                mov     [bp+var_8], ax
                or      ax, ax
                jz      short loc_7695
                mov     ax, 3
                push    ax
                push    dx
                push    word ptr [bp+var_4]
                push    [bp+var_8]
                nop
                push    cs
                call    near ptr _LWRITE
                mov     ax, 3
                push    ax
                mov     ax, 9
                push    ax
                call    GETDEBUGSTRING
                push    dx
                push    ax
                mov     ax, 2
                push    ax
                nop
                push    cs
                call    near ptr _LWRITE

loc_7695:                               ; CODE XREF: KERNELERROR+7B↑j
                cmp     [bp+arg_0], 0
                jnz     short loc_76D7
                les     bx, [bp+var_C]
                mov     ax, es:[bx+0Ah]
                mov     [bp+var_20], ax
                or      ax, ax
                jz      short loc_76B0
                sub     dx, dx
                or      [bp+arg_0], ax
                jmp     short loc_76D7
; ---------------------------------------------------------------------------

loc_76B0:                               ; CODE XREF: KERNELERROR+B5↑j
                call    GETEXEHEAD
                sub     dx, dx
                mov     dx, ax
                sub     ax, ax
                mov     word ptr [bp+var_C], ax
                mov     word ptr [bp+var_C+2], dx
                les     bx, [bp+var_C]
                mov     ax, es:[bx+0Ah]
                mov     [bp+var_20], ax
                mov     dx, [bp+var_E]
                sub     ax, ax
                mov     ax, [bp+var_20]
                mov     [bp+arg_0], ax
                mov     [bp+arg_2], dx

loc_76D7:                               ; CODE XREF: KERNELERROR+A7↑j
                                        ; KERNELERROR+BC↑j
                add     [bp+arg_0], 8

loc_76DB:                               ; CODE XREF: KERNELERROR+55↑j
                mov     ax, [bp+arg_0]
                mov     dx, [bp+arg_2]
                mov     word ptr [bp+var_4], ax
                mov     word ptr [bp+var_4+2], dx
                mov     [bp+var_8], 0
                jmp     short loc_76F1
; ---------------------------------------------------------------------------

loc_76EE:                               ; CODE XREF: KERNELERROR+10D↓j
                inc     [bp+var_8]

loc_76F1:                               ; CODE XREF: KERNELERROR+FA↑j
                les     bx, [bp+var_4]
                inc     word ptr [bp+var_4]
                mov     al, es:[bx]
                mov     [bp+var_6], al
                cmp     al, 20h ; ' '
                jge     short loc_76EE
                cmp     [bp+var_8], 0
                jz      short loc_7719
                mov     ax, 3
                push    ax
                push    [bp+arg_2]
                push    [bp+arg_0]
                push    [bp+var_8]
                nop
                push    cs
                call    near ptr _LWRITE

loc_7719:                               ; CODE XREF: KERNELERROR+3E↑j
                                        ; KERNELERROR+113↑j
                lea     ax, [bp+var_1E]
                mov     word ptr [bp+var_4], ax
                mov     word ptr [bp+var_4+2], ss
                les     bx, [bp+var_4]
                inc     word ptr [bp+var_4]
                mov     byte ptr es:[bx], 20h ; ' '
                push    es
                push    word ptr [bp+var_4]
                push    [bp+arg_2]
                call    HTOA
                mov     word ptr [bp+var_4], ax
                mov     word ptr [bp+var_4+2], dx
                les     bx, [bp+var_4]
                inc     word ptr [bp+var_4]
                mov     byte ptr es:[bx], 3Ah ; ':'
                push    dx
                push    word ptr [bp+var_4]
                push    [bp+arg_0]
                call    HTOA
                mov     word ptr [bp+var_4], ax
                mov     word ptr [bp+var_4+2], dx
                les     bx, [bp+var_4]
                inc     word ptr [bp+var_4]
                mov     byte ptr es:[bx], 0Dh
                mov     bx, word ptr [bp+var_4]
                inc     word ptr [bp+var_4]
                mov     byte ptr es:[bx], 0Ah
                mov     bx, word ptr [bp+var_4]
                inc     word ptr [bp+var_4]
                mov     byte ptr es:[bx], 0
                mov     ax, 3
                push    ax
                lea     ax, [bp+var_1E]
                push    ss
                push    ax
                lea     ax, [bp+var_1E]
                push    ss
                push    ax
                nop
                push    cs
                call    near ptr LSTRLEN
                push    ax
                nop
                push    cs
                call    near ptr _LWRITE

loc_778D:                               ; CODE XREF: KERNELERROR+31↑j
                push    [bp+arg_8]
                nop
                push    cs
                call    near ptr FATALEXIT
                mov     sp, bp
                pop     bp
                retn    0Ah
KERNELERROR     endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

FINDSEGSYMS     proc near               ; CODE XREF: STACKWALK+83↓p

var_28          = word ptr -28h
var_26          = byte ptr -26h
var_24          = byte ptr -24h
var_23          = byte ptr -23h
var_22          = word ptr -22h
var_20          = word ptr -20h
var_1E          = dword ptr -1Eh
var_1A          = word ptr -1Ah
var_18          = dword ptr -18h
var_14          = dword ptr -14h
var_10          = byte ptr -10h
var_6           = word ptr -6
var_4           = word ptr -4
var_1           = byte ptr -1
arg_0           = word ptr  4
arg_2           = dword ptr  6
arg_6           = dword ptr  0Ah

                push    bp
                mov     bp, sp
                sub     sp, 28h
                push    si
                les     bx, [bp+arg_6]
                cmp     word ptr es:[bx+88h], 0FFFFh
                jz      short loc_77C1
                push    word ptr es:[bx+88h]
                nop
                push    cs
                call    near ptr _LCLOSE
                les     bx, [bp+arg_6]
                mov     word ptr es:[bx+88h], 0FFFFh

loc_77C1:                               ; CODE XREF: FINDSEGSYMS+10↑j
                call    GETEXEHEAD

loc_77C4:                               ; CODE XREF: FINDSEGSYMS+1AC↓j
                mov     [bp+var_28], ax
                or      ax, ax
                jnz     short loc_77CE
                jmp     loc_7A94
; ---------------------------------------------------------------------------

loc_77CE:                               ; CODE XREF: FINDSEGSYMS+2E↑j
                mov     dx, ax
                sub     ax, ax
                mov     word ptr [bp+var_1E], ax
                mov     word ptr [bp+var_1E+2], dx
                les     bx, [bp+var_1E]
                mov     ax, es:[bx+22h]
                sub     dx, dx
                mov     bx, [bp+var_28]
                sub     cx, cx
                mov     dx, bx
                mov     word ptr [bp+var_18], ax
                mov     word ptr [bp+var_18+2], dx
                mov     [bp+var_1A], cx

loc_77F1:                               ; CODE XREF: FINDSEGSYMS+2F6↓j
                les     bx, [bp+var_1E]
                mov     ax, [bp+var_1A]
                cmp     es:[bx+1Ch], ax
                ja      short loc_7800
                jmp     loc_7940
; ---------------------------------------------------------------------------

loc_7800:                               ; CODE XREF: FINDSEGSYMS+60↑j
                les     bx, [bp+var_18]
                push    word ptr es:[bx+8]
                call    MYLOCK
                cmp     ax, [bp+arg_0]
                jz      short loc_7812
                jmp     loc_7A8A
; ---------------------------------------------------------------------------

loc_7812:                               ; CODE XREF: FINDSEGSYMS+72↑j
                les     bx, [bp+arg_6]
                mov     ax, bx
                mov     dx, es
                mov     es:[bx+80h], ax
                mov     es:[bx+82h], dx
                les     bx, [bp+var_1E]
                mov     ax, es:[bx+26h]
                sub     dx, dx
                mov     bx, [bp+var_28]
                sub     cx, cx
                mov     dx, bx
                mov     word ptr [bp+var_14], ax
                mov     word ptr [bp+var_14+2], dx
                les     bx, [bp+var_14]
                inc     word ptr [bp+var_14]
                mov     al, es:[bx]
                sub     ah, ah
                mov     [bp+var_20], ax
                jmp     short loc_7867
; ---------------------------------------------------------------------------

loc_7849:                               ; CODE XREF: FINDSEGSYMS+D4↓j
                les     bx, [bp+var_14]
                inc     word ptr [bp+var_14]
                mov     al, es:[bx]
                les     bx, [bp+arg_6]
                mov     si, es:[bx+80h]
                inc     word ptr es:[bx+80h]
                mov     es, word ptr es:[bx+82h]
                mov     es:[si], al

loc_7867:                               ; CODE XREF: FINDSEGSYMS+AC↑j
                mov     ax, [bp+var_20]
                dec     [bp+var_20]
                or      ax, ax
                jnz     short loc_7849
                les     bx, [bp+arg_6]
                mov     si, es:[bx+80h]
                inc     word ptr es:[bx+80h]
                mov     es, word ptr es:[bx+82h]
                mov     byte ptr es:[si], 2Eh ; '.'
                mov     es, word ptr [bp+arg_6+2]
                mov     si, es:[bx+80h]
                inc     word ptr es:[bx+80h]
                mov     es, word ptr es:[bx+82h]
                mov     byte ptr es:[si], 53h ; 'S'
                mov     es, word ptr [bp+arg_6+2]
                mov     si, es:[bx+80h]
                inc     word ptr es:[bx+80h]
                mov     es, word ptr es:[bx+82h]
                mov     byte ptr es:[si], 59h ; 'Y'
                mov     es, word ptr [bp+arg_6+2]
                mov     si, es:[bx+80h]
                inc     word ptr es:[bx+80h]
                mov     es, word ptr es:[bx+82h]
                mov     byte ptr es:[si], 4Dh ; 'M'
                mov     es, word ptr [bp+arg_6+2]
                les     bx, es:[bx+80h]
                mov     byte ptr es:[bx], 0
                les     bx, [bp+arg_6]
                mov     ax, bx
                mov     dx, es
                mov     es:[bx+80h], ax
                mov     es:[bx+82h], dx
                push    dx
                push    ax
                sub     ax, ax
                push    ax
                nop
                push    cs
                call    near ptr OPENPATHNAME
                les     bx, [bp+arg_6]
                mov     es:[bx+88h], ax
                inc     ax
                jz      short loc_7940
                push    word ptr es:[bx+88h]
                lea     ax, [bp+var_10]
                push    ss
                push    ax
                mov     ax, 10h
                push    ax
                nop
                push    cs
                call    _LREAD
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+88h]
                push    word ptr es:[bx+82h]
                push    word ptr es:[bx+80h]
                mov     al, [bp+var_1]
                sub     ah, ah
                push    ax
                nop
                push    cs
                call    _LREAD
                mov     ax, [bp+var_1A]
                cmp     [bp+var_6], ax
                jge     short loc_794A

loc_7933:                               ; CODE XREF: FINDSEGSYMS+211↓j
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+88h]
                nop
                push    cs
                call    near ptr _LCLOSE

loc_7940:                               ; CODE XREF: FINDSEGSYMS+62↑j
                                        ; FINDSEGSYMS+15E↑j
                les     bx, [bp+var_1E]
                mov     ax, es:[bx+6]
                jmp     loc_77C4
; ---------------------------------------------------------------------------

loc_794A:                               ; CODE XREF: FINDSEGSYMS+196↑j
                mov     al, [bp+var_1]
                cbw
                les     bx, [bp+arg_6]
                add     es:[bx+80h], ax
                mov     si, es:[bx+80h]
                inc     word ptr es:[bx+80h]
                mov     es, word ptr es:[bx+82h]
                mov     byte ptr es:[si], 21h ; '!'
                mov     es, word ptr [bp+arg_6+2]
                les     bx, es:[bx+80h]
                mov     byte ptr es:[bx], 0
                mov     ax, [bp+var_4]
                mov     [bp+var_22], ax
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+88h]
                mov     ax, 0FFFCh
                cwd
                push    dx
                push    ax
                mov     ax, 2
                push    ax
                nop
                push    cs
                call    near ptr _LLSEEK
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+88h]
                lea     ax, [bp+var_26]
                push    ss
                push    ax
                mov     ax, 4
                push    ax
                nop
                push    cs
                call    _LREAD
                cmp     [bp+var_23], 3
                jnz     short loc_7933
                mov     ax, [bp+var_1A]
                inc     ax
                mov     [bp+var_20], ax
                jmp     short loc_7A09
; ---------------------------------------------------------------------------

loc_79B7:                               ; CODE XREF: FINDSEGSYMS+276↓j
                cmp     [bp+var_24], 0Ah
                jl      short loc_79D3
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+88h]
                mov     ax, [bp+var_22]
                sub     dx, dx
                mov     cl, 4
                call    __lshl
                push    dx
                push    ax
                jmp     short loc_79E1
; ---------------------------------------------------------------------------

loc_79D3:                               ; CODE XREF: FINDSEGSYMS+220↑j
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+88h]
                sub     ax, ax
                push    ax
                push    [bp+var_22]

loc_79E1:                               ; CODE XREF: FINDSEGSYMS+236↑j
                sub     ax, ax
                push    ax
                nop
                push    cs
                call    near ptr _LLSEEK
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+88h]
                push    word ptr [bp+arg_2+2]
                push    word ptr [bp+arg_2]
                mov     ax, 15h
                push    ax
                nop
                push    cs
                call    _LREAD
                les     bx, [bp+arg_2]
                mov     ax, es:[bx]
                mov     [bp+var_22], ax

loc_7A09:                               ; CODE XREF: FINDSEGSYMS+21A↑j
                mov     ax, [bp+var_20]
                dec     [bp+var_20]
                or      ax, ax
                jnz     short loc_79B7
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+88h]
                push    word ptr es:[bx+82h]
                push    word ptr es:[bx+80h]
                les     bx, [bp+arg_2]
                mov     al, es:[bx+14h]
                sub     ah, ah
                push    ax
                nop
                push    cs
                call    _LREAD
                les     bx, [bp+arg_2]
                mov     al, es:[bx+14h]
                cbw
                les     bx, [bp+arg_6]
                add     es:[bx+80h], ax
                mov     si, es:[bx+80h]
                inc     word ptr es:[bx+80h]
                mov     es, word ptr es:[bx+82h]
                mov     byte ptr es:[si], 3Ah ; ':'
                mov     es, word ptr [bp+arg_6+2]
                les     bx, es:[bx+80h]
                mov     byte ptr es:[bx], 0
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+88h]
                sub     ax, ax
                push    ax
                push    ax
                mov     ax, 1
                push    ax
                nop
                push    cs
                call    near ptr _LLSEEK
                les     bx, [bp+arg_6]
                mov     es:[bx+84h], ax
                mov     es:[bx+86h], dx
                mov     ax, 1
                jmp     short loc_7ACE
; ---------------------------------------------------------------------------

loc_7A8A:                               ; CODE XREF: FINDSEGSYMS+74↑j
                inc     [bp+var_1A]
                add     word ptr [bp+var_18], 0Ah
                jmp     loc_77F1
; ---------------------------------------------------------------------------

loc_7A94:                               ; CODE XREF: FINDSEGSYMS+30↑j
                les     bx, [bp+arg_6]
                mov     word ptr es:[bx+88h], 0FFFFh
                push    es
                push    bx
                push    [bp+arg_0]
                call    HTOA
                les     bx, [bp+arg_6]
                mov     es:[bx+80h], ax
                mov     es:[bx+82h], dx
                mov     si, ax
                inc     word ptr es:[bx+80h]
                mov     es, dx
                mov     byte ptr es:[si], 3Ah ; ':'
                mov     es, word ptr [bp+arg_6+2]
                les     bx, es:[bx+80h]
                mov     byte ptr es:[bx], 0
                sub     ax, ax

loc_7ACE:                               ; CODE XREF: FINDSEGSYMS+2ED↑j
                pop     si
                mov     sp, bp
                pop     bp
                retn    0Ah
FINDSEGSYMS     endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

FINDSYMBOL      proc near               ; CODE XREF: STACKWALK+9D↓p

var_E           = word ptr -0Eh
var_C           = dword ptr -0Ch
var_8           = word ptr -8
var_6           = byte ptr -6
var_4           = word ptr -4
var_2           = word ptr -2
arg_0           = word ptr  4
arg_2           = dword ptr  6
arg_6           = dword ptr  0Ah

                push    bp
                mov     bp, sp
                sub     sp, 0Eh
                les     bx, [bp+arg_6]
                cmp     word ptr es:[bx+88h], 0FFFFh
                jnz     short loc_7AE9
                jmp     loc_7C01
; ---------------------------------------------------------------------------

loc_7AE9:                               ; CODE XREF: FINDSYMBOL+F↑j
                push    word ptr es:[bx+88h]
                push    word ptr es:[bx+86h]
                push    word ptr es:[bx+84h]
                sub     ax, ax
                push    ax
                nop
                push    cs
                call    near ptr _LLSEEK
                mov     [bp+var_4], ax
                mov     [bp+var_2], dx
                les     bx, [bp+arg_2]
                mov     ax, es:[bx+2]
                mov     [bp+var_E], ax
                jmp     loc_7BF4
; ---------------------------------------------------------------------------

loc_7B13:                               ; CODE XREF: FINDSYMBOL+129↓j
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+88h]
                lea     ax, [bp+var_8]
                push    ss
                push    ax
                mov     ax, 3
                push    ax
                nop
                push    cs
                call    _LREAD
                mov     ax, [bp+arg_0]
                cmp     [bp+var_8], ax
                ja      short loc_7B34
                jmp     loc_7BBB
; ---------------------------------------------------------------------------

loc_7B34:                               ; CODE XREF: FINDSYMBOL+5A↑j
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+88h]
                push    [bp+var_2]
                push    [bp+var_4]
                sub     ax, ax
                push    ax
                nop
                push    cs
                call    near ptr _LLSEEK
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+88h]
                lea     ax, [bp+var_8]
                push    ss
                push    ax
                mov     ax, 3
                push    ax
                nop
                push    cs
                call    _LREAD
                les     bx, [bp+arg_6]
                mov     ax, es:[bx+80h]
                mov     dx, es:[bx+82h]
                mov     word ptr [bp+var_C], ax
                mov     word ptr [bp+var_C+2], dx
                push    word ptr es:[bx+88h]
                push    dx
                push    ax
                mov     al, [bp+var_6]
                sub     ah, ah
                push    ax
                nop
                push    cs
                call    _LREAD
                mov     al, [bp+var_6]
                cbw
                add     word ptr [bp+var_C], ax
                mov     ax, [bp+arg_0]
                cmp     [bp+var_8], ax
                jnb     short loc_7BAF
                les     bx, [bp+var_C]
                inc     word ptr [bp+var_C]
                mov     byte ptr es:[bx], 2Bh ; '+'
                push    es
                push    word ptr [bp+var_C]
                sub     ax, [bp+var_8]
                push    ax
                call    HTOA
                mov     word ptr [bp+var_C], ax
                mov     word ptr [bp+var_C+2], dx

loc_7BAF:                               ; CODE XREF: FINDSYMBOL+BD↑j
                les     bx, [bp+var_C]
                mov     byte ptr es:[bx], 0
                mov     ax, 1
                jmp     short loc_7C23
; ---------------------------------------------------------------------------

loc_7BBB:                               ; CODE XREF: FINDSYMBOL+5C↑j
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+88h]
                sub     ax, ax
                push    ax
                push    ax
                mov     ax, 1
                push    ax
                nop
                push    cs
                call    near ptr _LLSEEK
                sub     ax, 3
                sbb     dx, 0
                mov     [bp+var_4], ax
                mov     [bp+var_2], dx
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+88h]
                mov     al, [bp+var_6]
                cbw
                cwd
                push    dx
                push    ax
                mov     ax, 1
                push    ax
                nop
                push    cs
                call    near ptr _LLSEEK

loc_7BF4:                               ; CODE XREF: FINDSYMBOL+3B↑j
                mov     ax, [bp+var_E]
                dec     [bp+var_E]
                or      ax, ax
                jz      short loc_7C01
                jmp     loc_7B13
; ---------------------------------------------------------------------------

loc_7C01:                               ; CODE XREF: FINDSYMBOL+11↑j
                                        ; FINDSYMBOL+127↑j
                les     bx, [bp+arg_6]
                push    word ptr es:[bx+82h]
                push    word ptr es:[bx+80h]
                push    [bp+arg_0]
                call    HTOA
                mov     word ptr [bp+var_C], ax
                mov     word ptr [bp+var_C+2], dx
                les     bx, [bp+var_C]
                mov     byte ptr es:[bx], 0
                sub     ax, ax

loc_7C23:                               ; CODE XREF: FINDSYMBOL+E4↑j
                mov     sp, bp
                pop     bp
                retn    0Ah
FINDSYMBOL      endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

NEXTFRAME       proc near               ; CODE XREF: STACKWALK+25↓p

var_2           = word ptr -2
arg_0           = dword ptr  4

                push    bp
                mov     bp, sp
                sub     sp, 2
                les     bx, [bp+arg_0]
                mov     ax, es:[bx]
                mov     [bp+var_2], ax
                test    al, 1
                jz      short loc_7C40
                xor     byte ptr [bp+var_2], 1

loc_7C40:                               ; CODE XREF: NEXTFRAME+11↑j
                cmp     [bp+var_2], 0
                jz      short loc_7C95
                mov     ax, [bp+var_2]
                cmp     word ptr [bp+arg_0], ax
                jnb     short loc_7C7F
                mov     ax, word ptr [bp+arg_0]
                mov     dx, word ptr [bp+arg_0+2]
                sub     ax, ax
                or      al, 0Ah
                mov     word ptr [bp+arg_0], ax
                les     bx, [bp+arg_0]
                add     word ptr [bp+arg_0], 2
                mov     ax, [bp+var_2]
                cmp     es:[bx], ax
                ja      short loc_7C7F
                add     word ptr [bp+arg_0], 2
                mov     bx, word ptr [bp+arg_0]
                cmp     es:[bx], ax
                jb      short loc_7C7F
                mov     ax, bx
                sub     ax, ax
                mov     ax, [bp+var_2]
                jmp     short loc_7C98
; ---------------------------------------------------------------------------

loc_7C7F:                               ; CODE XREF: NEXTFRAME+23↑j
                                        ; NEXTFRAME+3F↑j ...
                mov     ax, 3
                push    ax
                mov     ax, 8
                push    ax
                call    GETDEBUGSTRING
                push    dx
                push    ax
                mov     ax, 13h
                push    ax
                nop
                push    cs
                call    near ptr _LWRITE

loc_7C95:                               ; CODE XREF: NEXTFRAME+1B↑j
                sub     ax, ax
                cwd

loc_7C98:                               ; CODE XREF: NEXTFRAME+54↑j
                mov     sp, bp
                pop     bp
                retn    4
NEXTFRAME       endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

STACKWALK       proc near               ; CODE XREF: FATALEXIT+A1↓p

var_AA          = word ptr -0AAh
var_A8          = dword ptr -0A8h
var_A4          = word ptr -0A4h
var_A2          = byte ptr -0A2h
var_18          = word ptr -18h
var_16          = byte ptr -16h
arg_0           = byte ptr  4

                push    bp
                mov     bp, sp
                sub     sp, 0AAh
                lea     ax, [bp+arg_0]
                mov     word ptr [bp+var_A8], ax
                mov     word ptr [bp+var_A8+2], ss
                sub     word ptr [bp+var_A8], 4
                mov     [bp+var_A4], 0

loc_7CBB:                               ; CODE XREF: STACKWALK+CE↓j
                push    word ptr [bp+var_A8+2]
                push    word ptr [bp+var_A8]
                call    NEXTFRAME
                mov     word ptr [bp+var_A8], ax
                mov     word ptr [bp+var_A8+2], dx
                or      ax, dx
                jnz     short loc_7CD5
                jmp     loc_7D6F
; ---------------------------------------------------------------------------

loc_7CD5:                               ; CODE XREF: STACKWALK+32↑j
                les     bx, [bp+var_A8]
                mov     ax, es:[bx]
                mov     [bp+var_AA], ax
                mov     ax, es:[bx+2]
                mov     [bp+var_18], ax
                test    byte ptr [bp+var_AA], 1
                jz      short loc_7CF4
                sub     [bp+var_18], 5
                jmp     short loc_7CF8
; ---------------------------------------------------------------------------

loc_7CF4:                               ; CODE XREF: STACKWALK+4E↑j
                sub     [bp+var_18], 3

loc_7CF8:                               ; CODE XREF: STACKWALK+54↑j
                test    byte ptr [bp+var_AA], 1
                jz      short loc_7D26
                les     bx, [bp+var_A8]
                mov     ax, [bp+var_A4]
                cmp     es:[bx+4], ax
                jz      short loc_7D26
                lea     ax, [bp+var_A2]
                push    ss
                push    ax
                lea     ax, [bp+var_16]
                push    ss
                push    ax
                mov     ax, es:[bx+4]
                mov     [bp+var_A4], ax
                push    ax
                call    FINDSEGSYMS
                jmp     short loc_7D2D
; ---------------------------------------------------------------------------

loc_7D26:                               ; CODE XREF: STACKWALK+5F↑j
                                        ; STACKWALK+6D↑j
                cmp     [bp+var_AA], 0
                jz      short loc_7D6F

loc_7D2D:                               ; CODE XREF: STACKWALK+86↑j
                lea     ax, [bp+var_A2]
                push    ss
                push    ax
                lea     ax, [bp+var_16]
                push    ss
                push    ax
                push    [bp+var_18]
                call    FINDSYMBOL
                mov     ax, 3
                push    ax
                lea     ax, [bp+var_A2]
                push    ss
                push    ax
                lea     ax, [bp+var_A2]
                push    ss
                push    ax
                nop
                push    cs
                call    near ptr LSTRLEN
                push    ax
                nop
                push    cs
                call    near ptr _LWRITE
                mov     ax, 3
                push    ax
                push    ax
                call    GETDEBUGSTRING
                push    dx
                push    ax
                mov     ax, 2
                push    ax
                nop
                push    cs
                call    near ptr _LWRITE
                jmp     loc_7CBB
; ---------------------------------------------------------------------------

loc_7D6F:                               ; CODE XREF: STACKWALK+34↑j
                                        ; STACKWALK+8D↑j
                mov     sp, bp
                pop     bp
                retn    2
STACKWALK       endp
