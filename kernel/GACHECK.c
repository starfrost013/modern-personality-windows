/* THIS IS A C FILE */

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

CHECKGLOBALHEAP proc near               ; CODE XREF: GLOBALALLOC+7↑p
                                        ; GLOBALREALLOC+7↑p ...

var_2A          = word ptr -2Ah
var_28          = word ptr -28h
var_26          = word ptr -26h
var_24          = dword ptr -24h
var_20          = dword ptr -20h
var_1C          = word ptr -1Ch
var_1A          = word ptr -1Ah
var_18          = dword ptr -18h
var_14          = word ptr -14h
var_12          = word ptr -12h
var_10          = word ptr -10h
var_E           = word ptr -0Eh
var_C           = word ptr -0Ch
var_A           = word ptr -0Ah
var_8           = word ptr -8
var_6           = dword ptr -6
var_2           = word ptr -2

                push    bp
                mov     bp, sp
                sub     sp, 2Ah
                mov     [bp+var_2], 0
                call    GLOBALINFOPTR
                mov     word ptr [bp+var_24], ax
                mov     word ptr [bp+var_24+2], dx
                or      ax, dx
                jnz     short loc_72CB

loc_72C5:                               ; CODE XREF: CHECKGLOBALHEAP+25↓j
                sub     ax, ax
                cwd
                jmp     loc_75EE
; ---------------------------------------------------------------------------

loc_72CB:                               ; CODE XREF: CHECKGLOBALHEAP+16↑j
                les     bx, [bp+var_24]
                cmp     word ptr es:[bx], 0
                jz      short loc_72C5
                mov     ax, bx
                mov     dx, es
                sub     ax, ax
                mov     [bp+var_12], ax
                mov     [bp+var_10], dx
                mov     ax, es:[bx+4]
                mov     [bp+var_14], ax
                mov     [bp+var_1A], 0FFFFh
                mov     [bp+var_E], 0
                mov     ax, es:[bx+6]

loc_72F5:                               ; CODE XREF: CHECKGLOBALHEAP+134↓j
                mov     [bp+var_8], ax
                mov     ax, [bp+var_14]
                dec     [bp+var_14]
                or      ax, ax
                jz      short loc_7320
                les     bx, [bp+var_24]
                mov     ax, [bp+var_8]
                cmp     es:[bx+6], ax
                ja      short loc_7314
                cmp     es:[bx+8], ax
                jnb     short loc_7386

loc_7314:                               ; CODE XREF: CHECKGLOBALHEAP+5F↑j
                cmp     [bp+var_E], 0
                jnz     short loc_7320

loc_731A:                               ; CODE XREF: CHECKGLOBALHEAP:loc_7412↓j
                mov     ax, [bp+var_1A]
                mov     [bp+var_E], ax

loc_7320:                               ; CODE XREF: CHECKGLOBALHEAP+53↑j
                                        ; CHECKGLOBALHEAP+6B↑j ...
                cmp     [bp+var_E], 0
                jnz     short loc_7338
                cmp     [bp+var_14], 0
                jnz     short loc_7338
                les     bx, [bp+var_24]
                mov     ax, [bp+var_8]
                cmp     es:[bx+8], ax
                jz      short loc_733C

loc_7338:                               ; CODE XREF: CHECKGLOBALHEAP+77↑j
                                        ; CHECKGLOBALHEAP+7D↑j
                or      byte ptr [bp+var_2], 1

loc_733C:                               ; CODE XREF: CHECKGLOBALHEAP+89↑j
                les     bx, [bp+var_24]
                mov     ax, es:[bx+4]
                mov     [bp+var_14], ax
                mov     [bp+var_1A], 0FFFFh
                mov     ax, es:[bx+8]
                mov     [bp+var_8], ax

loc_7352:                               ; CODE XREF: CHECKGLOBALHEAP+18A↓j
                mov     ax, [bp+var_14]
                dec     [bp+var_14]
                or      ax, ax
                jnz     short loc_735F
                jmp     loc_743A
; ---------------------------------------------------------------------------

loc_735F:                               ; CODE XREF: CHECKGLOBALHEAP+AD↑j
                les     bx, [bp+var_24]
                mov     ax, [bp+var_8]
                cmp     es:[bx+6], ax
                ja      short loc_7374
                cmp     es:[bx+8], ax
                jb      short loc_7374
                jmp     loc_7415
