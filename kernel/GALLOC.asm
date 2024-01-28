GALIGN          proc near               ; CODE XREF: GREALLOC+7↓p
                                        ; GFREE+1↓p ...
                xor     cx, cx
                mov     ax, dx
                test    al, 1
                jz      short loc_5EAE
                xor     si, si

loc_5E92:                               ; CODE XREF: GALIGN+2B↓j
                or      ax, ax
                jz      short locret_5EAD
                mov     bx, ax
                dec     bx
                mov     es, bx
                cmp     byte ptr es:[di], 4Dh ; 'M'
                jnz     short loc_5EB7
                cmp     es:[di+0Ah], si
                jnz     short loc_5EB7
                cmp     es:[di+1], di
                jz      short loc_5EB7

locret_5EAD:                            ; CODE XREF: GALIGN+C↑j
                retn
; ---------------------------------------------------------------------------

loc_5EAE:                               ; CODE XREF: GALIGN+6↑j
                mov     si, dx
                call    HDREF
                jnz     short loc_5E92
                mov     bx, [si]

loc_5EB7:                               ; CODE XREF: GALIGN+17↑j
                                        ; GALIGN+1D↑j ...
                xor     ax, ax
                retn
GALIGN          endp


; =============== S U B R O U T I N E =======================================


GHANDLE         proc near               ; CODE XREF: GHANDLE+88↓j
                                        ; GHEXPAND+3↓p ...
                mov     bx, ax
                test    bl, 1
                jnz     short loc_5EEF
                or      bx, bx
                jz      short loc_5F1E
                test    bl, 2
                jz      short loc_5F1E
                mov     bx, [di+0Eh]
                cmp     ax, bx
                jbe     short loc_5F1E
                mov     cx, [bx]
                shl     cx, 1
                shl     cx, 1
                add     bx, cx
                cmp     ax, bx
                jnb     short loc_5F1E
                mov     bx, ax
                mov     cx, [bx+2]
                inc     cx
                jz      short loc_5F1E
                dec     cx
                test    cl, 40h
                jnz     short loc_5F25
                mov     ax, [bx]
                mov     bx, ax

loc_5EEF:                               ; CODE XREF: GHANDLE+5↑j
                dec     bx
                cmp     [di+6], bx
                jnb     short loc_5F1E
                cmp     [di+8], bx
                jbe     short loc_5F1E
                mov     es, bx
                cmp     byte ptr es:[di], 4Dh ; 'M'
                jnz     short loc_5F1E
                cmp     es:[di+1], di
                jz      short loc_5F1E
                mov     bx, es:[di+0Ah]
                or      bx, bx
                jz      short loc_5F20
                cmp     [bx], ax
                jnz     short loc_5F1E

loc_5F14:                               ; CODE XREF: GHANDLE+70↓j
                                        ; GHANDLE+86↓j
                mov     cx, [bx+2]
                mov     dx, ax
                or      dx, dx
                mov     ax, bx
                retn
; ---------------------------------------------------------------------------

loc_5F1E:                               ; CODE XREF: GHANDLE+9↑j
                                        ; GHANDLE+E↑j ...
                xor     ax, ax

loc_5F20:                               ; CODE XREF: GHANDLE+54↑j
                xor     cx, cx
                mov     dx, ax
                retn
; ---------------------------------------------------------------------------

loc_5F25:                               ; CODE XREF: GHANDLE+2F↑j
                xor     ax, ax
                test    cl, 80h
                jz      short loc_5F14
                cmp     word ptr cs:PSWAPHOOK+2, ax
                jz      short loc_5F1E
                not     ax
                push    bx
                push    bx
                push    ax
                call    cs:PSWAPHOOK
                pop     bx
                or      ax, ax
                jz      short loc_5F14
                jmp     GHANDLE
GHANDLE         endp


; =============== S U B R O U T I N E =======================================


GALLOC          proc near               ; CODE XREF: INT21ALLOC+3↓p
                                        ; GLOBALALLOC+50↓p
                or      bx, bx
                jnz     short loc_5F6A
                xchg    ax, cx
                test    cl, 2
                jz      short loc_5F64
                push    cx
                call    HALLOC
                pop     dx
                jcxz    short loc_5F64
                or      dh, 40h
                mov     [bx+2], dh
                jmp     short loc_5F88
; ---------------------------------------------------------------------------

loc_5F5E:                               ; CODE XREF: GALLOC+32↓j
                dec     dx
                mov     es, dx
                call    GMARKFREE

loc_5F64:                               ; CODE XREF: GALLOC+8↑j
                                        ; GALLOC+F↑j
                xor     dx, dx
                xor     ax, ax
                jmp     short loc_5F88
; ---------------------------------------------------------------------------

loc_5F6A:                               ; CODE XREF: GALLOC+2↑j
                call    GSEARCH
                jz      short loc_5F88
                test    dl, 2
                jz      short loc_5F88
                call    HALLOC
                jcxz    short loc_5F5E
                mov     si, [bx]
                dec     si
                mov     es, si
                mov     es:[di+0Ah], bx
                mov     [bx+2], dh
                call    GLRUADD

loc_5F88:                               ; CODE XREF: GALLOC+17↑j
                                        ; GALLOC+23↑j ...
                mov     cx, ax
                retn
GALLOC          endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

GREALLOC        proc near               ; CODE XREF: INT21REALLOC+3↓p
                                        ; GHEXPAND+2B↓p ...

