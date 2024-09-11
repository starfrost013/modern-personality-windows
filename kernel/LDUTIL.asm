; ****** modern:personality project ******
; Reverse engineered code  © 2022-2024 starfrost. See licensing information in the licensing file
; Original code            © 1982-1986 Microsoft Corporation

; LDUTIL.ASM: Provides various loading-related utils e.g. reference counting loaded binaries so we know when to free them and getting pointers to NE headers.

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

INCEXEUSAGE     proc near               ; CODE XREF: LOADMODULE+249↑p
                                        ; LOADMODULE+3AC↑p ...

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                push    di
                mov     cx, [bp+arg_0]
                jcxz    short loc_9F8
                mov     es, cx
                test    word ptr es:2, 8000h
                jnz     short loc_9F8
                cmp     word ptr es:0, 454Eh
                jnz     short loc_9F8
                inc     word ptr es:2
                mov     di, es:28h
                mov     cx, es:1Eh
                jcxz    short loc_9F8
                or      word ptr es:2, 8000h

loc_9E1:                                ; CODE XREF: INCEXEUSAGE+43↓j
                push    cx
                push    word ptr es:[di]
                call    INCEXEUSAGE
                pop     cx
                mov     es, [bp+arg_0]
                add     di, 2
                loop    loc_9E1
                xor     word ptr es:2, 8000h

loc_9F8:                                ; CODE XREF: INCEXEUSAGE+7↑j
                                        ; INCEXEUSAGE+12↑j ...
                pop     di
                mov     sp, bp
                pop     bp
                retn    2
INCEXEUSAGE     endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

DECEXEUSAGE     proc near               ; CODE XREF: LOADMODULE+3E8↑p
                                        ; DECEXEUSAGE+3C↓p ...

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                push    di
                mov     cx, [bp+arg_0]
                xor     ax, ax
                jcxz    short loc_A59
                mov     es, cx
                test    word ptr es:2, 8000h
                jnz     short loc_A59
                cmp     word ptr es:0, 454Eh
                jnz     short loc_A59
                dec     word ptr es:2
                mov     di, es:28h
                mov     cx, es:1Eh
                jcxz    short loc_A59
                or      word ptr es:2, 8000h

loc_A36:                                ; CODE XREF: DECEXEUSAGE+51↓j
                push    cx
                push    es
                push    word ptr es:[di]
                call    DECEXEUSAGE
                pop     es
                jnz     short loc_A4C
                push    es
                push    word ptr es:[di]
                call    DELMODULE
                pop     es
                mov     es:[di], ax

loc_A4C:                                ; CODE XREF: DECEXEUSAGE+40↑j
                pop     cx
                add     di, 2
                loop    loc_A36
                xor     word ptr es:2, 8000h

loc_A59:                                ; CODE XREF: DECEXEUSAGE+9↑j
                                        ; DECEXEUSAGE+14↑j ...
                pop     di
                mov     sp, bp
                pop     bp
                retn    2
DECEXEUSAGE     endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

; EntProcAddress
;
; Purpose: Returns the address of a function (procedure technically) referenced by an exported ordinal ID within a module.
; Internal function for GetProcAddress, which performs basic parameter validation and determines the module to load from (as hModule can be NULL to indicate laod fromt he calling module)
;
; Parameters (see calling convention!): 
;   si (hModule) -> module handle pointer to the module to find the function within.
;   bx (wOrdinal) -> the ordinal to find (converted from a function name by a call to the FINDORDINAL function by GETPROCADDRESS)
; 
; Returns: 
;     A segment:offset pointer to the function requested if successful, in the ax:dx register pair.
;     If, at this point, an invalid ordinal was provided to the function, a fatalexit code 403 - "Invalid ordinal reference to <module name>" - is triggered and Windows quits.
ENTPROCADDRESS  proc near               ; CODE XREF: SEGRELOC+BB↓p
                                        ; GETPROCADDRESS+3F↓p

arg_0           = word ptr  4
arg_2           = word ptr  6

                push    bp
                mov     bp, sp
                push    si
                push    di
                mov     es, [bp+arg_2]
                mov     cx, [bp+arg_0]
                jcxz    short loc_85D
                dec     cx
                mov     si, es:4

loc_82B:                                ; CODE XREF: ENTPROCADDRESS+27↓j
                                        ; ENTPROCADDRESS+33↓j ...
                xor     ax, ax
                lods    byte ptr es:[si]
                or      ax, ax
                jz      short loc_85D
                cmp     ax, cx
                jg      short loc_894
                sub     cx, ax
                mov     bx, ax
                lods    byte ptr es:[si]
                cmp     al, 0
                jz      short loc_82B
                cmp     al, 0FFh
                jz      short loc_84D
                add     si, bx
                shl     bx, 1
                add     si, bx
                jmp     short loc_82B
