; ****** modern:personality project ******
; Reverse engineered code  © 2022-2025 starfrost. See licensing information in the licensing file
; Original code            © 1982-1986 Microsoft Corporation

; GLRU.ASM: Implements a least recently used algorithm for memory segments so that unused memory segments can be freed or moved around to prioritise more commonly used segments.

; =============== S U B R O U T I N E =======================================
INCLUDE KERNEL.inc
INCLUDE KDATA.inc
sBegin CODE

assumeS CS,CODE
assumeS DS,CODE

LRUSWEEP_MODE1  proc far
                pop     cx
                push    cs
                push    cx
                mov     cx, 1
                jmp     short loc_6924
LRUSWEEP_MODE1  endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


LRUSWEEP        proc far
                xor     cx, cx

loc_6924:                               ; CODE XREF: LRUSWEEP_MODE1+6↑j
                push    ds
                push    si
                push    di
                push    dx
                mov     ds, cs:PGLOBALHEAP
                cmp     ds:18h, cx
                jnz     short loc_6988
                push    cs:HEXESWEEP

loc_6938:                               ; CODE XREF: LRUSWEEP+33↓j
                                        ; LRUSWEEP:loc_6957↓j ...
                pop     cx
                jcxz    short loc_6988
                mov     es, cx
                push    word ptr es:6
                mov     si, es:1Ch
                mov     di, es:3Eh
                mov     cx, si
                cmp     word ptr es:0, 454Eh
                jnz     short loc_6938

loc_6957:                               ; CODE XREF: LRUSWEEP+64↓j
                jcxz    short loc_6938
                xor     ax, ax
                cld
                repne scasb
                jnz     short loc_6938
                dec     di
                inc     ax
                stosb
                mov     bx, si
                sub     bx, cx
                dec     bx
                cmp     bx, si
                jnb     short loc_6938
                mov     ax, bx
                shl     bx, 1
                shl     bx, 1
                add     bx, ax
                shl     bx, 1
                add     bx, es:22h
                mov     bx, es:[bx+8]
                push    di
                xor     di, di
                call    GLRUTOP
                pop     di
                jmp     short loc_6957
; ---------------------------------------------------------------------------

loc_6988:                               ; CODE XREF: LRUSWEEP+F↑j
                                        ; LRUSWEEP+17↑j
                pop     dx
                pop     di
                pop     si
                pop     ds
                ret
LRUSWEEP        endp



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
                ret
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
                ret
; ---------------------------------------------------------------------------

loc_6291:                               ; CODE XREF: GLRUADD+14↑j
                mov     es:[di+0Ch], dx
                mov     es:[di+0Eh], dx

locret_6299:                            ; CODE XREF: GLRUADD+8↑j
                ret
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
                ret
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
                ret
; ---------------------------------------------------------------------------

loc_6304:                               ; CODE XREF: GLRUPREV:loc_62EF↑j
                                        ; GLRUPREV+1A↑j
                xor     si, si
                ret
GLRUPREV        endp

sEnd CODE

end