var_8           = word ptr -8
var_6           = word ptr -6
var_4           = word ptr -4
var_2           = word ptr -2

                push    bp
                mov     bp, sp
                push    ax
                push    dx
                push    cx
                push    bx
                call    GALIGN
                mov     bx, [bp+var_8]
                jz      short loc_6014
                test    [bp+var_2], 80h
                jnz     short loc_5FDF
                or      bx, bx
                jnz     short loc_6012
                jcxz    short loc_5FAE

loc_5FA7:                               ; CODE XREF: GREALLOC+28↓j
                                        ; GREALLOC:loc_5FC1↓j ...
                xor     ax, ax
                xor     dx, dx
                jmp     loc_612F
; ---------------------------------------------------------------------------

loc_5FAE:                               ; CODE XREF: GREALLOC+1A↑j
                test    [bp+var_2], 2
                jz      short loc_5FA7
                mov     al, 2
                xor     cx, cx
                mov     bx, [bp+var_4]
                push    es
                call    GNOTIFY
                pop     es

loc_5FC1:                               ; CODE XREF: GREALLOC+8C↓j
                jz      short loc_5FA7
                call    GLRUDEL
                push    word ptr es:[di+1]
                push    ax
                call    GMARKFREE
                pop     cx
                jz      short loc_5FD9
                mov     [si], cx
                or      byte ptr [si+2], 40h
                jmp     short loc_6010
; ---------------------------------------------------------------------------

loc_5FD9:                               ; CODE XREF: GREALLOC+44↑j
                pop     ax
                xor     ax, ax
                jmp     loc_612F
; ---------------------------------------------------------------------------

loc_5FDF:                               ; CODE XREF: GREALLOC+14↑j
                mov     ax, [bp+var_2]
                mov     dx, [bp+var_6]
                or      si, si
                jz      short loc_6004
                call    GLRUDEL
                and     byte ptr [si+2], 0FEh
                and     ah, 31h
                or      [si+2], ah
                test    cl, 40h
                jz      short loc_6004
                test    ah, 30h
                jz      short loc_6010
                mov     [si], dx
                jmp     short loc_6010
; ---------------------------------------------------------------------------

loc_6004:                               ; CODE XREF: GREALLOC+5C↑j
                                        ; GREALLOC+6E↑j
                call    GLRUADD
                test    ah, 30h
                jz      short loc_6010
                mov     es:[di+1], dx

loc_6010:                               ; CODE XREF: GREALLOC+4C↑j
                                        ; GREALLOC+73↑j ...
                jmp     short loc_607F
; ---------------------------------------------------------------------------

loc_6012:                               ; CODE XREF: GREALLOC+18↑j
                jmp     short loc_6060
; ---------------------------------------------------------------------------

loc_6014:                               ; CODE XREF: GREALLOC+D↑j
                test    cl, 40h
                jz      short loc_5FC1
                or      bx, bx
                jz      short loc_607F
                mov     ax, 2
                or      ax, [bp+var_2]
                mov     cl, [si+2]
                and     cl, 0Ch
                or      al, cl
                or      ah, cl
                test    al, 8
                jz      short loc_6033
                or      al, 1

loc_6033:                               ; CODE XREF: GREALLOC+A4↑j
                mov     [di+0Bh], al
                mov     cx, [si]
                push    si
                call    GSEARCH
                pop     si
                jz      short loc_605D
                xor     byte ptr [si+2], 40h
                mov     [si], ax
                mov     ch, [si+2]
                xchg    ax, si
                dec     si
                mov     es, si
                mov     es:[di+0Ah], ax
                and     ch, 0Ch
                mov     es:[di+5], ch
                call    GLRUADD
                jmp     loc_612F
; ---------------------------------------------------------------------------

loc_605D:                               ; CODE XREF: GREALLOC+B2↑j
                jmp     loc_60EF
; ---------------------------------------------------------------------------

loc_6060:                               ; CODE XREF: GREALLOC:loc_6012↑j
                mov     si, bx
                add     bx, ax
                call    HEND
                mov     bx, es:[di+8]
                cmp     dx, bx
                ja      short loc_6085

loc_606F:                               ; CODE XREF: GREALLOC+127↓j
                                        ; GREALLOC+1EE↓j
                mov     si, dx
                inc     dx
                inc     dx
                cmp     dx, bx
                jnb     short loc_607F
                call    GSPLICE
                mov     es, si
                call    GMARKFREE

loc_607F:                               ; CODE XREF: GREALLOC:loc_6010↑j
                                        ; GREALLOC+90↑j ...
                mov     ax, [bp+var_4]

loc_6082:                               ; CODE XREF: GREALLOC+166↓j
                jmp     loc_612F
; ---------------------------------------------------------------------------

loc_6085:                               ; CODE XREF: GREALLOC+E2↑j
                push    es
                mov     es, bx
                cmp     es:[di+1], di
                jnz     short loc_60B4
                sub     dx, bx
                push    si
                call    GCHECKFREE
                pop     si
                jb      short loc_60B4
                add     dx, bx
                pop     cx
                mov     cx, es
                call    GJOIN
                test    [bp+var_2], 40h
                jz      short loc_60AE
                mov     bx, cx
                mov     cx, dx
                dec     cx
                call    GZERO

loc_60AE:                               ; CODE XREF: GREALLOC+119↑j
                mov     bx, es:[di+8]
                jmp     short loc_606F
; ---------------------------------------------------------------------------

loc_60B4:                               ; CODE XREF: GREALLOC+101↑j
                                        ; GREALLOC+10A↑j
                pop     es
                mov     dx, [bp+var_2]
                test    dl, 8
                jnz     short loc_60C6
                mov     bx, 2
                jcxz    short loc_60F3
                test    dx, bx
                jnz     short loc_60F3