; ---------------------------------------------------------------------------

loc_7374:                               ; CODE XREF: CHECKGLOBALHEAP+BC↑j
                                        ; CHECKGLOBALHEAP+C2↑j
                cmp     [bp+var_E], 0
                jz      short loc_737D
                jmp     loc_743A
; ---------------------------------------------------------------------------

loc_737D:                               ; CODE XREF: CHECKGLOBALHEAP+CB↑j
                mov     ax, [bp+var_1A]
                mov     [bp+var_E], ax
                jmp     loc_743A
; ---------------------------------------------------------------------------

loc_7386:                               ; CODE XREF: CHECKGLOBALHEAP+65↑j
                mov     dx, [bp+var_8]
                sub     ax, ax
                mov     word ptr [bp+var_6], ax
                mov     word ptr [bp+var_6+2], dx
                les     bx, [bp+var_6]
                mov     ax, dx
                cmp     es:[bx+8], ax
                jbe     short loc_73E4
                cmp     [bp+var_E], 0
                jnz     short loc_73D4
                cmp     byte ptr es:[bx], 4Dh ; 'M'
                jz      short loc_73AD
                mov     ax, [bp+var_1A]
                jmp     short loc_73D1
; ---------------------------------------------------------------------------

loc_73AD:                               ; CODE XREF: CHECKGLOBALHEAP+F9↑j
                les     bx, [bp+var_6]
                cmp     word ptr es:[bx+3], 0
                jnz     short loc_73BD
                cmp     [bp+var_1A], 0FFFFh
                jz      short loc_73D4

loc_73BD:                               ; CODE XREF: CHECKGLOBALHEAP+108↑j
                les     bx, [bp+var_6]
                mov     ax, es:[bx+3]
                add     ax, [bp+var_8]
                inc     ax
                cmp     ax, es:[bx+8]
                jz      short loc_73D4
                mov     ax, [bp+var_8]

loc_73D1:                               ; CODE XREF: CHECKGLOBALHEAP+FE↑j
                mov     [bp+var_E], ax

loc_73D4:                               ; CODE XREF: CHECKGLOBALHEAP+F3↑j
                                        ; CHECKGLOBALHEAP+10E↑j ...
                mov     ax, [bp+var_8]
                mov     [bp+var_1A], ax
                les     bx, [bp+var_6]
                mov     ax, es:[bx+8]
                jmp     loc_72F5
; ---------------------------------------------------------------------------

loc_73E4:                               ; CODE XREF: CHECKGLOBALHEAP+ED↑j
                mov     ax, [bp+var_8]
                mov     [bp+var_1A], ax
                les     bx, [bp+var_6]
                mov     ax, es:[bx+8]
                mov     [bp+var_8], ax
                mov     dx, ax
                sub     ax, ax
                mov     word ptr [bp+var_6], ax
                mov     word ptr [bp+var_6+2], dx
                cmp     [bp+var_E], ax
                jz      short loc_7406
                jmp     loc_7320
; ---------------------------------------------------------------------------

loc_7406:                               ; CODE XREF: CHECKGLOBALHEAP+154↑j
                les     bx, [bp+var_6]
                cmp     byte ptr es:[bx], 5Ah ; 'Z'
                jnz     short loc_7412
                jmp     loc_7320
; ---------------------------------------------------------------------------

loc_7412:                               ; CODE XREF: CHECKGLOBALHEAP+160↑j
                jmp     loc_731A
; ---------------------------------------------------------------------------

loc_7415:                               ; CODE XREF: CHECKGLOBALHEAP+C4↑j
                mov     dx, [bp+var_8]
                sub     ax, ax
                mov     word ptr [bp+var_6], ax
                mov     word ptr [bp+var_6+2], dx
                mov     ax, dx
                mov     [bp+var_1A], ax
                les     bx, [bp+var_6]
                mov     ax, es:[bx+6]
                mov     [bp+var_8], ax
                mov     ax, [bp+var_1A]
                cmp     [bp+var_8], ax
                jnb     short loc_743A
                jmp     loc_7352
; ---------------------------------------------------------------------------

