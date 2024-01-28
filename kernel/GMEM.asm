

; =============== S U B R O U T I N E =======================================


GENTERCURRENTPDB proc near              ; CODE XREF: INT21ALLOC↓p
                                        ; INT21REALLOC↓p ...
                lds     di, cs:PCURRENTPDB
                mov     ds, word ptr [di]
                mov     cx, ds
                xor     ax, ax
                cmp     ds:4Ah, ax
                jz      short GENTER
                lds     di, ds:48h
                inc     word ptr [di+18h]
                retn
GENTERCURRENTPDB endp


; ---------------------------------------------------------------------------
                nop

; =============== S U B R O U T I N E =======================================


GENTER          proc near               ; CODE XREF: GETCODEHANDLE+50↑p
                                        ; INT24HANDLER+8E↑p ...
                mov     ds, cs:PGLOBALHEAP
                xor     di, di
                inc     word ptr [di+18h] ; increment memory block reference count
                retn
GENTER          endp


; =============== S U B R O U T I N E =======================================


GLEAVE          proc near               ; CODE XREF: GETCODEHANDLE+56↑p
                                        ; INT24HANDLER+94↑p ...
                dec     word ptr [di+18h] ; decrement memory block reference count
                retn
GLEAVE          endp


; =============== S U B R O U T I N E =======================================


GBTOP           proc near               ; CODE XREF: GLOBALALLOC+4D↓p
                                        ; GLOBALREALLOC+50↓p ...
                push    dx
                mov     dx, ss:[bx+2]
                mov     bx, ss:[bx]
                mov     cx, 4
                add     bx, 0Fh
                adc     dx, 0
                jnb     short loc_69E7
                dec     dx
                dec     bx

loc_69E7:                               ; CODE XREF: GBTOP+11↑j
                                        ; GBTOP+19↓j
                shr     dx, 1
                rcr     bx, 1
                loop    loc_69E7
                pop     dx
                inc     ax
                jz      short locret_6A44
                dec     ax
                push    cs
                pop     cx
                cmp     [bp+4], cx
                jz      short loc_69FB
                and     al, 0F2h

loc_69FB:                               ; CODE XREF: GBTOP+25↑j
                mov     [di+0Bh], al
                test    dl, 1
                jnz     short loc_6A18
                or      dx, dx
                jnz     short loc_6A0B
                test    al, 2
                jz      short loc_6A18

loc_6A0B:                               ; CODE XREF: GBTOP+33↑j
                or      al, 1
                cmp     [di+1Eh], di
                jz      short loc_6A18
                test    al, 8
                jnz     short loc_6A18
                xor     al, 1

loc_6A18:                               ; CODE XREF: GBTOP+2F↑j
                                        ; GBTOP+37↑j ...
                test    ah, 0Fh
                jz      short loc_6A23
                and     ah, 0F0h
                or      ah, 1

loc_6A23:                               ; CODE XREF: GBTOP+49↑j
                and     ah, 31h
                mov     cl, 0Ch
                and     cl, al
                or      ah, cl
                test    ah, 30h
                jz      short loc_6A3C
                mov     cx, [bp+4]
                dec     cx
                mov     es, cx
                mov     cx, es:[di+1]
                retn
; ---------------------------------------------------------------------------

loc_6A3C:                               ; CODE XREF: GBTOP+5D↑j
                les     si, cs:PCURRENTPDB
                mov     cx, es:[si]

locret_6A44:                            ; CODE XREF: GBTOP+1D↑j
                retn
GBTOP           endp


; =============== S U B R O U T I N E =======================================


GRESERVE        proc near               ; CODE XREF: CALCMAXNRSEG:loc_2555↑p
                push    ds
                push    di
                call    GENTER
                inc     ax
                add     ax, 1
                and     al, 0FEh
                mov     dx, ax
                xchg    ax, [di+1Eh]
                push    ax
                cmp     dx, ax
                jbe     short loc_6A79
                or      ax, ax
                jnz     short loc_6A61
                inc     ax
                jmp     short loc_6A79
; ---------------------------------------------------------------------------

loc_6A61:                               ; CODE XREF: GRESERVE+17↑j
                mov     byte ptr [di+0Bh], 0
                call    GRTEST
                jnz     short loc_6A79
                mov     dx, [di+1Eh]
                call    GCOMPACT
                call    GRTEST
                jnz     short loc_6A79
                pop     word ptr [di+1Eh]
                push    dx

loc_6A79:                               ; CODE XREF: GRESERVE+13↑j
                                        ; GRESERVE+1A↑j ...
                pop     dx
                call    GLEAVE
                pop     di
                pop     ds
                retn
GRESERVE        endp


; =============== S U B R O U T I N E =======================================


