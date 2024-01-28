

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

LOADEXEHEADER   proc near               ; CODE XREF: LOADMODULE+F4↑p
                                        ; BOOTSTRAP+15D↓p ...

var_46          = byte ptr -46h
var_6           = word ptr -6
var_4           = word ptr -4
var_2           = word ptr -2
arg_2           = word ptr  6
arg_4           = word ptr  8
arg_6           = word ptr  0Ah

                push    bp
                mov     bp, sp
                sub     sp, 46h
                push    si
                push    di
                xor     ax, ax
                mov     [bp+var_4], ax
                cmp     [bp+arg_2], ax
                jz      short loc_2571
                lds     si, [bp+4]
                mov     al, [si]
                inc     ax

loc_2571:                               ; CODE XREF: LOADEXEHEADER+10↑j
                mov     [bp+var_2], ax
                mov     bx, [bp+arg_6]
                cmp     [bp+arg_4], bx
                jz      short loc_2583
                mov     ds, bx
                xor     si, si
                jmp     short loc_25CD
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_2583:                               ; CODE XREF: LOADEXEHEADER+21↑j
                push    ss
                pop     ds
                lea     si, [bp+var_46]
                mov     dx, si
                mov     cx, 40h ; '@'
                mov     bx, [bp+arg_6]
                mov     ah, 3Fh ; '?'
                int     21h             ; DOS - 2+ - READ FROM FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to read
                                        ; DS:DX -> buffer
                jb      short loc_25C8
                cmp     ax, cx
                jb      short loc_25C8
                cmp     word ptr [si], 5A4Dh
                jnz     short loc_25C8
                mov     cx, [si+3Eh]
                mov     dx, [si+3Ch]
                mov     ax, cx
                or      ax, dx
                jz      short loc_25C8
                mov     ax, 4200h
                int     21h             ; DOS - 2+ - MOVE FILE READ/WRITE POINTER (LSEEK)
                                        ; AL = method: offset from beginning of file
                jb      short loc_25C8
                mov     cx, 40h ; '@'
                mov     dx, si
                mov     ah, 3Fh ; '?'
                int     21h             ; DOS - 2+ - READ FROM FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to read
                                        ; DS:DX -> buffer
                jb      short loc_25C8
                cmp     ax, cx
                jnz     short loc_25C8
                cmp     word ptr [si], 454Eh
                jz      short loc_25CD

loc_25C8:                               ; CODE XREF: LOADEXEHEADER+3B↑j
                                        ; LOADEXEHEADER+3F↑j ...
                xor     ax, ax
                jmp     loc_28BA
; ---------------------------------------------------------------------------

loc_25CD:                               ; CODE XREF: LOADEXEHEADER+27↑j
                                        ; LOADEXEHEADER+6D↑j
                mov     [bp+var_6], bx
                mov     di, [si+4]
                add     di, [si+6]
                mov     cx, [si+1Ch]
                add     di, cx
                shl     cx, 1
                add     di, cx
                add     di, cx
                add     di, cx
                add     cx, 2
                shl     cx, 1
                add     di, cx
                mov     cx, [si+30h]
                add     di, cx
                shl     cx, 1
                shl     cx, 1
                add     di, cx
                add     di, 10h
                add     di, [bp+var_2]
                mov     ax, 7
                xor     bx, bx
                push    ax
                push    di
                push    bx
                call    MYALLOC
                or      ax, ax
                jz      short loc_263D
                sub     di, [bp+var_2]
                mov     [bp+var_4], ax
                mov     es, ax
                cld
                mov     bx, [bp+var_6]
                cmp     [bp+arg_4], bx
                jnz     short loc_2649
                mov     ax, [si+4]
                add     ax, [si+6]
                sub     di, ax
                mov     cx, 40h ; '@'
                sub     ax, cx
                rep movsb
                mov     cx, ax
                push    es
                pop     ds
                mov     dx, di
                mov     ah, 3Fh ; '?'
                int     21h             ; DOS - 2+ - READ FROM FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to read
                                        ; DS:DX -> buffer
                jb      short loc_263D
                lea     si, [di-40h]
                cmp     ax, cx
                jz      short loc_2649

loc_263D:                               ; CODE XREF: LOADEXEHEADER+AF↑j
                                        ; LOADEXEHEADER+DB↑j ...
                push    [bp+var_4]
                call    MYFREE
                xor     ax, ax
                inc     ax
                jmp     loc_28BA
; ---------------------------------------------------------------------------

loc_2649:                               ; CODE XREF: LOADEXEHEADER+C0↑j
                                        ; LOADEXEHEADER+E2↑j
                test    word ptr [si+0Ch], 2000h
                jnz     short loc_263D
                cmp     byte ptr [si+2], 4
                jl      short loc_263D
                xor     di, di
                mov     cx, 40h ; '@'
                cld
                rep movsb
                mov     cx, es:1Ch
                xor     ax, ax
                mov     es:22h, di
                jcxz    short loc_2673

