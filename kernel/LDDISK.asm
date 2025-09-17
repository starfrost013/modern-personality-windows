; ****** modern:personality project ******
; Reverse engineered code  © 2022-2025 starfrost. See licensing information in the licensing file
; Original code            © 1982-1986 Microsoft Corporation

; KERNEL.def: LDDISK.ASM - Provides filename parsing and disk I/O services.
INCLUDE KERNEL.inc
INCLUDE KDATA.inc

externNP GROWSFT
externNP PATHDRVDSDX
externNP APPEND
externNP APPENDFIRST
externNP CLOSEOPENFILES
externNP SHOWDIALOGBOX2

sBegin CODE

assumeS CS,CODE
assumeS DS,CODE


;
; External Entry #74 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

                PUBLIC ISFLOPPY
ISFLOPPY        proc near               ; CODE XREF: OPENFILE+163↑p
                                        ; OPENFILE+185↑p ...
                mov     bx, 1
                push    bx
                push    di
                call    cs:PSYSPROC
                cmp     al, 2
                ret
; ---------------------------------------------------------------------------

loc_2144:                               ; CODE XREF: OPENFILE+17C↑p
                mov     dx, 160h
                call    loc_2184
                push    cs
                pop     ds
                assume ds:_TEXT
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
                ret
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

                PUBLIC GETPURENAME
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
                ret
GETPURENAME     endp


; =============== S U B R O U T I N E =======================================


PARSEFILE       proc near               ; CODE XREF: OPENFILE+97↑p
                                        ; OPENFILE+1D2↑p
                cld
                xor     bp, bp
                cmp     byte ptr [si+1], 3Ah ; ':'
                jnz     short get_default_disknum
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

get_default_disknum:                               ; CODE XREF: PARSEFILE+7↑j
                mov     ah, 19h
                int     21h             ; DOS - GET DEFAULT DISK NUMBER

loc_21F6:                               ; CODE XREF: PARSEFILE+13↑j
                mov     dl, al
                inc     dl
                add     al, 41h ; 'A'
                mov     ah, 3Ah ; ':'
                stosw
                push    di
                mov     bx, 2F5Ch       ; '/\'
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

fileparse_start:                               ; CODE XREF: PARSEFILE+115↓j
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
                jz      short fileparse_filename_done
                cmp     cl, 0Ch
                ja      short fileparse_start_extension
                mov     al, cl
                sub     al, ah
                cmp     al, 4
                ja      short fileparse_start_extension
                jmp     fileparse_start
; ---------------------------------------------------------------------------

fileparse_filename_done:                               ; CODE XREF: PARSEFILE+106↑j
                cmp     cl, 8
                ja      short fileparse_start_extension
                jmp     fileparse_start
; ---------------------------------------------------------------------------

loc_22FA:                               ; CODE XREF: PARSEFILE+A8↑j
                                        ; PARSEFILE+B3↑j
                cmp     ch, 1
                jz      short loc_2303
                ja      short fileparse_start_extension
                mov     ah, cl

loc_2303:                               ; CODE XREF: PARSEFILE+123↑j
                mov     es:[di], al
                xchg    al, ah
                or      ax, ax
                jnz     short loc_230F

fileparse_start_extension:                               ; CODE XREF: PARSEFILE+10B↑j
                                        ; PARSEFILE+113↑j ...
                jmp     loc_2275
; ---------------------------------------------------------------------------

loc_230F:                               ; CODE XREF: PARSEFILE+130↑j
                cmp     ax, 8
                ja      short fileparse_start_extension
                pop     ax
                sub     dx, ax
                lea     ax, [bx+3]
                add     ax, cx
                add     ax, dx

locret_231E:                            ; CODE XREF: PARSEFILE+9E↑j
                ret
PARSEFILE       endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame
                PUBLIC SEARCHPATH
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
                ret    0Ah
SEARCHPATH      endp

sEnd CODE

end
