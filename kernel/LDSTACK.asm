
; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

GETSTACKPTR     proc near               ; CODE XREF: STARTMODULE+90↑p

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                push    si
                mov     es, [bp+arg_0]
                test    word ptr es:0Ch, 8000h
                jnz     short loc_B57
                cmp     word ptr es:1Ah, 0
                jz      short loc_B57
                cmp     word ptr es:18h, 0
                jnz     short loc_B57
                mov     dx, es:12h
                mov     bx, es:8
                or      bx, bx
                jz      short loc_B4E
                add     dx, es:[bx+6]

loc_B4E:                                ; CODE XREF: GETSTACKPTR+2C↑j
                and     dx, 0FFFEh
                mov     es:18h, dx

loc_B57:                                ; CODE XREF: GETSTACKPTR+E↑j
                                        ; GETSTACKPTR+16↑j ...
                mov     dx, es:1Ah
                mov     ax, es:18h
                mov     cx, ax
                or      cx, dx
                jz      short loc_B74
                push    ax
                mov     cx, 0FFFFh
                push    es
                push    dx
                push    cx
                push    cx
                call    LOADSEGMENT
                pop     ax
                jmp     short loc_B77
; ---------------------------------------------------------------------------

loc_B74:                                ; CODE XREF: GETSTACKPTR+48↑j
                mov     ax, 1000h

loc_B77:                                ; CODE XREF: GETSTACKPTR+56↑j
                pop     si
                mov     sp, bp
                pop     bp
                retn    2
GETSTACKPTR     endp

======= S U B R O U T I N E =======================================

; Attributes: bp-based frame

PATCHSTACK      proc near               ; CODE XREF: GNOTIFY+1A↓p

arg_0           = word ptr  4
arg_2           = word ptr  6

; FUNCTION CHUNK AT 32A9 SIZE 00000003 BYTES

                push    bp
                mov     bp, sp
                push    si
                push    di
                mov     si, [bp+arg_2]
                mov     di, [bp+arg_0]
                push    cs:HEADTDB
                xor     cx, cx
                mov     cs:FUSEDBP, cx

loc_32C3:                               ; CODE XREF: PATCHSTACK+87↓j
                                        ; PATCHSTACK:loc_3389↓j
                pop     cx
                jcxz    short loc_32A9
                mov     es, cx
                push    word ptr es:0
                mov     ax, es:4
                cmp     ax, si
                jnz     short loc_32DA
                mov     es:4, di

loc_32DA:                               ; CODE XREF: PATCHSTACK+27↑j
                mov     bx, ss
                cmp     bx, ax
                mov     bx, es:2
                lea     bx, [bx+10h]
                jnz     short loc_32EF

loc_32E8:                               ; CODE XREF: PATCHSTACK+A9↓j
                mov     bx, bp
                mov     cs:FUSEDBP, bp

loc_32EF:                               ; CODE XREF: PATCHSTACK+3A↑j
                mov     es, ax
                mov     ax, bx

loc_32F3:                               ; CODE XREF: PATCHSTACK+9B↓j
                mov     bx, ax
                xor     ax, ax
                test    byte ptr es:[bx], 1
                jz      short loc_3330
                cmp     es:[bx+4], si
                jnz     short loc_3316
                push    es
                push    bx
                les     bx, es:[bx+2]
                cmp     word ptr es:[bx], 3FCDh
                pop     bx
                pop     es
                jz      short loc_3316
                mov     es:[bx+4], di

loc_3316:                               ; CODE XREF: PATCHSTACK+55↑j
                                        ; PATCHSTACK+64↑j
                cmp     es:[bx-2], si
                jnz     short loc_332F
                push    es
                push    bx
                les     bx, es:[bx+2]
                cmp     word ptr es:[bx], 3FCDh
                pop     bx
                pop     es
                jz      short loc_332F
                mov     es:[bx-2], di

loc_332F:                               ; CODE XREF: PATCHSTACK+6E↑j
                                        ; PATCHSTACK+7D↑j
                inc     ax

loc_3330:                               ; CODE XREF: PATCHSTACK+4F↑j
                xor     ax, es:[bx]
                jz      short loc_32C3
                cmp     ax, bx
                jbe     short loc_335A
                cmp     ax, es:0Ah
                jb      short loc_335A
                cmp     ax, es:0Eh
                ja      short loc_335A
                jmp     short loc_32F3
