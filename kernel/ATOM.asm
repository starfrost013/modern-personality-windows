;
; External Entry #68 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public INITATOMTABLE
INITATOMTABLE   proc far                ; CODE XREF: LOOKUPATOM+2F↓p

arg_0           = word ptr  6

                inc     bp              ; KERNEL_68
                push    bp
                mov     bp, sp
                push    ds
                mov     ax, ds:8
                or      ax, ax
                jnz     short loc_4A76
                mov     bx, [bp+arg_0]
                or      bx, bx
                jnz     short loc_4A5E
                mov     bl, 25h ; '%'

loc_4A5E:                               ; CODE XREF: INITATOMTABLE+11↑j
                push    bx
                inc     bx
                shl     bx, 1
                mov     ax, 40h ; '@'
                push    ax
                push    bx
                nop
                push    cs
                call    near ptr LOCALALLOC
                pop     dx
                jcxz    short loc_4A76
                mov     ds:8, ax
                mov     bx, ax
                mov     [bx], dx

loc_4A76:                               ; CODE XREF: INITATOMTABLE+A↑j
                                        ; INITATOMTABLE+24↑j
                mov     cx, ax
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
INITATOMTABLE   endp


; =============== S U B R O U T I N E =======================================


DELATOM         proc near               ; CODE XREF: DELETEATOM+19↓p
                mov     cl, 2
DELATOM         endp

; ---------------------------------------------------------------------------
                db 0BBh
;
; External Entry #70 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public ADDATOM
ADDATOM         proc near
                mov     cl, 1
ADDATOM         endp

; ---------------------------------------------------------------------------
                db 0BBh
;
; External Entry #69 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public FINDATOM
FINDATOM        proc far
                mov     cl, 0           ; KERNEL_69
FINDATOM        endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

LOOKUPATOM      proc far

var_5           = byte ptr -5
var_4           = word ptr -4
arg_0           = dword ptr  6

                inc     bp
                push    bp
                mov     bp, sp
                push    ds
                sub     sp, 4
                push    si
                push    di
                mov     [bp+var_5], cl
                mov     cx, word ptr [bp+arg_0+2]
                jcxz    short loc_4B0F
                push    cx
                nop
                push    cs
                call    near ptr GLOBALHANDLE
                mov     [bp+var_4], ax
                les     si, [bp+arg_0]
                assume es:nothing
                cmp     byte ptr es:[si], 23h ; '#'
                jz      short loc_4AF2
                xor     ax, ax
                cmp     ds:8, ax
                jnz     short loc_4AD0
                push    ax
                nop
                push    cs
                call    near ptr INITATOMTABLE
                jcxz    short loc_4B1F
                mov     cx, [bp+var_4]
                jcxz    short loc_4ACD
                push    cx
                nop
                push    cs
                call    near ptr GLOBALHANDLE
                mov     word ptr [bp+arg_0+2], dx

loc_4ACD:                               ; CODE XREF: LOOKUPATOM+37↑j
                                        ; LOOKUPATOM+74↓j
                les     si, [bp+arg_0]

loc_4AD0:                               ; CODE XREF: LOOKUPATOM+2A↑j
                xor     ax, ax
                xor     cx, cx
                xor     dx, dx
                cld

loc_4AD7:                               ; CODE XREF: LOOKUPATOM+65↓j
                lods    byte ptr es:[si]
                or      al, al
                jz      short loc_4B24
                inc     cl
                jz      short loc_4B1F
                call    MYUPPER
                mov     bx, dx
                rol     bx, 1
                add     bx, dx
                add     bx, ax
                ror     dx, 1
                add     dx, bx
                jmp     short loc_4AD7
; ---------------------------------------------------------------------------

loc_4AF2:                               ; CODE XREF: LOOKUPATOM+22↑j
                inc     si
                xor     cx, cx

loc_4AF5:                               ; CODE XREF: LOOKUPATOM+82↓j
                lods    byte ptr es:[si]
                or      al, al
                jz      short loc_4B12
                sub     al, 30h ; '0'
                cmp     al, 9
                ja      short loc_4ACD
                xor     ah, ah
                mov     bx, ax
                mov     al, 0Ah
                mul     cx
                add     ax, bx
                mov     cx, ax
                jmp     short loc_4AF5
; ---------------------------------------------------------------------------

