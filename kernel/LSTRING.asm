
;
; External Entry #90 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public LSTRLEN
LSTRLEN         proc far                ; CODE XREF: LOADMODULE+23↑p
                                        ; KERNELERROR+20↓p ...
                mov     bx, sp          ; KERNEL_90
                push    di
                les     di, ss:[bx+4]
                cld
                xor     ax, ax
                mov     cx, 0FFFFh
                repne scasb
                mov     ax, cx
                neg     ax
                dec     ax
                dec     ax
                pop     di
                retf    4
LSTRLEN         endp


; =============== S U B R O U T I N E =======================================


INTERNALSTRFUNC proc near               ; CODE XREF: LSTRCPY↓p
                                        ; LSTRCAT↓p ...
                pop     dx
                mov     bx, sp
                push    ds
                push    si
                push    di
                lds     si, ss:[bx+4]
                les     di, ss:[bx+8]
                cld
                jmp     dx
INTERNALSTRFUNC endp

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR LSTRCPY
;   ADDITIONAL PARENT FUNCTION LSTRCMP
;   ADDITIONAL PARENT FUNCTION ANSIPREV

loc_5284:                               ; CODE XREF: LSTRCPY+E↓j
                                        ; LSTRCMP:loc_52EE↓j ...
                pop     di
                pop     si
                pop     ds
                retf    8
; END OF FUNCTION CHUNK FOR LSTRCPY
;
; External Entry #88 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public LSTRCPY
LSTRCPY         proc far

; FUNCTION CHUNK AT 5284 SIZE 00000006 BYTES

                call    INTERNALSTRFUNC ; KERNEL_88

loc_528D:                               ; CODE XREF: LSTRCPY+7↓j
                                        ; LSTRCAT+B↓j
                lodsb
                stosb
                or      al, al
                jnz     short loc_528D
                mov     ax, di
                dec     ax
                mov     dx, es
                jmp     short loc_5284
LSTRCPY         endp ; sp-analysis failed

;
; External Entry #89 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public LSTRCAT
LSTRCAT         proc far
                call    INTERNALSTRFUNC ; KERNEL_89
                xor     ax, ax
                mov     cx, 0FFFFh
                repne scasb
                dec     di
                jmp     short loc_528D
LSTRCAT         endp

;
; External Entry #87 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public LSTRCMP
LSTRCMP         proc far

; FUNCTION CHUNK AT 5284 SIZE 00000006 BYTES

                call    INTERNALSTRFUNC ; KERNEL_87

loc_52AA:                               ; CODE XREF: LSTRCMP+36↓j
                xor     ax, ax
                cmp     [si], al
                jz      short loc_52E7
                cmp     es:[di], al
                jz      short loc_52E4
                lodsb
                call    ISKANJI
                jb      short loc_52C0
                mov     ah, [si]
                inc     si
                jmp     short loc_52C5
; ---------------------------------------------------------------------------

loc_52C0:                               ; CODE XREF: LSTRCMP+12↑j
                call    MYLOWER
                xor     ah, ah

loc_52C5:                               ; CODE XREF: LSTRCMP+17↑j
                mov     bx, ax
                mov     al, es:[di]
                inc     di
                call    ISKANJI
                jb      short loc_52D6
                mov     ah, es:[di]
                inc     di
                jmp     short loc_52DB
; ---------------------------------------------------------------------------

loc_52D6:                               ; CODE XREF: LSTRCMP+27↑j
                call    MYLOWER
                xor     ah, ah

loc_52DB:                               ; CODE XREF: LSTRCMP+2D↑j
                cmp     ax, bx
                jz      short loc_52AA
                mov     ax, 0
                jb      short loc_52ED

loc_52E4:                               ; CODE XREF: LSTRCMP+C↑j
                inc     ax
                jmp     short loc_52EE
; ---------------------------------------------------------------------------

loc_52E7:                               ; CODE XREF: LSTRCMP+7↑j
                cmp     byte ptr es:[di], 0
                jz      short loc_52EE