; ---------------------------------------------------------------------------

loc_3349:                               ; CODE XREF: PATCHSTACK:loc_32A9↑j
                xor     bx, bx
                cmp     cs:FUSEDBP, bx
                jnz     short loc_3357
                push    bx
                mov     ax, ss
                jmp     short loc_32E8
; ---------------------------------------------------------------------------

loc_3357:                               ; CODE XREF: PATCHSTACK+A4↑j
                jmp     short loc_338C
; ---------------------------------------------------------------------------
                align 2

loc_335A:                               ; CODE XREF: PATCHSTACK+8B↑j
                                        ; PATCHSTACK+92↑j ...
                mov     ax, 303h
                push    ax
                mov     ax, offset aPatchstackInva ; "PatchStack - invalid BP chain"
                push    cs
                push    ax
                push    es
                push    bx
                call    KERNELERROR
                jmp     short loc_3389
; ---------------------------------------------------------------------------
aPatchstackInva db 'PatchStack - invalid BP chain',0
                                        ; DATA XREF: PATCHSTACK+B2↑o
                db 24h
; ---------------------------------------------------------------------------

loc_3389:                               ; CODE XREF: PATCHSTACK+BC↑j
                jmp     loc_32C3
; ---------------------------------------------------------------------------

loc_338C:                               ; CODE XREF: PATCHSTACK:loc_3357↑j
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    4
PATCHSTACK      endp


; =============== S U B R O U T I N E =======================================


PATCHSTACKINTERNAL proc near            ; CODE XREF: SEARCHSTACK+AB↓p
                                        ; CATCH+1D↓p
                push    es
                push    bx
                mov     dx, es:[bx-2]
                or      dx, dx
                jz      short loc_33B3
                dec     dx
                mov     es, dx
                inc     dx
                cmp     byte ptr es:0, 4Dh ; 'M'
                jnz     short loc_33B3
                mov     cx, es:0Ah
                jcxz    short loc_33B3
                mov     dx, cx

loc_33B3:                               ; CODE XREF: PATCHSTACKINTERNAL+8↑j
                                        ; PATCHSTACKINTERNAL+14↑j ...
                dec     si
                mov     es, si
                inc     si
                mov     cx, es:0Ah
                jcxz    short loc_33DE
                mov     si, cx
                mov     es, word ptr es:1
                mov     bx, es:22h
                mov     cx, es:1Ch

loc_33CF:                               ; CODE XREF: PATCHSTACKINTERNAL+44↓j
                cmp     es:[bx+8], si
                jz      short loc_33E7
                add     bx, 0Ah
                loop    loc_33CF
                mov     si, es:[bx+4]

loc_33DE:                               ; CODE XREF: PATCHSTACKINTERNAL+28↑j
                pop     bx
                pop     es
                xchg    dx, si
                mov     cx, es:[bx+2]
                retn
; ---------------------------------------------------------------------------

loc_33E7:                               ; CODE XREF: PATCHSTACKINTERNAL+3F↑j
                sub     cx, es:1Ch
                neg     cx
                shl     cx, 1
                shl     cx, 1
                add     cx, es:3Ch
                mov     si, dx
                mov     dx, es
                pop     bx
                pop     es
                retn
PATCHSTACKINTERNAL endp

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR SEARCHSTACK

loc_33FE:                               ; CODE XREF: SEARCHSTACK+14↓j
                jmp     short loc_3468
; END OF FUNCTION CHUNK FOR SEARCHSTACK
; ---------------------------------------------------------------------------
                db 90h

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

SEARCHSTACK     proc near               ; CODE XREF: GNOTIFY+37↓p

arg_0           = word ptr  4

; FUNCTION CHUNK AT 33FE SIZE 00000002 BYTES

                push    bp
                mov     bp, sp
                push    si
                mov     si, [bp+arg_0]
                push    cs:HEADTDB
                xor     cx, cx
                mov     cs:FUSEDBP, cx

loc_3414:                               ; CODE XREF: SEARCHSTACK+4E↓j
                                        ; SEARCHSTACK:loc_3599↓j
                pop     cx
                jcxz    short loc_33FE
                mov     es, cx
                push    word ptr es:0
                cmp     es:4, si
                jz      short loc_3478
                mov     bx, ss
                mov     ax, es:4
                cmp     bx, ax
                mov     bx, es:2
                lea     bx, [bx+10h]
                jnz     short loc_343E

