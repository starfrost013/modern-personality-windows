

; ---------------------------------------------------------------------------
INT3FBP         dw 0                    ; DATA XREF: INT3FHANDLER+3B↓w
                                        ; SEARCHSTACK+BF↓r ...
INT3FSAVEDBP    dw 0                    ; DATA XREF: SEARCHSTACK+110↓r
                                        ; SEARCHSTACK+139↓w
INT3FSAVEDSS    dw 0                    ; DATA XREF: INT3FTHUNK+20↓w
                                        ; SEARCHSTACK+103↓r ...
INT3FSAVEDDS    dw 0                    ; DATA XREF: INT3FTHUNK+1A↓r
                                        ; SEARCHSTACK+125↓r ...
INT3FSAVEDFRAME db 2 dup(0)
INT3FSAVEDIP    dw 0                    ; DATA XREF: INT3FTHUNK+6↓r
                                        ; SEARCHSTACK+11D↓r ...
INT3FSAVEDCS    dw 0                    ; DATA XREF: INT3FTHUNK+10↓r
                                        ; SEARCHSTACK+115↓r ...
INT3FCURRENTCS  dw 0                    ; DATA XREF: INT3FTHUNK+B↓w
                                        ; INT3FHANDLER↓w ...
INT3FCURRENTDS  dw 0                    ; DATA XREF: INT3FTHUNK+15↓w
                                        ; INT3FFAIL+B↓r ...
INT3FCURRENTIP  dw 0                    ; DATA XREF: INT3FTHUNK+1↓w
                                        ; INT3FHANDLER+A↓w ...

; =============== S U B R O U T I N E =======================================


INT3FTHUNK      proc far
                pushf
                pop     cs:INT3FCURRENTIP
                push    cs:INT3FSAVEDIP
                pop     cs:INT3FCURRENTCS
                push    cs:INT3FSAVEDCS
                pop     cs:INT3FCURRENTDS
                push    cs:INT3FSAVEDDS
                pop     ds
                mov     cs:INT3FSAVEDSS, 0
                jmp     short loc_181F
INT3FTHUNK      endp ; sp-analysis failed

; ---------------------------------------------------------------------------
                nop

; =============== S U B R O U T I N E =======================================


INT3FFAIL       proc near               ; CODE XREF: INT3FHANDLER:loc_1872↓j
                xor     bx, bx
                mov     ax, 4FFh
                push    ax
                mov     ax, offset SZERRINT3FSEGMENT ; "INT 3F handler unable to load segment f"...
                push    cs
                push    ax
                push    cs:INT3FCURRENTDS
                push    bx
                call    KERNELERROR
                jmp     short loc_1805
; ---------------------------------------------------------------------------
SZERRINT3FSEGMENT db 'INT 3F handler unable to load segment from ',0
                                        ; DATA XREF: INT3FFAIL+6↑o
                db  24h ; $
; ---------------------------------------------------------------------------

loc_1805:                               ; CODE XREF: INT3FFAIL+14↑j
                mov     ax, 4CFFh
                int     21h             ; DOS - 2+ - QUIT WITH EXIT CODE (EXIT)
INT3FFAIL       endp                    ; AL = exit code


; =============== S U B R O U T I N E =======================================


INT3FHANDLER    proc far
                pop     cs:INT3FCURRENTCS
                pop     cs:INT3FCURRENTDS
                pop     cs:INT3FCURRENTIP
                sub     cs:INT3FCURRENTCS, 2

loc_181F:                               ; CODE XREF: INT3FTHUNK+27↑j
                inc     bp
                push    bp
                mov     bp, sp
                push    ds
                push    es
                push    dx
                push    cx
                push    bx
                push    ax
                sti
                les     bx, dword ptr cs:INT3FCURRENTCS
                xor     cx, cx
                mov     cl, es:[bx+2]
                jcxz    short near ptr RETTHUNK
                push    ax
                mov     bx, 0FFFFh
                push    es
                push    cx
                push    bx
                push    bx
                call    TESTDSAX
                mov     [bp-0Ch], ax
                mov     cs:INT3FBP, bp
                call    LOADSEGMENT
                jcxz    short loc_1872
                pop     ax
                pop     dx
                cmp     ax, dx
                jz      short loc_1859
                push    dx
                call    MYLOCK

loc_1859:                               ; CODE XREF: INT3FHANDLER+49↑j
                push    ax

