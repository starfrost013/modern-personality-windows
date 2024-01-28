
; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

FINDORDINAL     proc near               ; CODE XREF: SEGRELOC+AF↓p
                                        ; GETPROCADDRESS+3A↓p

arg_0           = dword ptr  4
arg_4           = word ptr  8

                push    bp
                mov     bp, sp
                push    si
                push    di
                les     si, [bp+arg_0]
                cmp     byte ptr es:[si+1], 23h ; '#'
                jz      short loc_91C

loc_8E7:                                ; CODE XREF: FINDORDINAL+56↓j
                push    ds
                mov     ds, [bp+arg_4]
                mov     si, ds:26h
                cld

loc_8F0:                                ; CODE XREF: FINDORDINAL+8A↓j
                xor     ax, ax
                lodsb
                add     si, ax
                add     si, 2

loc_8F8:                                ; CODE XREF: FINDORDINAL+42↓j
                lodsb
                les     di, [bp+arg_0]
                mov     cx, ax
                jcxz    short loc_93E
                cmp     es:[di], al
                jnz     short loc_915
                inc     di
                repe cmpsb
                jnz     short loc_915
                lodsw
                mov     bx, ds
                pop     ds
                cmp     [bp+arg_4], bx
                jz      short invalid_procedure_name
                jmp     short loc_965
; ---------------------------------------------------------------------------

loc_915:                                ; CODE XREF: FINDORDINAL+2B↑j
                                        ; FINDORDINAL+30↑j
                add     si, cx
                add     si, 2
                jmp     short loc_8F8
; ---------------------------------------------------------------------------

loc_91C:                                ; CODE XREF: FINDORDINAL+D↑j
                lods    byte ptr es:[si]
                mov     cl, al
                xor     ch, ch
                dec     cx
                inc     si
                xor     ax, ax

loc_926:                                ; CODE XREF: FINDORDINAL+62↓j
                mov     dx, ax
                lods    byte ptr es:[si]
                sub     al, 30h ; '0'
                cmp     al, 9
                ja      short loc_8E7
                xor     ah, ah
                mov     bx, ax
                mov     al, 0Ah
                mul     dx
                add     ax, bx
                loop    loc_926
                jmp     short invalid_procedure_name
; ---------------------------------------------------------------------------

loc_93E:                                ; CODE XREF: FINDORDINAL+26↑j
                mov     bx, ds
                pop     ds
                cmp     [bp+arg_4], bx
                jnz     short loc_965
                mov     bx, 0FFFFh
                mov     es, [bp+arg_4]
                mov     ax, 2Ch ; ','
                mov     dx, es:20h
                push    es
                push    bx
                push    ax
                push    dx
                call    LOADNRTABLE
                push    ds
                mov     ds, dx
                mov     si, ax
                or      ax, dx
                jnz     short loc_8F0
                pop     ds

loc_965:                                ; CODE XREF: FINDORDINAL+3B↑j
                                        ; FINDORDINAL+6C↑j
                push    ax
                mov     ax, 2Ch ; ','
                push    [bp+arg_4]
                push    ax
                call    FREENRTABLE
                pop     ax

invalid_procedure_name:                 ; CODE XREF: FINDORDINAL+39↑j
                                        ; FINDORDINAL+64↑j
                or      ax, ax
                jnz     short loc_9A4
                les     bx, [bp+arg_0]
                inc     bx
                mov     ax, 404h
                push    ax
                mov     ax, offset SZINVALIDPROC ; "Invalid procedure name "
                push    cs
                push    ax
                push    es
                push    bx
                call    KERNELERROR
                jmp     short loc_9A2
; ---------------------------------------------------------------------------
SZINVALIDPROC   db 'Invalid procedure name ',0
                                        ; DATA XREF: FINDORDINAL+A5↑o
                db 24h
; ---------------------------------------------------------------------------

loc_9A2:                                ; CODE XREF: FINDORDINAL+AF↑j
                xor     ax, ax

loc_9A4:                                ; CODE XREF: FINDORDINAL+9B↑j
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    6
FINDORDINAL     endp



; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

FINDEXEINFO     proc near               ; CODE XREF: LOADMODULE+76↑p
                                        ; LOADMODULE+1CF↑p ...