loc_3437:                               ; CODE XREF: SEARCHSTACK+73↓j
                mov     bx, bp
                mov     cs:FUSEDBP, bp

loc_343E:                               ; CODE XREF: SEARCHSTACK+34↑j
                mov     es, ax
                mov     ax, bx

loc_3442:                               ; CODE XREF: SEARCHSTACK+62↓j
                mov     bx, ax
                xor     ax, ax
                test    byte ptr es:[bx], 1
                jnz     short loc_3497

loc_344C:                               ; CODE XREF: SEARCHSTACK+94↓j
                xor     ax, es:[bx]
                jz      short loc_3414
                cmp     ax, bx
                jbe     short loc_3465
                cmp     ax, es:0Ah
                jb      short loc_3465
                cmp     ax, es:0Eh
                ja      short loc_3465
                jmp     short loc_3442
; ---------------------------------------------------------------------------

loc_3465:                               ; CODE XREF: SEARCHSTACK+52↑j
                                        ; SEARCHSTACK+59↑j ...
                jmp     loc_3569
; ---------------------------------------------------------------------------

loc_3468:                               ; CODE XREF: SEARCHSTACK:loc_33FE↑j
                xor     bx, bx
                cmp     cs:FUSEDBP, bx
                jnz     short loc_3476
                mov     ax, ss
                push    bx
                jmp     short loc_3437
; ---------------------------------------------------------------------------

loc_3476:                               ; CODE XREF: SEARCHSTACK+6E↑j
                mov     es, bx
                assume es:cseg01

loc_3478:                               ; CODE XREF: SEARCHSTACK+22↑j
                                        ; SEARCHSTACK+91↓j ...
                mov     ax, bx
                mov     dx, es
                jmp     loc_359C
; ---------------------------------------------------------------------------

loc_347F:                               ; CODE XREF: SEARCHSTACK+9A↓j
                                        ; SEARCHSTACK+A9↓j
                cmp     es:[bx-2], si
                jnz     short loc_3494
                push    es
                push    bx
                les     bx, es:[bx+2]
                assume es:nothing
                cmp     word ptr es:[bx], 3FCDh
                pop     bx
                pop     es
                jnz     short loc_3478

loc_3494:                               ; CODE XREF: SEARCHSTACK+82↑j
                                        ; SEARCHSTACK+F4↓j
                inc     ax
                jmp     short loc_344C
; ---------------------------------------------------------------------------

loc_3497:                               ; CODE XREF: SEARCHSTACK+49↑j
                cmp     es:[bx+4], si
                jnz     short loc_347F
                push    es
                push    bx
                les     bx, es:[bx+2]
                cmp     word ptr es:[bx], 3FCDh
                pop     bx
                pop     es
                jz      short loc_347F
                call    PATCHSTACKINTERNAL
                cmp     es:[bx+4], dx
                jz      short loc_3478
                test    si, 0E001h
                jnz     short loc_3478
                shr     si, 1
                push    es
                push    bx
                push    ax
                cmp     cs:INT3FBP, bx
                jz      short loc_34F7

loc_34C7:                               ; CODE XREF: SEARCHSTACK+101↓j
                                        ; SEARCHSTACK+165↓j
                mov     ax, cx
                xchg    cx, es:[bx+2]
                mov     es:[bx-2], cx
                and     ax, 0FFF0h
                mov     cl, 4
                shr     ax, cl
                sub     ax, si
                add     dx, ax
                mov     ax, 0Fh
                and     ax, es:[bx+2]
                shl     si, cl
                or      ax, si
                mov     es:[bx+2], ax
                mov     es:[bx+4], dx
                pop     ax
                pop     bx
                pop     es
                mov     si, [bp+arg_0]
                jmp     short loc_3494
; ---------------------------------------------------------------------------

loc_34F7:                               ; CODE XREF: SEARCHSTACK+C4↑j
                mov     bx, es
                mov     ax, ss
                cmp     ax, bx
                mov     bx, cs:INT3FBP
                jnz     short loc_34C7
                cmp     cs:INT3FSAVEDSS, 0
                jz      short loc_3535
                mov     es, cs:INT3FSAVEDSS
                mov     bx, cs:INT3FSAVEDBP
                mov     ax, cs:INT3FSAVEDCS
                mov     es:[bx+4], ax
                mov     ax, cs:INT3FSAVEDIP
                mov     es:[bx+2], ax
                mov     ax, cs:INT3FSAVEDDS
                mov     es:[bx-2], ax
                push    ss
                pop     es
                mov     bx, cs:INT3FBP

