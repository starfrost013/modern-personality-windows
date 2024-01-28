



; =============== S U B R O U T I N E =======================================


HALLOC          proc near               ; CODE XREF: LOCALALLOC+59↑p
                                        ; LOCALALLOC+6F↑p ...
                mov     bx, [di+10h]
                or      bx, bx
                jz      short loc_5DEA

loc_5DDB:                               ; CODE XREF: HALLOC+26↓j
                xor     cx, cx
                mov     [bx+2], cx
                xchg    ax, [bx]
                mov     [di+10h], ax
                mov     ax, bx
                mov     cx, ax
                retn
; ---------------------------------------------------------------------------

loc_5DEA:                               ; CODE XREF: HALLOC+5↑j
                push    ax
                push    dx
                mov     cx, [di+12h]
                jcxz    short loc_5DFC
                call    word ptr [di+14h]
                jcxz    short loc_5DFC
                mov     bx, ax
                pop     dx
                pop     ax
                jmp     short loc_5DDB
; ---------------------------------------------------------------------------

loc_5DFC:                               ; CODE XREF: HALLOC+1B↑j
                                        ; HALLOC+20↑j
                xor     ax, ax
                pop     dx
                pop     dx
                retn
HALLOC          endp


; =============== S U B R O U T I N E =======================================


HTHREAD         proc near               ; CODE XREF: LCOMPACT+171↑p
                                        ; GHEXPAND+61↓p ...
                push    di
                push    ds
                pop     es
                assume es:nothing
                cld

loc_5E05:                               ; CODE XREF: HTHREAD+C↓j
                lea     ax, [di+4]
                stosw
                mov     ax, 0FFFFh
                stosw
                loop    loc_5E05
                mov     [di-4], cx
                pop     ax
                retn
HTHREAD         endp


; =============== S U B R O U T I N E =======================================


HFREE           proc near               ; CODE XREF: LOCALFREE:loc_5AC7↑p
                                        ; GFREE:loc_6197↓p ...
                or      si, si
                jz      short loc_5E28
                mov     ax, 0FFFFh
                xchg    ax, [si+2]
                inc     ax
                jz      short loc_5E2B
                mov     ax, si
                xchg    ax, [di+10h]
                mov     [si], ax

loc_5E28:                               ; CODE XREF: HFREE+2↑j
                xor     ax, ax
                retn
; ---------------------------------------------------------------------------

loc_5E2B:                               ; CODE XREF: HFREE+B↑j
                dec     ax
                retn
HFREE           endp


; =============== S U B R O U T I N E =======================================


HDREF           proc near               ; CODE XREF: LDREF:loc_57AE↑p
                                        ; GALIGN+28↓p
                xor     ax, ax
                mov     cx, [si+2]
                inc     cx
                jz      short loc_5E3D
                dec     cx
                and     cl, 40h
                jnz     short loc_5E3D
                mov     ax, [si]

loc_5E3D:                               ; CODE XREF: HDREF+6↑j
                                        ; HDREF+C↑j
                or      ax, ax
                retn
HDREF           endp


; =============== S U B R O U T I N E =======================================


HENUM           proc near               ; CODE XREF: LCOMPACT:loc_55D4↑p
                                        ; GFREEALL:loc_61C8↓p
                or      si, si
                jnz     short loc_5E6F
                mov     ax, [di+0Eh]

loc_5E47:                               ; CODE XREF: HENUM+35↓j
                mov     si, ax
                or      si, si
                jz      short loc_5E6C
                lodsw
                mov     cx, ax

loc_5E50:                               ; CODE XREF: HENUM+32↓j
                mov     ax, [si+2]
                inc     ax
                jz      short loc_5E6F
                dec     ax
                cmp     byte ptr [di+0Bh], 0
                jz      short loc_5E6C
                test    al, 40h
                jnz     short loc_5E6F
                and     al, 0Fh
                cmp     [di+0Bh], al
                jnz     short loc_5E6F
                or      ah, ah
                jnz     short loc_5E6F

loc_5E6C:                               ; CODE XREF: HENUM+B↑j
                                        ; HENUM+1B↑j
                or      si, si
                retn
