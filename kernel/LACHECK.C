/* THIS IS A C FILE */

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

CHECKLOCALHEAP  proc near               ; CODE XREF: LOCALALLOC+7↑p
                                        ; LOCALREALLOC+7↑p ...

var_1A          = byte ptr -1Ah
var_18          = word ptr -18h
var_16          = word ptr -16h
var_14          = word ptr -14h
var_12          = word ptr -12h
var_10          = word ptr -10h
var_E           = word ptr -0Eh
var_C           = word ptr -0Ch
var_A           = word ptr -0Ah
var_8           = word ptr -8
var_6           = word ptr -6
var_4           = word ptr -4
var_2           = word ptr -2

                push    bp
                mov     bp, sp
                sub     sp, 1Ah
                mov     [bp+var_2], 0
                mov     ax, ds:6
                mov     [bp+var_12], ax
                or      ax, ax
                jnz     short loc_70DA

loc_70D5:                               ; CODE XREF: CHECKLOCALHEAP+20↓j
                sub     ax, ax
                jmp     loc_72A9
; ---------------------------------------------------------------------------

loc_70DA:                               ; CODE XREF: CHECKLOCALHEAP+13↑j
                mov     bx, [bp+var_12]
                cmp     word ptr [bx], 0
                jz      short loc_70D5
                mov     ax, [bx+4]
                mov     [bp+var_8], ax
                mov     ax, [bx+6]
                mov     [bp+var_4], ax
                mov     bx, ax
                test    byte ptr [bx], 1
                jnz     short loc_70F9
                or      byte ptr [bp+var_2], 1

loc_70F9:                               ; CODE XREF: CHECKLOCALHEAP+33↑j
                                        ; CHECKLOCALHEAP+53↓j
                mov     ax, [bp+var_8]
                dec     [bp+var_8]
                or      ax, ax
                jz      short loc_711E
                mov     bx, [bp+var_4]
                mov     ax, bx
                cmp     [bx+2], ax
                jbe     short loc_7115
                mov     ax, [bx+2]
                mov     [bp+var_4], ax
                jmp     short loc_70F9
; ---------------------------------------------------------------------------

loc_7115:                               ; CODE XREF: CHECKLOCALHEAP+4B↑j
                mov     bx, [bp+var_4]
                mov     ax, [bx+2]
                mov     [bp+var_4], ax

loc_711E:                               ; CODE XREF: CHECKLOCALHEAP+41↑j
                cmp     [bp+var_8], 0
                jnz     short loc_712F
                mov     bx, [bp+var_12]
                mov     ax, [bp+var_4]
                cmp     [bx+8], ax
                jz      short loc_7133

loc_712F:                               ; CODE XREF: CHECKLOCALHEAP+62↑j
                or      byte ptr [bp+var_2], 1

loc_7133:                               ; CODE XREF: CHECKLOCALHEAP+6D↑j
                mov     bx, [bp+var_12]
                mov     ax, [bx+4]
                mov     [bp+var_8], ax
                mov     ax, [bx+8]
                mov     [bp+var_4], ax
                mov     bx, ax
                test    byte ptr [bx], 1
                jnz     short loc_714D
                or      byte ptr [bp+var_2], 2

loc_714D:                               ; CODE XREF: CHECKLOCALHEAP+87↑j
                                        ; CHECKLOCALHEAP+A8↓j
                mov     ax, [bp+var_8]
                dec     [bp+var_8]
                or      ax, ax
                jz      short loc_7170
                mov     bx, [bp+var_4]
                mov     ax, [bx]
                and     al, 0FCh
                mov     [bp+var_C], ax
                cmp     bx, ax
                jbe     short loc_716A
                mov     [bp+var_4], ax
                jmp     short loc_714D
; ---------------------------------------------------------------------------

loc_716A:                               ; CODE XREF: CHECKLOCALHEAP+A3↑j
                mov     ax, [bp+var_C]
                mov     [bp+var_4], ax

loc_7170:                               ; CODE XREF: CHECKLOCALHEAP+95↑j
                cmp     [bp+var_8], 0
                jnz     short loc_7181
                mov     bx, [bp+var_12]
                mov     ax, [bp+var_4]
                cmp     [bx+6], ax
                jz      short loc_7185

loc_7181:                               ; CODE XREF: CHECKLOCALHEAP+B4↑j
                or      byte ptr [bp+var_2], 2

loc_7185:                               ; CODE XREF: CHECKLOCALHEAP+BF↑j
                mov     bx, [bp+var_12]
                mov     ax, [bx+4]
                mov     [bp+var_8], ax
                mov     ax, [bx+6]
                mov     [bp+var_4], ax
                mov     [bp+var_E], 0
                jmp     short loc_71E2
; ---------------------------------------------------------------------------

loc_719B:                               ; CODE XREF: CHECKLOCALHEAP+12A↓j
                mov     bx, [bp+var_4]
                mov     al, [bx]
                mov     [bp+var_1A], al
                test    [bp+var_1A], 1
                jz      short loc_71D9
                test    [bp+var_1A], 2
                jz      short loc_71D9
                mov     ax, [bx+4]
                mov     [bp+var_A], ax
                mov     bx, ax
                cmp     word ptr [bx+2], 0FFFFh
                jnz     short loc_71C3
                or      byte ptr [bp+var_2], 4
                jmp     short loc_71D9