arg_0           = word ptr  4
arg_2           = dword ptr  6

                push    bp
                mov     bp, sp
                push    si
                push    di
                push    ds
                mov     bx, [bp+arg_0]
                mov     ax, cs:HEXEHEAD

loc_7EF:                                ; CODE XREF: FINDEXEINFO+2B↓j
                or      ax, ax
                jz      short loc_80F
                mov     es, ax
                mov     di, es:26h
                cmp     es:[di], bl
                jnz     short loc_809
                inc     di
                lds     si, [bp+arg_2]
                mov     cx, bx
                repe cmpsb
                jz      short loc_80F

loc_809:                                ; CODE XREF: FINDEXEINFO+1B↑j
                mov     ax, es:6
                jmp     short loc_7EF
; ---------------------------------------------------------------------------

loc_80F:                                ; CODE XREF: FINDEXEINFO+F↑j
                                        ; FINDEXEINFO+25↑j
                pop     ds
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    6
FINDEXEINFO     endp



;
; External Entry #95 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public LOADLIBRARY
LOADLIBRARY     proc far
                pop     ax              ; KERNEL_95
                pop     dx
                mov     cx, 0FFFFh
                push    cx
                push    cx
                push    dx
                push    ax
                jmp     near ptr LOADMODULE
; ---------------------------------------------------------------------------
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf
LOADLIBRARY     endp

;
; External Entry #93 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GETCODEHANDLE
GETCODEHANDLE   proc far

arg_0           = dword ptr  6

                inc     bp              ; KERNEL_93
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                les     bx, [bp+arg_0]
                cmp     word ptr es:0, 454Eh
                jnz     short loc_19B0
                cmp     bx, es:4
                jnb     short loc_198B
                dec     bx
                cmp     bx, es:1Ch
                jnb     short loc_19B0
                mov     cx, bx
                inc     cx
                jmp     short loc_19A0
; ---------------------------------------------------------------------------

loc_198B:                               ; CODE XREF: GETCODEHANDLE+18↑j
                cmp     word ptr es:[bx], 0D02Eh
                jnz     short loc_19B0
                dec     bx
                cmp     byte ptr es:[bx+6], 0EAh
                jz      short loc_19AC
                xor     cx, cx
                mov     cl, es:[bx+8]

loc_19A0:                               ; CODE XREF: GETCODEHANDLE+25↑j
                mov     dx, 0FFFFh
                push    es
                push    cx
                push    dx
                push    dx
                call    LOADSEGMENT
                jmp     short loc_19BD
; ---------------------------------------------------------------------------

loc_19AC:                               ; CODE XREF: GETCODEHANDLE+34↑j
                les     bx, es:[bx+7]

loc_19B0:                               ; CODE XREF: GETCODEHANDLE+11↑j
                                        ; GETCODEHANDLE+20↑j ...
                push    es
                call    MYLOCK
                call    GENTER
                call    GLRUTOP
                call    GLEAVE

loc_19BD:                               ; CODE XREF: GETCODEHANDLE+46↑j
                mov     ax, dx
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    4
GETCODEHANDLE   endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

COPYNAME        proc near               ; CODE XREF: GETPROCADDRESS+31↓p
                                        ; GETMODULEHANDLE+1C↓p

arg_0           = word ptr  4
arg_2           = word ptr  6
arg_4           = dword ptr  8

                push    bp
                mov     bp, sp
                push    si
                les     si, [bp+arg_4]
                mov     bx, [bp+arg_2]
                mov     cx, 3Fh ; '?'
                mov     dx, [bp+arg_0]

loc_19DC:                               ; CODE XREF: COPYNAME+1C↓j
                lods    byte ptr es:[si]
                or      al, al
                jz      short loc_19EA
                call    dx
                inc     bx
                mov     ss:[bx], al
                loop    loc_19DC

loc_19EA:                               ; CODE XREF: COPYNAME+14↑j
                mov     byte ptr ss:[bx+1], 0
                mov     ax, bx
                mov     bx, [bp+arg_2]
                sub     ax, bx
                mov     ss:[bx], al
                pop     si
                mov     sp, bp
                pop     bp
                retn    8