loc_60C6:                               ; CODE XREF: GREALLOC+130↑j
                jmp     loc_5FA7
; ---------------------------------------------------------------------------

loc_60C9:                               ; CODE XREF: GREALLOC+17F↓j
                                        ; GREALLOC+1F8↓j
                mov     bx, [bp+var_4]
                test    bl, 1
                jnz     short loc_60D3
                mov     bx, [bx]

loc_60D3:                               ; CODE XREF: GREALLOC+144↑j
                dec     bx
                mov     es, bx
                mov     ax, es:[di+3]
                mov     es, word ptr es:[di+8]
                cmp     es:[di+1], di
                jnz     short loc_60E9
                add     ax, es:[di+3]
                inc     ax

loc_60E9:                               ; CODE XREF: GREALLOC+157↑j
                cmp     ax, dx
                jbe     short loc_60EF
                mov     dx, ax

loc_60EF:                               ; CODE XREF: GREALLOC:loc_605D↑j
                                        ; GREALLOC+160↑j
                xor     ax, ax
                jmp     short loc_6082
; ---------------------------------------------------------------------------

loc_60F3:                               ; CODE XREF: GREALLOC+135↑j
                                        ; GREALLOC+139↑j
                or      dx, bx
                test    [bp+var_4], 1
                jz      short loc_610C
                xor     dx, bx
                test    [bp+var_2], bx
                jnz     short loc_610C
                xor     dx, dx
                call    GCOMPACT
                mov     dx, ax
                jmp     short loc_60C9
; ---------------------------------------------------------------------------

loc_610C:                               ; CODE XREF: GREALLOC+16F↑j
                                        ; GREALLOC+176↑j
                mov     ax, dx
                mov     bx, si
                mov     cx, si
                call    GSEARCH
                jz      short loc_6135
                mov     si, [bp+var_4]
                mov     cx, ax
                test    si, 1
                jnz     short loc_6126
                mov     cx, si
                mov     si, [si]

loc_6126:                               ; CODE XREF: GREALLOC+195↑j
                dec     ax
                mov     es, ax
                dec     si
                call    GMOVEBUSY
                mov     ax, cx

loc_612F:                               ; CODE XREF: GREALLOC+20↑j
                                        ; GREALLOC+51↑j ...
                mov     cx, ax
                mov     sp, bp
                pop     bp
                retn
; ---------------------------------------------------------------------------

loc_6135:                               ; CODE XREF: GREALLOC+18A↑j
                mov     bx, [bp+var_4]
                test    bl, 1
                jnz     short loc_613F
                mov     bx, [bx]

loc_613F:                               ; CODE XREF: GREALLOC+1B0↑j
                mov     ax, bx
                dec     bx
                mov     es, bx
                mov     bx, [bp+var_8]
                add     bx, ax
                call    HEND
                mov     bx, es:[di+8]
                mov     es, bx
                cmp     es:[di+1], di
                jnz     short loc_617C
                sub     dx, bx
                call    GCHECKFREE
                jb      short loc_617C
                add     dx, bx
                mov     cx, es
                call    GJOIN
                test    [bp+var_2], 40h
                jz      short loc_6175
                mov     bx, cx
                mov     cx, dx
                dec     cx
                call    GZERO

loc_6175:                               ; CODE XREF: GREALLOC+1E0↑j
                mov     bx, es:[di+8]
                jmp     loc_606F
; ---------------------------------------------------------------------------

loc_617C:                               ; CODE XREF: GREALLOC+1CB↑j
                                        ; GREALLOC+1D2↑j
                xor     dx, dx
                call    GCOMPACT
                mov     dx, ax
                jmp     loc_60C9
GREALLOC        endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


GFREE           proc near               ; CODE XREF: INT21FREE+2↓p
                                        ; GLOBALFREE+8F↓p
                push    cx
                call    GALIGN
                pop     dx
                jz      short loc_6197
                or      dx, dx
                jnz     short loc_619D

loc_6191:                               ; CODE XREF: GFREE+1B↓j
                call    GLRUDEL
                call    GMARKFREE

loc_6197:                               ; CODE XREF: GFREE+5↑j
                call    HFREE

loc_619A:                               ; CODE XREF: GFREE+20↓j
                mov     cx, ax
                retn
; ---------------------------------------------------------------------------

loc_619D:                               ; CODE XREF: GFREE+9↑j
                cmp     es:[di+1], dx
                jz      short loc_6191
                mov     ax, 0FFFFh
                jmp     short loc_619A
GFREE           endp


; =============== S U B R O U T I N E =======================================


GFREEALL        proc near               ; CODE XREF: GLOBALFREEALL+73↓p
                mov     es, word ptr [di+6]
                mov     cx, [di+4]

loc_61AE:                               ; CODE XREF: GFREEALL+19↓j
                cmp     es:[di+1], dx
                jnz     short loc_61BD
                call    GLRUDEL
                call    GMARKFREE
                call    HFREE

loc_61BD:                               ; CODE XREF: GFREEALL+A↑j
                mov     es, word ptr es:[di+8]
                loop    loc_61AE
                xor     si, si
                mov     [di+0Bh], cl

loc_61C8:                               ; CODE XREF: GFREEALL+29↓j
                                        ; GFREEALL+2D↓j ...
                call    HENUM
                jz      short locret_61DC
                test    byte ptr [si+2], 40h
                jz      short loc_61C8
                cmp     [si], dx
                jnz     short loc_61C8
                call    HFREE
                jmp     short loc_61C8
; ---------------------------------------------------------------------------

locret_61DC:                            ; CODE XREF: GFREEALL+23↑j
                retn
GFREEALL        endp