loc_743A:                               ; CODE XREF: CHECKGLOBALHEAP+AF↑j
                                        ; CHECKGLOBALHEAP+CD↑j ...
                cmp     [bp+var_14], 0
                jnz     short loc_744C
                les     bx, [bp+var_24]
                mov     ax, [bp+var_8]
                cmp     es:[bx+6], ax
                jz      short loc_7450

loc_744C:                               ; CODE XREF: CHECKGLOBALHEAP+191↑j
                or      byte ptr [bp+var_2], 2

loc_7450:                               ; CODE XREF: CHECKGLOBALHEAP+19D↑j
                cmp     [bp+var_2], 0
                jz      short loc_7459
                jmp     loc_75E6
; ---------------------------------------------------------------------------

loc_7459:                               ; CODE XREF: CHECKGLOBALHEAP+1A7↑j
                cmp     [bp+var_E], 0
                jz      short loc_7462
                jmp     loc_75E6
; ---------------------------------------------------------------------------

loc_7462:                               ; CODE XREF: CHECKGLOBALHEAP+1B0↑j
                les     bx, [bp+var_24]
                mov     ax, es:[bx+4]
                mov     [bp+var_14], ax
                mov     ax, es:[bx+6]
                mov     [bp+var_8], ax
                mov     [bp+var_1C], 0
                jmp     short loc_74EB
; ---------------------------------------------------------------------------

loc_747A:                               ; CODE XREF: CHECKGLOBALHEAP+246↓j
                mov     dx, [bp+var_8]
                sub     ax, ax
                mov     word ptr [bp+var_6], ax
                mov     word ptr [bp+var_6+2], dx
                les     bx, [bp+var_6]
                cmp     es:[bx+1], ax
                jz      short loc_74E1
                cmp     es:[bx+0Ah], ax
                jz      short loc_74E1
                mov     ax, es:[bx+0Ah]
                sub     dx, dx
                or      ax, [bp+var_12]
                mov     dx, [bp+var_10]
                mov     word ptr [bp+var_18], ax
                mov     word ptr [bp+var_18+2], dx
                les     bx, [bp+var_18]
                cmp     word ptr es:[bx+2], 0FFFFh
                jnz     short loc_74C2
                or      byte ptr [bp+var_2], 4

loc_74B4:                               ; CODE XREF: CHECKGLOBALHEAP+22F↓j
                cmp     [bp+var_E], 0
                jnz     short loc_74E1
                mov     ax, [bp+var_8]
                mov     [bp+var_E], ax
                jmp     short loc_74E1
; ---------------------------------------------------------------------------

loc_74C2:                               ; CODE XREF: CHECKGLOBALHEAP+201↑j
                les     bx, [bp+var_6]
                cmp     word ptr es:[bx+0Ah], 0FFFFh
                jz      short loc_74D8
                les     bx, [bp+var_18]
                mov     ax, [bp+var_8]
                inc     ax
                cmp     es:[bx], ax
                jz      short loc_74DE

loc_74D8:                               ; CODE XREF: CHECKGLOBALHEAP+21D↑j
                or      byte ptr [bp+var_2], 8
                jmp     short loc_74B4
; ---------------------------------------------------------------------------

loc_74DE:                               ; CODE XREF: CHECKGLOBALHEAP+229↑j
                inc     [bp+var_1C]

loc_74E1:                               ; CODE XREF: CHECKGLOBALHEAP+1DF↑j
                                        ; CHECKGLOBALHEAP+1E5↑j ...
                les     bx, [bp+var_6]
                mov     ax, es:[bx+8]
                mov     [bp+var_8], ax

loc_74EB:                               ; CODE XREF: CHECKGLOBALHEAP+1CB↑j
                mov     ax, [bp+var_14]
                dec     [bp+var_14]
                or      ax, ax
                jnz     short loc_747A
                mov     [bp+var_28], 0
                mov     [bp+var_2A], 0
                mov     [bp+var_A], 0
                mov     [bp+var_26], 0
                les     bx, [bp+var_24]
                mov     ax, es:[bx+0Eh]
                mov     [bp+var_8], ax
                mov     ax, [bp+var_1C]
                mov     [bp+var_C], ax
                jmp     short loc_7581
; ---------------------------------------------------------------------------