; ---------------------------------------------------------------------------
                retn
COPYNAME        endp

;
; External Entry #50 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GETPROCADDRESS
GETPROCADDRESS  proc far                ; CODE XREF: RETTHUNK+82↑p
                                        ; INITFWDREF+5F↓p ...

var_42          = byte ptr -42h
arg_0           = word ptr  6
arg_2           = word ptr  8
arg_4           = word ptr  0Ah

                inc     bp              ; KERNEL_50
                push    bp
                mov     bp, sp
                push    ds
                sub     sp, 40h
                push    si
                push    [bp+arg_4]
                call    GETEXEPTR
                xor     dx, dx
                jcxz    short loc_1A43
                mov     si, ax
                cmp     [bp+arg_2], 0
                jnz     short loc_1A21
                mov     ax, [bp+arg_0]
                jmp     short loc_1A3E
; ---------------------------------------------------------------------------

loc_1A21:                               ; CODE XREF: GETPROCADDRESS+19↑j
                lea     bx, [bp+var_42]
                mov     dx, 0FFh
                mov     dx, 1A00h
                push    [bp+arg_2]
                push    [bp+arg_0]
                push    bx
                push    dx
                call    COPYNAME
                lea     bx, [bp+var_42]
                push    si
                push    ss
                push    bx
                call    FINDORDINAL

loc_1A3E:                               ; CODE XREF: GETPROCADDRESS+1E↑j
                push    si
                push    ax
                call    ENTPROCADDRESS

loc_1A43:                               ; CODE XREF: GETPROCADDRESS+11↑j
                mov     cx, ax
                or      cx, dx
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    6
GETPROCADDRESS  endp

;
; External Entry #49 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GETMODULEFILENAME
GETMODULEFILENAME proc far

arg_0           = word ptr  6
arg_2           = dword ptr  8
arg_6           = word ptr  0Ch

                inc     bp              ; KERNEL_49
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                push    [bp+arg_6]
                call    GETEXEPTR
                jcxz    short loc_1A87
                mov     ds, ax
                mov     si, ds:0Ah
                xor     cx, cx
                mov     cl, [si]
                sub     cx, 8
                lea     si, [si+8]
                les     di, [bp+arg_2]
                cmp     cx, [bp+arg_0]
                jl      short loc_1A7E
                mov     cx, [bp+arg_0]
                dec     cx

loc_1A7E:                               ; CODE XREF: GETMODULEFILENAME+25↑j
                cld
                mov     ax, cx
                rep movsb
                mov     byte ptr es:[di], 0

loc_1A87:                               ; CODE XREF: GETMODULEFILENAME+D↑j
                mov     cx, ax
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    8
GETMODULEFILENAME endp

;
; External Entry #48 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GETMODULEUSAGE
GETMODULEUSAGE  proc far

arg_0           = word ptr  6

                inc     bp              ; KERNEL_48
                push    bp
                mov     bp, sp
                push    ds
                push    [bp+arg_0]
                call    GETEXEPTR
                jcxz    short loc_1AA9
                mov     es, ax
                mov     ax, es:2

loc_1AA9:                               ; CODE XREF: GETMODULEUSAGE+B↑j
                mov     cx, ax
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
GETMODULEUSAGE  endp

;
; External Entry #54 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GETINSTANCEDATA
GETINSTANCEDATA proc far

arg_0           = word ptr  6
arg_2           = word ptr  8
arg_4           = word ptr  0Ah

                inc     bp              ; KERNEL_54
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                push    ds
                push    [bp+arg_4]
                call    MYLOCK
                pop     es
                or      ax, ax
                jz      short loc_1ADC
                mov     ds, ax
                mov     si, [bp+arg_2]
                mov     di, si
                mov     ax, [bp+arg_0]
                mov     cx, ax
                jcxz    short loc_1ADC
                cld
                rep movsb
                push    es
                pop     ds

loc_1ADC:                               ; CODE XREF: GETINSTANCEDATA+11↑j
                                        ; GETINSTANCEDATA+1F↑j
                mov     cx, ax
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    6
GETINSTANCEDATA endp

;
; External Entry #51 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public MAKEPROCINSTANCE
MAKEPROCINSTANCE proc far

