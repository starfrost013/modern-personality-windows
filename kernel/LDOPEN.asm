
;
; External Entry #76 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public DELETEPATHNAME
DELETEPATHNAME  proc near
                pop     bx              ; KERNEL_76
                pop     cx
                mov     ax, 4100h
                push    ax
                push    cx
                push    bx
DELETEPATHNAME  endp ; sp-analysis failed

;
; External Entry #75 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public OPENPATHNAME
OPENPATHNAME    proc far                ; CODE XREF: FINDSEGSYMS+152↓p

var_52          = byte ptr -52h
arg_0           = word ptr  6
arg_2           = dword ptr  8

                inc     bp              ; KERNEL_75
                push    bp
                mov     bp, sp
                push    ds
                sub     sp, 50h
                push    si
                push    di
                lds     dx, [bp+arg_2]
                mov     ax, [bp+arg_0]
                or      ah, ah
                jnz     short loc_1ECA
                mov     ah, 3Dh ; '='

loc_1ECA:                               ; CODE XREF: OPENPATHNAME+12↑j
                mov     di, ax
                mov     ax, 4300h
                int     21h             ; DOS - 2+ - GET FILE ATTRIBUTES
                                        ; DS:DX -> ASCIZ file name or directory
                                        ; name without trailing slash
                jb      short loc_1ED9
                mov     ax, di
                int     21h             ; DOS -
                jnb     short loc_1EE4

loc_1ED9:                               ; CODE XREF: OPENPATHNAME+1D↑j
                lea     ax, [bp+var_52]
                push    ds
                push    dx
                push    ss
                push    ax
                push    di
                call    SEARCHPATH

loc_1EE4:                               ; CODE XREF: OPENPATHNAME+23↑j
                mov     bx, ax
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    6
OPENPATHNAME    endp

;
; External Entry #74 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public OPENFILE
OPENFILE        proc far                ; CODE XREF: LOADMODULE+92↑p
                                        ; LOADNRTABLE+38↑p ...

var_56          = byte ptr -56h
var_6           = word ptr -6
var_4           = word ptr -4
arg_0           = word ptr  6
arg_2           = dword ptr  8
arg_6           = dword ptr  0Ch

                inc     bp              ; KERNEL_74
                push    bp
                mov     bp, sp
                push    ds
                sub     sp, 54h
                push    si
                push    di
                mov     ax, [bp+arg_0]
                test    ah, 10h
                mov     ah, 3Dh ; '='
                jz      short loc_1F09
                mov     ah, 3Ch ; '<'

loc_1F09:                               ; CODE XREF: OPENFILE+12↑j
                mov     [bp+var_4], ax
                test    byte ptr [bp+arg_0+1], 80h
                jz      short loc_1F80
                mov     byte ptr [bp+var_6], 1
                lds     si, [bp+arg_2]
                or      si, si
                jnz     short loc_1F3A
                cmp     word ptr [si], 454Eh
                jnz     short loc_1F3A
                mov     ds, cs:HEXEHEAD
                mov     si, ds:0Ah
                mov     word ptr [bp+arg_2+2], ds
                mov     word ptr [bp+arg_2], si
                mov     word ptr [bp+arg_6+2], cs
                mov     word ptr [bp+arg_6], 138h

loc_1F3A:                               ; CODE XREF: OPENFILE+28↑j
                                        ; OPENFILE+2E↑j
                call    GROWSFT
                lea     dx, [si+8]
                xor     cx, cx
                mov     ax, [bp+var_4]
                call    near ptr PATHDRVDSDX
                jb      short loc_1F56
                pushf
                cli
                call    cs:PREVINT21PROC
                jnb     short loc_1F5B

loc_1F53:                               ; CODE XREF: OPENFILE+66↓j
                jmp     loc_1FDC
; ---------------------------------------------------------------------------

loc_1F56:                               ; CODE XREF: OPENFILE+55↑j
                mov     ax, 0Fh
                jmp     short loc_1F53
; ---------------------------------------------------------------------------

loc_1F5B:                               ; CODE XREF: OPENFILE+5E↑j
                mov     bx, ax
                mov     ax, 5700h
                int     21h             ; DOS - 2+ - GET FILE'S DATE/TIME
                                        ; BX = file handle
                mov     ax, bx
                push    ds
                pop     es
                test    byte ptr [bp+arg_0+1], 4
                jz      short loc_1F76
                cmp     [si+4], dx
                jnz     short loc_1F79
                cmp     [si+6], cx
                jnz     short loc_1F79

