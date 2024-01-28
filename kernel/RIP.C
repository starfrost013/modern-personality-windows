

; THIS IS A C FILE!!!!!
; IT MUST BE TRANSPILED TO C!!!!
; Figure out what is NOT c and put it in RIPAUX.ASM!!!

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