GRTEST          proc near               ; CODE XREF: GRESERVE+20↑p
                                        ; GRESERVE+2B↑p
                mov     bx, 6
                mov     cx, [di+4]
                xor     dx, dx
                mov     es, word ptr [di+8]
                call    GFINDFREE
                or      ax, ax
                retn
GRTEST          endp


; =============== S U B R O U T I N E =======================================


GAVAIL          proc near               ; CODE XREF: GLOBALCOMPACT+54↓p
                mov     byte ptr [di+0Bh], 0
                call    GCOMPACT
                or      dx, dx
                jz      short loc_6A9F
                jmp     loc_6B29
; ---------------------------------------------------------------------------

loc_6A9F:                               ; CODE XREF: GAVAIL+9↑j
                push    dx
                mov     es, word ptr [di+6]

loc_6AA3:                               ; CODE XREF: GAVAIL+28↓j
                                        ; GAVAIL+2E↓j ...
                cmp     byte ptr es:[di], 5Ah ; 'Z'
                jz      short loc_6B26
                mov     es, word ptr es:[di+8]
                cmp     es:[di+1], di
                jz      short loc_6ACE
                mov     si, es:[di+0Ah]
                or      si, si
                jz      short loc_6AA3
                cmp     byte ptr [si+3], 0
                jnz     short loc_6AA3
                test    byte ptr [si+2], 1
                jz      short loc_6AA3
                test    byte ptr es:[di+5], 8
                jnz     short loc_6AA3

loc_6ACE:                               ; CODE XREF: GAVAIL+20↑j
                push    es
                mov     ax, es:[di+3]
                mov     cx, [di+4]

loc_6AD6:                               ; CODE XREF: GAVAIL:loc_6B18↓j
                mov     es, word ptr es:[di+8]
                cmp     es:[di+1], di
                jz      short loc_6B13
                cmp     byte ptr es:[di], 5Ah ; 'Z'
                jz      short loc_6B01
                mov     si, es:[di+0Ah]
                or      si, si
                jz      short loc_6B1A
                cmp     byte ptr [si+3], 0
                jnz     short loc_6B1A
                test    byte ptr [si+2], 1
                jz      short loc_6B18
                test    byte ptr es:[di+5], 8
                jz      short loc_6B13

loc_6B01:                               ; CODE XREF: GAVAIL+53↑j
                mov     si, es
                sub     si, [di+8]
                neg     si
                sub     si, [di+1Eh]
                inc     ax
                add     ax, si
                jz      short loc_6B1A
                dec     ax
                jmp     short loc_6B1A
; ---------------------------------------------------------------------------

loc_6B13:                               ; CODE XREF: GAVAIL+4D↑j
                                        ; GAVAIL+6E↑j
                add     ax, es:[di+3]
                inc     ax

loc_6B18:                               ; CODE XREF: GAVAIL+67↑j
                loop    loc_6AD6

loc_6B1A:                               ; CODE XREF: GAVAIL+5B↑j
                                        ; GAVAIL+61↑j ...
                pop     es
                cmp     ax, dx
                jbe     short loc_6AA3
                mov     dx, ax
                pop     ax
                push    es
                jmp     loc_6AA3
; ---------------------------------------------------------------------------

loc_6B26:                               ; CODE XREF: GAVAIL+16↑j
                pop     es
                mov     ax, dx

loc_6B29:                               ; CODE XREF: GAVAIL+B↑j
                or      ax, ax
                jz      short loc_6B31
                dec     ax
                jz      short loc_6B31
                dec     ax

loc_6B31:                               ; CODE XREF: GAVAIL+9A↑j
                                        ; GAVAIL+9D↑j
                and     al, 0FEh
                xor     dx, dx
                retn
GAVAIL          endp


; =============== S U B R O U T I N E =======================================


GNOTIFY         proc near               ; CODE XREF: GREALLOC+32↑p
                                        ; GMOVE+30↑p ...
                xor     ah, ah
                push    si
                push    di
                mov     di, cx
                mov     cx, ax
                mov     si, bx
                test    bl, 1
                jnz     short loc_6B47
                mov     si, [bx]

loc_6B47:                               ; CODE XREF: GNOTIFY+D↑j
                loop    loc_6B67
                push    si
                push    di
                call    DEBUGMOVEDSEGMENT
                push    si
                push    di
                call    PATCHSTACK
                push    si
                push    di
                call    PATCHTHUNKS
                mov     cx, ds
                cmp     cx, si
                jnz     short loc_6BA9
                push    di
                pop     ds
                mov     cs:PGLOBALHEAP, ds
                jmp     short loc_6BA9
; ---------------------------------------------------------------------------

loc_6B67:                               ; CODE XREF: GNOTIFY:loc_6B47↑j
                loop    loc_6BA9
                mov     di, bx
                push    word ptr [di]
                call    SEARCHSTACK
                or      ax, dx
                jz      short loc_6B78
                xor     ax, ax
                jmp     short loc_6BA9
