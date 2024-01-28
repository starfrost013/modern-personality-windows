

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
                call    cs:PREVINT21PROC
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
                call    cs:PREVINT21PROC
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