loc_52ED:                               ; CODE XREF: LSTRCMP+3B↑j
                dec     ax

loc_52EE:                               ; CODE XREF: LSTRCMP+3E↑j
                                        ; LSTRCMP+44↑j
                jmp     short loc_5284
LSTRCMP         endp ; sp-analysis failed

;
; External Entry #79 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public ANSIUPPER
ANSIUPPER       proc far
                mov     bx, sp          ; KERNEL_79
                push    di
                push    si
                les     di, ss:[bx+4]
                mov     cx, es
                mov     ax, di
                call    MYUPPER
                jcxz    short loc_530A
                call    MYANSIUPPER
                mov     dx, es
                mov     ax, ss:[bx+4]

loc_530A:                               ; CODE XREF: ANSIUPPER+F↑j
                pop     si
                pop     di
                retf    4
ANSIUPPER       endp

;
; External Entry #80 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public ANSILOWER
ANSILOWER       proc far
                mov     bx, sp          ; KERNEL_80
                push    di
                push    si
                les     di, ss:[bx+4]
                mov     cx, es
                mov     ax, di
                call    MYLOWER
                jcxz    short loc_5329
                call    MYANSILOWER
                mov     dx, es
                mov     ax, ss:[bx+4]

loc_5329:                               ; CODE XREF: ANSILOWER+F↑j
                pop     si
                pop     di
                retf    4
ANSILOWER       endp

;
; External Entry #78 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public ANSIPREV
ANSIPREV        proc far

; FUNCTION CHUNK AT 5284 SIZE 00000006 BYTES

                call    INTERNALSTRFUNC ; KERNEL_78
                cmp     si, di
                jz      short loc_5350
                dec     si
                cmp     cs:FFAREAST, 0
                jz      short loc_5350
                xchg    di, si
                inc     di

loc_5341:                               ; CODE XREF: ANSIPREV+1E↓j
                mov     dx, si
                lodsb
                call    ISKANJI
                jb      short loc_534A
                inc     si

loc_534A:                               ; CODE XREF: ANSIPREV+19↑j
                cmp     si, di
                jb      short loc_5341
                mov     si, dx

loc_5350:                               ; CODE XREF: ANSIPREV+5↑j
                                        ; ANSIPREV+E↑j
                mov     ax, si
                mov     dx, ds
                jmp     loc_5284
ANSIPREV        endp ; sp-analysis failed

; ---------------------------------------------------------------------------
                db 2 dup(90h)
;
; External Entry #77 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public ANSINEXT
ANSINEXT        proc far
                mov     bx, sp          ; KERNEL_77
                push    di
                les     di, ss:[bx+4]
                mov     al, es:[di]
                or      al, al
                jz      short loc_536E
                inc     di
                call    ISKANJI
                jb      short loc_536E
                inc     di

loc_536E:                               ; CODE XREF: ANSINEXT+C↑j
                                        ; ANSINEXT+12↑j
                mov     ax, di
                mov     dx, es
                pop     di
                retf    4
ANSINEXT        endp


; =============== S U B R O U T I N E =======================================


MYANSIUPPER     proc near               ; CODE XREF: ANSIUPPER+11↑p
                cld
                mov     si, di

loc_5379:                               ; CODE XREF: MYANSIUPPER+D↓j
                                        ; MYANSIUPPER+15↓j
                lods    byte ptr es:[si]
                call    ISKANJI
                jb      short loc_5385
                inc     si
                inc     di
                inc     di
                jmp     short loc_5379
; ---------------------------------------------------------------------------

loc_5385:                               ; CODE XREF: MYANSIUPPER+8↑j
                call    MYUPPER
                stosb
                or      al, al
                jnz     short loc_5379
                retn
MYANSIUPPER     endp


; =============== S U B R O U T I N E =======================================


MYANSILOWER     proc near               ; CODE XREF: ANSILOWER+11↑p
                cld
                mov     si, di