; ---------------------------------------------------------------------------

loc_6B78:                               ; CODE XREF: GNOTIFY+3C↑j
                cmp     word ptr cs:PSWAPHOOK+2, 0
                jz      short loc_6B94
                mov     ax, [di+2]
                push    di
                push    ax
                call    cs:PSWAPHOOK
                or      ax, ax
                jz      short loc_6B94
                or      byte ptr [di+2], 80h
                jmp     short loc_6B9A
; ---------------------------------------------------------------------------

loc_6B94:                               ; CODE XREF: GNOTIFY+48↑j
                                        ; GNOTIFY+56↑j
                test    byte ptr [di+2], 1
                jz      short loc_6BA9

loc_6B9A:                               ; CODE XREF: GNOTIFY+5C↑j
                xor     di, di
                push    si
                push    di
                call    DEBUGMOVEDSEGMENT
                push    si
                push    di
                call    PATCHTHUNKS
                mov     ax, 1

loc_6BA9:                               ; CODE XREF: GNOTIFY+26↑j
                                        ; GNOTIFY+2F↑j ...
                pop     di
                pop     si
                or      ax, ax
                retn
GNOTIFY         endp


; =============== S U B R O U T I N E =======================================


GHEXPAND        proc near
                mov     ax, ds
                push    cx
                call    GHANDLE
                pop     cx
                jz      short loc_6C19
                mov     dx, ax
                xor     ax, ax
                mov     bx, [di+0Eh]
                mov     bx, [bx]
                inc     bx
                add     bx, cx
                shl     bx, 1
                shl     bx, 1
                add     bx, [di+0Eh]
                jb      short loc_6C19
                add     bx, 0Fh
                jb      short loc_6C19
                mov     cl, 4
                shr     bx, cl
                and     byte ptr [di+0Bh], 0F7h
                call    GREALLOC
                jcxz    short loc_6C19
                mov     dx, ax
                call    GALIGN
                jz      short loc_6C19
                mov     bx, es:[di+3]
                mov     cl, 4
                shl     bx, cl
                sub     bx, 3
                and     bl, 0FCh
                sub     bx, [di+0Eh]
                mov     cl, 2
                shr     bx, cl
                mov     ax, bx
                mov     bx, [di+0Eh]
                mov     cx, ax
                xchg    ax, [bx]
                sub     cx, ax
                inc     bx
                inc     bx
                shl     ax, 1
                shl     ax, 1
                add     bx, ax
                xchg    bx, di
                call    HTHREAD
                mov     [di], cx
                mov     di, bx
                mov     cx, ax
                retn
; ---------------------------------------------------------------------------

loc_6C19:                               ; CODE XREF: GHEXPAND+7↑j
                                        ; GHEXPAND+1C↑j ...
                xor     cx, cx
                retn
GHEXPAND        endp


; =============== S U B R O U T I N E =======================================


GMEMCHECK       proc near               ; CODE XREF: GLOBALALLOC+56↓p
                                        ; GLOBALREALLOC+59↓p
                or      ax, ax
                jz      short GMEMFAIL
                retn
GMEMCHECK       endp


; =============== S U B R O U T I N E =======================================


GMEMFAIL        proc near               ; CODE XREF: GMEMCHECK+2↑j
                retn
GMEMFAIL        endp

;
; External Entry #27 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public SETSWAPHOOK
SETSWAPHOOK     proc far
                mov     bx, sp          ; KERNEL_27
                mov     ax, ss:[bx+4]
                mov     dx, ss:[bx+6]
                xchg    ax, word ptr cs:PSWAPHOOK
                xchg    dx, word ptr cs:PSWAPHOOK+2
                retf    4
SETSWAPHOOK     endp


; =============== S U B R O U T I N E =======================================


