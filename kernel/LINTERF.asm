
;
; External Entry #5 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public LOCALALLOC
LOCALALLOC      proc far                ; CODE XREF: INITATOMTABLE+20↑p
                                        ; LOOKUPATOM+116↑p

arg_0           = word ptr  6
arg_2           = word ptr  8

                inc     bp              ; KERNEL_5
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                call    CHECKLOCALHEAP
                or      ax, ax
                jz      short loc_5849
                or      ax, 100h
                push    ax
                mov     ax, offset SZERRLOCALALLOC ; "LocalAlloc: Invalid local heap"
                push    cs
                push    ax
                xor     ax, ax
                push    ax
                push    ax
                call    KERNELERROR
                jmp     short loc_5849
; ---------------------------------------------------------------------------
SZERRLOCALALLOC db 'LocalAlloc: Invalid local heap',0
                                        ; DATA XREF: LOCALALLOC+12↑o
                db 24h
; ---------------------------------------------------------------------------

loc_5849:                               ; CODE XREF: LOCALALLOC+C↑j
                                        ; LOCALALLOC+1E↑j
                call    LENTER
                mov     ax, [bp+arg_2]
                test    al, 10h
                jz      short loc_5856
                inc     word ptr [di+2]

loc_5856:                               ; CODE XREF: LOCALALLOC+48↑j
                mov     bx, [bp+arg_0]
                or      bx, bx
                jnz     short loc_586E
                and     ax, 2
                jz      short loc_588C
                call    HALLOC
                xor     byte ptr [bx], 2
                or      byte ptr [bx+2], 40h
                jmp     short loc_588C
; ---------------------------------------------------------------------------

loc_586E:                               ; CODE XREF: LOCALALLOC+52↑j
                call    LALLOC
                jz      short loc_588C
                test    dl, 2
                jz      short loc_588C
                call    HALLOC
                mov     si, [bx]
                mov     [si-2], ax
                or      byte ptr [si-6], 2
                and     dh, 0Fh
                jz      short loc_588C
                mov     [bx+2], dh

loc_588C:                               ; CODE XREF: LOCALALLOC+57↑j
                                        ; LOCALALLOC+63↑j ...
                test    [bp+arg_2], 10h
                jz      short loc_5896
                dec     word ptr [di+2]

loc_5896:                               ; CODE XREF: LOCALALLOC+88↑j
                call    LLEAVE
                mov     cx, ax
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    4
LOCALALLOC      endp

;
; External Entry #6 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public LOCALREALLOC
LOCALREALLOC    proc far

arg_0           = word ptr  6
arg_2           = word ptr  8
arg_4           = word ptr  0Ah

                inc     bp              ; KERNEL_6
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                call    CHECKLOCALHEAP
                or      ax, ax
                jz      short loc_58EA
                or      ax, 100h
                push    ax
                mov     ax, offset SZERRLOCALREALLOC ; "LocalReAlloc: Invalid local heap"
                push    cs
                push    ax
                xor     ax, ax
                push    ax
                push    ax
                call    KERNELERROR
                jmp     short loc_58EA
; ---------------------------------------------------------------------------
SZERRLOCALREALLOC db 'LocalReAlloc: Invalid local heap',0
                                        ; DATA XREF: LOCALREALLOC+12↑o
                db 24h
; ---------------------------------------------------------------------------

loc_58EA:                               ; CODE XREF: LOCALREALLOC+C↑j
                                        ; LOCALREALLOC+1E↑j
                call    LENTER
                test    [bp+arg_0], 10h
                jz      short loc_58F7
                inc     word ptr [di+2]

loc_58F7:                               ; CODE XREF: LOCALREALLOC+4A↑j
                mov     si, [bp+arg_4]
                call    LDREF
                jz      short loc_5957
                test    [bp+arg_0], 80h
                jnz     short loc_5944
                mov     si, bx
                mov     bx, ax
                add     bx, [bp+arg_2]
                call    LALIGN
                mov     bx, [si+2]
                cmp     [bp+arg_2], 0
                jnz     short loc_5973
                jcxz    short loc_5920

loc_591B:                               ; CODE XREF: LOCALREALLOC+7D↓j
                                        ; LOCALREALLOC+89↓j ...
                xor     ax, ax
                jmp     loc_5A1E
; ---------------------------------------------------------------------------

loc_5920:                               ; CODE XREF: LOCALREALLOC+71↑j
                test    [bp+arg_0], 2
                jz      short loc_591B
                mov     al, 2
                xor     cx, cx
                mov     bx, [bp+arg_4]
                call    LNOTIFY
                jz      short loc_591B
                xor     ax, ax
                mov     bx, si
                call    LFREE
                jz      short loc_59A8
                mov     [si], ax
                or      byte ptr [si+2], 40h
                jmp     short loc_59A5