loc_266C:                               ; CODE XREF: LOADEXEHEADER+118↓j
                movsw
                movsw
                movsw
                movsw
                stosw
                loop    loc_266C

loc_2673:                               ; CODE XREF: LOADEXEHEADER+111↑j
                mov     cx, es:26h
                sub     cx, es:24h
                mov     es:24h, di
                rep movsb
                mov     cx, es:28h
                sub     cx, es:26h
                mov     es:26h, di
                lodsb
                stosb
                mov     bx, ax
                sub     cx, bx
                dec     cx

loc_269A:                               ; CODE XREF: LOADEXEHEADER+147↓j
                lodsb
                call    MYUPPER
                stosb
                dec     bx
                jnz     short loc_269A
                rep movsb
                mov     cx, es:2Ah
                sub     cx, es:28h
                mov     es:28h, di
                rep movsb
                mov     es:3Eh, di
                mov     cx, es:1Ch
                mov     al, 0FFh
                rep stosb
                mov     es:3Ch, di
                mov     cx, es:1Ch
                jcxz    short loc_26DC
                mov     ax, 3FCDh
                xor     bx, bx

loc_26D4:                               ; CODE XREF: LOADEXEHEADER+181↓j
                inc     bh
                stosw
                xchg    ax, bx
                stosw
                xchg    ax, bx
                loop    loc_26D4

loc_26DC:                               ; CODE XREF: LOADEXEHEADER+174↑j
                xor     ax, ax
                stosw
                mov     ax, es
                stosw
                mov     es:3Ah, di
                mov     cx, es:1Ch
                jcxz    short loc_26F4
                xor     ax, ax
                shl     cx, 1
                rep stosw

loc_26F4:                               ; CODE XREF: LOADEXEHEADER+193↑j
                mov     cx, es:4
                sub     cx, es:2Ah
                mov     es:2Ah, di
                jcxz    short loc_2707
                rep movsb

loc_2707:                               ; CODE XREF: LOADEXEHEADER+1AA↑j
                mov     es:4, di

loc_270C:                               ; CODE XREF: LOADEXEHEADER+1BE↓j
                                        ; LOADEXEHEADER+1CD↓j ...
                lodsw
                stosw
                xor     cx, cx
                mov     cl, al
                jcxz    short loc_2744
                cmp     ah, 0
                jz      short loc_270C
                cmp     ah, 0FFh
                jz      short loc_2728
                mov     ax, cx
                shl     cx, 1
                add     cx, ax
                rep movsb
                jmp     short loc_270C
; ---------------------------------------------------------------------------

loc_2728:                               ; CODE XREF: LOADEXEHEADER+1C3↑j
                                        ; LOADEXEHEADER+1E7↓j
                lodsb
                mov     ah, 2Eh ; '.'
                stosw
                mov     ax, 3ED0h
                stosw
                xor     ax, ax
                mov     al, [si+2]
                dec     al
                add     ax, es:3Eh
                stosw
                movsw
                movsb
                movsw
                loop    loc_2728
                jmp     short loc_270C
; ---------------------------------------------------------------------------

loc_2744:                               ; CODE XREF: LOADEXEHEADER+1B9↑j
                xor     bx, bx
                mov     es:2, bx
                mov     es:6, bx
                mov     es:0Ah, bx
                cmp     es:32h, bx
                jnz     short loc_2763
                mov     word ptr es:32h, 9

loc_2763:                               ; CODE XREF: LOADEXEHEADER+201↑j
                mov     cx, [bp+var_2]
                jcxz    short loc_2772
                mov     es:0Ah, di
                lds     si, [bp+4]
                rep movsb

loc_2772:                               ; CODE XREF: LOADEXEHEADER+20D↑j
                mov     bx, es:0Eh
                or      bx, bx
                jz      short loc_278B
                dec     bx
                shl     bx, 1
                mov     cx, bx
                shl     bx, 1
                shl     bx, 1
                add     bx, cx
                add     bx, es:22h

loc_278B:                               ; CODE XREF: LOADEXEHEADER+220↑j
                mov     es:8, bx
                mov     bx, es:22h
                xor     cx, cx

loc_2797:                               ; CODE XREF: LOADEXEHEADER+305↓j
                inc     cx
                cmp     cx, es:1Ch
                jbe     short loc_27A2
                jmp     loc_2861
; ---------------------------------------------------------------------------

loc_27A2:                               ; CODE XREF: LOADEXEHEADER+244↑j
                mov     al, 1
                and     al, es:[bx+4]
                jz      short loc_27D4
                and     word ptr es:[bx+4], 0FFFh
                cmp     es:8, bx
                jz      short loc_27C1
                or      byte ptr es:[bx+4], 40h
                and     byte ptr es:[bx+4], 0EFh

loc_27C1:                               ; CODE XREF: LOADEXEHEADER+25C↑j
                jmp     loc_285B
; ---------------------------------------------------------------------------

loc_27C4:                               ; CODE XREF: LOADEXEHEADER+280↓j
                cmp     cs:FBOOTING, 0
                jnz     short loc_27E7
                or      word ptr es:[bx+4], 40h
                jmp     short loc_27E7