; =============== S U B R O U T I N E =======================================


GLOCK           proc near               ; CODE XREF: LOCKSEGMENT+5↓p
                                        ; GLOBALLOCK:loc_6EDC↓p
                inc     ch
                jz      short locret_61E4
                mov     [bx+3], ch

locret_61E4:                            ; CODE XREF: GLOCK+2↑j
                retn
GLOCK           endp


; =============== S U B R O U T I N E =======================================


GUNLOCK         proc near               ; CODE XREF: UNLOCKSEGMENT+5↓p
                                        ; GLOBALUNLOCK:loc_6F33↓p
                dec     ch
                cmp     ch, 0FEh
                jnb     short loc_61F9
                dec     byte ptr [bx+3]
                jnz     short locret_61FB
                test    cl, 1
                jz      short loc_61F9
                call    GLRUTOP

loc_61F9:                               ; CODE XREF: GUNLOCK+5↑j
                                        ; GUNLOCK+F↑j
                xor     cx, cx

locret_61FB:                            ; CODE XREF: GUNLOCK+A↑j
                retn
GUNLOCK         endp


; =============== S U B R O U T I N E =======================================


GLRUTOP         proc near               ; CODE XREF: GETCODEHANDLE+53↑p
                                        ; GUNLOCK+11↑p ...
                push    es
                push    cx
                push    dx
                push    si
                cmp     [di+1Ah], bx
                jz      short loc_6257
                test    byte ptr [bx+2], 1
                jz      short loc_6257
                test    byte ptr [bx+2], 40h
                jnz     short loc_6257
                mov     dx, bx
                mov     bx, [bx]
                dec     bx
                mov     es, bx
                push    es
                mov     bx, es:[di+0Eh]
                mov     si, es:[di+0Ch]
                mov     cx, [bx]
                dec     cx
                mov     es, cx
                mov     es:[di+0Ch], si
                mov     cx, [si]
                dec     cx
                mov     es, cx
                mov     es:[di+0Eh], bx
                mov     bx, dx
                xchg    bx, [di+1Ah]
                mov     cx, [bx]
                dec     cx
                mov     es, cx
                mov     si, dx
                xchg    si, es:[di+0Ch]
                mov     cx, [si]
                dec     cx
                mov     es, cx
                mov     es:[di+0Eh], dx
                pop     es
                mov     es:[di+0Ch], si
                mov     es:[di+0Eh], bx
                mov     bx, dx

loc_6257:                               ; CODE XREF: GLRUTOP+7↑j
                                        ; GLRUTOP+D↑j ...
                pop     si
                pop     dx
                pop     cx
                pop     es
                retn
GLRUTOP         endp


; =============== S U B R O U T I N E =======================================


GLRUADD         proc near               ; CODE XREF: GALLOC+40↑p
                                        ; GREALLOC:loc_6004↑p ...
                mov     bx, es:[di+0Ah]
                test    byte ptr [bx+2], 1
                jz      short locret_6299
                mov     dx, bx
                xchg    bx, [di+1Ah]
                inc     word ptr [di+1Ch]
                or      bx, bx
                jz      short loc_6291
                mov     cx, [bx]
                dec     cx
                push    es
                mov     es, cx
                mov     si, dx
                xchg    si, es:[di+0Ch]
                mov     cx, [si]
                dec     cx
                mov     es, cx
                mov     es:[di+0Eh], dx
                pop     es
                mov     es:[di+0Ch], si
                mov     es:[di+0Eh], bx
                retn
; ---------------------------------------------------------------------------

loc_6291:                               ; CODE XREF: GLRUADD+14↑j
                mov     es:[di+0Ch], dx
                mov     es:[di+0Eh], dx

locret_6299:                            ; CODE XREF: GLRUADD+8↑j
                retn
GLRUADD         endp


; =============== S U B R O U T I N E =======================================


GLRUDEL         proc near               ; CODE XREF: GREALLOC+38↑p
                                        ; GREALLOC+5E↑p ...
                push    si
                push    cx
                mov     cx, es:[di+0Ah]
                jcxz    short loc_62E2
                mov     bx, cx
                test    byte ptr [bx+2], 1
                jz      short loc_62E2
                test    byte ptr [bx+2], 40h
                jnz     short loc_62E2
                mov     bx, es:[di+0Eh]
                mov     si, es:[di+0Ch]
                push    es
                mov     cx, [bx]
                dec     cx
                mov     es, cx
                mov     es:[di+0Ch], si
                mov     cx, [si]
                dec     cx
                mov     es, cx
                mov     es:[di+0Eh], bx
                pop     es
                dec     word ptr [di+1Ch]
                mov     cx, es:[di+0Ah]
                cmp     [di+1Ah], cx
                jnz     short loc_62E2
                mov     [di+1Ah], bx
                cmp     bx, cx
                jnz     short loc_62E2
                sub     [di+1Ah], bx

loc_62E2:                               ; CODE XREF: GLRUDEL+6↑j
                                        ; GLRUDEL+E↑j ...
                pop     cx
                pop     si
                retn
GLRUDEL         endp


; =============== S U B R O U T I N E =======================================


GLRUPREV        proc near               ; CODE XREF: GDISCARD+40↓p
                or      si, si
                jnz     short loc_62EF
                mov     si, [di+1Ah]
                mov     cx, [di+1Ch]

loc_62EF:                               ; CODE XREF: GLRUPREV+2↑j
                jcxz    short loc_6304
                dec     cx
                mov     si, [si]
                dec     si
                mov     es, si
                mov     si, es:[di+0Ch]
                test    byte ptr [si+2], 40h
                jnz     short loc_6304
                or      si, si
                retn