loc_5391:                               ; CODE XREF: MYANSILOWER+D↓j
                                        ; MYANSILOWER+15↓j
                lods    byte ptr es:[si]
                call    ISKANJI
                jb      short loc_539D
                inc     si
                inc     di
                inc     di
                jmp     short loc_5391
; ---------------------------------------------------------------------------

loc_539D:                               ; CODE XREF: MYANSILOWER+8↑j
                call    MYLOWER
                stosb
                or      al, al
                jnz     short loc_5391
                retn
MYANSILOWER     endp


; =============== S U B R O U T I N E =======================================


MYUPPER         proc near               ; CODE XREF: LOADEXEHEADER+142↑p
                                        ; CMPRESSTR+1C↑p ...
                cmp     al, 61h ; 'a'
                jb      short locret_53B8
                cmp     al, 7Ah ; 'z'
                jbe     short loc_53B6
                cmp     al, 0E0h
                jb      short locret_53B8
                cmp     al, 0FEh
                ja      short locret_53B8

loc_53B6:                               ; CODE XREF: MYUPPER+6↑j
                sub     al, 20h ; ' '

locret_53B8:                            ; CODE XREF: MYUPPER+2↑j
                                        ; MYUPPER+A↑j ...
                retn
MYUPPER         endp


; =============== S U B R O U T I N E =======================================


MYLOWER         proc near               ; CODE XREF: PROFILESTRINGTOLOWER:loc_4EC0↑p
                                        ; PROFILESTRINGTOLOWER+14↑p ...
                cmp     al, 41h ; 'A'
                jb      short locret_53CB
                cmp     al, 5Ah ; 'Z'
                jbe     short loc_53C9
                cmp     al, 0C0h
                jb      short locret_53CB
                cmp     al, 0DEh
                ja      short locret_53CB

loc_53C9:                               ; CODE XREF: MYLOWER+6↑j
                add     al, 20h ; ' '

locret_53CB:                            ; CODE XREF: MYLOWER+2↑j
                                        ; MYLOWER+A↑j ...
                retn
MYLOWER         endp


; =============== S U B R O U T I N E =======================================


ISKANJI         proc near               ; CODE XREF: LSTRCMP+F↑p
                                        ; LSTRCMP+24↑p ...
                cmp     cs:FFAREAST, 1
                jb      short locret_53F9
                mov     cx, word ptr cs:KEYINFO ; ""
                cmp     cl, ch
                ja      short loc_53F8
                cmp     al, cl
                jb      short loc_53E5
                cmp     al, ch
                jbe     short loc_53F6

loc_53E5:                               ; CODE XREF: ISKANJI+13↑j
                mov     cx, word ptr cs:KEYINFO+2 ; ""
                cmp     cl, ch
                ja      short loc_53F8
                cmp     al, cl
                jb      short locret_53F9
                cmp     al, ch
                ja      short loc_53F8

loc_53F6:                               ; CODE XREF: ISKANJI+17↑j
                clc
                retn
; ---------------------------------------------------------------------------

loc_53F8:                               ; CODE XREF: ISKANJI+F↑j
                                        ; ISKANJI+20↑j ...
                stc

locret_53F9:                            ; CODE XREF: ISKANJI+6↑j
                                        ; ISKANJI+24↑j
                retn
ISKANJI         endp



; =============== S U B R O U T I N E =======================================


APPENDFIRST     proc near               ; CODE XREF: PROMPT+2D↑p
                mov     cs:BUFPOS, 92h
APPENDFIRST     endp


; =============== S U B R O U T I N E =======================================


APPEND          proc near               ; CODE XREF: ISFLOPPY+18↑p
                                        ; PROMPT+B↑p ...
                push    si
                push    di
                mov     di, cs
                mov     es, di
                assume es:cseg01
                mov     di, cs:BUFPOS
                mov     si, dx

loc_4A3A:                               ; CODE XREF: APPEND+11↓j
                lodsb
                stosb
                or      al, al
                jnz     short loc_4A3A
                dec     di
                mov     cs:BUFPOS, di
                pop     di
                pop     si
                retn
APPEND          endp