; ---------------------------------------------------------------------------

loc_5944:                               ; CODE XREF: LOCALREALLOC+5C↑j
                mov     ax, [bp+arg_0]
                or      si, si
                jz      short loc_59A5
                and     byte ptr [si+2], 0C0h
                and     ah, 3Fh
                or      [si+2], ah
                jmp     short loc_59A5
; ---------------------------------------------------------------------------

loc_5957:                               ; CODE XREF: LOCALREALLOC+55↑j
                test    cl, 40h
                jz      short loc_59A5
                mov     bx, [bp+arg_2]
                push    si
                mov     ax, 2
                or      ax, [bp+arg_0]
                call    LALLOC
                pop     si
                jz      short loc_591B
                xor     byte ptr [si+2], 40h
                jmp     loc_5A14
; ---------------------------------------------------------------------------

loc_5973:                               ; CODE XREF: LOCALREALLOC+6F↑j
                cmp     dx, bx
                ja      short loc_59AB

loc_5977:                               ; CODE XREF: LOCALREALLOC:loc_59C4↓j
                push    si
                mov     si, dx
                lea     dx, [si+8]
                cmp     dx, bx
                pop     bx
                jnb     short loc_59A5
                mov     cx, si
                xchg    cx, [bx+2]
                mov     [si], bx
                xchg    si, cx
                and     word ptr [si], 3
                jz      short loc_5997
                inc     word ptr [di+4]
                jmp     short loc_599E
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_5997:                               ; CODE XREF: LOCALREALLOC+E7↑j
                mov     si, [si+2]
                and     word ptr [si], 3

loc_599E:                               ; CODE XREF: LOCALREALLOC+EC↑j
                or      [si], cx
                xchg    si, cx
                mov     [si+2], cx

loc_59A5:                               ; CODE XREF: LOCALREALLOC+9A↑j
                                        ; LOCALREALLOC+A1↑j ...
                mov     ax, [bp+arg_4]

loc_59A8:                               ; CODE XREF: LOCALREALLOC+92↑j
                jmp     short loc_5A1E
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_59AB:                               ; CODE XREF: LOCALREALLOC+CD↑j
                test    byte ptr [bx], 1
                jnz     short loc_59C6
                cmp     dx, [bx+2]
                ja      short loc_59C6
                mov     cx, bx
                call    LJOIN
                test    [bp+arg_0], 40h
                jz      short loc_59C4
                call    LZERO

loc_59C4:                               ; CODE XREF: LOCALREALLOC+117↑j
                jmp     short loc_5977
; ---------------------------------------------------------------------------

loc_59C6:                               ; CODE XREF: LOCALREALLOC+106↑j
                                        ; LOCALREALLOC+10B↑j
                mov     dx, [bp+arg_0]
                mov     bx, 2
                jcxz    short loc_59D5
                test    dx, bx
                jnz     short loc_59D5

loc_59D2:                               ; CODE XREF: LOCALREALLOC+137↓j
                                        ; LOCALREALLOC+143↓j
                jmp     loc_591B
; ---------------------------------------------------------------------------

loc_59D5:                               ; CODE XREF: LOCALREALLOC+124↑j
                                        ; LOCALREALLOC+128↑j
                or      dx, bx
                test    [bp+arg_4], bx
                jnz     short loc_59E3
                test    [bp+arg_0], bx
                jz      short loc_59D2
                xor     dx, bx

loc_59E3:                               ; CODE XREF: LOCALREALLOC+132↑j
                mov     ax, dx
                mov     bx, [bp+arg_2]
                call    LALLOC
                jz      short loc_59D2
                push    ax
                mov     cx, ax
                mov     bx, [bp+arg_4]
                mov     al, 1
                call    LNOTIFY
                mov     si, [bp+arg_4]
                call    LDREF
                mov     si, ax
                pop     ax
                mov     cx, [bx+2]
                sub     cx, si
                call    LREPSETUP
                push    di
                mov     di, ax
                rep movsw
                pop     di
                call    LFREE
                jz      short loc_5A1E

loc_5A14:                               ; CODE XREF: LOCALREALLOC+C8↑j
                mov     [si], ax
                xchg    ax, si
                or      byte ptr [si-6], 2
                mov     [si-2], ax

loc_5A1E:                               ; CODE XREF: LOCALREALLOC+75↑j
                                        ; LOCALREALLOC:loc_59A8↑j ...
                test    [bp+arg_0], 10h
                jz      short loc_5A28
                dec     word ptr [di+2]