; ---------------------------------------------------------------------------

loc_6304:                               ; CODE XREF: GLRUPREV:loc_62EF↑j
                                        ; GLRUPREV+1A↑j
                xor     si, si
                retn
GLRUPREV        endp


; =============== S U B R O U T I N E =======================================


GSPLICE         proc near               ; CODE XREF: GREALLOC+EC↑p
                                        ; GSEARCH+AE↓p ...
                inc     word ptr [di+4]
                push    si
                push    es
                mov     cx, si
                xchg    cx, es:[di+8]
                mov     es, cx
                mov     es:[di+6], si
                mov     es, si
                mov     es:[di+8], cx
                sub     si, cx
                neg     si
                dec     si
                mov     es:[di+3], si
                pop     cx
                mov     es:[di+6], cx
                mov     es:[di+1], di
                mov     es:[di+0Ah], di
                mov     byte ptr es:[di], 4Dh ; 'M'
                mov     es, cx
                sub     cx, es:[di+8]
                neg     cx
                dec     cx
                mov     es:[di+3], cx
                pop     si
                retn
GSPLICE         endp


; =============== S U B R O U T I N E =======================================


GJOIN           proc near               ; CODE XREF: GREALLOC+111↑p
                                        ; GREALLOC+1D8↑p ...
                dec     word ptr [di+4]
                mov     si, es:[di+6]
                mov     es, word ptr es:[di+8]
                mov     es:[di+6], si
                push    es
                mov     es, si
                pop     word ptr es:[di+8]
                sub     si, es:[di+8]
                neg     si
                dec     si
                mov     es:[di+3], si
                retn
GJOIN           endp


; =============== S U B R O U T I N E =======================================


GZERO           proc near               ; CODE XREF: GREALLOC+120↑p
                                        ; GREALLOC+1E7↑p ...
                push    ax
                push    di
                push    es
                mov     es, bx
                sub     bx, cx
                neg     bx
                inc     bx

loc_6373:                               ; CODE XREF: GZERO+2B↓j
                mov     cx, 1000h
                cmp     bx, cx
                jnb     short loc_637E
                mov     cx, bx
                jcxz    short loc_6396

loc_637E:                               ; CODE XREF: GZERO+F↑j
                sub     bx, cx
                shl     cx, 1
                shl     cx, 1
                shl     cx, 1
                xor     ax, ax
                xor     di, di
                cld
                rep stosw
                mov     ax, es
                add     ah, 10h
                mov     es, ax
                assume es:nothing
                jmp     short loc_6373
; ---------------------------------------------------------------------------

loc_6396:                               ; CODE XREF: GZERO+13↑j
                pop     es
                assume es:nothing
                pop     di
                pop     ax
                retn
GZERO           endp


; =============== S U B R O U T I N E =======================================


GSEARCH         proc near               ; CODE XREF: GALLOC:loc_5F6A↑p
                                        ; GREALLOC+AE↑p ...
                push    cx
                push    ax
                add     bx, 1
                call    HEND
                mov     cx, [di+4]
                mov     es, word ptr [di+6]
                mov     bx, 8
                test    al, 1
                jz      short loc_63B4
                mov     es, word ptr [di+8]
                mov     bl, 6

loc_63B4:                               ; CODE XREF: GSEARCH+13↑j
                mov     es, word ptr es:[bx]

loc_63B7:                               ; CODE XREF: GSEARCH+5B↓j
                                        ; GSEARCH+81↓j
                cmp     es:[di+1], di
                jz      short loc_6409
                mov     si, es:[di+0Ah]
                cmp     bl, 8
                jnz     short loc_63F7
                or      si, si
                jz      short loc_6418
                cmp     [si+3], bh
                jnz     short loc_6418
                pop     ax
                push    ax
                test    al, 2
                jnz     short loc_6418
                mov     ax, es:[di+3]
                inc     ax
                cmp     ax, dx
                jb      short loc_6418
                push    dx
                mov     dx, ax
                call    GFINDFREE
                pop     dx
                or      ax, ax
                jz      short loc_6418
                push    word ptr es:[di+6]
                mov     si, es
                mov     es, ax
                call    GMOVEBUSY
                pop     es
                jmp     short loc_63B7
; ---------------------------------------------------------------------------

loc_63F7:                               ; CODE XREF: GSEARCH+2A↑j
                cmp     [di+1Eh], di
                jz      short loc_6418
                or      si, si
                jz      short loc_641D
                test    byte ptr es:[di+5], 8
                jz      short loc_641D
                jmp     short loc_6418
; ---------------------------------------------------------------------------

loc_6409:                               ; CODE XREF: GSEARCH+21↑j
                call    GCHECKFREE
                jnb     short loc_6432
                cmp     [di+1Eh], di
                jz      short loc_6418
                cmp     bl, 6
                jz      short loc_641D

loc_6418:                               ; CODE XREF: GSEARCH+2E↑j
                                        ; GSEARCH+33↑j ...
                mov     es, word ptr es:[bx]
                loop    loc_63B7

loc_641D:                               ; CODE XREF: GSEARCH+64↑j
                                        ; GSEARCH+6B↑j ...
                push    bx
                call    GCOMPACT
                pop     bx
                cmp     ax, dx
                jnb     short loc_6432
                mov     dx, ax
                or      dx, dx
                jz      short loc_642D
                dec     dx

loc_642D:                               ; CODE XREF: GSEARCH+90↑j
                pop     ax
                pop     cx
                xor     ax, ax
                retn
; ---------------------------------------------------------------------------