GINIT           proc near               ; CODE XREF: GLOBALINIT:loc_934C↓p
                lea     si, [bx+1]
                and     si, 0FFFEh
                lea     di, [si+2]
                and     di, 0FFFEh
                add     cx, 0Fh
                shr     cx, 1   ; *2
                shr     cx, 1   ; *4
                shr     cx, 1   ; *8
                shr     cx, 1   : 16
                sub     cx, dx
                neg     cx
                and     cl, 0FEh
                dec     dx
                and     dl, 0FEh
                dec     ax
                and     al, 0FEh
                mov     ds, si
                xor     bx, bx
                mov     byte ptr [bx], 4Dh ; 'M'
                mov     word ptr [bx+3], 1
                mov     word ptr [bx+1], 0FFFFh
                mov     [bx+5], bl
                mov     word ptr [bx+6], ds
                mov     [bx+8], di
                mov     [bx+0Ah], bx
                push    ds
                mov     ds, dx
                mov     byte ptr [bx], 5Ah ; 'Z'
                mov     word ptr [bx+3], 1
                mov     word ptr [bx+1], 0FFFFh
                mov     word ptr [bx+8], ds
                mov     [bx+5], bl
                mov     [bx+0Ah], bx
                push    ds
                mov     [bx+6], cx
                mov     ds, cx
                mov     [bx+8], dx
                sub     dx, cx
                dec     dx
                mov     byte ptr [bx], 4Dh ; 'M'
                mov     [bx+3], dx
                mov     word ptr [bx+1], 0FFFFh
                mov     [bx+5], bl
                mov     [bx+0Ah], bx
                mov     [bx+0Ch], bx
                mov     [bx+0Eh], bx
                push    ax
                push    ds
                push    dx
                mov     [bx+6], ax
                mov     ds, ax
                mov     [bx+8], cx
                sub     cx, ax
                dec     cx
                mov     byte ptr [bx], 4Dh ; 'M'
                mov     [bx+3], cx
                mov     word ptr [bx+1], 0FFFFh
                mov     [bx+5], bl
                mov     [bx+0Ah], bx
                mov     [bx+0Ch], bx
                mov     [bx+0Eh], bx
                mov     [bx+6], di
                mov     ds, di
                mov     [bx+8], ax
                sub     ax, di
                dec     ax
                mov     byte ptr [bx], 4Dh ; 'M'
                mov     [bx+1], bx
                mov     [bx+3], ax
                mov     [bx+6], si
                mov     [bx+0Ah], bx
                pop     cx
                pop     dx
                shl     cx, 1
                shl     cx, 1
                shl     cx, 1
                push    cx
                inc     dx
                mov     es, dx
                xor     ax, ax
                xor     di, di
                rep stosw
                mov     ds, dx
                pop     cx
                shl     cx, 1
                pop     ax
                pop     dx
                pop     bx
                retn
GINIT           endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

GLOBALINIT      proc far                ; CODE XREF: BOOTSTRAP+C7↑p

arg_0           = word ptr  6
arg_2           = word ptr  8
arg_4           = word ptr  0Ah
arg_6           = word ptr  0Ch

                inc     bp
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                mov     ax, [bp+arg_4]
                mov     bx, [bp+arg_2]
                mov     cx, [bp+arg_6]
                mov     dx, [bp+arg_0]
                or      bx, bx
                jnz     short loc_934C
                not     bx
                mov     ah, 48h ; 'H'
                int     21h             ; DOS - 2+ - ALLOCATE MEMORY
                                        ; BX = number of 16-byte paragraphs desired
                jnb     short loc_9347
                mov     ah, 48h ; 'H'
                int     21h             ; DOS - 2+ - ALLOCATE MEMORY
                                        ; BX = number of 16-byte paragraphs desired
                jb      short loc_9347
                mov     dx, ax
                add     bx, ax
                xchg    bx, dx
                mov     ax, dx
                sub     ax, 800h
                jmp     short loc_934C
; ---------------------------------------------------------------------------

loc_9347:                               ; CODE XREF: GLOBALINIT+1D↑j
                                        ; GLOBALINIT+23↑j
                xor     ax, ax
                jmp     short loc_93BD
; ---------------------------------------------------------------------------
                align 2

loc_934C:                               ; CODE XREF: GLOBALINIT+15↑j
                                        ; GLOBALINIT+30↑j
                call    GINIT
                mov     cs:PGLOBALHEAP, ds
                xor     di, di
                mov     [di+6], bx
                mov     [di+8], dx
                mov     word ptr [di+4], 5
                mov     [di+1Ah], di
                mov     [di+18h], di
                mov     [di+1Eh], di
                mov     word ptr [di+12h], 20h ; ' '
                mov     word ptr [di+14h], 6BAEh
                lea     bx, [di+23h]
                and     bl, 0FCh
                mov     [di+0Eh], bx
                sub     cx, 3
                and     cl, 0FCh
                sub     cx, bx
                shr     cx, 1
                shr     cx, 1
                mov     [bx], cx
                inc     bx
                inc     bx
                mov     [di+10h], bx
                mov     di, bx
                call    HTHREAD
                xor     ax, ax
                stosw
                xor     di, di
                mov     ax, ds
                call    HALLOC
                mov     ax, [bx]
                dec     ax
                mov     es, ax
                mov     es:[di+0Ah], bx
                mov     cs:HGLOBALHEAP, bx
                mov     es, word ptr es:[di+6]
                mov     ax, es
                inc     ax
                push    es
                call    HALLOC
                pop     es
                mov     es:[di+0Ah], bx

loc_93BD:                               ; CODE XREF: GLOBALINIT+34↑j
                mov     cx, ax
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    8
GLOBALINIT      endp
