
; =============== S U B R O U T I N E =======================================


LBESTFIT        proc near               ; CODE XREF: LCOMPACT:loc_5685↓p
                push    bx
                push    cx
                push    dx
                xor     si, si
                push    si
                mov     dx, [bx+2]
                sub     dx, bx

loc_5553:                               ; CODE XREF: LBESTFIT+3C↓j
                mov     ax, [bx]
                test    al, 1
                jz      short loc_5580
                test    al, 2
                jz      short loc_5580
                mov     si, [bx+4]
                cmp     byte ptr [si+3], 0
                jnz     short loc_5580
                mov     ax, [bx+2]
                sub     ax, bx
                cmp     ax, dx
                ja      short loc_557E
                pop     si
                or      si, si
                jz      short loc_557B
                add     ax, si
                cmp     ax, [si+2]
                jbe     short loc_557D

loc_557B:                               ; CODE XREF: LBESTFIT+2A↑j
                mov     si, bx

loc_557D:                               ; CODE XREF: LBESTFIT+31↑j
                push    si

loc_557E:                               ; CODE XREF: LBESTFIT+25↑j
                mov     ax, [bx]

loc_5580:                               ; CODE XREF: LBESTFIT+F↑j
                                        ; LBESTFIT+13↑j ...
                and     al, 0FCh
                mov     bx, ax
                loop    loc_5553
                pop     si
                pop     dx
                pop     cx
                pop     bx
                retn
LBESTFIT        endp


; =============== S U B R O U T I N E =======================================


LCOMPACT        proc near               ; CODE XREF: LALLOC+29↑p
                                        ; LALLOC+73↑p ...
                push    si
                mov     word ptr [di+0Ah], 1001h
                cmp     word ptr [di+2], 0
                jz      short loc_559A
                dec     byte ptr [di+0Ah]

loc_559A:                               ; CODE XREF: LCOMPACT+A↑j
                                        ; LCOMPACT+7E↓j
                push    dx
                xor     ax, ax
                push    ax
                mov     bx, [di+8]
                mov     cx, [di+4]

loc_55A4:                               ; CODE XREF: LCOMPACT:loc_55AE↓j
                mov     ax, [bx]
                test    al, 1
                jz      short loc_560B
                and     al, 0FCh
                mov     bx, ax

loc_55AE:                               ; CODE XREF: LCOMPACT:loc_565D↓j
                loop    loc_55A4

loc_55B0:                               ; CODE XREF: LCOMPACT+42↓j
                                        ; LCOMPACT+76↓j
                pop     bx
                pop     dx
                mov     ax, bx
                or      ax, ax
                jz      short loc_55C6
                sub     ax, [bx+2]
                neg     ax
                dec     byte ptr [di+0Ah]
                jl      short loc_55C6
                cmp     ax, dx
                jb      short loc_55C8

loc_55C6:                               ; CODE XREF: LCOMPACT+2B↑j
                                        ; LCOMPACT+35↑j
                pop     si
                retn
; ---------------------------------------------------------------------------

loc_55C8:                               ; CODE XREF: LCOMPACT+39↑j
                push    dx
                push    bx
                dec     byte ptr [di+0Bh]
                jz      short loc_55B0
                inc     byte ptr [di+0Ah]
                xor     si, si

loc_55D4:                               ; CODE XREF: LCOMPACT+5A↓j
                                        ; LCOMPACT+70↓j
                call    HENUM
                jz      short loc_55FD
                push    cx
                mov     cl, 2
                xchg    ax, cx
                mov     bx, si
                call    LNOTIFY
                pop     cx
                or      ax, ax
                jz      short loc_55D4
                mov     bx, [si]
                sub     bx, 6
                call    LFREE
                xor     ax, ax
                mov     [si], ax
                or      byte ptr [si+2], 40h
                or      byte ptr [di+0Ah], 80h
                jmp     short loc_55D4
; ---------------------------------------------------------------------------

loc_55FD:                               ; CODE XREF: LCOMPACT+4C↑j
                test    byte ptr [di+0Ah], 80h
                jz      short loc_55B0
                xor     byte ptr [di+0Ah], 80h
                pop     bx
                pop     dx
                jmp     short loc_559A