; ---------------------------------------------------------------------------

loc_84D:                                ; CODE XREF: ENTPROCADDRESS+2B↑j
                mov     ax, bx
                shl     bx, 1
                shl     bx, 1
                add     bx, ax
                shl     bx, 1
                add     bx, ax
                add     si, bx
                jmp     short loc_82B
; ---------------------------------------------------------------------------

loc_85D:                                ; CODE XREF: ENTPROCADDRESS+B↑j
                                        ; ENTPROCADDRESS+19↑j ...
                xor     bx, bx
                mov     ax, 403h ; errCode for kernelerror
                push    ax
                mov     ax, offset SZINVALIDORDINAL ; "Invalid ordinal reference to "
                push    cs
                push    ax
                push    es  ; pointer to module that called this function (so kernelerror can put it in the error message)
                push    bx
                call    KERNELERROR
                jmp     short loc_88E
; ---------------------------------------------------------------------------
SZINVALIDORDINAL db 'Invalid ordinal reference to ',0
                                        ; DATA XREF: ENTPROCADDRESS+4B↑o
                db 24h
; ---------------------------------------------------------------------------

loc_88E:                                ; CODE XREF: ENTPROCADDRESS+55↑j
                xor     dx, dx
                xor     ax, ax
                jmp     short loc_8D0
; ---------------------------------------------------------------------------

loc_894:                                ; CODE XREF: ENTPROCADDRESS+1D↑j
                lods    byte ptr es:[si]
                cmp     al, 0
                jz      short loc_85D
                mov     bx, cx
                cmp     al, 0FFh
                jz      short loc_8BF
                add     si, bx
                shl     bx, 1
                mov     si, es:[bx+si+1]
                mov     cx, 0FFFFh
                push    es
                push    ax
                push    cx
                push    cx
                call    LOADSEGMENT ; load segment containing function
                xor     dx, dx
                or      ax, ax
                jz      short loc_85D
                mov     dx, ax
                mov     ax, si
                jmp     short loc_8D0
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_8BF:                                ; CODE XREF: ENTPROCADDRESS+86↑j
                mov     ax, bx
                shl     bx, 1
                shl     bx, 1
                add     bx, ax
                shl     bx, 1
                add     bx, ax
                mov     dx, es
                lea     ax, [bx+si+1]

loc_8D0:                                ; CODE XREF: ENTPROCADDRESS+7A↑j
                                        ; ENTPROCADDRESS+A4↑j
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    4
ENTPROCADDRESS  endp

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

STARTPROCADDRESS proc near              ; CODE XREF: STARTMODULE+4F↑p

arg_0           = word ptr  4
arg_2           = word ptr  6

                push    bp
                mov     bp, sp
                push    di
                mov     es, [bp+arg_2]
                mov     di, 14h
                xor     dx, dx
                mov     ax, es:[di+2]
                or      ax, ax
                jz      short loc_A86
                mov     di, es:[di]
                push    es
                push    ax
                push    [bp+arg_0]
                push    [bp+arg_0]
                call    LOADSEGMENT
                jcxz    short loc_A86
                mov     ax, di

loc_A86:                                ; CODE XREF: STARTPROCADDRESS+12↑j
                                        ; STARTPROCADDRESS+22↑j
                pop     di
                mov     sp, bp
                pop     bp
                retn    4
STARTPROCADDRESS endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

GETINSTANCE     proc near               ; CODE XREF: LOADMODULE+3A2↑p
                                        ; LOADMODULE+419↑p ...

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                mov     es, [bp+arg_0]
                mov     ax, es:0Ch
                test    ax, 3
                mov     ax, es
                jz      short loc_AAB
                mov     bx, es:8
                or      bx, bx
                jz      short loc_AAB
                mov     ax, es:[bx+8]

loc_AAB:                                ; CODE XREF: GETINSTANCE+F↑j
                                        ; GETINSTANCE+18↑j
                mov     cx, ax
                mov     sp, bp
                pop     bp
                retn    2
GETINSTANCE     endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

GETEXEPTR       proc near               ; CODE XREF: LOADMODULE+D7↑p
                                        ; LOADMODULE+255↑p ...

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                push    [bp+arg_0]
                call    MYLOCK
                or      ax, ax
                jz      short loc_B14
                mov     es, ax
                cmp     word ptr es:0, 454Eh
                jz      short loc_B10
                dec     ax
                mov     es, ax
                mov     ax, es:1
                or      ax, ax
                jz      short loc_B10
                mov     es, ax
                cmp     word ptr es:0, 454Eh
                jz      short loc_B10
                xor     ax, ax