; ---------------------------------------------------------------------------

loc_71C3:                               ; CODE XREF: CHECKLOCALHEAP+FB↑j
                mov     ax, [bp+var_4]
                add     ax, 6
                mov     bx, [bp+var_A]
                cmp     ax, [bx]
                jz      short loc_71D6
                or      byte ptr [bp+var_2], 8
                jmp     short loc_71D9
; ---------------------------------------------------------------------------

loc_71D6:                               ; CODE XREF: CHECKLOCALHEAP+10E↑j
                inc     [bp+var_E]

loc_71D9:                               ; CODE XREF: CHECKLOCALHEAP+E7↑j
                                        ; CHECKLOCALHEAP+ED↑j ...
                mov     bx, [bp+var_4]
                mov     ax, [bx+2]
                mov     [bp+var_4], ax

loc_71E2:                               ; CODE XREF: CHECKLOCALHEAP+D9↑j
                mov     ax, [bp+var_8]
                dec     [bp+var_8]
                or      ax, ax
                jnz     short loc_719B
                mov     bx, [bp+var_12]
                mov     ax, [bx+0Eh]
                mov     [bp+var_10], ax
                mov     [bp+var_16], 0
                mov     [bp+var_18], 0
                mov     [bp+var_6], 0
                mov     [bp+var_14], 0
                jmp     short loc_7255
; ---------------------------------------------------------------------------

loc_720B:                               ; CODE XREF: CHECKLOCALHEAP+199↓j
                mov     ax, [bp+var_10]
                inc     ax
                inc     ax
                mov     [bp+var_A], ax
                mov     bx, [bp+var_10]
                mov     ax, [bx]
                mov     [bp+var_8], ax
                add     [bp+var_16], ax
                jmp     short loc_7243
; ---------------------------------------------------------------------------

loc_7220:                               ; CODE XREF: CHECKLOCALHEAP+18B↓j
                mov     bx, [bp+var_A]
                cmp     word ptr [bx+2], 0FFFFh
                jnz     short loc_722E
                inc     [bp+var_14]
                jmp     short loc_723F
; ---------------------------------------------------------------------------

loc_722E:                               ; CODE XREF: CHECKLOCALHEAP+167↑j
                mov     bx, [bp+var_A]
                test    byte ptr [bx+2], 40h
                jz      short loc_723C
                inc     [bp+var_18]
                jmp     short loc_723F
; ---------------------------------------------------------------------------

loc_723C:                               ; CODE XREF: CHECKLOCALHEAP+175↑j
                inc     [bp+var_6]

loc_723F:                               ; CODE XREF: CHECKLOCALHEAP+16C↑j
                                        ; CHECKLOCALHEAP+17A↑j
                add     [bp+var_A], 4

loc_7243:                               ; CODE XREF: CHECKLOCALHEAP+15E↑j
                mov     ax, [bp+var_8]
                dec     [bp+var_8]
                or      ax, ax
                jnz     short loc_7220
                mov     bx, [bp+var_A]
                mov     ax, [bx]
                mov     [bp+var_10], ax

loc_7255:                               ; CODE XREF: CHECKLOCALHEAP+149↑j
                cmp     [bp+var_10], 0
                jnz     short loc_720B
                mov     ax, [bp+var_6]
                cmp     [bp+var_E], ax
                jz      short loc_7267
                or      byte ptr [bp+var_2], 10h

loc_7267:                               ; CODE XREF: CHECKLOCALHEAP+1A1↑j
                mov     ax, [bp+var_14]
                add     ax, [bp+var_6]
                add     ax, [bp+var_18]
                cmp     ax, [bp+var_16]
                jz      short loc_7279
                or      byte ptr [bp+var_2], 20h

loc_7279:                               ; CODE XREF: CHECKLOCALHEAP+1B3↑j
                mov     bx, [bp+var_12]
                mov     ax, [bx+10h]
                mov     [bp+var_A], ax
                mov     [bp+var_8], 0
                jmp     short loc_7294
; ---------------------------------------------------------------------------

loc_7289:                               ; CODE XREF: CHECKLOCALHEAP+1D8↓j
                inc     [bp+var_8]
                mov     bx, [bp+var_A]
                mov     ax, [bx]
                mov     [bp+var_A], ax

loc_7294:                               ; CODE XREF: CHECKLOCALHEAP+1C7↑j
                cmp     [bp+var_A], 0
                jnz     short loc_7289
                mov     ax, [bp+var_8]
                cmp     [bp+var_14], ax
                jz      short loc_72A6
                or      byte ptr [bp+var_2], 40h

loc_72A6:                               ; CODE XREF: CHECKLOCALHEAP+1E0↑j
                mov     ax, [bp+var_2]

loc_72A9:                               ; CODE XREF: CHECKLOCALHEAP+17↑j
                mov     sp, bp
                pop     bp
                retn
CHECKLOCALHEAP  endp