loc_4B0F:                               ; CODE XREF: LOOKUPATOM+10↑j
                mov     cx, word ptr [bp+arg_0]

loc_4B12:                               ; CODE XREF: LOOKUPATOM+6E↑j
                jcxz    short loc_4B1F
                cmp     cx, 0C000h
                jnb     short loc_4B1F
                mov     ax, cx
                jmp     loc_4BE2
; ---------------------------------------------------------------------------

loc_4B1F:                               ; CODE XREF: LOOKUPATOM+32↑j
                                        ; LOOKUPATOM+54↑j ...
                xor     ax, ax
                jmp     loc_4BE2
; ---------------------------------------------------------------------------

loc_4B24:                               ; CODE XREF: LOOKUPATOM+50↑j
                jcxz    short loc_4B1F
                xchg    ax, dx
                mov     bx, ds:8
                div     word ptr [bx]
                lea     bx, [bx+2]
                shl     dx, 1
                add     bx, dx
                mov     dx, cx
                mov     ax, ss
                mov     es, ax

loc_4B3A:                               ; CODE XREF: LOOKUPATOM+DC↓j
                mov     si, [bx]
                or      si, si
                jz      short loc_4B69
                cmp     [si+4], dl
                jnz     short loc_4B65
                les     di, [bp+arg_0]
                lea     si, [si+5]
                mov     cx, dx

loc_4B4D:                               ; CODE XREF: LOOKUPATOM+D4↓j
                jcxz    short loc_4B61
                dec     cx
                lodsb
                call    MYUPPER
                mov     ah, al
                mov     al, es:[di]
                call    MYUPPER
                inc     di
                cmp     ah, al
                jz      short loc_4B4D

loc_4B61:                               ; CODE XREF: LOOKUPATOM:loc_4B4D↑j
                mov     si, [bx]
                jz      short loc_4B69

loc_4B65:                               ; CODE XREF: LOOKUPATOM+B8↑j
                lea     bx, [si]
                jmp     short loc_4B3A
; ---------------------------------------------------------------------------

loc_4B69:                               ; CODE XREF: LOOKUPATOM+B3↑j
                                        ; LOOKUPATOM+D8↑j
                xor     cx, cx
                mov     cl, [bp+var_5]
                jcxz    short loc_4BD7
                loop    loc_4B7B
                or      si, si
                jz      short loc_4B94
                inc     word ptr [si+2]
                jmp     short loc_4BD7
; ---------------------------------------------------------------------------

loc_4B7B:                               ; CODE XREF: LOOKUPATOM+E5↑j
                or      si, si
                jz      short loc_4BE2
                dec     word ptr [si+2]
                jg      short loc_4B90
                xor     di, di
                xchg    di, [si]
                mov     [bx], di
                push    si
                nop
                push    cs
                call    near ptr LOCALFREE

loc_4B90:                               ; CODE XREF: LOOKUPATOM+F7↑j
                xor     si, si
                jmp     short loc_4BD7
; ---------------------------------------------------------------------------

loc_4B94:                               ; CODE XREF: LOOKUPATOM+E9↑j
                mov     di, bx
                push    dx
                add     dx, 6
                mov     bx, 40h ; '@'
                push    bx
                push    dx
                nop
                push    cs
                call    near ptr LOCALALLOC
                pop     cx
                mov     si, ax
                or      si, si
                jz      short loc_4BD7
                mov     [di], si
                inc     word ptr [si+2]
                mov     [si+4], cl
                mov     cx, [bp+var_4]
                jcxz    short loc_4BC1
                push    cx
                nop
                push    cs
                call    near ptr GLOBALHANDLE
                mov     word ptr [bp+arg_0+2], dx

loc_4BC1:                               ; CODE XREF: LOOKUPATOM+12B↑j
                mov     bx, si
                push    ds
                pop     es
                lea     di, [si+5]
                xor     cx, cx
                mov     cl, [si+4]
                inc     cx
                lds     si, [bp+arg_0]
                rep movsb
                push    es
                pop     ds
                mov     si, bx

loc_4BD7:                               ; CODE XREF: LOOKUPATOM+E3↑j
                                        ; LOOKUPATOM+EE↑j ...
                mov     ax, si
                shr     ax, 1
                shr     ax, 1
                jz      short loc_4BE2
                or      ax, 0C000h