; ---------------------------------------------------------------------------

loc_5E6F:                               ; CODE XREF: HENUM+2↑j
                                        ; HENUM+14↑j ...
                lea     si, [si+4]
                loop    loc_5E50
                lodsw
                jmp     short loc_5E47
HENUM           endp


; =============== S U B R O U T I N E =======================================


HEND            proc near               ; CODE XREF: GREALLOC+D9↓p
                                        ; GREALLOC+1BE↓p ...
                jb      short loc_5E84
                lea     dx, [bx+1]
                and     dl, 0FEh
                cmp     dx, bx
                jb      short loc_5E84
                retn
; ---------------------------------------------------------------------------

loc_5E84:                               ; CODE XREF: HEND↑j HEND+A↑j
                mov     dx, 0FFFEh
                retn
HEND            endp


; =============== S U B R O U T I N E =======================================


;
; External Entry #47 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GETMODULEHANDLE
GETMODULEHANDLE proc far                ; CODE XREF: RETTHUNK+78↑p
                                        ; INITFWDREF+52↓p ...

var_42          = byte ptr -42h
var_41          = byte ptr -41h
arg_0           = word ptr  6
arg_2           = word ptr  8

                inc     bp              ; KERNEL_47
                push    bp
                mov     bp, sp
                push    ds
                sub     sp, 40h
                cmp     [bp+arg_2], 0
                jz      short loc_1E35
                lea     bx, [bp+var_42]
                mov     dx, 53A6h
                push    [bp+arg_2]
                push    [bp+arg_0]
                push    bx
                push    dx
                call    COPYNAME
                lea     bx, [bp+var_41]
                push    ss
                push    bx
                push    ax
                call    FINDEXEINFO
                jmp     short loc_1E3B
; ---------------------------------------------------------------------------

loc_1E35:                               ; CODE XREF: GETMODULEHANDLE+C↑j
                push    [bp+arg_0]
                call    GETEXEPTR

loc_1E3B:                               ; CODE XREF: GETMODULEHANDLE+28↑j
                mov     cx, ax
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    4
GETMODULEHANDLE endp

;
; External Entry #53 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public CALLPROCINSTANCE
CALLPROCINSTANCE proc near
                mov     ax, ds          ; KERNEL_53
                mov     cx, es:[bx]
                jcxz    short loc_1E5F
                xchg    ax, cx
                test    al, 1
                jnz     short loc_1E5F
                xchg    ax, bx
CALLPROCINSTANCE endp


; =============== S U B R O U T I N E =======================================


CALLMOVEABLEINSTANCEPROC proc near
                mov     ds, cs:PGLOBALHEAP
                mov     bx, [bx]
                xchg    ax, bx
                mov     ds, cx

loc_1E5F:                               ; CODE XREF: CALLPROCINSTANCE+5↑j
                                        ; CALLPROCINSTANCE+A↑j
                jmp     dword ptr es:[bx+2]
CALLMOVEABLEINSTANCEPROC endp

;
; External Entry #94 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public DEFINEHANDLETABLE
DEFINEHANDLETABLE proc far

arg_0           = word ptr  6

                inc     bp              ; KERNEL_94
                push    bp
                mov     bp, sp
                push    ds
                push    di
                push    ds
                call    MYLOCK
                or      ax, ax
                jz      short loc_1EA0
                xor     ax, ax
                test    byte ptr es:5, 4
                jz      short loc_1EA0
                mov     di, [bp+arg_0]
                push    di
                cmp     es:0Ch, ax
                jnz     short loc_1E9B
                xchg    dx, cs:HHANDLE
                mov     es:0Ch, dx
                mov     cx, es:[di+10h]
                lea     di, [di+12h]
                cld
                rep stosw
                inc     ax

loc_1E9B:                               ; CODE XREF: DEFINEHANDLETABLE+21↑j
                pop     word ptr es:0Eh

loc_1EA0:                               ; CODE XREF: DEFINEHANDLETABLE+C↑j
                                        ; DEFINEHANDLETABLE+16↑j
                pop     di
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
DEFINEHANDLETABLE endp