loc_AE3:                                ; CODE XREF: GETEXEPTR+5F↓j
                mov     ax, 406h
                push    ax
                mov     ax, offset SZINVALIDMODULEHANDLE ; "Invalid module handle"
                push    cs
                push    ax
                push    ax
                push    [bp+arg_0]
                call    KERNELERROR
                jmp     short loc_B0C
; ---------------------------------------------------------------------------
SZINVALIDMODULEHANDLE db 'Invalid module handle',0
                                        ; DATA XREF: GETEXEPTR+34↑o
                db 24h
; ---------------------------------------------------------------------------

loc_B0C:                                ; CODE XREF: GETEXEPTR+40↑j
                xor     ax, ax
                jmp     short loc_B14
; ---------------------------------------------------------------------------

loc_B10:                                ; CODE XREF: GETEXEPTR+16↑j
                                        ; GETEXEPTR+21↑j ...
                or      ax, ax
                jz      short loc_AE3

loc_B14:                                ; CODE XREF: GETEXEPTR+B↑j
                                        ; GETEXEPTR+5B↑j
                mov     cx, ax
                mov     sp, bp
                pop     bp
                retn    2
GETEXEPTR       endp




; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

MYALLOC         proc near               ; CODE XREF: LOADNRTABLE+62↓p
                                        ; ALLOCSEG+48↓p ...

arg_0           = word ptr  4
arg_2           = word ptr  6
arg_4           = word ptr  8

                push    bp
                mov     bp, sp
                mov     cx, [bp+arg_4]
                mov     al, 7
                and     al, cl
                mov     bx, 0F000h
                and     bx, cx
                jz      short loc_B9E
                shr     bx, 1
                shr     bx, 1
                shr     bx, 1
                shr     bx, 1
                cmp     al, 0
                jnz     short loc_B9E
                or      bl, 8

loc_B9E:                                ; CODE XREF: MYALLOC+F↑j
                                        ; MYALLOC+1B↑j
                cmp     al, 1
                jnz     short loc_BA5
                or      bl, 4

loc_BA5:                                ; CODE XREF: MYALLOC+22↑j
                test    cl, 10h
                jz      short loc_BAD
                or      bl, 2

loc_BAD:                                ; CODE XREF: MYALLOC+2A↑j
                xor     dx, dx
                mov     ax, [bp+arg_2]
                mov     cx, [bp+arg_0]
                jcxz    short loc_BBD

loc_BB7:                                ; CODE XREF: MYALLOC+3D↓j
                shl     ax, 1
                rcl     dx, 1
                loop    loc_BB7

loc_BBD:                                ; CODE XREF: MYALLOC+37↑j
                push    bx
                push    dx
                push    ax
                nop
                push    cs
                call    near ptr GLOBALALLOC
                push    ax
                test    al, 1
                jnz     short loc_BCE
                push    ax
                call    MYLOCK

loc_BCE:                                ; CODE XREF: MYALLOC+4A↑j
                pop     dx
                mov     sp, bp
                pop     bp
                retn    6
MYALLOC         endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

MYLOCK          proc near               ; CODE XREF: GETEXEPTR+6↑p
                                        ; MYALLOC+4D↑p ...

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                push    [bp+arg_0]
                nop
                push    cs
                call    near ptr GLOBALHANDLE
                xchg    ax, dx
                mov     sp, bp
                pop     bp
                retn    2
MYLOCK          endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

MYFREE          proc near               ; CODE XREF: LOADMODULE:loc_500↑p
                                        ; ALLOCALLSEGS+A6↓p ...

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                mov     cx, [bp+arg_0]
                jcxz    short loc_C20
                push    cx
                call    MYLOCK
                push    cx
                or      ax, ax
                jz      short loc_C0F
                dec     ax
                mov     es, ax
                inc     ax
                push    ax
                test    byte ptr es:5, 4
                jz      short loc_C0C
                xor     dx, dx
                push    ax
                push    dx
                call    PATCHTHUNKS

loc_C0C:                                ; CODE XREF: MYFREE+1C↑j
                call    DEBUGFREESEGMENT

loc_C0F:                                ; CODE XREF: MYFREE+F↑j
                pop     cx
                or      ch, ch
                jz      short loc_C20

loc_C14:                                ; CODE XREF: MYFREE+37↓j
                push    [bp+arg_0]
                nop
                push    cs
                call    near ptr GLOBALUNLOCK
                or      ax, ax
                jnz     short loc_C14

loc_C20:                                ; CODE XREF: MYFREE+6↑j
                                        ; MYFREE+2B↑j
                push    [bp+arg_0]
                nop
                push    cs
                call    near ptr GLOBALFREE
                mov     sp, bp
                pop     bp
                retn    2
MYFREE          endp