; ---------------------------------------------------------------------------

loc_560B:                               ; CODE XREF: LCOMPACT+1D↑j
                cmp     word ptr [di+2], 0
                jnz     short loc_5660
                mov     si, ax
                test    byte ptr [si], 2
                jz      short loc_5685
                mov     si, [si+4]
                cmp     byte ptr [si+3], 0
                jnz     short loc_5685
                push    cx
                push    di
                mov     si, ax
                call    LMOVE
                mov     [di], si
                or      byte ptr [di], 3
                mov     bx, ax
                mov     [di+2], bx
                and     word ptr [bx], 3
                or      [bx], di
                mov     [si+2], di
                and     byte ptr [si], 0FCh
                mov     bx, [di+4]
                lea     ax, [di+6]
                mov     [bx], ax
                pop     di
                mov     al, 1
                lea     cx, [si+6]
                call    LNOTIFY
                pop     cx
                mov     bx, si
                mov     si, [bx]
                test    byte ptr [si], 1
                jnz     short loc_565D
                call    LJOIN
                dec     cx

loc_565D:                               ; CODE XREF: LCOMPACT+CC↑j
                                        ; LCOMPACT+F8↓j
                jmp     loc_55AE
; ---------------------------------------------------------------------------

loc_5660:                               ; CODE XREF: LCOMPACT+84↑j
                                        ; LCOMPACT+FF↓j
                pop     si
                cmp     si, bx
                jz      short loc_567D
                test    word ptr [bx], 1
                jnz     short loc_567D
                or      si, si
                jz      short loc_567B
                mov     ax, [si+2]
                sub     ax, si
                add     ax, bx
                cmp     [bx+2], ax
                jbe     short loc_567D

loc_567B:                               ; CODE XREF: LCOMPACT+E2↑j
                mov     si, bx

loc_567D:                               ; CODE XREF: LCOMPACT+D8↑j
                                        ; LCOMPACT+DE↑j ...
                push    si

loc_567E:                               ; CODE XREF: LCOMPACT+153↓j
                mov     bx, [bx]
                and     bl, 0FCh
                jmp     short loc_565D
; ---------------------------------------------------------------------------

loc_5685:                               ; CODE XREF: LCOMPACT+8B↑j
                                        ; LCOMPACT+94↑j
                call    LBESTFIT
                or      si, si
                jz      short loc_5660
                push    cx
                push    di
                push    word ptr [bx]
                call    LMOVE
                pop     cx
                cmp     bx, di
                jz      short loc_569D
                mov     cx, bx
                mov     [bx+2], di

loc_569D:                               ; CODE XREF: LCOMPACT+10B↑j
                mov     [di], cx
                or      byte ptr [di], 3
                mov     [di+2], ax
                xchg    ax, di
                and     word ptr [di], 3
                or      [di], ax
                xchg    ax, di
                lea     cx, [di+6]
                cmp     bx, di
                mov     bx, di
                mov     di, [di+4]
                xchg    cx, [di]
                pop     di
                pop     ax
                jz      short loc_56C1
                inc     ax
                inc     word ptr [di+4]

loc_56C1:                               ; CODE XREF: LCOMPACT+130↑j
                push    bx
                push    ax
                mov     al, 1
                mov     bx, [bx+4]
                call    LNOTIFY
                pop     cx
                and     byte ptr [si], 0FDh
                mov     bx, si
                push    word ptr [di+4]
                call    LFREE
                pop     si
                sub     si, [di+4]
                sub     cx, si
                pop     bx
                jmp     short loc_567E
; ---------------------------------------------------------------------------
                xor     ax, ax
                mov     bx, cx
                inc     bx
                shl     bx, 1
                shl     bx, 1
                push    cx
                call    LALLOC
                pop     cx
                jz      short loc_5702
                mov     bx, ax
                xchg    bx, [di+0Eh]
                push    di
                mov     di, ax
                mov     [di], cx
                inc     di
                inc     di
                call    HTHREAD
                mov     [di], bx
                pop     di

loc_5702:                               ; CODE XREF: LCOMPACT+163↑j
                mov     cx, ax
                retn
LCOMPACT        endp
