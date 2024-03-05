; ModernPersonality
; Copyright © 2023-2024 starfrost

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

SAVESTATE       proc near               ; CODE XREF: CREATETASK+EF↑p
                                        ; BOOTSCHEDULE+84↓p ...

arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                push    si
                push    di
                push    ds
                cld
                mov     ax, [bp+arg_0]
                mov     es, ax
                xor     ax, ax
                mov     ds, ax
                assume ds:cseg01
                mov     di, 20h ; ' '
                mov     si, 0
                movsw
                movsw
                movsw
                movsw
                movsw
                movsw
                mov     si, 0F8h
                movsw
                movsw
                mov     ds, [bp+arg_0]
                assume ds:nothing
                cmp     word ptr ds:1Ah, 0
                jz      short loc_39CA
                xor     ax, ax
                call    STATEXJUMP

loc_39CA:                               ; CODE XREF: SAVESTATE+29↑j
                les     bx, cs:PDMAADD
                mov     ax, es:[bx]
                mov     ds:34h, ax
                mov     ax, es:[bx+2]
                mov     ds:36h, ax
                les     bx, cs:PCNTCFLAG
                mov     al, es:[bx]
                mov     ds:38h, ax
                les     bx, cs:PERRMODE
                mov     al, es:[bx]
                mov     ds:3Bh, al
                les     bx, cs:PCURRENTPDB
                mov     ax, es:[bx]
                mov     ds:32h, ax
                test    byte ptr ds:3Ah, 80h
                jnz     short loc_3A23
                mov     ah, 19h
                int     21h             ; DOS - GET DEFAULT DISK NUMBER
                mov     dl, al
                inc     dl
                or      al, 0C0h
                mov     ds:3Ah, al
                lea     si, ds:3Dh
                mov     byte ptr [si-1], 5Ch ; '\'
                mov     ah, 47h ; 'G'
                int     21h             ; DOS - 2+ - GET CURRENT DIRECTORY
                                        ; DL = drive (0=default, 1=A, etc.)
                                        ; DS:SI points to 64-byte buffer area
                jnb     short loc_3A23
                mov     byte ptr [si-1], 0

loc_3A23:                               ; CODE XREF: SAVESTATE+68↑j
                                        ; SAVESTATE+83↑j
                mov     di, ds:30h
                or      di, di
                jz      short loc_3A32
                push    ds
                pop     es
                mov     ax, 4E00h
                int     67h             ;  - LIM EMS - GET OR SET PAGE MAP
                                        ; DS:SI -> array holding information
                                        ; ES:DI -> array to receive information
                                        ; if getting mapping registers

loc_3A32:                               ; CODE XREF: SAVESTATE+8F↑j
                mov     ax, ds
                pop     ds
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    2
SAVESTATE       endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

RESTORESTATE    proc near               ; CODE XREF: BOOTSCHEDULE+89↓p

arg_0           = word ptr  4
arg_2           = word ptr  6

                push    bp
                mov     bp, sp
                push    si
                push    di
                push    ds
                cld
                mov     ds, [bp+arg_2]
                mov     ax, [bp+arg_2]
                mov     ds, ax
                mov     si, 20h ; ' '
                xor     ax, ax
                mov     es, ax
                assume es:cseg01
                mov     di, 0
                movsw
                movsw
                movsw
                movsw
                movsw
                movsw
                mov     di, 0F8h
                movsw
                movsw
                les     bx, cs:PCNTCFLAG
                assume es:nothing
                mov     ax, ds:38h
                mov     es:[bx], al
                les     bx, cs:PERRMODE
                mov     al, ds:3Bh
                mov     es:[bx], al
                lds     dx, ds:34h
                mov     ah, 1Ah
                pushf
                cli
                call    cs:PREVINT21PROC ; Indirect INT 21h (MS-DOS API) call (see KDATA.ASM)
                mov     ds, [bp+arg_2]
                and     byte ptr ds:3Ah, 0BFh
                mov     cx, [bp+arg_0]
                jcxz    short loc_3ABA
                mov     es, cx
                mov     al, es:3Ah
                test    al, 40h
                jz      short loc_3ABA
                mov     ah, ds:3Ah
                and     ax, 3F3Fh
                cmp     al, ah
                jnz     short loc_3ABA
                lea     di, ds:3Dh
                mov     si, di

loc_3AAC:                               ; CODE XREF: RESTORESTATE+76↓j
                cmpsb
                jnz     short loc_3ABA
                cmp     byte ptr [si-1], 0
                jnz     short loc_3AAC
                or      byte ptr ds:3Ah, 40h

loc_3ABA:                               ; CODE XREF: RESTORESTATE+52↑j
                                        ; RESTORESTATE+5C↑j ...
                mov     bx, ds:32h
                cmp     word ptr ds:1Ah, 0
                jz      short loc_3ACA
                mov     al, 1
                call    STATEXJUMP

loc_3ACA:                               ; CODE XREF: RESTORESTATE+86↑j
                mov     ah, 50h ; 'P'
                pushf
                cli
                call    cs:PREVINT21PROC ; Indirect INT 21h (MS-DOS API) call (see KDATA.ASM)
                mov     si, ds:30h
                or      si, si
                jz      short loc_3AE0
                mov     ax, 4E01h
                int     67h             ;  - LIM EMS - GET OR SET PAGE MAP
                                        ; DS:SI -> array holding information
                                        ; ES:DI -> array to receive information
                                        ; if setting mapping registers

