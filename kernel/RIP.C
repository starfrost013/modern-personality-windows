/* ****** modern:personality project ******
; Reverse engineered code  © 2022-2024 starfrost. See licensing information in the licensing file
; Original code            © 1982-1986 Microsoft Corporation

; RIP.C: Handles the kernel crashing on debug builds with a bugcheck-like error code. Yes, "rip.c" was what microsoft called it back then. */


/* THIS IS A C FILE!!!!!
/ IT MUST BE TRANSPILED TO C!!!!

; Some of this is not C - it goes in RIPAUX.ASM!!! 

K&R C NO // !!!!
*/

/* points to fatalexit on release builds
#ifdef KDEBUG

takes:
    - error code
    - message
    - optional useful info like NT
    tries to determine module name. 
*/

#ifdef DEBUG
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
arg_2           = word ptr  6 // errcode?
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

/* #endif KDEBUG */
;
; External Entry #1 into the Module
; Attributes (0001): Fixed Exported
;


; =============== S U B R O U T I N E =======================================


                public FATALEXIT
FATALEXIT       proc far                ; CODE XREF: KERNELERROR+1A0↑p
                push    ds              ; KERNEL_1
                pop     ax
                nop
                inc     bp
                push    bp
                mov     bp, sp
                push    ds
                mov     ds, ax
                sub     sp, 0Eh

loc_7D82:                               ; CODE XREF: FATALEXIT+F8↓j
                                        ; FATALEXIT+102↓j
                mov     ax, 3
                push    ax
                mov     ax, 4
                push    ax
                call    GETDEBUGSTRING
                push    dx
                push    ax
                mov     ax, 14h
                push    ax
                nop
                push    cs
                call    near ptr _LWRITE
                cmp     word ptr [bp+6], 0FFFFh
                jnz     short loc_7DB0
                mov     ax, 3
                push    ax
                mov     ax, 5
                push    ax
                call    GETDEBUGSTRING
                push    dx
                push    ax
                mov     ax, 0Fh
                jmp     short loc_7DFA
; ---------------------------------------------------------------------------

loc_7DB0:                               ; CODE XREF: FATALEXIT+27↑j
                lea     ax, [bp-0Eh]
                mov     [bp-6], ax
                mov     word ptr [bp-4], ss
                les     bx, [bp-6]
                inc     word ptr [bp-6]
                mov     byte ptr es:[bx], 30h ; '0'
                mov     bx, [bp-6]
                inc     word ptr [bp-6]
                mov     byte ptr es:[bx], 78h ; 'x'
                push    es
                push    word ptr [bp-6]
                push    word ptr [bp+6]
                call    HTOA
                mov     [bp-6], ax
                mov     [bp-4], dx
                les     bx, [bp-6]
                inc     word ptr [bp-6]
                mov     byte ptr es:[bx], 0
                mov     ax, 3
                push    ax
                lea     ax, [bp-0Eh]
                push    ss
                push    ax
                lea     ax, [bp-0Eh]
                push    ss
                push    ax
                nop
                push    cs
                call    near ptr LSTRLEN

loc_7DFA:                               ; CODE XREF: FATALEXIT+39↑j
                push    ax
                nop
                push    cs
                call    near ptr _LWRITE
                mov     ax, 3
                push    ax
                mov     ax, 6
                push    ax
                call    GETDEBUGSTRING
                push    dx
                push    ax
                mov     ax, 10h
                push    ax
                nop
                push    cs
                call    near ptr _LWRITE
                call    STACKWALK
                mov     ax, 3
                push    ax
                mov     ax, 7
                push    ax
                call    GETDEBUGSTRING
                push    dx
                push    ax
                mov     ax, 1Ch
                push    ax
                nop
                push    cs
                call    near ptr _LWRITE
                mov     byte ptr [bp-8], 0

loc_7E33:                               ; CODE XREF: FATALEXIT+D4↓j
                mov     ax, 3
                push    ax
                lea     ax, [bp-8]
                push    ss
                push    ax
                mov     ax, 1
                push    ax
                nop
                push    cs
                call    _LREAD
                cmp     byte ptr [bp-8], 0
                jz      short loc_7E33
                cmp     byte ptr [bp-8], 61h ; 'a'
                jl      short loc_7E5B
                cmp     byte ptr [bp-8], 7Ah ; 'z'
                jg      short loc_7E5B
                add     byte ptr [bp-8], 0E0h

