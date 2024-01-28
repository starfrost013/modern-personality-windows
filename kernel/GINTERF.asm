;
; External Entry #15 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GLOBALALLOC
GLOBALALLOC     proc far                ; CODE XREF: MYALLOC+44↑p
                                        ; LOADSEGMENT+103↑p ...

arg_0           = byte ptr  6
arg_4           = word ptr  0Ah

                inc     bp              ; KERNEL_15
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                call    CHECKGLOBALHEAP
                or      ax, ax
                jz      short loc_6C7B
                or      ax, 200h
                xor     bx, bx
                push    ax
                mov     ax, offset SZERRGLOBALALLOC ; "GlobalAlloc: Invalid global heap"
                push    cs
                push    ax
                push    dx
                push    bx
                call    KERNELERROR
                jmp     short loc_6C7B
; ---------------------------------------------------------------------------
SZERRGLOBALALLOC db 'GlobalAlloc: Invalid global heap',0
                                        ; DATA XREF: GLOBALALLOC+14↑o
                db 24h
; ---------------------------------------------------------------------------

loc_6C7B:                               ; CODE XREF: GLOBALALLOC+C↑j
                                        ; GLOBALALLOC+1E↑j
                call    GENTER
                xor     dx, dx
                mov     ax, [bp+arg_4]
                lea     bx, [bp+arg_0]
                call    GBTOP
                call    GALLOC
                call    GLEAVE
                call    GMEMCHECK
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    6
GLOBALALLOC     endp

;
; External Entry #16 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GLOBALREALLOC
GLOBALREALLOC   proc far                ; CODE XREF: SEGLOAD+2C↑p
                                        ; ALLOCRESOURCE+68↑p ...

arg_0           = word ptr  6
arg_2           = byte ptr  8
arg_6           = word ptr  0Ch

                inc     bp              ; KERNEL_16
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                call    CHECKGLOBALHEAP
                or      ax, ax
                jz      short loc_6CE3
                or      ax, 200h
                xor     bx, bx
                push    ax
                mov     ax, offset SZERRGLOBALREALLOC ; "GlobalReAlloc: Invalid global heap"
                push    cs
                push    ax
                push    dx
                push    bx
                call    KERNELERROR
                jmp     short loc_6CE3
; ---------------------------------------------------------------------------
SZERRGLOBALREALLOC db 'GlobalReAlloc: Invalid global heap',0
                                        ; DATA XREF: GLOBALREALLOC+14↑o
                db 24h
; ---------------------------------------------------------------------------

loc_6CE3:                               ; CODE XREF: GLOBALREALLOC+C↑j
                                        ; GLOBALREALLOC+1E↑j
                call    GENTER
                mov     dx, [bp+arg_6]
                mov     ax, [bp+arg_0]
                lea     bx, [bp+arg_2]
                call    GBTOP
                call    GREALLOC
                call    GLEAVE
                call    GMEMCHECK
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    8
GLOBALREALLOC   endp

;
; External Entry #17 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GLOBALFREE
GLOBALFREE      proc far                ; CODE XREF: MYFREE+3E↑p
                                        ; FREENRTABLE+2D↑p ...

arg_0           = word ptr  6

                inc     bp              ; KERNEL_17
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                call    CHECKGLOBALHEAP
                or      ax, ax
                jz      short loc_6D49
                or      ax, 200h
                xor     bx, bx
                push    ax
                mov     ax, offset SZERRGLOBALFREE ; "GlobalFree: Invalid global heap"
                push    cs
                push    ax
                push    dx
                push    bx
                call    KERNELERROR
                jmp     short loc_6D49
; ---------------------------------------------------------------------------
SZERRGLOBALFREE db 'GlobalFree: Invalid global heap',0
                                        ; DATA XREF: GLOBALFREE+14↑o
                db 24h
; ---------------------------------------------------------------------------

loc_6D49:                               ; CODE XREF: GLOBALFREE+C↑j
                                        ; GLOBALFREE+1E↑j
                call    GENTER
                mov     dx, [bp+arg_0]
                call    GALIGN
                or      si, si
                jz      short loc_6D92
                cmp     ch, 0
                jz      short loc_6D92
                xor     bx, bx
                mov     ax, 2F0h
                push    ax
                mov     ax, offset SZERRGLOBALFREELOCKED ; "GlobalFree: freeing locked object"
                push    cs
                push    ax
                push    bx
                push    [bp+arg_0]
                call    KERNELERROR
                jmp     short loc_6D92
; ---------------------------------------------------------------------------
SZERRGLOBALFREELOCKED db 'GlobalFree: freeing locked object',0
                                        ; DATA XREF: GLOBALFREE+59↑o
                db 24h
; ---------------------------------------------------------------------------

loc_6D92:                               ; CODE XREF: GLOBALFREE+4C↑j
                                        ; GLOBALFREE+51↑j ...
                mov     dx, [bp+arg_0]
                xor     cx, cx
                call    GFREE
                call    GLEAVE
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
GLOBALFREE      endp