loc_1F76:                               ; CODE XREF: OPENFILE+77↑j
                jmp     loc_2106
; ---------------------------------------------------------------------------

loc_1F79:                               ; CODE XREF: OPENFILE+7C↑j
                                        ; OPENFILE+81↑j
                mov     ah, 3Eh ; '>'
                int     21h             ; DOS - 2+ - CLOSE A FILE WITH HANDLE
                                        ; BX = file handle
                jmp     loc_2037
; ---------------------------------------------------------------------------

loc_1F80:                               ; CODE XREF: OPENFILE+1D↑j
                lds     si, [bp+arg_6]
                les     di, [bp+arg_2]
                lea     di, [di+8]
                push    bp
                call    PARSEFILE
                mov     di, bp
                pop     bp
                test    byte ptr [bp+arg_0+1], 4
                jz      short loc_1F98
                xor     di, di

loc_1F98:                               ; CODE XREF: OPENFILE+A1↑j
                mov     [bp+var_6], di
                or      ax, ax
                jz      short loc_1FE0
                lds     si, [bp+arg_2]
                lea     si, [si+8]
                cmp     cs:FINT21, 0
                jz      short loc_1FB6
                push    ds
                push    si
                push    ds
                push    si
                call    cs:PKEYPROC

loc_1FB6:                               ; CODE XREF: OPENFILE+B8↑j
                test    byte ptr [bp+arg_0+1], 1
                jz      short loc_1FC1
                xor     bx, bx
                jmp     loc_2118
; ---------------------------------------------------------------------------

loc_1FC1:                               ; CODE XREF: OPENFILE+C7↑j
                mov     dx, si
                test    byte ptr [bp+arg_0+1], 10h
                jnz     short loc_1FD0
                mov     ax, 4300h
                int     21h             ; DOS - 2+ - GET FILE ATTRIBUTES
                                        ; DS:DX -> ASCIZ file name or directory
                                        ; name without trailing slash
                jb      short loc_1FDC

loc_1FD0:                               ; CODE XREF: OPENFILE+D4↑j
                xor     cx, cx
                mov     ax, [bp+var_4]
                int     21h             ; DOS -
                jb      short loc_1FDC
                jmp     loc_20CA
; ---------------------------------------------------------------------------

loc_1FDC:                               ; CODE XREF: OPENFILE:loc_1F53↑j
                                        ; OPENFILE+DB↑j ...
                cmp     al, 4
                jb      short loc_1FE3

loc_1FE0:                               ; CODE XREF: OPENFILE+AA↑j
                jmp     loc_20AC
; ---------------------------------------------------------------------------

loc_1FE3:                               ; CODE XREF: OPENFILE+EB↑j
                cmp     byte ptr [bp+var_6], 0
                jnz     short loc_2037
                lea     bx, [bp+var_56]
                mov     ax, [bp+var_4]
                push    ds
                push    dx
                push    ss
                push    bx
                push    ax
                call    SEARCHPATH
                cmp     ax, 0FFFFh
                jz      short loc_1FFF

loc_1FFC:                               ; CODE XREF: OPENFILE+142↓j
                jmp     loc_20B8
; ---------------------------------------------------------------------------

loc_1FFF:                               ; CODE XREF: OPENFILE+107↑j
                mov     cx, cs:HEXEHEAD
                jcxz    short loc_2037
                mov     ds, cx
                mov     si, ds:0Ah
                lea     si, [si+8]
                push    ss
                pop     es
                lea     di, [bp+var_56]

loc_2014:                               ; CODE XREF: OPENFILE+125↓j
                lodsb
                stosb
                or      al, al
                jnz     short loc_2014
                lea     di, [bp+var_56]
                call    GETPURENAME
                lds     si, [bp+arg_6]

loc_2023:                               ; CODE XREF: OPENFILE+134↓j
                lodsb
                stosb
                or      al, al
                jnz     short loc_2023
                push    ss
                pop     ds
                lea     dx, [bp+var_56]
                xor     cx, cx
                mov     ax, [bp+var_4]
                int     21h             ; DOS -
                jnb     short loc_1FFC

loc_2037:                               ; CODE XREF: OPENFILE+8A↑j
                                        ; OPENFILE+F4↑j ...
                lds     si, [bp+arg_2]
                lea     si, [si+8]
                test    byte ptr [bp+arg_0+1], 20h
                jz      short loc_20AC
                cmp     cs:FINT21, 0
                jz      short loc_20AC
                xor     bx, bx
                mov     bl, [si]
                sub     bl, 41h ; 'A'
                jb      short loc_20AC
                mov     di, bx
                call    ISFLOPPY
                jnz     short loc_2063
                cmp     byte ptr [bp+var_6], 0
                jnz     short loc_2096
                jmp     short loc_2083