loc_6432:                               ; CODE XREF: GSEARCH+72↑j
                                        ; GSEARCH+8A↑j
                mov     ax, es:[di+3]
                inc     ax
                mov     cx, ax
                sub     cx, dx
                xor     si, si
                jcxz    short loc_645C
                cmp     bl, 6
                jz      short loc_644D
                mov     si, es
                add     si, dx
                call    GSPLICE
                jmp     short loc_645C
; ---------------------------------------------------------------------------

loc_644D:                               ; CODE XREF: GSEARCH+A8↑j
                mov     si, es:[di+8]
                sub     si, dx
                call    GSPLICE
                mov     es, si
                mov     si, es:[di+6]

loc_645C:                               ; CODE XREF: GSEARCH+A3↑j
                                        ; GSEARCH+B1↑j
                pop     dx
                pop     word ptr es:[di+1]
                xor     ax, ax
                mov     es:[di+0Ch], ax
                mov     es:[di+0Eh], ax
                mov     al, 0Ch
                and     al, dl
                mov     es:[di+5], al
                mov     ax, es
                inc     ax
                test    dl, 40h
                jz      short loc_6485
                mov     cx, es:[di+8]
                dec     cx
                mov     bx, ax
                call    GZERO

loc_6485:                               ; CODE XREF: GSEARCH+DF↑j
                mov     es, si
                call    GMARKFREE
                or      ax, ax
                retn
GSEARCH         endp


; =============== S U B R O U T I N E =======================================


GMARKFREE       proc near               ; CODE XREF: GALLOC+1C↑p
                                        ; GREALLOC+40↑p ...
                mov     si, es
                or      si, si
                jz      short loc_64CA
                mov     es:[di+1], di
                push    dx
                xor     dx, dx
                xchg    dx, es:[di+0Ah]
                push    word ptr es:[di+6]
                mov     es, word ptr es:[di+8]
                cmp     es:[di+1], di
                jnz     short loc_64AF
                call    GJOIN

loc_64AF:                               ; CODE XREF: GMARKFREE+1D↑j
                pop     es
                cmp     es:[di+1], di
                jnz     short loc_64BD
                mov     es, word ptr es:[di+8]
                call    GJOIN

loc_64BD:                               ; CODE XREF: GMARKFREE+27↑j
                mov     si, dx
                pop     dx
                cmp     es:[di+1], di
                jz      short loc_64CA
                mov     es, word ptr es:[di+8]

loc_64CA:                               ; CODE XREF: GMARKFREE+4↑j
                                        ; GMARKFREE+37↑j
                or      si, si
                retn
GMARKFREE       endp


; =============== S U B R O U T I N E =======================================


GFINDFREE       proc near               ; CODE XREF: GSEARCH+47↑p
                                        ; GRTEST+B↓p
                push    es
                push    cx

loc_64CF:                               ; CODE XREF: GFINDFREE+17↓j
                cmp     es:[di+1], di
                jnz     short loc_64E1
                call    GCHECKFREE
                mov     ax, es
                jnb     short loc_64E8
                cmp     bl, 6
                jz      short loc_64E6

loc_64E1:                               ; CODE XREF: GFINDFREE+6↑j
                mov     es, word ptr es:[bx]
                loop    loc_64CF

loc_64E6:                               ; CODE XREF: GFINDFREE+12↑j
                xor     ax, ax

loc_64E8:                               ; CODE XREF: GFINDFREE+D↑j
                pop     cx
                pop     es
                retn
GFINDFREE       endp


; =============== S U B R O U T I N E =======================================


GCHECKFREE      proc near               ; CODE XREF: GREALLOC+106↑p
                                        ; GREALLOC+1CF↑p ...
                mov     ax, es:[di+3]
                inc     ax
                cmp     [di+1Eh], di
                jz      short loc_652D
                test    byte ptr [di+0Bh], 8
                jnz     short loc_652D
                push    es
                mov     es, word ptr es:[di+8]
                cmp     byte ptr es:[di], 5Ah ; 'Z'
                jz      short loc_650D
                test    byte ptr es:[di+5], 8
                jz      short loc_652C

loc_650D:                               ; CODE XREF: GCHECKFREE+19↑j
                pop     es
                mov     si, [di+8]
                sub     si, [di+1Eh]
                cmp     si, es:[di+8]
                jnb     short loc_652D
                sub     si, es:[di+8]
                neg     si
                cmp     ax, si
                jbe     short loc_6528
                sub     ax, si
                jmp     short loc_652D
; ---------------------------------------------------------------------------

loc_6528:                               ; CODE XREF: GCHECKFREE+37↑j
                xor     ax, ax
                jmp     short loc_652D
; ---------------------------------------------------------------------------

loc_652C:                               ; CODE XREF: GCHECKFREE+20↑j
                pop     es

loc_652D:                               ; CODE XREF: GCHECKFREE+8↑j
                                        ; GCHECKFREE+E↑j ...
                cmp     ax, dx
                retn
GCHECKFREE      endp

; ---------------------------------------------------------------------------
                db 80h dup(0)
word_65B0       dw 0                    ; DATA XREF: GMOVE:loc_6606↓w
                                        ; GMOVE:loc_6655↓r ...
word_65B2       dw 0                    ; DATA XREF: GMOVE+46↓w
                                        ; GMOVE+AE↓r

; =============== S U B R O U T I N E =======================================