var_2           = word ptr -2
arg_0           = word ptr  6
arg_2           = word ptr  8
arg_4           = word ptr  0Ah

                inc     bp              ; KERNEL_51
                push    bp
                mov     bp, sp
                push    ds
                push    di
                mov     ax, cs:HTHUNKS
                or      ax, ax
                jnz     short loc_1B2B

loc_1AF9:                               ; CODE XREF: MAKEPROCINSTANCE+53↓j
                mov     bx, 1F0h
                mov     cx, 2040h
                push    cx
                push    ax
                push    bx
                nop
                push    cs
                call    near ptr GLOBALALLOC
                mov     es, ax
                mov     bx, cs:HTHUNKS
                mov     cs:HTHUNKS, es
                mov     es:0, bx
                mov     bx, 6
                mov     cx, 3Dh ; '='

loc_1B1E:                               ; CODE XREF: MAKEPROCINSTANCE+3B↓j
                lea     dx, [bx+8]
                mov     es:[bx], dx
                mov     bx, dx
                loop    loc_1B1E
                mov     es:[bx], cx

loc_1B2B:                               ; CODE XREF: MAKEPROCINSTANCE+C↑j
                                        ; MAKEPROCINSTANCE+51↓j
                mov     es, ax
                mov     bx, es:6
                or      bx, bx
                jnz     short loc_1B40
                mov     ax, es:0
                or      ax, ax
                jnz     short loc_1B2B
                jmp     short loc_1AF9
; ---------------------------------------------------------------------------

loc_1B40:                               ; CODE XREF: MAKEPROCINSTANCE+49↑j
                mov     ax, es:[bx]
                mov     es:6, ax
                lea     di, [bx-6]
                mov     bx, [bp+var_2]
                mov     ax, [bp+arg_0]
                or      ax, ax
                jz      short loc_1B5C
                push    es
                push    ax
                call    MYLOCK
                pop     es
                mov     bx, ax

loc_1B5C:                               ; CODE XREF: MAKEPROCINSTANCE+67↑j
                cld
                mov     dx, di
                mov     al, 0B8h
                stosb
                mov     ax, bx
                stosw
                mov     al, 0EAh
                stosb
                mov     ax, [bp+arg_2]
                stosw
                mov     ax, [bp+arg_4]
                stosw
                mov     ax, dx
                mov     dx, es
                mov     cx, ax
                or      cx, dx
                pop     di
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    6
MAKEPROCINSTANCE endp

;
; External Entry #52 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public FREEPROCINSTANCE
FREEPROCINSTANCE proc far

arg_0           = word ptr  6
arg_2           = word ptr  8

                inc     bp              ; KERNEL_52
                push    bp
                mov     bp, sp
                push    ds
                push    di
                mov     ax, cs:HTHUNKS

loc_1B8E:                               ; CODE XREF: FREEPROCINSTANCE+19↓j
                or      ax, ax
                jz      short loc_1BB3
                mov     es, ax
                cmp     ax, [bp+arg_2]
                jz      short loc_1B9F
                mov     ax, es:0
                jmp     short loc_1B8E
; ---------------------------------------------------------------------------

loc_1B9F:                               ; CODE XREF: FREEPROCINSTANCE+13↑j
                mov     di, [bp+arg_0]
                xor     ax, ax
                cld
                stosw
                stosw
                stosw
                mov     ax, di
                xchg    ax, es:6
                stosw
                mov     ax, 0FFFFh

loc_1BB3:                               ; CODE XREF: FREEPROCINSTANCE+C↑j
                mov     cx, ax
                pop     di
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    4
FREEPROCINSTANCE endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

PATCHPROLOG     proc near               ; CODE XREF: PATCHTHUNKS+179↓p
                                        ; PATCHTHUNKS+19A↓p

arg_0           = dword ptr  4

                push    bp
                mov     bp, sp
                push    bx
                push    cx
                push    dx
                push    es
                les     bx, [bp+arg_0]
                cmp     byte ptr es:[bx], 0B8h
                jz      short loc_1BD7
                cmp     byte ptr es:[bx], 0CCh
                jnz     short loc_1BF5