; ---------------------------------------------------------------------------

loc_2063:                               ; CODE XREF: OPENFILE+166↑j
                test    byte ptr [bp+arg_0+1], 80h
                jnz     short loc_2074
                cmp     byte ptr [bp+var_6], 0
                jz      short loc_2074
                call    loc_2144
                jmp     short loc_20AC
; ---------------------------------------------------------------------------

loc_2074:                               ; CODE XREF: OPENFILE+174↑j
                                        ; OPENFILE+17A↑j
                mov     di, 0FFFFh

loc_2077:                               ; CODE XREF: OPENFILE+188↓j
                inc     di
                call    ISFLOPPY
                jnz     short loc_2077
                mov     ax, di
                add     al, 41h ; 'A'
                mov     [si], al

loc_2083:                               ; CODE XREF: OPENFILE+16E↑j
                les     di, [bp+arg_2]
                lea     di, [di+0Bh]
                mov     si, di
                call    GETPURENAME
                xchg    si, di

loc_2090:                               ; CODE XREF: OPENFILE+1A1↓j
                lodsb
                stosb
                or      al, al
                jnz     short loc_2090

loc_2096:                               ; CODE XREF: OPENFILE+16C↑j
                call    PROMPT
                jz      short loc_20AC
                lds     si, [bp+arg_2]
                lea     dx, [si+8]
                xor     cx, cx
                mov     ax, [bp+var_4]
                int     21h             ; DOS -
                jnb     short loc_20CA
                jmp     short loc_2037
; ---------------------------------------------------------------------------

loc_20AC:                               ; CODE XREF: OPENFILE:loc_1FE0↑j
                                        ; OPENFILE+14E↑j ...
                lds     si, [bp+arg_2]
                mov     [si+2], ax
                mov     ax, 0FFFFh
                jmp     short loc_212A
; ---------------------------------------------------------------------------
                align 2

loc_20B8:                               ; CODE XREF: OPENFILE:loc_1FFC↑j
                les     di, [bp+arg_2]
                lea     di, [di+8]
                push    ss
                pop     ds
                lea     si, [bp+var_56]
                push    ax
                push    bp
                call    PARSEFILE
                pop     bp
                pop     ax

loc_20CA:                               ; CODE XREF: OPENFILE+E6↑j
                                        ; OPENFILE+1B5↑j
                push    ax
                les     si, [bp+arg_2]
                lea     di, [si+8]
                mov     cx, 0FFFFh
                xor     al, al
                repne scasb
                neg     cx
                add     cx, 6
                mov     es:[si], cl
                cmp     cs:FINT21, 0
                jz      short loc_20FC
                mov     al, es:[si+8]
                or      al, 20h
                sub     al, 61h ; 'a'
                cbw
                mov     di, ax
                call    ISFLOPPY
                mov     ch, 0
                jz      short loc_20FC
                inc     ch

loc_20FC:                               ; CODE XREF: OPENFILE+1F3↑j
                                        ; OPENFILE+205↑j
                mov     es:[si+1], ch
                pop     bx
                mov     ax, 5700h
                int     21h             ; DOS - 2+ - GET FILE'S DATE/TIME
                                        ; BX = file handle

loc_2106:                               ; CODE XREF: OPENFILE:loc_1F76↑j
                mov     es:[si+6], cx
                mov     es:[si+4], dx
                test    byte ptr [bp+arg_0+1], 42h
                jz      short loc_2128
                mov     ah, 3Eh ; '>'
                int     21h             ; DOS - 2+ - CLOSE A FILE WITH HANDLE
                                        ; BX = file handle

loc_2118:                               ; CODE XREF: OPENFILE+CB↑j
                test    byte ptr [bp+arg_0+1], 2
                jz      short loc_2128
                lds     si, [bp+arg_2]
                lea     dx, [si+8]
                mov     ah, 41h ; 'A'
                int     21h             ; DOS - 2+ - DELETE A FILE (UNLINK)
                                        ; DS:DX -> ASCIZ pathname of file to delete (no wildcards allowed)

loc_2128:                               ; CODE XREF: OPENFILE+21F↑j
                                        ; OPENFILE+229↑j
                mov     ax, bx

loc_212A:                               ; CODE XREF: OPENFILE+1C2↑j
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    0Ah
OPENFILE        endp


; =============== S U B R O U T I N E =======================================