loc_7E5B:                               ; CODE XREF: FATALEXIT+DA↑j
                                        ; FATALEXIT+E0↑j
                cmp     byte ptr [bp-8], 41h ; 'A'
                jz      short loc_7E7A
                cmp     byte ptr [bp-8], 49h ; 'I'
                jz      short loc_7E83
                cmp     byte ptr [bp-8], 42h ; 'B'
                jz      short loc_7E70
                jmp     loc_7D82
; ---------------------------------------------------------------------------

loc_7E70:                               ; CODE XREF: FATALEXIT+F6↑j
                mov     ax, 2
                push    ax
                call    ENTERBREAK
                jmp     loc_7D82
; ---------------------------------------------------------------------------

loc_7E7A:                               ; CODE XREF: FATALEXIT+EA↑j
                mov     ax, 1
                push    ax
                nop
                push    cs
                call    EXITKERNEL

loc_7E83:                               ; CODE XREF: FATALEXIT+F0↑j
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
FATALEXIT       endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

HTOA            proc near               ; CODE XREF: KERNELERROR+141↑p
                                        ; KERNELERROR+15B↑p ...

var_4           = word ptr -4
var_2           = byte ptr -2
arg_0           = word ptr  4
arg_2           = dword ptr  6

                push    bp
                mov     bp, sp
                sub     sp, 4
                push    si
                mov     [bp+var_4], 4
                jmp     short loc_7EC3
; ---------------------------------------------------------------------------

loc_7E9C:                               ; CODE XREF: HTOA+3D↓j
                mov     al, byte ptr [bp+arg_0]
                and     al, 0Fh
                mov     [bp+var_2], al
                mov     cl, 4
                shr     [bp+arg_0], cl
                cmp     al, 9
                jle     short loc_7EB3
                add     [bp+var_2], 37h ; '7'
                jmp     short loc_7EB7
; ---------------------------------------------------------------------------

loc_7EB3:                               ; CODE XREF: HTOA+1D↑j
                add     [bp+var_2], 30h ; '0'

loc_7EB7:                               ; CODE XREF: HTOA+23↑j
                mov     bx, [bp+var_4]
                les     si, [bp+arg_2]
                mov     al, [bp+var_2]
                mov     es:[bx+si], al

loc_7EC3:                               ; CODE XREF: HTOA+C↑j
                mov     ax, [bp+var_4]
                dec     [bp+var_4]
                or      ax, ax
                jnz     short loc_7E9C
                mov     ax, word ptr [bp+arg_2]
                mov     dx, word ptr [bp+arg_2+2]
                add     ax, 4
                pop     si
                mov     sp, bp
                pop     bp
                retn    6
HTOA            endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

GETDEBUGSTRING  proc near               ; CODE XREF: LOADRESOURCE+160↑p
                                        ; KERNELERROR+95↑p ...

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                push    di
                push    cs
                pop     es
                assume es:cseg01
                mov     dx, es
                mov     di, 215h
                mov     bx, [bp+arg_0]

loc_7EEB:                               ; CODE XREF: GETDEBUGSTRING+1B↓j
                dec     bx
                jl      short loc_7EFE
                xor     ax, ax
                mov     cx, 0FFFFh
                repne scasb
                cmp     es:[di], al
                jnz     short loc_7EEB
                xor     ax, ax
                xor     dx, dx

loc_7EFE:                               ; CODE XREF: GETDEBUGSTRING+F↑j
                mov     ax, di
                pop     di
                mov     sp, bp
                pop     bp
                retn    2
GETDEBUGSTRING  endp


; =============== S U B R O U T I N E =======================================


GETEXEHEAD      proc near               ; CODE XREF: KERNELERROR:loc_76B0↑p
                                        ; FINDSEGSYMS:loc_77C1↑p
                mov     ax, cs:HEXEHEAD
                retn
GETEXEHEAD      endp


; =============== S U B R O U T I N E =======================================


ENTERBREAK      proc near               ; CODE XREF: FATALEXIT+FF↑p
                pop     ax
                pop     cx
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                pop     ax
                pop     bx
                add     sp, cx
                pushf
                push    bx
                push    ax
                xor     ax, ax
                mov     es, ax
                jmp     dword ptr es:HEXEHEAD
ENTERBREAK      endp


; =============== S U B R O U T I N E =======================================


__lshl          proc near               ; CODE XREF: FINDSEGSYMS+231↑p
                xor     ch, ch
                jcxz    short locret_7F30

loc_7F2A:                               ; CODE XREF: __lshl+8↓j
                shl     ax, 1
                rcl     dx, 1
                loop    loc_7F2A

locret_7F30:                            ; CODE XREF: __lshl+2↑j
                retn
__lshl          endp
#endif