loc_5A28:                               ; CODE XREF: LOCALREALLOC+17B↑j
                call    LLEAVE
                mov     cx, ax
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    6
LOCALREALLOC    endp

;
; External Entry #7 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public LOCALFREE
LOCALFREE       proc far                ; CODE XREF: LOOKUPATOM+102↑p

arg_0           = word ptr  6

                inc     bp              ; KERNEL_7
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                call    CHECKLOCALHEAP
                or      ax, ax
                jz      short loc_5A79
                or      ax, 100h
                push    ax
                mov     ax, offset SZERRLOCALFREE ; "LocalFree: Invalid local heap"
                push    cs
                push    ax
                xor     ax, ax
                push    ax
                push    ax
                call    KERNELERROR
                jmp     short loc_5A79
; ---------------------------------------------------------------------------
SZERRLOCALFREE  db 'LocalFree: Invalid local heap',0
                                        ; DATA XREF: LOCALFREE+12↑o
                db 24h
; ---------------------------------------------------------------------------

loc_5A79:                               ; CODE XREF: LOCALFREE+C↑j
                                        ; LOCALFREE+1E↑j
                call    LENTER
                mov     si, [bp+arg_0]
                call    LDREF
                jz      short loc_5AC7
                or      ch, ch
                jz      short loc_5AC4
                xor     bx, bx
                mov     ax, 1F0h
                push    ax
                mov     ax, offset SZERRLOCALFREELOCKED ; "LocalFree: freeing locked object"
                push    cs
                push    ax
                push    bx
                push    [bp+arg_0]
                call    KERNELERROR
                jmp     short loc_5ABE
; ---------------------------------------------------------------------------
SZERRLOCALFREELOCKED db 'LocalFree: freeing locked object',0
                                        ; DATA XREF: LOCALFREE+54↑o
                db 24h
; ---------------------------------------------------------------------------

loc_5ABE:                               ; CODE XREF: LOCALFREE+60↑j
                mov     si, [bp+arg_0]
                call    LDREF

loc_5AC4:                               ; CODE XREF: LOCALFREE+4C↑j
                call    LFREE

loc_5AC7:                               ; CODE XREF: LOCALFREE+48↑j
                call    HFREE
                call    LLEAVE
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
LOCALFREE       endp

;
; External Entry #10 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public LOCALSIZE
LOCALSIZE       proc far
                push    si              ; KERNEL_10
                mov     si, sp
                mov     si, ss:[si+6]
                call    LDREF
                jz      short loc_5AEB
                sub     ax, [bx+2]
                neg     ax

loc_5AEB:                               ; CODE XREF: LOCALSIZE+A↑j
                mov     cx, ax
                pop     si
                retf    2
LOCALSIZE       endp

;
; External Entry #12 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public LOCALFLAGS
LOCALFLAGS      proc far
                push    si              ; KERNEL_12
                mov     si, sp
                mov     si, ss:[si+6]
                call    LDREF
                mov     cx, si
                jcxz    short loc_5B02
                mov     cx, [si+2]

loc_5B02:                               ; CODE XREF: LOCALFLAGS+C↑j
                xchg    cl, ch
                mov     ax, cx
                pop     si
                retf    2
LOCALFLAGS      endp

;
; External Entry #8 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public LOCALLOCK
LOCALLOCK       proc far

arg_0           = word ptr  6

                inc     bp              ; KERNEL_8
                push    bp
                mov     bp, sp
                push    ds
                push    si
                mov     si, [bp+arg_0]
                call    LDREF
                jz      short loc_5B62
                or      si, si
                jz      short loc_5B62
                inc     byte ptr [si+3]
                jnz     short loc_5B60
                xor     ax, ax
                mov     ax, 1C0h
                push    ax
                mov     ax, offset SZERRLOCALLOCK ; "LocalLock: Object usage count overflow"
                push    cs
                push    ax
                push    ax
                push    [bp+arg_0]
                call    KERNELERROR
                jmp     short loc_5B5D
; ---------------------------------------------------------------------------
SZERRLOCALLOCK  db 'LocalLock: Object usage count overflow',0
                                        ; DATA XREF: LOCALLOCK+1D↑o
                db 24h
; ---------------------------------------------------------------------------

loc_5B5D:                               ; CODE XREF: LOCALLOCK+29↑j
                dec     byte ptr [si+3]

loc_5B60:                               ; CODE XREF: LOCALLOCK+15↑j
                mov     ax, [si]

