

; =============== S U B R O U T I N E =======================================


GCOMPACT        proc near               ; CODE XREF: GREALLOC+17A↑p
                                        ; GREALLOC+1F3↑p ...
                push    si

loc_6673:                               ; CODE XREF: GCOMPACT+33↓j
                push    dx
                cmp     [di+1Eh], di
                jz      short loc_6682
                mov     es, word ptr [di+6]
                mov     bx, 8
                call    GCMPHEAP

loc_6682:                               ; CODE XREF: GCOMPACT+5↑j
                mov     es, word ptr [di+8]
                mov     bx, 6
                call    GCMPHEAP
                pop     dx
                mov     es, ax
                or      ax, ax
                jz      short loc_6697
                call    GCHECKFREE
                jnb     short loc_66A7

loc_6697:                               ; CODE XREF: GCOMPACT+1E↑j
                test    byte ptr [di+0Bh], 30h
                jnz     short loc_66A7
                cmp     [di+2], di
                jnz     short loc_66A7
                call    GDISCARD
                jnz     short loc_6673

loc_66A7:                               ; CODE XREF: GCOMPACT+23↑j
                                        ; GCOMPACT+29↑j ...
                pop     si
                retn
GCOMPACT        endp


; =============== S U B R O U T I N E =======================================


GCMPHEAP        proc near               ; CODE XREF: GCOMPACT+D↑p
                                        ; GCOMPACT+16↑p
                mov     cx, [di+4]
                xor     ax, ax
                push    ax

loc_66AF:                               ; CODE XREF: GCMPHEAP+F↓j
                cmp     es:[di+1], di
                jz      short loc_66BC

loc_66B5:                               ; CODE XREF: GCMPHEAP+2B↓j
                                        ; GCMPHEAP+5A↓j
                mov     es, word ptr es:[bx]
                loop    loc_66AF
                pop     ax
                retn
; ---------------------------------------------------------------------------

loc_66BC:                               ; CODE XREF: GCMPHEAP+A↑j
                                        ; GCMPHEAP+21↓j ...
                test    byte ptr [di+0Bh], 10h
                jnz     short loc_66D1
                cmp     [di+2], di
                jnz     short loc_66D1
                call    GSLIDE
                jnz     short loc_66BC
                call    GBESTFIT
                jnz     short loc_66BC

loc_66D1:                               ; CODE XREF: GCMPHEAP+17↑j
                                        ; GCMPHEAP+1C↑j
                cmp     bl, 6
                jnz     short loc_66B5
                pop     si
                mov     ax, es
                cmp     si, ax
                jz      short loc_6702
                cmp     es:[di+1], di
                jnz     short loc_6702
                or      si, si
                jz      short loc_6700
                cmp     [di+1Eh], di
                jz      short loc_66F2
                test    byte ptr [di+0Bh], 8
                jnz     short loc_6702

loc_66F2:                               ; CODE XREF: GCMPHEAP+41↑j
                push    es
                mov     es, si
                mov     ax, es:[di+3]
                pop     es
                cmp     es:[di+3], ax
                jb      short loc_6702

loc_6700:                               ; CODE XREF: GCMPHEAP+3C↑j
                mov     si, es

loc_6702:                               ; CODE XREF: GCMPHEAP+32↑j
                                        ; GCMPHEAP+38↑j ...
                push    si
                jmp     short loc_66B5
GCMPHEAP        endp



; =============== S U B R O U T I N E =======================================


GBESTFIT        proc near               ; CODE XREF: GCMPHEAP+23↑p
                push    es
                push    cx
                xor     si, si
                mov     dx, es:[di+3]

loc_67DD:                               ; CODE XREF: GBESTFIT+36↓j
                cmp     es:[di+1], di
                jz      short loc_6808
                push    si
                call    GMOVEABLE
                pop     si
                jz      short loc_6808
                cmp     es:[di+3], dx
                ja      short loc_6808
                or      si, si
                jz      short loc_6802
                push    es
                mov     es, si
                mov     ax, es:[di+3]
                pop     es
                cmp     es:[di+3], ax
                jbe     short loc_6808

loc_6802:                               ; CODE XREF: GBESTFIT+1D↑j
                mov     si, es
                mov     ax, es:[di+3]

loc_6808:                               ; CODE XREF: GBESTFIT+C↑j
                                        ; GBESTFIT+13↑j ...
                mov     es, word ptr es:[bx]
                loop    loc_67DD
                pop     cx
                pop     es
                or      si, si
                jz      short locret_6816
                call    GMOVEBUSY

locret_6816:                            ; CODE XREF: GBESTFIT+3C↑j
                retn
GBESTFIT        endp