ISFLOPPY        proc near               ; CODE XREF: OPENFILE+163↑p
                                        ; OPENFILE+185↑p ...
                mov     bx, 1
                push    bx
                push    di
                call    cs:PSYSPROC
                cmp     al, 2
                retn
; ---------------------------------------------------------------------------

loc_2144:                               ; CODE XREF: OPENFILE+17C↑p
                mov     dx, 160h
                call    loc_2184
                push    cs
                pop     ds
                assume ds:cseg01
                mov     dx, 16Dh
                call    APPEND
                mov     bx, 153h
                mov     cx, 1030h
                jmp     short loc_217D
ISFLOPPY        endp


; =============== S U B R O U T I N E =======================================


PROMPT          proc near               ; CODE XREF: OPENFILE:loc_2096↑p
                mov     dx, 11Eh
                call    loc_2184
                push    cs
                pop     ds
                mov     dx, 126h
                call    APPEND
                mov     al, byte ptr DRVLET ; "X:"
                call    CLOSEOPENFILES
                mov     bx, 147h
                mov     cx, 1010h
                test    byte ptr [bp+7], 8
                jz      short loc_217D
                mov     cx, 1011h

loc_217D:                               ; CODE XREF: ISFLOPPY+21↑j
                                        ; PROMPT+1E↑j
                call    SHOWDIALOGBOX2
                mov     ax, 2
                retn
; ---------------------------------------------------------------------------

loc_2184:                               ; CODE XREF: ISFLOPPY+10↑p
                                        ; PROMPT+3↑p
                cld
                push    cs
                pop     ds
                call    APPENDFIRST
                les     bx, [bp+8]
                lea     si, [bx+8]
                mov     al, es:[si]
                mov     byte ptr DRVLET, al ; "X:"
                mov     cs:LASTDRIVESWAPPED, al
                mov     ax, es
                les     di, [bp+0Ch]
                cmp     [bp+0Eh], ax
                jnz     short loc_21AA
                cmp     di, bx
                jnz     short loc_21AA
                mov     di, si

loc_21AA:                               ; CODE XREF: PROMPT+48↑j
                                        ; PROMPT+4C↑j
                call    GETPURENAME
                push    es
                pop     ds
                assume ds:nothing
                mov     dx, di
                jmp     APPEND
PROMPT          endp


; =============== S U B R O U T I N E =======================================


GETPURENAME     proc near               ; CODE XREF: OPENFILE+12A↑p
                                        ; OPENFILE+198↑p ...
                cld
                xor     al, al
                mov     cx, 0FFFFh
                mov     bx, di
                repne scasb
                inc     cx
                inc     cx
                neg     cx

loc_21C2:                               ; CODE XREF: GETPURENAME+23↓j
                cmp     bx, di
                jz      short locret_21D9
                mov     al, es:[di-1]
                cmp     al, 5Ch ; '\'
                jz      short locret_21D9
                cmp     al, 2Fh ; '/'
                jz      short locret_21D9
                cmp     al, 3Ah ; ':'
                jz      short locret_21D9
                dec     di
                jmp     short loc_21C2
; ---------------------------------------------------------------------------

locret_21D9:                            ; CODE XREF: GETPURENAME+10↑j
                                        ; GETPURENAME+18↑j ...
                retn
GETPURENAME     endp


; =============== S U B R O U T I N E =======================================


PARSEFILE       proc near               ; CODE XREF: OPENFILE+97↑p
                                        ; OPENFILE+1D2↑p
                cld
                xor     bp, bp
                cmp     byte ptr [si+1], 3Ah ; ':'
                jnz     short loc_21F2
                lodsb
                inc     si
                or      al, 20h
                sub     al, 61h ; 'a'
                jb      short loc_21EF
                cmp     al, 19h
                jbe     short loc_21F6

loc_21EF:                               ; CODE XREF: PARSEFILE+F↑j
                jmp     loc_2276
; ---------------------------------------------------------------------------

loc_21F2:                               ; CODE XREF: PARSEFILE+7↑j
                mov     ah, 19h
                int     21h             ; DOS - GET DEFAULT DISK NUMBER