loc_3AE0:                               ; CODE XREF: RESTORESTATE+9C↑j
                mov     ax, ds
                mov     dx, [bp+arg_0]
                pop     ds
                pop     di
                pop     si
                mov     sp, bp
                pop     bp
                retn    4
RESTORESTATE    endp


; =============== S U B R O U T I N E =======================================


STATEXJUMP      proc near               ; CODE XREF: SAVESTATE+2D↑p
                                        ; RESTORESTATE+8A↑p
                cbw
                push    ds
                mov     cx, ds          ; sets dx to ds+0004
                                        ; sets cx to 8087 found state
                                        ; calls es+0018
                                        ; likely to do with leaving after saving/restoring state
                                        ; possibly a loc not a function
                mov     es, cx
                mov     ds, word ptr ds:4
                mov     cx, cs:F8087
                call    dword ptr es:18h
                pop     ds
                retn
STATEXJUMP      endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

RESCHEDULE      proc far                ; CODE XREF: WAITEVENT+29↓j
                                        ; YIELD+24↓j
                inc     bp
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                push    ax              ; this function is DESIGNED to run into BOOTSCHEDULE!!!!
RESCHEDULE      endp ; sp-analysis failed

      
; =============== S U B R O U T I N E =======================================


BOOTSCHEDULE    proc far                ; CODE XREF: BOOTSCHEDULE+A↓j
                                        ; BOOTSCHEDULE+E3↓j ...
                mov     ax, cs:HEADTDB

loc_3B10:                               ; CODE XREF: BOOTSCHEDULE+16↓j
                                        ; BOOTSCHEDULE+51↓j
                or      ax, ax
                jnz     short loc_3B18
                int     28h             ; DOS 2+ internal - KEYBOARD BUSY LOOP
                jmp     short near ptr BOOTSCHEDULE
; ---------------------------------------------------------------------------

loc_3B18:                               ; CODE XREF: BOOTSCHEDULE+6↑j
                mov     ds, ax
                mov     ax, ds:0
                cmp     word ptr ds:6, 0
                jz      short loc_3B10
                mov     di, ds
                mov     si, cs:CURTDB
                cmp     di, si
                jnz     short loc_3B36
                pop     ax
                pop     di
                pop     si
                pop     ds
                pop     bp
                dec     bp
                retf
; ---------------------------------------------------------------------------

loc_3B36:                               ; CODE XREF: BOOTSCHEDULE+21↑j
                push    cx
                mov     cx, cs:LOCKTDB
                jcxz    short loc_3B42
                cmp     cx, di
                jnz     short loc_3BB5

loc_3B42:                               ; CODE XREF: BOOTSCHEDULE+30↑j
                push    es
                push    bx
                les     bx, cs:PINDOS
                cmp     byte ptr es:[bx], 0
                jnz     short loc_3B5A
                les     bx, cs:PERRMODE
                cmp     byte ptr es:[bx], 0
                jz      short loc_3B5F

loc_3B5A:                               ; CODE XREF: BOOTSCHEDULE+41↑j
                pop     bx
                pop     es
                pop     cx
                jmp     short loc_3B10
; ---------------------------------------------------------------------------

loc_3B5F:                               ; CODE XREF: BOOTSCHEDULE+4C↑j
                inc     cs:INSCHEDULER
                push    dx
                inc     byte ptr ds:8
                push    ds
                call    DELETETASK
                push    ds
                call    INSERTTASK
                dec     byte ptr ds:8
                cli
                mov     es, si
                xor     si, si
                cmp     word ptr es:7Eh, 4454h
                jnz     short loc_3B93
                mov     word ptr es:4, ss
                mov     es:2, sp
                mov     si, es
                push    si
                call    SAVESTATE

loc_3B93:                               ; CODE XREF: BOOTSCHEDULE+75↑j
                push    ds
                push    si
                call    RESTORESTATE
                mov     ss, word ptr ds:4
                mov     sp, ds:2
                mov     cs:CURTDB, ds
                dec     cs:INSCHEDULER
                sti
                cmp     word ptr ds:16h, 0
                jnz     short loc_3BBD

loc_3BB2:                               ; CODE XREF: BOOTSCHEDULE+D5↓j
                pop     dx
                pop     bx
                pop     es

loc_3BB5:                               ; CODE XREF: BOOTSCHEDULE+34↑j
                pop     cx
                pop     ax
                pop     di
                pop     si
                pop     ds
                pop     bp
                dec     bp
                retf
; ---------------------------------------------------------------------------

loc_3BBD:                               ; CODE XREF: BOOTSCHEDULE+A4↑j
                mov     ax, 10h
                mov     bp, sp
                add     bp, 10h
                mov     cx, 1
                xchg    cx, ds:6
                dec     cx
                push    cx
                push    ds
                push    ax
                push    si
                push    cx
                push    word ptr ds:12h
                call    dword ptr ds:14h
                pop     cx
                add     ds:6, cx
                or      ax, ax
                jz      short loc_3BB2
                push    ds
                call    DELETETASK
                push    ds
                call    INSERTTASK
                pop     dx
                pop     bx
                pop     es
                pop     cx
                jmp     near ptr BOOTSCHEDULE
BOOTSCHEDULE    endp ; sp-analysis failed
