; =============== S U B R O U T I N E =======================================


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
                retf
LRUSWEEP        endp