loc_185A:                               ; CODE XREF: RETTHUNK+44↓j
                                        ; RETTHUNK+49↓j
                pop     ax
                pop     bx
                pop     cx
                pop     dx
                pop     es
                pop     ds
                pop     bp
                dec     bp
                push    cs:INT3FCURRENTIP
                push    cs:INT3FCURRENTDS
                push    cs:INT3FCURRENTCS
                iret
; ---------------------------------------------------------------------------

loc_1872:                               ; CODE XREF: INT3FHANDLER+43↑j
                                        ; RETTHUNK+32↓j
                jmp     INT3FFAIL
INT3FHANDLER    endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


RETTHUNK        proc far                ; CODE XREF: INT3FHANDLER+2B↑j
                mov     cl, es:[bx+3]
                jcxz    short loc_18BB
                xor     ax, ax

loc_187D:                               ; CODE XREF: RETTHUNK+E↓j
                add     bx, 4
                cmp     es:[bx], ax
                jnz     short loc_187D
                mov     es, word ptr es:[bx+2]
                mov     bx, 0FFFFh
                push    es
                push    cx
                push    bx
                push    bx
                mov     ax, cs:INT3FCURRENTCS
                mov     cl, 3
                shr     ax, cl
                and     al, 0FEh
                xchg    ax, [bp-2]
                mov     cs:INT3FCURRENTCS, ax
                dec     word ptr [bp+0]
                call    LOADSEGMENT
                jcxz    short loc_1872
                mov     cs:INT3FCURRENTDS, ax
                push    word ptr [bp-2]
                call    MYLOCK
                mov     [bp-2], ax
                inc     word ptr [bp+0]
                jmp     short loc_185A
; ---------------------------------------------------------------------------

loc_18BB:                               ; CODE XREF: RETTHUNK+4↑j
                cmp     ah, 3
                ja      short loc_185A
                pop     bx
                pop     bx
                pop     cx
                pop     dx
                pop     es
                pop     ds
                pop     bp
                jnz     short loc_18D8
                xor     bp, bp
                push    cs:INT3FCURRENTDS
                push    cs:INT3FCURRENTCS
                push    es
                push    bx
                retf
; ---------------------------------------------------------------------------

loc_18D8:                               ; CODE XREF: RETTHUNK+52↑j
                xor     bp, bp
                or      ah, ah
                jnz     short loc_18E5
                nop
                push    cs
                call    near ptr GETVERSION
                jmp     short loc_18FA
; ---------------------------------------------------------------------------

loc_18E5:                               ; CODE XREF: RETTHUNK+67↑j
                dec     ah
                jnz     short loc_18F2
                push    es
                push    bx
                nop
                push    cs
                call    near ptr GETMODULEHANDLE
                jmp     short loc_18FA
; ---------------------------------------------------------------------------

loc_18F2:                               ; CODE XREF: RETTHUNK+72↑j
                push    dx
                push    es
                push    bx
                nop
                push    cs
                call    near ptr GETPROCADDRESS

loc_18FA:                               ; CODE XREF: RETTHUNK+6E↑j
                                        ; RETTHUNK+7B↑j
                jmp     dword ptr cs:INT3FCURRENTCS
RETTHUNK        endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


TESTDSAX        proc near               ; CODE XREF: INT3FHANDLER+35↑p
                xor     bx, bx
                test    al, 1
                jz      short done
                mov     es, cs:PGLOBALHEAP
                cmp     ax, es:[bx+6]
                jbe     short done
                cmp     ax, es:[bx+8]
                jnb     short done
                dec     ax
                mov     es, ax
                inc     ax
                cmp     byte ptr es:[bx], 4Dh ; 'M'
                jnz     short done
                mov     cx, es:[bx+1]
                jcxz    short done
                test    byte ptr es:[bx+5], 4
                jnz     short done
                mov     dx, es:[bx+0Ah]
                or      dx, dx
                jz      short done
                mov     es, cx
                cmp     word ptr es:[bx], 454Eh
                jnz     short done
                mov     bx, es:[bx+8]
                or      bx, bx
                jz      short done
                cmp     es:[bx+8], dx
                jnz     short done
                mov     ax, dx

done:                                   ; CODE XREF: TESTDSAX+4↑j
                                        ; TESTDSAX+F↑j ...
                retn
TESTDSAX        endp