loc_1BD7:                               ; CODE XREF: PATCHPROLOG+E↑j
                inc     bx
                cmp     es:[bx], si
                jnz     short loc_1BF5
                mov     dx, si
                xor     dx, di
                test    bl, 1
                jz      short loc_1BE8
                xchg    dh, dl

loc_1BE8:                               ; CODE XREF: PATCHPROLOG+23↑j
                mov     es:[bx], di
                mov     ax, es
                call    GETCHKSUMADDR
                jcxz    short loc_1BF5
                xor     es:[bx], dx

loc_1BF5:                               ; CODE XREF: PATCHPROLOG+14↑j
                                        ; PATCHPROLOG+1A↑j ...
                pop     es
                pop     dx
                pop     cx
                pop     bx
                mov     sp, bp
                pop     bp
                retn    4
PATCHPROLOG     endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

PATCHTHUNKS     proc near               ; CODE XREF: MYFREE+22↑p
                                        ; GNOTIFY+1F↓p ...

arg_0           = word ptr  4
arg_2           = word ptr  6

                push    bp
                mov     bp, sp
                push    si
                push    di
                mov     ax, [bp+arg_2]
                call    CHECKSEGCHKSUM
                push    cs:HHANDLE

loc_1C0F:                               ; CODE XREF: PATCHTHUNKS:loc_1C2D↓j
                                        ; PATCHTHUNKS+33↓j
                pop     cx
                jcxz    short loc_1C3A
                push    cx
                call    MYLOCK
                mov     ax, [bp+arg_2]
                mov     dx, [bp+arg_0]
                push    word ptr es:0Ch
                mov     di, es:0Eh
                mov     cx, es:[di+10h]
                add     di, 12h

loc_1C2D:                               ; CODE XREF: PATCHTHUNKS+39↓j
                jcxz    short loc_1C0F
                cld
                repne scasw
                jnz     short loc_1C0F
                mov     es:[di-2], dx
                jmp     short loc_1C2D
; ---------------------------------------------------------------------------

loc_1C3A:                               ; CODE XREF: PATCHTHUNKS+11↑j
                mov     si, [bp+arg_2]
                mov     di, [bp+arg_0]
                mov     ax, si
                dec     ax
                mov     es, ax
                mov     bl, es:5
                mov     ax, es:0Ah
                or      ax, ax
                jnz     short loc_1C54
                mov     ax, si

loc_1C54:                               ; CODE XREF: PATCHTHUNKS+51↑j
                mov     es, word ptr es:1
                cmp     word ptr es:0, 454Eh
                jnz     short loc_1C7E
                test    bl, 4
                jnz     short loc_1CAC
                mov     bx, es:22h
                mov     cx, es:1Ch
                jcxz    short loc_1C7E

loc_1C73:                               ; CODE XREF: PATCHTHUNKS+7D↓j
                cmp     es:[bx+8], ax
                jz      short loc_1C81
                add     bx, 0Ah
                loop    loc_1C73

loc_1C7E:                               ; CODE XREF: PATCHTHUNKS+61↑j
                                        ; PATCHTHUNKS+72↑j ...
                jmp     loc_1E03
; ---------------------------------------------------------------------------

loc_1C81:                               ; CODE XREF: PATCHTHUNKS+78↑j
                mov     dx, es:[bx+4]
                test    dl, 4
                jz      short loc_1C7E
                sub     cx, es:1Ch
                neg     cx
                inc     cx
                push    bx
                or      di, di
                jnz     short loc_1CA3
                mov     bx, es:3Eh
                add     bx, cx
                mov     byte ptr es:[bx-1], 0FFh

loc_1CA3:                               ; CODE XREF: PATCHTHUNKS+96↑j
                pop     bx
                test    dl, 1
                jnz     short loc_1CAC
                jmp     loc_1DA3
; ---------------------------------------------------------------------------

loc_1CAC:                               ; CODE XREF: PATCHTHUNKS+66↑j
                                        ; PATCHTHUNKS+A8↑j
                push    es
                push    cs:HTHUNKS

loc_1CB2:                               ; CODE XREF: PATCHTHUNKS+F0↓j
                pop     cx
                jcxz    short loc_1CF1
                mov     es, cx
                push    word ptr es:0
                xor     bx, bx
                mov     cx, 3Dh ; '='