loc_21F6:                               ; CODE XREF: PARSEFILE+13↑j
                mov     dl, al
                inc     dl
                add     al, 41h ; 'A'
                mov     ah, 3Ah ; ':'
                stosw
                push    di
                mov     bx, 2F5Ch
                mov     al, [si]
                cmp     al, bh
                jz      short loc_2239
                cmp     al, bl
                jz      short loc_2239
                mov     al, bl
                stosb
                mov     cx, ds
                xchg    si, di
                mov     ax, es
                mov     ds, ax
                mov     ah, 47h ; 'G'
                int     21h             ; DOS - 2+ - GET CURRENT DIRECTORY
                                        ; DL = drive (0=default, 1=A, etc.)
                                        ; DS:SI points to 64-byte buffer area
                jb      short loc_2275
                mov     ds, cx
                xchg    si, di
                xor     al, al
                mov     cx, 0FFFFh
                repne scasb
                dec     di
                mov     al, es:[di-1]
                cmp     al, bh
                jz      short loc_2239
                cmp     al, bl
                jz      short loc_2239
                mov     al, bl
                stosb

loc_2239:                               ; CODE XREF: PARSEFILE+2D↑j
                                        ; PARSEFILE+31↑j ...
                xor     cx, cx
                mov     dx, di

loc_223D:                               ; CODE XREF: PARSEFILE+115↓j
                                        ; PARSEFILE+11D↓j
                lodsb
                cmp     al, bl
                jz      short loc_2246
                cmp     al, bh
                jnz     short loc_2280

loc_2246:                               ; CODE XREF: PARSEFILE+66↑j
                cmp     byte ptr es:[di-1], 3Ah ; ':'
                jz      short loc_2255
                cmp     [si], bl
                jz      short loc_2275
                cmp     [si], bh
                jz      short loc_2275

loc_2255:                               ; CODE XREF: PARSEFILE+71↑j
                inc     bp
                cmp     cl, ch
                jnz     short loc_227B
                jcxz    short loc_22D2
                cmp     cl, 2
                ja      short loc_2275
                dec     di
                dec     cl
                jz      short loc_2239
                mov     di, dx

loc_2268:                               ; CODE XREF: PARSEFILE+99↓j
                dec     di
                mov     al, es:[di-1]
                cmp     al, bl
                jz      short loc_2239
                cmp     al, 3Ah ; ':'
                jnz     short loc_2268

loc_2275:                               ; CODE XREF: PARSEFILE+42↑j
                                        ; PARSEFILE+75↑j ...
                pop     ax

loc_2276:                               ; CODE XREF: PARSEFILE:loc_21EF↑j
                xor     ax, ax
                jmp     locret_231E
; ---------------------------------------------------------------------------

loc_227B:                               ; CODE XREF: PARSEFILE+7E↑j
                mov     al, bl
                stosb
                jmp     short loc_2239
; ---------------------------------------------------------------------------

loc_2280:                               ; CODE XREF: PARSEFILE+6A↑j
                or      al, al
                jz      short loc_22FA
                cmp     al, 20h ; ' '
                jb      short loc_2275
                ja      short loc_2295

loc_228A:                               ; CODE XREF: PARSEFILE+B7↓j
                lodsb
                or      al, al
                jz      short loc_22FA
                cmp     al, 20h ; ' '
                jz      short loc_228A
                jmp     short loc_2275
; ---------------------------------------------------------------------------

loc_2295:                               ; CODE XREF: PARSEFILE+AE↑j
                cmp     al, 3Bh ; ';'
                jz      short loc_2275
                cmp     al, 3Ah ; ':'
                jz      short loc_2275
                cmp     al, 2Ch ; ','
                jz      short loc_2275
                cmp     al, 7Ch ; '|'
                jz      short loc_2275
                cmp     al, 2Bh ; '+'
                jz      short loc_2275
                cmp     al, 3Ch ; '<'
                jz      short loc_2275
                cmp     al, 3Eh ; '>'
                jz      short loc_2275
                cmp     al, 22h ; '"'
                jz      short loc_2275
                cmp     al, 5Bh ; '['
                jz      short loc_2275
                cmp     al, 5Dh ; ']'
                jz      short loc_2275
                cmp     al, 3Dh ; '='
                jz      short loc_2275
                cmp     al, 61h ; 'a'
                jb      short loc_22CB
                cmp     al, 7Ah ; 'z'
                ja      short loc_22CB
                add     al, 0E0h

loc_22CB:                               ; CODE XREF: PARSEFILE+E9↑j
                                        ; PARSEFILE+ED↑j
                inc     cl
                cmp     cl, 77h ; 'w'
                ja      short loc_2275

loc_22D2:                               ; CODE XREF: PARSEFILE+80↑j
                stosb
                cmp     al, 2Eh ; '.'
                jnz     short loc_22DD
                inc     ch
                mov     ah, cl
                dec     ah