loc_4BE2:                               ; CODE XREF: LOOKUPATOM+91↑j
                                        ; LOOKUPATOM+96↑j ...
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    4
LOOKUPATOM      endp

;
; External Entry #71 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public DELETEATOM
DELETEATOM      proc far

arg_0           = word ptr  6

                inc     bp              ; KERNEL_71
                push    bp
                mov     bp, sp
                push    ds
                mov     bx, [bp+arg_0]
                cmp     bx, 0C000h
                jb      short loc_4C0D
                shl     bx, 1
                shl     bx, 1
                lea     bx, [bx+5]
                push    ds
                push    bx
                nop
                push    cs
                call    DELATOM
                jmp     short loc_4C0F
; ---------------------------------------------------------------------------

loc_4C0D:                               ; CODE XREF: DELETEATOM+C↑j
                xor     ax, ax

loc_4C0F:                               ; CODE XREF: DELETEATOM+1C↑j
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
DELETEATOM      endp

;
; External Entry #73 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GETATOMHANDLE
GETATOMHANDLE   proc far

arg_0           = word ptr  6

                inc     bp              ; KERNEL_73
                push    bp
                mov     bp, sp
                push    ds
                mov     ax, [bp+arg_0]
                cmp     ax, 0C000h
                jb      short loc_4C2D
                shl     ax, 1
                shl     ax, 1
                jmp     short loc_4C2F
; ---------------------------------------------------------------------------

loc_4C2D:                               ; CODE XREF: GETATOMHANDLE+B↑j
                xor     ax, ax

loc_4C2F:                               ; CODE XREF: GETATOMHANDLE+11↑j
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
GETATOMHANDLE   endp

;
; External Entry #72 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GETATOMNAME
GETATOMNAME     proc far

arg_0           = word ptr  6
arg_2           = dword ptr  8
arg_6           = word ptr  0Ch

                inc     bp              ; KERNEL_72
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                les     di, [bp+arg_2]
                xor     cx, cx
                mov     es:[di], cl
                mov     bx, [bp+arg_6]
                cmp     bx, 0C000h
                jb      short loc_4C7A
                shl     bx, 1
                shl     bx, 1
                cmp     [bx+2], cx
                jz      short loc_4C76
                mov     cl, [bx+4]
                jcxz    short loc_4C76
                cmp     [bp+arg_0], cx
                jg      short loc_4C69
                mov     cx, [bp+arg_0]
                dec     cx

loc_4C69:                               ; CODE XREF: GETATOMNAME+29↑j
                lea     si, [bx+5]
                mov     ax, cx
                rep movsb
                mov     byte ptr es:[di], 0
                jmp     short loc_4CAA
; ---------------------------------------------------------------------------

loc_4C76:                               ; CODE XREF: GETATOMNAME+1F↑j
                                        ; GETATOMNAME+24↑j ...
                xor     ax, ax
                jmp     short loc_4CAA
; ---------------------------------------------------------------------------

loc_4C7A:                               ; CODE XREF: GETATOMNAME+16↑j
                or      bx, bx
                jz      short loc_4C76
                mov     al, 23h ; '#'
                stosb
                mov     ax, bx
                mov     bx, 0Ah
                mov     cx, [bp+arg_0]

loc_4C89:                               ; CODE XREF: GETATOMNAME+5B↓j
                xor     dx, dx
                div     bx
                push    dx
                dec     cx
                or      ax, ax
                jz      short loc_4C97
                jcxz    short loc_4C97
                jmp     short loc_4C89
; ---------------------------------------------------------------------------

loc_4C97:                               ; CODE XREF: GETATOMNAME+57↑j
                                        ; GETATOMNAME+59↑j
                sub     [bp+arg_0], cx
                mov     cx, [bp+arg_0]

loc_4C9D:                               ; CODE XREF: GETATOMNAME+67↓j
                pop     ax
                add     al, 30h ; '0'
                stosb
                loop    loc_4C9D
                xor     al, al
                stosb
                mov     ax, [bp+arg_0]
                inc     ax

loc_4CAA:                               ; CODE XREF: GETATOMNAME+3A↑j
                                        ; GETATOMNAME+3E↑j
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    8
GETATOMNAME     endp ; sp-analysis failed

; ---------------------------------------------------------------------------
                db '[]',0Dh,0Ah,'='
;