loc_1CC1:                               ; CODE XREF: PATCHTHUNKS:loc_1CED↓j
                add     bx, 8
                cmp     byte ptr es:[bx], 0B8h
                jnz     short loc_1CED
                cmp     es:[bx+1], si
                jnz     short loc_1CED
                mov     es:[bx+1], di
                or      di, di
                jnz     short loc_1CED
                xchg    bx, di
                xor     ax, ax
                cld
                stosw
                stosw
                stosw
                mov     ax, di
                xchg    ax, es:6
                stosw
                xchg    bx, di
                sub     bx, 8

loc_1CED:                               ; CODE XREF: PATCHTHUNKS+C9↑j
                                        ; PATCHTHUNKS+CF↑j ...
                loop    loc_1CC1
                jmp     short loc_1CB2
; ---------------------------------------------------------------------------

loc_1CF1:                               ; CODE XREF: PATCHTHUNKS+B4↑j
                pop     es
                mov     bx, es:4
                xor     ah, ah
                or      di, di
                jnz     short loc_1D30
                push    si
                call    MYLOCK
                mov     di, dx
                mov     si, es:0Ch
                mov     cx, cs:HHANDLE
                cmp     cx, di
                jnz     short loc_1D19
                mov     cs:HHANDLE, si
                jmp     short loc_1D2D
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_1D19:                               ; CODE XREF: PATCHTHUNKS+110↑j
                                        ; PATCHTHUNKS+127↓j
                jcxz    short loc_1D2D
                push    cx
                call    MYLOCK
                mov     cx, es:0Ch
                cmp     cx, di
                jnz     short loc_1D19
                mov     es:0Ch, si

loc_1D2D:                               ; CODE XREF: PATCHTHUNKS+117↑j
                                        ; PATCHTHUNKS:loc_1D19↑j ...
                jmp     loc_1E03
; ---------------------------------------------------------------------------

loc_1D30:                               ; CODE XREF: PATCHTHUNKS+FC↑j
                                        ; PATCHTHUNKS+13E↓j ...
                mov     cx, es:[bx]
                or      cl, cl
                jz      short loc_1D2D
                add     bx, 2
                cmp     ch, 0
                jz      short loc_1D30
                cmp     ch, 0FFh
                jz      short loc_1D82
                push    bx
                mov     bl, ch
                xor     bh, bh
                xor     ch, ch
                dec     bx
                shl     bx, 1
                mov     dx, bx
                shl     bx, 1
                shl     bx, 1
                add     bx, dx
                add     bx, es:22h
                xor     dx, dx
                test    byte ptr es:[bx+4], 2
                jz      short loc_1D68
                mov     dx, es:[bx+8]

loc_1D68:                               ; CODE XREF: PATCHTHUNKS+163↑j
                pop     bx

loc_1D69:                               ; CODE XREF: PATCHTHUNKS+17F↓j
                test    byte ptr es:[bx], 2
                jz      short loc_1D7B
                or      dx, dx
                jz      short loc_1D7B
                push    dx
                push    word ptr es:[bx+1]
                call    PATCHPROLOG

loc_1D7B:                               ; CODE XREF: PATCHTHUNKS+16E↑j
                                        ; PATCHTHUNKS+172↑j
                add     bx, 3
                loop    loc_1D69
                jmp     short loc_1D30
; ---------------------------------------------------------------------------

loc_1D82:                               ; CODE XREF: PATCHTHUNKS+143↑j
                xor     ch, ch

loc_1D84:                               ; CODE XREF: PATCHTHUNKS+1A0↓j
                test    byte ptr es:[bx], 2
                jz      short loc_1D9C
                cmp     byte ptr es:[bx+6], 0EAh
                jnz     short loc_1D9C
                push    word ptr es:[bx+9]
                push    word ptr es:[bx+7]
                call    PATCHPROLOG

loc_1D9C:                               ; CODE XREF: PATCHTHUNKS+189↑j
                                        ; PATCHTHUNKS+190↑j
                add     bx, 0Bh
                loop    loc_1D84
                jmp     short loc_1D30
; ---------------------------------------------------------------------------