loc_3535:                               ; CODE XREF: SEARCHSTACK+109↑j
                mov     cs:INT3FSAVEDSS, es
                mov     cs:INT3FSAVEDBP, bx
                mov     ax, es:[bx+4]
                mov     cs:INT3FSAVEDCS, ax
                mov     ax, es:[bx+2]
                mov     cs:INT3FSAVEDIP, ax
                mov     ax, es:[bx-2]
                mov     cs:INT3FSAVEDDS, ax
                mov     word ptr es:[bx+4], cs
                mov     word ptr es:[bx+2], 1798h
                push    cs
                pop     es
                assume es:cseg01
                mov     bx, 178Ch
                jmp     loc_34C7
; ---------------------------------------------------------------------------

loc_3569:                               ; CODE XREF: SEARCHSTACK:loc_3465↑j
                mov     ax, 303h
                push    ax
                mov     ax, offset SZSEARCHSTACKINVALIDBPCHAIN ; "SearchStack - invalid BP chain"
                push    cs
                push    ax
                push    es
                push    bx
                call    KERNELERROR
                jmp     short loc_3599
; ---------------------------------------------------------------------------
SZSEARCHSTACKINVALIDBPCHAIN db 'SearchStack - invalid BP chain',0
                                        ; DATA XREF: SEARCHSTACK+16C↑o
                db 24h
; ---------------------------------------------------------------------------

loc_3599:                               ; CODE XREF: SEARCHSTACK+176↑j
                jmp     loc_3414
; ---------------------------------------------------------------------------

loc_359C:                               ; CODE XREF: SEARCHSTACK+7B↑j
                pop     si
                mov     sp, bp
                pop     bp
                retn    2
SEARCHSTACK     endp ; sp-analysis failed

;
; External Entry #55 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public CATCH
CATCH           proc far

arg_0           = dword ptr  6

                inc     bp              ; KERNEL_55
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                push    ss
                nop
                push    cs
                call    near ptr GLOBALHANDLE
                mov     es, dx
                assume es:nothing
                mov     bx, bp
                push    word ptr es:[bx]
                push    si
                mov     si, es:[bx+4]
                push    word ptr es:[bx+2]
                call    PATCHSTACKINTERNAL
                les     bx, [bp+arg_0]
                mov     es:[bx+10h], ax
                pop     word ptr es:[bx+0Eh]
                mov     es:[bx+0Ch], si
                mov     es:[bx+0Ah], di
                pop     word ptr es:[bx+8]
                pop     word ptr es:[bx+6]
                mov     es:[bx+4], sp
                mov     es:[bx], cx
                mov     es:[bx+2], dx
                xor     ax, ax

loc_35EB:                               ; CODE XREF: THROW+61↓j
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    4
CATCH           endp

;
; External Entry #56 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public THROW
THROW           proc far
                mov     bx, sp          ; KERNEL_56
                mov     di, ss:[bx+4]
                lds     si, ss:[bx+6]
                push    word ptr [si+10h]
                nop
                push    cs
                call    near ptr GLOBALHANDLE
                cli
                mov     ss, dx
                mov     sp, [si+4]
                sti
                mov     bp, sp
                add     bp, 6
                push    word ptr [si+6]
                pop     word ptr [bp+0]
                push    word ptr [si+8]
                pop     word ptr [bp-4]
                push    word ptr [si+0Ah]
                pop     word ptr [bp-6]
                push    word ptr [si+0Ch]
                nop
                push    cs
                call    near ptr GLOBALHANDLE
                mov     [bp-2], dx
                les     bx, [si]
                cmp     word ptr es:[bx], 3FCDh
                jnz     short loc_3651
                xor     cx, cx
                mov     cl, es:[bx+3]
                mov     bx, 0FFFFh
                push    es
                push    cx
                push    bx
                push    bx
                call    LOADSEGMENT
                mov     es, ax
                mov     bx, [si+0Eh]

loc_3651:                               ; CODE XREF: THROW+42↑j
                mov     word ptr [bp+4], es
                mov     [bp+2], bx
                mov     ax, di
                jmp     short loc_35EB
THROW           endp