;
; External Entry #26 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GLOBALFREEALL
GLOBALFREEALL   proc far                ; CODE XREF: DELMODULE+3C↑p
                                        ; DOSTerminateHook+41↑p

arg_0           = word ptr  6

                inc     bp              ; KERNEL_26
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                call    CHECKGLOBALHEAP
                or      ax, ax
                jz      short loc_6DEE
                or      ax, 200h
                xor     bx, bx
                push    ax
                mov     ax, offset SZERRGLOBALFREEALL ; "GlobalFreeAll: Invalid global heap"
                push    cs
                push    ax
                push    dx
                push    bx
                call    KERNELERROR
                jmp     short loc_6DEE
; ---------------------------------------------------------------------------
SZERRGLOBALFREEALL db 'GlobalFreeAll: Invalid global heap',0
                                        ; DATA XREF: GLOBALFREEALL+14↑o
                db 24h
; ---------------------------------------------------------------------------

loc_6DEE:                               ; CODE XREF: GLOBALFREEALL+C↑j
                                        ; GLOBALFREEALL+1E↑j
                call    GENTER
                mov     dx, [bp+arg_0]
                or      dx, dx
                jnz     short loc_6E00
                les     si, cs:PCURRENTPDB
                mov     dx, es:[si]

loc_6E00:                               ; CODE XREF: GLOBALFREEALL+4C↑j
                mov     es, word ptr [di+6]
                mov     cx, [di+4]

loc_6E06:                               ; CODE XREF: GLOBALFREEALL+71↓j
                cmp     es:[di+1], dx
                jnz     short loc_6E17
                mov     ax, es
                inc     ax
                push    cx
                push    dx
                push    ax
                call    DEBUGFREESEGMENT
                pop     dx
                pop     cx

loc_6E17:                               ; CODE XREF: GLOBALFREEALL+60↑j
                mov     es, word ptr es:[di+8]
                loop    loc_6E06
                call    GFREEALL
                call    GLEAVE
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
GLOBALFREEALL   endp


; =============== S U B R O U T I N E =======================================


XHANDLE         proc near               ; CODE XREF: GLOBALHANDLE↓p
                                        ; LOCKSEGMENT↓p ...
                pop     dx
                mov     bx, sp
                mov     ax, ss:[bx+4]
                inc     ax
                jz      short loc_6E4B
                dec     ax

loc_6E3B:                               ; CODE XREF: XHANDLE+1D↓j
                push    ds
                push    di
                mov     ds, cs:PGLOBALHEAP
                xor     di, di
                inc     word ptr [di+18h]
                push    dx
                jmp     GHANDLE
; ---------------------------------------------------------------------------

loc_6E4B:                               ; CODE XREF: XHANDLE+8↑j
                mov     ax, ds
                jmp     short loc_6E3B
XHANDLE         endp ; sp-analysis failed

;
; External Entry #21 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public GLOBALHANDLE
GLOBALHANDLE    proc far                ; CODE XREF: MYLOCK+8↑p
                                        ; ALLOCRESOURCE+6E↑p ...
                call    XHANDLE         ; KERNEL_21
                jmp     short loc_6E89
GLOBALHANDLE    endp

;
; External Entry #23 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public LOCKSEGMENT
LOCKSEGMENT     proc far                ; CODE XREF: ALLOCSEG+7A↑p
                                        ; INITTASK+5F↑p ...
                call    XHANDLE         ; KERNEL_23
                jz      short loc_6E89
                call    GLOCK
                jmp     short loc_6E89
LOCKSEGMENT     endp

;
; External Entry #24 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public UNLOCKSEGMENT
UNLOCKSEGMENT   proc far                ; CODE XREF: INITTASK+44↑p
                                        ; LOCALNOTIFYDEFAULT+8B↑p
                call    XHANDLE         ; KERNEL_24
                jz      short loc_6E89
                call    GUNLOCK
                jmp     short loc_6E89
UNLOCKSEGMENT   endp

;
; External Entry #20 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public GLOBALSIZE
GLOBALSIZE      proc far                ; CODE XREF: LOCALNOTIFYDEFAULT+1E↑p
                                        ; LOCALNOTIFYDEFAULT+57↑p
                call    XHANDLE         ; KERNEL_20
                or      dx, dx
                jz      short loc_6E89
                mov     ax, es:[di+3]
                push    ax
                xor     dx, dx
                mov     cx, 4

loc_6E79:                               ; CODE XREF: GLOBALSIZE+15↓j
                shl     ax, 1
                rcl     dx, 1
                loop    loc_6E79
                pop     cx
                jmp     short loc_6E89
GLOBALSIZE      endp

;
; External Entry #22 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public GLOBALFLAGS
GLOBALFLAGS     proc far
                call    XHANDLE         ; KERNEL_22
                xchg    cl, ch
                mov     ax, cx

loc_6E89:                               ; CODE XREF: GLOBALHANDLE+3↑j
                                        ; LOCKSEGMENT+3↑j ...
                dec     word ptr [di+18h]
                pop     di
                pop     ds
                retf    2