GMOVE           proc near               ; CODE XREF: GSLIDECOMMON:loc_6773↓p
                                        ; GMOVEBUSY+56↓p
                push    es
                push    si
                push    di
                push    ax
                push    bx
                push    cx
                push    dx
                mov     dx, si
                and     dx, 1
                push    es
                mov     cx, es
                or      cl, 1
                mov     ax, si
                xor     ax, dx
                mov     es, ax
                xor     dl, 1
                add     dx, es:[di+3]
                push    dx
                mov     ax, 1
                mov     bx, es:[di+0Ah]
                or      bx, bx
                jnz     short loc_65E3
                mov     bx, es
                inc     bx

loc_65E3:                               ; CODE XREF: GMOVE+2A↑j
                push    es
                call    GNOTIFY
                pop     cx
                inc     cx
                pop     dx
                pop     di
                push    ds
                mov     ax, ss
                cmp     ax, cx
                mov     cx, 0
                jnz     short loc_6606
                mov     cx, di
                or      cl, 1
                mov     cs:word_65B2, sp
                cli
                push    cs
                pop     ss
                assume ss:cseg01
                mov     sp, 65B0h
                sti

loc_6606:                               ; CODE XREF: GMOVE+3F↑j
                mov     cs:word_65B0, cx
                mov     ax, dx
                add     ax, si
                mov     bx, dx
                add     bx, di
                cmp     si, di
                jb      short loc_661B
                mov     ax, si
                mov     bx, di

loc_661B:                               ; CODE XREF: GMOVE+61↑j
                                        ; GMOVE+9F↓j
                mov     cx, 1000h
                cmp     dx, cx
                jnb     short loc_6626
                mov     cx, dx
                jcxz    short loc_6655

loc_6626:                               ; CODE XREF: GMOVE+6C↑j
                sub     dx, cx
                mov     si, cx
                shl     cx, 1
                shl     cx, 1
                shl     cx, 1
                cmp     ax, bx
                jb      short loc_6641
                cld
                mov     ds, ax
                mov     es, bx
                add     ax, si
                add     bx, si
                xor     si, si
                jmp     short loc_664F
; ---------------------------------------------------------------------------

loc_6641:                               ; CODE XREF: GMOVE+7E↑j
                std
                sub     ax, si
                sub     bx, si
                mov     si, cx
                dec     si
                shl     si, 1
                mov     ds, ax
                mov     es, bx

loc_664F:                               ; CODE XREF: GMOVE+8B↑j
                mov     di, si
                rep movsw
                jmp     short loc_661B
; ---------------------------------------------------------------------------

loc_6655:                               ; CODE XREF: GMOVE+70↑j
                cmp     cs:word_65B0, cx
                jz      short loc_6668
                cli
                mov     ss, cs:word_65B0
                assume ss:nothing
                mov     sp, cs:word_65B2
                sti

loc_6668:                               ; CODE XREF: GMOVE+A6↑j
                pop     ds
                pop     dx
                pop     cx
                pop     bx
                pop     ax
                pop     di
                pop     si
                pop     es
                cld
                retn
GMOVE           endp

; =============== S U B R O U T I N E =======================================


GMOVEABLE       proc near               ; CODE XREF: GSLIDE+A↓p
                                        ; GBESTFIT+F↓p
                mov     si, es:[di+0Ah]
                or      si, si
                jz      short loc_6726
                cmp     [si+3], bh
                jnz     short loc_6726
                test    byte ptr es:[di+5], 8
                jz      short loc_671D
                cmp     bl, 8
                retn
; ---------------------------------------------------------------------------

loc_671D:                               ; CODE XREF: GMOVEABLE+12↑j
                cmp     [di+1Eh], di
                jz      short loc_6728
                cmp     bl, 6
                retn
; ---------------------------------------------------------------------------

loc_6726:                               ; CODE XREF: GMOVEABLE+6↑j
                                        ; GMOVEABLE+B↑j
                xor     si, si

loc_6728:                               ; CODE XREF: GMOVEABLE+1B↑j
                or      si, si
                retn
GMOVEABLE       endp


; =============== S U B R O U T I N E =======================================


GSLIDE          proc near               ; CODE XREF: GCMPHEAP+1E↑p
                push    es
                mov     es, word ptr es:[bx]
                mov     ax, es
                mov     dx, es:[di+3]
                call    GMOVEABLE
                pop     es
                jnz     short GSLIDECOMMON
                retn
GSLIDE          endp


; =============== S U B R O U T I N E =======================================


GSLIDECOMMON    proc near               ; CODE XREF: GSLIDE+E↑j
                                        ; GMOVEBUSY+1D↓p
                mov     si, ax
                inc     dx
                cmp     bl, 8
                jz      short loc_675B
                mov     ax, es:[di+8]
                push    ax
                sub     ax, dx
                push    ax
                cmp     es:[bx], si
                jz      short loc_6754
                push    es
                jmp     short loc_6755
; ---------------------------------------------------------------------------

loc_6754:                               ; CODE XREF: GSLIDECOMMON+13↑j
                push    si

loc_6755:                               ; CODE XREF: GSLIDECOMMON+16↑j
                mov     es, ax
                xor     ax, ax
                jmp     short loc_6773
; ---------------------------------------------------------------------------

loc_675B:                               ; CODE XREF: GSLIDECOMMON+6↑j
                cmp     es:[bx], si
                jz      short loc_6766
                push    word ptr es:[di+8]
                jmp     short loc_6769
; ---------------------------------------------------------------------------

loc_6766:                               ; CODE XREF: GSLIDECOMMON+22↑j
                add     ax, dx
                push    ax

loc_6769:                               ; CODE XREF: GSLIDECOMMON+28↑j
                mov     ax, es
                add     ax, dx
                push    ax
                push    es
                mov     ax, es:[di+6]