loc_5B62:                               ; CODE XREF: LOCALLOCK+C↑j
                                        ; LOCALLOCK+10↑j
                mov     cx, ax
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
LOCALLOCK       endp

;
; External Entry #9 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public LOCALUNLOCK
LOCALUNLOCK     proc far

arg_0           = word ptr  6

                inc     bp              ; KERNEL_9
                push    bp
                mov     bp, sp
                push    ds
                push    si
                mov     si, [bp+arg_0]
                call    LDREF
                jz      short loc_5BD5
                xor     ax, ax
                or      si, si
                jz      short loc_5BD5
                dec     ch
                cmp     ch, 0FEh
                jz      short loc_5BD5
                mov     ax, si
                dec     byte ptr [si+3]
                jz      short loc_5BD3
                jb      short loc_5BD5
                xor     ax, ax
                mov     ax, 1F0h
                push    ax
                mov     ax, offset SZERRLOCALUNLOCK ; "LocalUnlock: Object usage count underfl"...
                push    cs
                push    ax
                push    ax
                push    [bp+arg_0]
                call    KERNELERROR
                jmp     short loc_5BD3
; ---------------------------------------------------------------------------
SZERRLOCALUNLOCK db 'LocalUnlock: Object usage count underflow',0
                                        ; DATA XREF: LOCALUNLOCK+2A↑o
                db 24h
; ---------------------------------------------------------------------------

loc_5BD3:                               ; CODE XREF: LOCALUNLOCK+20↑j
                                        ; LOCALUNLOCK+36↑j
                xor     ax, ax

loc_5BD5:                               ; CODE XREF: LOCALUNLOCK+C↑j
                                        ; LOCALUNLOCK+12↑j ...
                mov     cx, ax
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
LOCALUNLOCK     endp

;
; External Entry #11 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public LOCALHANDLE
LOCALHANDLE     proc far
                mov     bx, sp          ; KERNEL_11
                mov     bx, ss:[bx+4]
                test    bl, 2
                jz      short loc_5BF9
                mov     ax, bx
                mov     bx, [bx-2]
                cmp     [bx], ax
                jz      short loc_5BF9
                xor     bx, bx

loc_5BF9:                               ; CODE XREF: LOCALHANDLE+9↑j
                                        ; LOCALHANDLE+12↑j
                mov     ax, bx
                retf    2
LOCALHANDLE     endp

;
; External Entry #13 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public LOCALCOMPACT
LOCALCOMPACT    proc far

arg_0           = word ptr  6

                inc     bp              ; KERNEL_13
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                call    CHECKLOCALHEAP
                or      ax, ax
                jz      short loc_5C40
                or      ax, 100h
                push    ax
                mov     ax, offset SZERRLOCALCOMPACT ; "LocalCompact: Invalid local heap"
                push    cs
                push    ax
                xor     ax, ax
                push    ax
                push    ax
                call    KERNELERROR
                jmp     short loc_5C40
; ---------------------------------------------------------------------------
SZERRLOCALCOMPACT db 'LocalCompact: Invalid local heap',0
                                        ; DATA XREF: LOCALCOMPACT+12↑o
                db 24h
; ---------------------------------------------------------------------------

loc_5C40:                               ; CODE XREF: LOCALCOMPACT+C↑j
                                        ; LOCALCOMPACT+1E↑j
                call    LENTER
                mov     bx, [bp+arg_0]
                clc
                call    LALIGN
                call    LCOMPACT
                or      ax, ax
                jz      short loc_5C54
                sub     ax, 6

loc_5C54:                               ; CODE XREF: LOCALCOMPACT+51↑j
                call    LLEAVE
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
LOCALCOMPACT    endp

;
; External Entry #14 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public LOCALNOTIFY
LOCALNOTIFY     proc far
                mov     bx, sp          ; KERNEL_14
                mov     ax, ss:[bx+4]
                mov     dx, ss:[bx+6]
                mov     bx, ds:6
                xchg    ax, [bx+16h]
                xchg    dx, [bx+18h]
                retf    4
LOCALNOTIFY     endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

LOCALNOTIFYDEFAULT proc far             ; DATA XREF: LOCALINIT+55↓o

arg_0           = word ptr  6
arg_4           = word ptr  0Ah

                inc     bp
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                mov     ax, [bp+arg_4]
                or      ax, ax
                jnz     short loc_5CAF
                push    ds
                nop
                push    cs
                call    near ptr GLOBALHANDLE
                or      ax, ax
                jz      short loc_5CAF
                push    cx
                mov     si, ax
                push    si
                nop
                push    cs
                call    near ptr GLOBALSIZE
                pop     bx
                add     ax, [bp+arg_0]
                adc     dx, 0
                add     ax, [di+1Ch]
                adc     dx, 0
                jz      short loc_5CB1
                xor     ax, ax
                xor     cx, cx