GLOBALFLAGS     endp ; sp-analysis failed

;
; External Entry #18 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public GLOBALLOCK
GLOBALLOCK      proc far                ; CODE XREF: LOADRESOURCE+70↑p
                                        ; LOCKRESOURCE+10↑p ...
                call    XHANDLE         ; KERNEL_18
                jz      short loc_6EDF
                cmp     ch, 0FFh
                jnz     short loc_6EDC
                push    bx
                push    cx
                push    dx
                xor     cx, cx
                mov     ax, 2C0h
                push    ax
                mov     ax, offset SZERRGLOBALLOCK ; "GlobalLock: Object usage count overflow"
                push    cs
                push    ax
                push    cx
                push    bx
                call    KERNELERROR
                jmp     short loc_6ED9
; ---------------------------------------------------------------------------
SZERRGLOBALLOCK db 'GlobalLock: Object usage count overflow',0
                                        ; DATA XREF: GLOBALLOCK+13↑o
                db 24h
; ---------------------------------------------------------------------------

loc_6ED9:                               ; CODE XREF: GLOBALLOCK+1D↑j
                pop     dx
                pop     cx
                pop     bx

loc_6EDC:                               ; CODE XREF: GLOBALLOCK+8↑j
                call    GLOCK

loc_6EDF:                               ; CODE XREF: GLOBALLOCK+3↑j
                xor     ax, ax
                mov     cx, dx

loc_6EE3:                               ; CODE XREF: GLOBALUNLOCK+3↓j
                jmp     short loc_6E89
GLOBALLOCK      endp

;
; External Entry #19 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public GLOBALUNLOCK
GLOBALUNLOCK    proc far                ; CODE XREF: MYFREE+32↑p
                                        ; LOADRESOURCE+80↑p ...
                call    XHANDLE         ; KERNEL_19
                jz      short loc_6EE3
                cmp     ch, 0
                jnz     short loc_6F33
                push    bx
                push    cx
                push    dx
                xor     cx, cx
                mov     ax, 2F0h
                push    ax
                mov     ax, offset SZERRGLOBALUNLOCK ; "GlobalUnlock: Object usage count underf"...
                push    cs
                push    ax
                push    cx
                push    bx
                call    KERNELERROR
                jmp     short loc_6F30
; ---------------------------------------------------------------------------
SZERRGLOBALUNLOCK db 'GlobalUnlock: Object usage count underflow',0
                                        ; DATA XREF: GLOBALUNLOCK+13↑o
                db 24h
; ---------------------------------------------------------------------------

loc_6F30:                               ; CODE XREF: GLOBALUNLOCK+1D↑j
                pop     dx
                pop     cx
                pop     bx

loc_6F33:                               ; CODE XREF: GLOBALUNLOCK+8↑j
                call    GUNLOCK
                mov     ax, cx
                jmp     loc_6E89
GLOBALUNLOCK    endp

;
; External Entry #25 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GLOBALCOMPACT
GLOBALCOMPACT   proc far                ; CODE XREF: ADDMODULE+40↑p
                                        ; FREEMODULE+A8↑p ...

arg_0           = byte ptr  6

                inc     bp              ; KERNEL_25
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                call    CHECKGLOBALHEAP
                or      ax, ax
                jz      short loc_6F7F
                or      ax, 200h
                xor     bx, bx
                push    ax
                mov     ax, offset SZERRGLOBALCOMPACT ; "GlobalCompact: Invalid global heap"
                push    cs
                push    ax
                push    dx
                push    bx
                call    KERNELERROR
                jmp     short loc_6F7F
; ---------------------------------------------------------------------------
SZERRGLOBALCOMPACT db 'GlobalCompact: Invalid global heap',0
                                        ; DATA XREF: GLOBALCOMPACT+14↑o
                db 24h
; ---------------------------------------------------------------------------

loc_6F7F:                               ; CODE XREF: GLOBALCOMPACT+C↑j
                                        ; GLOBALCOMPACT+1E↑j
                call    GENTER
                mov     ax, 0FFFFh
                lea     bx, [bp+arg_0]
                call    GBTOP
                clc
                call    HEND
                call    GAVAIL
                mov     cx, 4
                push    ax

loc_6F96:                               ; CODE XREF: GLOBALCOMPACT+5F↓j
                shl     ax, 1
                rcl     dx, 1
                loop    loc_6F96
                pop     cx
                call    GLEAVE
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    4
GLOBALCOMPACT   endp


; =============== S U B R O U T I N E =======================================


GLOBALINFOPTR   proc near               ; CODE XREF: CHECKGLOBALHEAP+B↓p
                mov     dx, cs:PGLOBALHEAP
                xor     ax, ax
                retn
GLOBALINFOPTR   endp

;
; External Entry #28 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public GLOBALMASTERHANDLE
GLOBALMASTERHANDLE proc far
                mov     ax, cs:HGLOBALHEAP ; KERNEL_28
                mov     dx, cs:PGLOBALHEAP
                retf
GLOBALMASTERHANDLE endp