loc_1DA3:                               ; CODE XREF: PATCHTHUNKS+AA↑j
                or      di, di
                jnz     short loc_1DAC
                and     byte ptr es:[bx+4], 0FBh

loc_1DAC:                               ; CODE XREF: PATCHTHUNKS+1A6↑j
                mov     dx, cx
                mov     bx, es:4

loc_1DB3:                               ; CODE XREF: PATCHTHUNKS+1C1↓j
                                        ; PATCHTHUNKS+1D0↓j ...
                mov     cx, es:[bx]
                or      cl, cl
                jz      short loc_1E03
                add     bx, 2
                cmp     ch, 0
                jz      short loc_1DB3
                cmp     ch, 0FFh
                jz      short loc_1DD1
                xor     ch, ch
                add     bx, cx
                shl     cx, 1
                add     bx, cx
                jmp     short loc_1DB3
; ---------------------------------------------------------------------------

loc_1DD1:                               ; CODE XREF: PATCHTHUNKS+1C6↑j
                xor     ch, ch

loc_1DD3:                               ; CODE XREF: PATCHTHUNKS+200↓j
                cmp     byte ptr es:[bx+6], 0EAh
                jnz     short loc_1DFC
                cmp     es:[bx+9], si
                jnz     short loc_1DFC
                or      di, di
                jnz     short loc_1DF8
                mov     ax, es:[bx+7]
                mov     word ptr es:[bx+6], 3FCDh
                mov     es:[bx+8], dl
                mov     es:[bx+9], ax
                jmp     short loc_1DFC
; ---------------------------------------------------------------------------

loc_1DF8:                               ; CODE XREF: PATCHTHUNKS+1E3↑j
                mov     es:[bx+9], di

loc_1DFC:                               ; CODE XREF: PATCHTHUNKS+1D9↑j
                                        ; PATCHTHUNKS+1DF↑j ...
                add     bx, 0Bh
                loop    loc_1DD3
                jmp     short loc_1DB3
; ---------------------------------------------------------------------------

loc_1E03:                               ; CODE XREF: PATCHTHUNKS:loc_1C7E↑j
                                        ; PATCHTHUNKS:loc_1D2D↑j ...
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    4
PATCHTHUNKS     endp



;
; External Entry #100 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public VALIDATECODESEGMENTS
VALIDATECODESEGMENTS proc far           ; CODE XREF: BOOTDONE+5A↓p
                mov     ax, ds          ; KERNEL_100
                nop
                inc     bp
                push    bp
                mov     bp, sp
                push    ds
                mov     ds, ax
                push    si
                push    di
                push    cs:HEXEHEAD

loc_2A61:                               ; CODE XREF: VALIDATECODESEGMENTS+22↓j
                                        ; VALIDATECODESEGMENTS+44↓j
                pop     cx
                jcxz    short loc_2A96
                mov     ds, cx
                push    word ptr ds:6
                mov     si, ds:22h
                mov     cx, ds:1Ch
                jcxz    short loc_2A61

loc_2A74:                               ; CODE XREF: VALIDATECODESEGMENTS+42↓j
                test    word ptr [si+4], 1
                jnz     short loc_2A8F
                test    word ptr [si+4], 0F000h
                jz      short loc_2A8F
                mov     di, cx
                push    word ptr [si+8]
                call    MYLOCK
                call    CHECKSEGCHKSUM
                mov     cx, di

loc_2A8F:                               ; CODE XREF: VALIDATECODESEGMENTS+29↑j
                                        ; VALIDATECODESEGMENTS+30↑j
                add     si, 0Ah
                loop    loc_2A74
                jmp     short loc_2A61
; ---------------------------------------------------------------------------

loc_2A96:                               ; CODE XREF: VALIDATECODESEGMENTS+12↑j
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf
VALIDATECODESEGMENTS endp

; ---------------------------------------------------------------------------
FUSEDBP         dw 0                    ; DATA XREF: PATCHSTACK+12↓w
                                        ; PATCHSTACK+3E↓w ...
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR PATCHSTACK

loc_32A9:                               ; CODE XREF: PATCHSTACK+18↓j
                jmp     loc_3349
; END OF FUNCTION CHUNK FOR PATCHSTACK