loc_22DD:                               ; CODE XREF: PARSEFILE+FB↑j
                cmp     ch, 0
                jz      short loc_22F2
                cmp     cl, 0Ch
                ja      short loc_230C
                mov     al, cl
                sub     al, ah
                cmp     al, 4
                ja      short loc_230C
                jmp     loc_223D
; ---------------------------------------------------------------------------

loc_22F2:                               ; CODE XREF: PARSEFILE+106↑j
                cmp     cl, 8
                ja      short loc_230C
                jmp     loc_223D
; ---------------------------------------------------------------------------

loc_22FA:                               ; CODE XREF: PARSEFILE+A8↑j
                                        ; PARSEFILE+B3↑j
                cmp     ch, 1
                jz      short loc_2303
                ja      short loc_230C
                mov     ah, cl

loc_2303:                               ; CODE XREF: PARSEFILE+123↑j
                mov     es:[di], al
                xchg    al, ah
                or      ax, ax
                jnz     short loc_230F

loc_230C:                               ; CODE XREF: PARSEFILE+10B↑j
                                        ; PARSEFILE+113↑j ...
                jmp     loc_2275
; ---------------------------------------------------------------------------

loc_230F:                               ; CODE XREF: PARSEFILE+130↑j
                cmp     ax, 8
                ja      short loc_230C
                pop     ax
                sub     dx, ax
                lea     ax, [bx+3]
                add     ax, cx
                add     ax, dx

locret_231E:                            ; CODE XREF: PARSEFILE+9E↑j
                retn
PARSEFILE       endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

SEARCHPATH      proc near               ; CODE XREF: OPENPATHNAME+2D↑p
                                        ; OPENFILE+101↑p

var_4           = dword ptr -4
arg_0           = word ptr  4
arg_2           = dword ptr  6
arg_6           = dword ptr  0Ah

                push    bp
                mov     bp, sp
                sub     sp, 4
                les     di, [bp+arg_6]
                call    GETPURENAME
                mov     word ptr [bp+var_4], di
                mov     word ptr [bp+var_4+2], es
                lds     si, cs:PCURRENTPDB
                mov     ds, word ptr [si]
                mov     ds, word ptr ds:2Ch
                xor     si, si

loc_233E:                               ; CODE XREF: SEARCHPATH+3A↓j
                cmp     byte ptr [si], 0
                jz      short loc_2399
                lodsw
                cmp     ax, 4150h
                jnz     short loc_2354
                lodsw
                cmp     ax, 4854h
                jnz     short loc_2354
                lodsb
                cmp     al, 3Dh ; '='
                jz      short loc_235B

loc_2354:                               ; CODE XREF: SEARCHPATH+28↑j
                                        ; SEARCHPATH+2E↑j ...
                lodsb
                or      al, al
                jnz     short loc_2354
                jmp     short loc_233E
; ---------------------------------------------------------------------------

loc_235B:                               ; CODE XREF: SEARCHPATH+33↑j
                                        ; SEARCHPATH+78↓j
                les     di, [bp+arg_2]

loc_235E:                               ; CODE XREF: SEARCHPATH+47↓j
                lodsb
                stosb
                cmp     al, 3Bh ; ';'
                jz      short loc_2369
                or      al, al
                jnz     short loc_235E
                dec     si

loc_2369:                               ; CODE XREF: SEARCHPATH+43↑j
                mov     al, 5Ch ; '\'
                cmp     es:[di-2], al
                jnz     short loc_2372
                dec     di

loc_2372:                               ; CODE XREF: SEARCHPATH+50↑j
                mov     es:[di-1], al
                push    ds
                push    si
                lds     si, [bp+var_4]

loc_237B:                               ; CODE XREF: SEARCHPATH+60↓j
                lodsb
                stosb
                or      al, al
                jnz     short loc_237B
                lds     dx, [bp+arg_2]
                mov     ax, 4300h
                int     21h             ; DOS - 2+ - GET FILE ATTRIBUTES
                                        ; DS:DX -> ASCIZ file name or directory
                                        ; name without trailing slash
                jb      short loc_2390
                mov     ax, [bp+arg_0]
                int     21h             ; DOS -

loc_2390:                               ; CODE XREF: SEARCHPATH+6A↑j
                pop     si
                pop     ds
                jnb     short loc_239C
                cmp     byte ptr [si], 0
                jnz     short loc_235B

loc_2399:                               ; CODE XREF: SEARCHPATH+22↑j
                mov     ax, 0FFFFh

loc_239C:                               ; CODE XREF: SEARCHPATH+73↑j
                mov     sp, bp
                pop     bp
                retn    0Ah