; ---------------------------------------------------------------------------

loc_27D4:                               ; CODE XREF: LOADEXEHEADER+24F↑j
                test    byte ptr es:[bx+4], 10h
                jz      short loc_27C4
                or      word ptr es:[bx+4], 0F000h
                or      byte ptr es:0Ch, 80h

loc_27E7:                               ; CODE XREF: LOADEXEHEADER+271↑j
                                        ; LOADEXEHEADER+279↑j
                test    byte ptr es:0Ch, 2
                jnz     short loc_285B
                test    byte ptr es:0Ch, 1
                jz      short loc_285B
                mov     si, es:4
                xor     ah, ah

loc_27FE:                               ; CODE XREF: LOADEXEHEADER+2B1↓j
                                        ; LOADEXEHEADER+2C1↓j ...
                lods    byte ptr es:[si]
                or      ax, ax
                jz      short loc_285B
                mov     dx, ax
                lods    byte ptr es:[si]
                cmp     al, 0
                jz      short loc_27FE
                cmp     al, 0FFh
                jz      short loc_282A
                cmp     al, cl
                jz      short loc_281C
                add     si, dx
                shl     dx, 1
                add     si, dx
                jmp     short loc_27FE
; ---------------------------------------------------------------------------

loc_281C:                               ; CODE XREF: LOADEXEHEADER+2B9↑j
                                        ; LOADEXEHEADER+2CD↓j
                test    byte ptr es:[si], 2
                jnz     short loc_283E
                add     si, 3
                dec     dx
                jnz     short loc_281C
                jmp     short loc_27FE
; ---------------------------------------------------------------------------

loc_282A:                               ; CODE XREF: LOADEXEHEADER+2B5↑j
                                        ; LOADEXEHEADER+2E1↓j
                cmp     es:[si+8], cl
                jnz     short loc_2836
                test    byte ptr es:[si], 2
                jnz     short loc_283E

loc_2836:                               ; CODE XREF: LOADEXEHEADER+2D5↑j
                add     si, 0Bh
                dec     dx
                jnz     short loc_282A
                jmp     short loc_27FE
; ---------------------------------------------------------------------------

loc_283E:                               ; CODE XREF: LOADEXEHEADER+2C7↑j
                                        ; LOADEXEHEADER+2DB↑j
                or      word ptr es:[bx+4], 400h
                test    byte ptr es:[bx+4], 40h
                jz      short loc_285B
                push    bx
                mov     bx, es:8
                or      bx, bx
                jz      short loc_285A
                or      byte ptr es:[bx+4], 40h

loc_285A:                               ; CODE XREF: LOADEXEHEADER+2FA↑j
                pop     bx

loc_285B:                               ; CODE XREF: LOADEXEHEADER:loc_27C1↑j
                                        ; LOADEXEHEADER+294↑j ...
                add     bx, 0Ah
                jmp     loc_2797
; ---------------------------------------------------------------------------

loc_2861:                               ; CODE XREF: LOADEXEHEADER+246↑j
                mov     bx, es:16h
                or      bx, bx
                jz      short loc_2897
                dec     bx
                shl     bx, 1
                mov     si, bx
                shl     si, 1
                shl     si, 1
                add     si, bx
                add     si, es:22h
                or      byte ptr es:[si+4], 40h
                cmp     word ptr es:0Eh, 0
                jz      short loc_2897
                or      word ptr es:[si+4], 400h
                mov     si, es:8
                or      byte ptr es:[si+4], 40h

loc_2897:                               ; CODE XREF: LOADEXEHEADER+30F↑j
                                        ; LOADEXEHEADER+32C↑j
                test    word ptr es:0Ch, 8000h
                jnz     short loc_28AF
                cmp     word ptr es:12h, 0
                jnz     short loc_28AF
                mov     word ptr es:12h, 1000h

loc_28AF:                               ; CODE XREF: LOADEXEHEADER+345↑j
                                        ; LOADEXEHEADER+34D↑j
                mov     dx, es
                dec     dx
                mov     ds, dx
                assume ds:nothing
                mov     word ptr ds:1, es
                mov     ax, es

loc_28BA:                               ; CODE XREF: LOADEXEHEADER+71↑j
                                        ; LOADEXEHEADER+ED↑j
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    8
LOADEXEHEADER   endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

TRIMEXEHEADER   proc near               ; CODE XREF: LOADMODULE+348↑p
                                        ; STARTTASK+64↓p ...

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                mov     es, [bp+arg_0]
                xor     ax, ax
                cmp     word ptr es:0, 454Eh
                jnz     short loc_28E0
                mov     ax, 2Ch ; ','
                push    [bp+arg_0]
                push    ax
                call    FREENRTABLE
                mov     ax, [bp+arg_0]

loc_28E0:                               ; CODE XREF: TRIMEXEHEADER+F↑j
                mov     sp, bp
                pop     bp
                retn    2
TRIMEXEHEADER   endp