loc_751B:                               ; CODE XREF: CHECKGLOBALHEAP+2DC↓j
                cmp     [bp+var_8], 0
                jz      short loc_758B
                mov     ax, [bp+var_8]
                sub     dx, dx
                or      ax, [bp+var_12]
                mov     dx, [bp+var_10]
                mov     word ptr [bp+var_20], ax
                mov     word ptr [bp+var_20+2], dx
                add     ax, 2
                mov     word ptr [bp+var_18], ax
                mov     word ptr [bp+var_18+2], dx
                les     bx, [bp+var_20]
                mov     ax, es:[bx]
                mov     [bp+var_14], ax
                add     [bp+var_28], ax
                jmp     short loc_756E
; ---------------------------------------------------------------------------

loc_7549:                               ; CODE XREF: CHECKGLOBALHEAP+2C9↓j
                les     bx, [bp+var_18]
                cmp     word ptr es:[bx+2], 0FFFFh
                jnz     short loc_7558
                inc     [bp+var_26]
                jmp     short loc_756A
; ---------------------------------------------------------------------------

loc_7558:                               ; CODE XREF: CHECKGLOBALHEAP+2A4↑j
                les     bx, [bp+var_18]
                test    byte ptr es:[bx+2], 40h
                jz      short loc_7567
                inc     [bp+var_2A]
                jmp     short loc_756A
; ---------------------------------------------------------------------------

loc_7567:                               ; CODE XREF: CHECKGLOBALHEAP+2B3↑j
                inc     [bp+var_A]

loc_756A:                               ; CODE XREF: CHECKGLOBALHEAP+2A9↑j
                                        ; CHECKGLOBALHEAP+2B8↑j
                add     word ptr [bp+var_18], 4

loc_756E:                               ; CODE XREF: CHECKGLOBALHEAP+29A↑j
                mov     ax, [bp+var_14]
                dec     [bp+var_14]
                or      ax, ax
                jnz     short loc_7549
                les     bx, [bp+var_18]
                mov     ax, es:[bx]
                mov     [bp+var_8], ax

loc_7581:                               ; CODE XREF: CHECKGLOBALHEAP+26C↑j
                mov     ax, [bp+var_C]
                dec     [bp+var_C]
                or      ax, ax
                jnz     short loc_751B

loc_758B:                               ; CODE XREF: CHECKGLOBALHEAP+272↑j
                mov     ax, [bp+var_A]
                cmp     [bp+var_1C], ax
                jz      short loc_7597
                or      byte ptr [bp+var_2], 10h

loc_7597:                               ; CODE XREF: CHECKGLOBALHEAP+2E4↑j
                mov     ax, [bp+var_26]
                add     ax, [bp+var_A]
                add     ax, [bp+var_2A]
                cmp     ax, [bp+var_28]
                jz      short loc_75A9
                or      byte ptr [bp+var_2], 20h

loc_75A9:                               ; CODE XREF: CHECKGLOBALHEAP+2F6↑j
                mov     ax, [bp+var_26]
                mov     [bp+var_14], ax
                les     bx, [bp+var_24]
                mov     ax, es:[bx+10h]
                jmp     short loc_75CF
; ---------------------------------------------------------------------------

loc_75B8:                               ; CODE XREF: CHECKGLOBALHEAP+32D↓j
                mov     ax, [bp+var_8]
                sub     dx, dx
                or      ax, [bp+var_12]
                mov     dx, [bp+var_10]
                mov     word ptr [bp+var_18], ax
                mov     word ptr [bp+var_18+2], dx
                les     bx, [bp+var_18]
                mov     ax, es:[bx]

loc_75CF:                               ; CODE XREF: CHECKGLOBALHEAP+309↑j
                mov     [bp+var_8], ax
                mov     ax, [bp+var_14]
                dec     [bp+var_14]
                or      ax, ax
                jnz     short loc_75B8
                cmp     [bp+var_8], 0
                jz      short loc_75E6
                or      byte ptr [bp+var_2], 40h

loc_75E6:                               ; CODE XREF: CHECKGLOBALHEAP+1A9↑j
                                        ; CHECKGLOBALHEAP+1B2↑j ...
                mov     dx, [bp+var_E]
                sub     ax, ax
                mov     ax, [bp+var_2]

loc_75EE:                               ; CODE XREF: CHECKGLOBALHEAP+1B↑j
                mov     sp, bp
                pop     bp
                retn
CHECKGLOBALHEAP endp