SEARCHPATH      endp


;
; External Entry #98 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public GETLASTDISKCHANGE
GETLASTDISKCHANGE proc far
                xor     ax, ax          ; KERNEL_98
                xchg    al, cs:LASTDRIVESWAPPED
                retf
GETLASTDISKCHANGE endp

;
; External Entry #92 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public GETTEMPDRIVE
GETTEMPDRIVE    proc far                ; CODE XREF: GETTEMPFILENAME+F↓p
                mov     bx, sp          ; KERNEL_92
                push    si
                push    di
                mov     ax, ss:[bx+4]
                and     al, 7Fh
                jnz     short loc_23BC
                mov     ah, 19h
                int     21h             ; DOS - GET DEFAULT DISK NUMBER
                add     al, 41h ; 'A'

loc_23BC:                               ; CODE XREF: GETTEMPDRIVE+A↑j
                and     al, 5Fh
                test    byte ptr ss:[bx+4], 80h
                jnz     short loc_23E4
                sub     al, 41h ; 'A'
                cbw
                mov     si, ax
                xor     di, di

loc_23CC:                               ; CODE XREF: GETTEMPDRIVE+30↓j
                call    ISFLOPPY
                cmp     al, 3
                mov     dx, 1
                jz      short loc_23E0
                inc     di
                cmp     di, 19h
                jbe     short loc_23CC
                xor     dx, dx
                mov     di, si

loc_23E0:                               ; CODE XREF: GETTEMPDRIVE+2A↑j
                mov     ax, di
                add     al, 41h ; 'A'

loc_23E4:                               ; CODE XREF: GETTEMPDRIVE+19↑j
                mov     ah, 3Ah ; ':'
                pop     di
                pop     si
                retf    2
GETTEMPDRIVE    endp


; =============== S U B R O U T I N E =======================================


HEXTOA          proc near               ; CODE XREF: GETTEMPFILENAME+8E↓p
                                        ; GETTEMPFILENAME+94↓p
                mov     ah, al
                mov     cl, 4
                shr     al, cl
                and     ah, 0Fh
                add     ax, 3030h
                cmp     al, 39h ; '9'
                jbe     short loc_23FD
                add     al, 7

loc_23FD:                               ; CODE XREF: HEXTOA+E↑j
                cmp     ah, 39h ; '9'
                jbe     short locret_2405
                add     ah, 7

locret_2405:                            ; CODE XREF: HEXTOA+15↑j
                retn
HEXTOA          endp

;
; External Entry #97 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public GETTEMPFILENAME
GETTEMPFILENAME proc far

var_6           = word ptr -6
var_4           = word ptr -4
arg_0           = dword ptr  6
arg_4           = word ptr  0Ah
arg_6           = dword ptr  0Ch
arg_A           = word ptr  10h

                inc     bp              ; KERNEL_97
                push    bp
                mov     bp, sp
                push    ds
                sub     sp, 4
                push    si
                push    di
                push    [bp+arg_A]
                nop
                push    cs
                call    near ptr GETTEMPDRIVE
                mov     [bp+var_6], dx
                les     di, [bp+arg_0]
                stosw
                mov     ax, [bp+arg_A]
                test    al, 80h
                jnz     short loc_245F
                lds     si, cs:PCURRENTPDB
                mov     ds, word ptr [si]
                mov     ds, word ptr ds:2Ch
                xor     si, si

loc_2433:                               ; CODE XREF: GETTEMPFILENAME+47↓j
                lodsw
                or      al, al
                jz      short loc_2464
                cmp     ax, 4554h
                jnz     short loc_2448
                lodsw
                cmp     ax, 504Dh
                jnz     short loc_2448
                lodsb
                cmp     al, 3Dh ; '='
                jz      short loc_244F

loc_2448:                               ; CODE XREF: GETTEMPFILENAME+35↑j
                                        ; GETTEMPFILENAME+3B↑j ...
                lodsb
                or      al, al
                jnz     short loc_2448
                jmp     short loc_2433
; ---------------------------------------------------------------------------

loc_244F:                               ; CODE XREF: GETTEMPFILENAME+40↑j
                cmp     byte ptr [si+1], 3Ah ; ':'
                jnz     short loc_2457
                dec     di
                dec     di

loc_2457:                               ; CODE XREF: GETTEMPFILENAME+4D↑j
                                        ; GETTEMPFILENAME+57↓j
                lodsb
                or      al, al
                jz      short loc_2464
                stosb
                jmp     short loc_2457
; ---------------------------------------------------------------------------