loc_6773:                               ; CODE XREF: GSLIDECOMMON+1D↑j
                call    GMOVE
                mov     si, es
                pop     es
                or      ax, ax
                jz      short loc_6781
                mov     es:[di+6], ax

loc_6781:                               ; CODE XREF: GSLIDECOMMON+3F↑j
                pop     ax
                mov     es:[di+8], ax
                mov     dx, es
                mov     es, ax
                mov     es:[di+6], dx
                pop     ax
                mov     es:[di+8], ax
                mov     dx, es
                mov     es, ax
                mov     es:[di+6], dx
                mov     es, si
                mov     si, es:[di+0Ah]
                or      si, si
                jz      short loc_67AA
                mov     ax, es
                inc     ax
                mov     [si], ax

loc_67AA:                               ; CODE XREF: GSLIDECOMMON+67↑j
                mov     es, word ptr es:[bx]
                mov     ax, es:[di+8]
                mov     si, es
                sub     ax, si
                dec     ax
                mov     es:[di+3], ax
                mov     byte ptr es:[di], 4Dh ; 'M'
                mov     byte ptr es:[di+5], 0
                mov     es:[di+0Ah], di
                mov     es:[di+0Ch], di
                mov     es:[di+0Eh], di
                call    GMARKFREE
                or      ax, ax
                retn
GSLIDECOMMON    endp


; =============== S U B R O U T I N E =======================================


GMOVEBUSY       proc near               ; CODE XREF: GREALLOC+19F↑p
                                        ; GSEARCH+57↑p ...
                push    cx
                push    dx
                mov     ax, es
                mov     cx, es:[di+3]
                cmp     es:[di+1], di
                mov     es, si
                mov     dx, es:[di+3]
                jnz     short loc_6847
                cmp     cx, dx
                jz      short loc_6847
                mov     es, ax
                mov     ax, si
                push    si
                call    GSLIDECOMMON
                inc     word ptr [di+4]
                mov     ax, es
                pop     es
                call    GMARKFREE
                mov     es, ax
                or      ax, ax
                jmp     short loc_6886
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_6847:                               ; CODE XREF: GMOVEBUSY+12↑j
                                        ; GMOVEBUSY+16↑j
                inc     si
                mov     cl, es:[di+5]
                push    word ptr es:[di+1]
                push    word ptr es:[di+0Ch]
                push    word ptr es:[di+0Eh]
                mov     es, ax
                pop     word ptr es:[di+0Eh]
                pop     word ptr es:[di+0Ch]
                pop     word ptr es:[di+1]
                mov     es:[di+5], cl
                inc     ax
                mov     es, ax
                call    GMOVE
                dec     si
                mov     es, si
                call    GMARKFREE
                dec     ax
                mov     es, ax
                inc     ax
                or      si, si
                jz      short loc_6886
                mov     [si], ax
                mov     es:[di+0Ah], si
                xor     si, si

loc_6886:                               ; CODE XREF: GMOVEBUSY+2D↑j
                                        ; GMOVEBUSY+65↑j
                pop     dx
                pop     cx
                retn
GMOVEBUSY       endp


; =============== S U B R O U T I N E =======================================


GDISCARD        proc near               ; CODE XREF: GCOMPACT+30↑p
                push    es
                push    ax
                push    dx
                mov     byte ptr [di+0Ah], 0
                sub     dx, ax
                mov     [di+0Ch], dx
                mov     es, word ptr [di+8]
                mov     cx, es
                cmp     [di+1Eh], di
                jz      short loc_68C2
                test    byte ptr [di+0Bh], 8
                jnz     short loc_68C2

loc_68A5:                               ; CODE XREF: GDISCARD+2B↓j
                mov     es, word ptr es:[di+6]
                cmp     es:[di+1], di
                jz      short loc_68B6
                test    byte ptr es:[di+5], 8
                jnz     short loc_68A5

loc_68B6:                               ; CODE XREF: GDISCARD+24↑j
                sub     cx, [di+1Eh]
                cmp     cx, es:[di+8]
                jbe     short loc_68C2
                mov     cx, [di+8]

loc_68C2:                               ; CODE XREF: GDISCARD+14↑j
                                        ; GDISCARD+1A↑j ...
                mov     [di+16h], cx
                xor     si, si
                push    si

loc_68C8:                               ; CODE XREF: GDISCARD+4D↓j
                                        ; GDISCARD+54↓j ...
                pop     cx
                call    GLRUPREV
                jnz     short loc_68D1
                jmp     short loc_6912
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_68D1:                               ; CODE XREF: GDISCARD+43↑j
                push    cx
                cmp     byte ptr [si+3], 0
                jnz     short loc_68C8
                mov     bx, [di+16h]
                cmp     [si], bx
                jnb     short loc_68C8
                mov     bx, si
                mov     al, 2
                call    GNOTIFY
                jnz     short loc_68EA
                jmp     short loc_68C8
; ---------------------------------------------------------------------------

loc_68EA:                               ; CODE XREF: GDISCARD+5D↑j
                mov     ax, [si]
                dec     ax
                mov     es, ax
                push    word ptr es:[di+0Eh]
                call    GLRUDEL
                push    word ptr es:[di+1]
                mov     dx, es:[di+3]
                call    GMARKFREE
                pop     word ptr [si]
                or      byte ptr [si+2], 40h
                mov     byte ptr [di+0Ah], 1
                pop     si
                sub     [di+0Ch], dx
                ja      short loc_68C8
                pop     cx

loc_6912:                               ; CODE XREF: GDISCARD+45↑j
                cmp     byte ptr [di+0Ah], 0
                pop     dx
                pop     ax
                pop     es
                retn
GDISCARD        endp