loc_5CAF:                               ; CODE XREF: LOCALNOTIFYDEFAULT+C↑j
                                        ; LOCALNOTIFYDEFAULT+16↑j
                jmp     short loc_5D1B
; ---------------------------------------------------------------------------

loc_5CB1:                               ; CODE XREF: LOCALNOTIFYDEFAULT+2E↑j
                xor     cx, cx
                test    si, 1
                jnz     short loc_5CC1
                cmp     bh, 1
                jnz     short loc_5CC1
                or      cl, 2

loc_5CC1:                               ; CODE XREF: LOCALNOTIFYDEFAULT+3C↑j
                                        ; LOCALNOTIFYDEFAULT+41↑j
                push    bx
                push    si
                push    dx
                push    ax
                push    cx
                nop
                push    cs
                call    near ptr GLOBALREALLOC
                pop     bx
                jcxz    short loc_5D1B
                push    bx
                push    ax
                nop
                push    cs
                call    near ptr GLOBALSIZE
                mov     bx, ax
                sub     bx, 4
                and     bl, 0FCh
                mov     di, ds:6
                mov     si, [di+8]
                mov     [bx+2], bx
                mov     [bx], si
                or      byte ptr [bx], 1
                mov     [si+2], bx
                mov     [di+8], bx
                inc     word ptr [di+4]
                mov     bx, si
                call    LFREE
                mov     ax, 1
                pop     bx
                cmp     bh, 1
                jnz     short loc_5D1B
                push    ds
                nop
                push    cs
                call    near ptr UNLOCKSEGMENT
                xor     ax, ax
                push    ax
                push    ax
                nop
                push    cs
                call    near ptr GLOBALCOMPACT
                push    ds
                nop
                push    cs
                call    near ptr LOCKSEGMENT
                mov     ax, 1

loc_5D1B:                               ; CODE XREF: LOCALNOTIFYDEFAULT:loc_5CAF↑j
                                        ; LOCALNOTIFYDEFAULT+51↑j ...
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    6
LOCALNOTIFYDEFAULT endp

;
; External Entry #4 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public LOCALINIT
LOCALINIT       proc far                ; CODE XREF: INITTASK+2F↑p

arg_0           = word ptr  6
arg_2           = word ptr  8
arg_4           = word ptr  0Ah

                inc     bp              ; KERNEL_4
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                mov     cx, [bp+arg_4]
                jcxz    short loc_5D36
                mov     ds, cx

loc_5D36:                               ; CODE XREF: LOCALINIT+A↑j
                mov     bx, [bp+arg_2]
                or      bx, bx
                jnz     short loc_5D54
                mov     cx, ds
                dec     cx
                mov     es, cx
                assume es:nothing
                mov     bx, es:3
                mov     cl, 4
                shl     bx, cl
                dec     bx
                xchg    bx, [bp+arg_0]
                sub     bx, [bp+arg_0]
                neg     bx

loc_5D54:                               ; CODE XREF: LOCALINIT+13↑j
                clc
                call    LALIGN
                mov     bx, dx
                lea     di, [bx+4]
                xor     ax, ax
                mov     cx, [bp+arg_0]
                cmp     bx, cx
                jnb     short loc_5DC5
                sub     cx, di
                call    LREPSETUP
                push    di
                rep stosw
                pop     di
                lea     bx, [di+1Eh]
                mov     byte ptr [di+12h], 20h ; ' '
                mov     byte ptr [di+4], 3
                mov     [di+6], dx
                mov     word ptr [di+16h], offset LOCALNOTIFYDEFAULT
                mov     word ptr [di+18h], cs
                mov     word ptr [di+14h], offset loc_56E0
                mov     word ptr [di+1Ch], 200h
                clc
                call    LALIGN
                mov     si, dx
                mov     bx, [bp+arg_0]
                sub     bx, 4
                and     bl, 0FCh
                mov     [di+8], bx
                mov     ds:6, di
                mov     di, [di+6]
                mov     [si], di
                mov     [si+2], bx
                mov     [bx+2], bx
                lea     ax, [si+1]
                mov     [bx], ax
                mov     [di+2], si
                lea     ax, [di+1]
                mov     [di], ax
                push    ds
                nop
                push    cs
                call    near ptr LOCKSEGMENT
                mov     al, 1

loc_5DC5:                               ; CODE XREF: LOCALINIT+3C↑j
                mov     cx, ax
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    6
LOCALINIT       endp