loc_245F:                               ; CODE XREF: GETTEMPFILENAME+1E↑j
                mov     al, 7Eh ; '~'
                stosb
                jmp     short loc_246F
; ---------------------------------------------------------------------------

loc_2464:                               ; CODE XREF: GETTEMPFILENAME+30↑j
                                        ; GETTEMPFILENAME+54↑j
                mov     ax, 7E5Ch
                cmp     es:[di-1], al
                jnz     short loc_246E
                dec     di

loc_246E:                               ; CODE XREF: GETTEMPFILENAME+65↑j
                stosw

loc_246F:                               ; CODE XREF: GETTEMPFILENAME+5C↑j
                lds     si, [bp+arg_6]
                mov     cx, 3

loc_2475:                               ; CODE XREF: GETTEMPFILENAME+75↓j
                lodsb
                or      al, al
                jz      short loc_247D
                stosb
                loop    loc_2475

loc_247D:                               ; CODE XREF: GETTEMPFILENAME+72↑j
                mov     dx, [bp+arg_4]
                or      dx, dx
                jnz     short loc_248A
                mov     ah, 2Ch ; ','
                int     21h             ; DOS - GET CURRENT TIME
                                        ; Return: CH = hours, CL = minutes, DH = seconds
                                        ; DL = hundredths of seconds
                xor     dx, cx

loc_248A:                               ; CODE XREF: GETTEMPFILENAME+7C↑j
                                        ; GETTEMPFILENAME+8A↓j ...
                mov     [bp+var_4], dx
                jnz     short loc_2492
                inc     dx
                jmp     short loc_248A
; ---------------------------------------------------------------------------

loc_2492:                               ; CODE XREF: GETTEMPFILENAME+87↑j
                mov     al, dh
                call    HEXTOA
                stosw
                mov     al, dl
                call    HEXTOA
                stosw
                mov     ax, 542Eh
                stosw
                mov     ax, 504Dh
                stosw
                xor     ax, ax
                stosb
                cmp     [bp+arg_4], ax
                jnz     short loc_24F1
                lds     dx, [bp+arg_0]
                cmp     cs:DOS_VERSION, 3
                jb      short loc_24C7
                mov     ah, 5Bh ; '['
                xor     cx, cx
                int     21h             ; DOS - 3+ - CREATE NEW FILE
                                        ; DS:DX -> ASCIZ directory path name
                                        ; CX = file attribute
                jnb     short loc_24E3
                cmp     al, 50h ; 'P'
                jz      short loc_24CE
                jmp     short loc_24EC
; ---------------------------------------------------------------------------

loc_24C7:                               ; CODE XREF: GETTEMPFILENAME+B1↑j
                mov     ax, 4300h
                int     21h             ; DOS - 2+ - GET FILE ATTRIBUTES
                                        ; DS:DX -> ASCIZ file name or directory
                                        ; name without trailing slash
                jb      short loc_24D7

loc_24CE:                               ; CODE XREF: GETTEMPFILENAME+BD↑j
                sub     di, 9
                mov     dx, [bp+var_4]
                inc     dx
                jmp     short loc_248A
; ---------------------------------------------------------------------------

loc_24D7:                               ; CODE XREF: GETTEMPFILENAME+C6↑j
                cmp     al, 2
                jnz     short loc_24EC
                xor     cx, cx
                mov     ah, 3Ch ; '<'
                int     21h             ; DOS - 2+ - CREATE A FILE WITH HANDLE (CREAT)
                                        ; CX = attributes for file
                                        ; DS:DX -> ASCIZ filename (may include drive and path)
                jb      short loc_24EC

loc_24E3:                               ; CODE XREF: GETTEMPFILENAME+B9↑j
                mov     bx, ax
                mov     ah, 3Eh ; '>'
                int     21h             ; DOS - 2+ - CLOSE A FILE WITH HANDLE
                                        ; BX = file handle
                jmp     short loc_24F1
; ---------------------------------------------------------------------------
                align 2

loc_24EC:                               ; CODE XREF: GETTEMPFILENAME+BF↑j
                                        ; GETTEMPFILENAME+D3↑j ...
                xor     ax, ax
                mov     [bp+var_4], ax

loc_24F1:                               ; CODE XREF: GETTEMPFILENAME+A6↑j
                                        ; GETTEMPFILENAME+E3↑j
                mov     ax, [bp+var_4]
                mov     dx, [bp+var_6]
                pop     di
                pop     si
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    0Ch
GETTEMPFILENAME endp


; =============== S U B R O U T I N E =======================================