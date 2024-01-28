
; =============== S U B R O U T I N E =======================================


INITPROFILE     proc near               ; CODE XREF: FASTBOOT+62↑p
                push    ds
                push    si
                push    di
                mov     di, 0
                call    BUFFERINIT
                call    UNLOCKBUFFER
                pop     di
                pop     si
                pop     ds
                assume ds:nothing
                retn
INITPROFILE     endp


; =============== S U B R O U T I N E =======================================

; Might also be called "ENDINIT" (two symbols on same byte :v)
; Attributes: bp-based frame

INITLOADER      proc near               ; CODE XREF: BOOTSTRAP+27E↑j

var_A           = word ptr -0Ah
var_4           = dword ptr -4
arg_0           = word ptr  4

                push    bp
                mov     bp, sp
                sub     sp, 0Ah
                push    di
                push    si
                sub     si, si
                mov     dx, [bp+arg_0]
                sub     ax, ax
                or      al, 80h
                mov     word ptr [bp+var_4], ax
                mov     word ptr [bp+var_4+2], dx
                les     bx, [bp+var_4]
                assume es:nothing
                inc     word ptr [bp+var_4]
                cmp     byte ptr es:[bx], 0
                jnz     short loc_8C21
                jmp     loc_8CB8
; ---------------------------------------------------------------------------

loc_8C21:                               ; CODE XREF: INITLOADER+21↑j
                mov     bx, word ptr [bp+var_4]
                inc     word ptr [bp+var_4]
                cmp     byte ptr es:[bx], 20h ; ' '
                jz      short loc_8C30
                jmp     loc_8CB8
; ---------------------------------------------------------------------------

loc_8C30:                               ; CODE XREF: INITLOADER+30↑j
                mov     bx, word ptr [bp+var_4]
                inc     word ptr [bp+var_4]
                cmp     byte ptr es:[bx], 2Dh ; '-'
                jnz     short loc_8CB8
                mov     si, word ptr [bp+var_4]
                jmp     short loc_8C44
; ---------------------------------------------------------------------------

loc_8C41:                               ; CODE XREF: INITLOADER+50↓j
                inc     word ptr [bp+var_4]

loc_8C44:                               ; CODE XREF: INITLOADER+44↑j
                les     bx, [bp+var_4]
                cmp     byte ptr es:[bx], 20h ; ' '
                jg      short loc_8C41
                cmp     byte ptr es:[bx], 20h ; ' '
                jnz     short loc_8C58
                inc     word ptr [bp+var_4]
                jmp     short loc_8C5B
; ---------------------------------------------------------------------------

loc_8C58:                               ; CODE XREF: INITLOADER+56↑j
                les     bx, [bp+var_4]

loc_8C5B:                               ; CODE XREF: INITLOADER+5B↑j
                mov     byte ptr es:[bx], 0
                sub     di, di
                jmp     short loc_8C67
; ---------------------------------------------------------------------------

loc_8C63:                               ; CODE XREF: INITLOADER+73↓j
                inc     word ptr [bp+var_4]
                inc     di

loc_8C67:                               ; CODE XREF: INITLOADER+66↑j
                les     bx, [bp+var_4]
                cmp     byte ptr es:[bx], 20h ; ' '
                jge     short loc_8C63
                jmp     short loc_8C73
; ---------------------------------------------------------------------------

loc_8C72:                               ; CODE XREF: INITLOADER+82↓j
                dec     di

loc_8C73:                               ; CODE XREF: INITLOADER+75↑j
                dec     word ptr [bp+var_4]
                les     bx, [bp+var_4]
                cmp     byte ptr es:[bx], 20h ; ' '
                jz      short loc_8C72
                mov     [bp+var_A], di
                inc     word ptr [bp+var_4]
                mov     bx, word ptr [bp+var_4]
                mov     byte ptr es:[bx], 0
                jmp     short loc_8C9B
; ---------------------------------------------------------------------------

loc_8C8E:                               ; CODE XREF: INITLOADER+A5↓j
                les     bx, [bp+var_4]
                mov     al, es:[bx-1]
                mov     es:[bx], al
                dec     word ptr [bp+var_4]

loc_8C9B:                               ; CODE XREF: INITLOADER+91↑j
                mov     ax, di
                dec     di
                or      ax, ax
                jnz     short loc_8C8E
                les     bx, [bp+var_4]
                inc     word ptr [bp+var_4]
                mov     al, byte ptr [bp+var_A]
                mov     es:[bx], al
                mov     bx, [bp+var_A]
                add     bx, word ptr [bp+var_4]
                mov     byte ptr es:[bx], 0Dh

loc_8CB8:                               ; CODE XREF: INITLOADER+23↑j
                                        ; INITLOADER+32↑j ...
                mov     ax, si
                pop     si
                pop     di
                mov     sp, bp
                pop     bp
                retn    2
INITLOADER      endp

; ---------------------------------------------------------------------------
                db 0C8h
                db 0A6h
                db 0C8h
                db 0A5h
                db 0C8h
                db 0A5h
                db 0C8h
                db 0A5h
                db  1Fh
                db  1Fh
                db  1Eh
                db  1Fh
                db  1Eh
                db  1Fh
                db  1Fh
                db  1Eh
                db  1Fh
                db  1Eh
                db  1Fh
SZEMMXXX        db 'EMMXXXX0'
SZERRWRONGDOSVERSION db 'Incorrect DOS version$'
                                        ; DATA XREF: INITDOSVARP+2EC↓o
SZERRDOSWRONGVERSION db 'DOS 2.0 or greater required$'
                                        ; DATA XREF: INITDOSVARP:incorrect_dos_version↓o
SZERRWRONGDISKTRANSFERADDR db 'Disk transfer address does not match$'
                                        ; DATA XREF: INITDOSVARP:wrong_dta_address↓o
SZERRCTRLCNOTMATCH db 'Control-C flag does not match$'
                                        ; DATA XREF: INITDOSVARP:wrong_ctrlc_flag↓o
SZERRCURRENTPDBNOTFOUND db 'CurrentPDB not found$'
                                        ; DATA XREF: INITDOSVARP:no_current_pdb↓o
SZERRCURRENTPDBNOTMATCH db 'CurrentPDB does not match$'
                                        ; DATA XREF: INITDOSVARP:wrong_current_pdb↓o
SZERRINT22HNOTFOUND db 'DOS int 22h not found$'
                                        ; DATA XREF: INITDOSVARP:no_int_22h_handler↓o
SZERRMODENOTMATCH db 'Error mode flag does not match$'
                                        ; DATA XREF: INITDOSVARP:wrong_error_mode_flag↓o
SZERRCURRENTDRIVENOTMATCH db 'Current drive does not match$'
                                        ; DATA XREF: INITDOSVARP:wrong_current_drive↓o
                db 0Dh,0Ah,'$'
; ---------------------------------------------------------------------------
                iret

; =============== S U B R O U T I N E =======================================

; ax -> pointer to error message
; Attributes: bp-based frame

BOOTFAILUREEXIT proc near               ; CODE XREF: INITDOSVARP+2F1↓p
                                        ; INITDOSVARP+2F7↓p ...

arg_2           = dword ptr  6

                push    bp
                mov     bp, sp
                push    ds
                mov     ah, 9
                lds     dx, [bp+4]
                int     21h             ; DOS - PRINT STRING
                                        ; DS:DX -> string terminated by "$"
                pop     ds
                mov     sp, bp
                pop     bp
                retn    4
BOOTFAILUREEXIT endp

; ---------------------------------------------------------------------------
SZUSER          db 'USER',0             ; DATA XREF: INITFWDREF+4B↓o
SZSYSTEM        db 'SYSTEM',0           ; DATA XREF: INITFWDREF+7B↓o
SZNO1           db '#1',0               ; DATA XREF: INITFWDREF+57↓o
                                        ; INITFWDREF+87↓o ...
SZNO2           db '#2',0               ; DATA XREF: INITFWDREF+69↓o
                                        ; INITFWDREF+99↓o
SZKEYBOARD      db 'KEYBOARD',0         ; DATA XREF: INITFWDREF+AB↓o
SZNO5           db '#5',0               ; DATA XREF: INITFWDREF+B7↓o

; =============== S U B R O U T I N E =======================================


INITFWDREF      proc far                ; CODE XREF: SLOWBOOT+6D↑p
                                        ; SLOWBOOT+86↑p ...
                push    si
                push    di
                push    cs
                pop     ds
                assume ds:cseg01
                mov     ax, 3520h
                int     21h             ; DOS - 2+ - GET INTERRUPT VECTOR
                                        ; AL = interrupt number
                                        ; Return: ES:BX = value of interrupt vector
                mov     word ptr PREVINT20PROC, bx ; ""
                mov     word ptr PREVINT20PROC+2, es ; ""
                mov     ax, 3521h
                int     21h             ; DOS - 2+ - GET INTERRUPT VECTOR
                                        ; AL = interrupt number
                                        ; Return: ES:BX = value of interrupt vector
                mov     word ptr PREVINT21PROC, bx
                mov     word ptr PREVINT21PROC+2, es
                mov     ax, 3524h
                int     21h             ; DOS - 2+ - GET INTERRUPT VECTOR
                                        ; AL = interrupt number
                                        ; Return: ES:BX = value of interrupt vector
                mov     word ptr PREVINT24PROC, bx
                mov     word ptr PREVINT24PROC+2, es
                mov     ax, 3527h
                int     21h             ; DOS - 2+ - GET INTERRUPT VECTOR
                                        ; AL = interrupt number
                                        ; Return: ES:BX = value of interrupt vector
                mov     word ptr PREVINT27PROC, bx ; ""
                mov     word ptr PREVINT27PROC+2, es ; ""
                mov     ah, 52h ; 'R'
                int     21h             ; DOS - 2+ internal - GET LIST OF LISTS
                                        ; Return: ES:BX -> DOS list of lists
                mov     ax, es:[bx+0Ch]
                mov     dx, es:[bx+0Eh]
                mov     word ptr PREVBCON, ax
                mov     word ptr PREVBCON+2, dx
                mov     bx, offset SZUSER ; "USER"
                push    cs
                push    bx
                nop
                push    cs
                call    near ptr GETMODULEHANDLE
                mov     si, ax
                mov     bx, offset SZNO1 ; "#1"
                push    si
                push    cs
                push    bx
                nop
                push    cs
                call    near ptr GETPROCADDRESS
                mov     word ptr PMBOXPROC, ax
                mov     word ptr PMBOXPROC+2, dx
                mov     bx, offset SZNO2 ; "#2"
                push    si
                push    cs
                push    bx
                nop
                push    cs
                call    near ptr GETPROCADDRESS
                mov     word ptr PEXITPROC, ax
                mov     word ptr PEXITPROC+2, dx
                mov     bx, offset SZSYSTEM ; "SYSTEM"
                push    cs
                push    bx
                nop
                push    cs
                call    near ptr GETMODULEHANDLE
                mov     si, ax
                mov     bx, offset SZNO1 ; "#1"
                push    si
                push    cs
                push    bx
                nop
                push    cs
                call    near ptr GETPROCADDRESS
                mov     word ptr PSYSPROC, ax
                mov     word ptr PSYSPROC+2, dx
                mov     bx, offset SZNO2 ; "#2"
                push    si
                push    cs
                push    bx
                nop
                push    cs
                call    near ptr GETPROCADDRESS
                mov     word ptr PTIMERPROC, ax
                mov     word ptr PTIMERPROC+2, dx
                mov     bx, offset SZKEYBOARD ; "KEYBOARD"
                push    cs
                push    bx
                nop
                push    cs
                call    near ptr GETMODULEHANDLE
                mov     si, ax
                mov     bx, offset SZNO5 ; "#5"
                push    si
                push    cs
                push    bx
                nop
                push    cs
                call    near ptr GETPROCADDRESS
                mov     word ptr PKEYPROC, ax
                mov     word ptr PKEYPROC+2, dx
                mov     bx, 55h ; 'U'
                push    cs
                push    bx
                mov     bx, offset CHECKFAREAST
                push    cs
                push    bx
                mov     bx, offset SZNO1 ; "#1"
                push    si
                push    cs
                push    bx
                nop
                push    cs
                call    near ptr GETPROCADDRESS
                push    dx
                push    ax
                retf
INITFWDREF      endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================

; Unreferenced, dead code

; Function Name: CheckFarEast
;
; Purpose: Checks if the operating system is running under a "far east" (Korean, Japanese, etc) locale.
;
; Parameters: None                          
;
; Returns: None. Internal FFAREAST kernel variable incremented (from 0) if true.
;
; Notes: Appears to be dead code (Check Win1.02, GDI and USER!)
CHECKFAREAST    proc near               ; DATA XREF: INITFWDREF+CE↑o
                mov     si, offset KEYINFO ; 'U'   ; load first word of KEYINFO
                lodsw
                cmp     al, ah          ; is the second byte of keyinfo lower or equal to the first?
                jbe     short is_far_east   ; if so, branch, set far est
                lodsw                   ; check second word
                cmp     al, ah          ; is the fourth byte of keyinfo above the third?
                ja      short far_east_check_done

is_far_east:                               ; CODE XREF: CHECKFAREAST+6↑j
                inc     FFAREAST        ; set ffareast

far_east_check_done:                               ; CODE XREF: CHECKFAREAST+B↑j
                pop     di              ; restore 
                pop     si
                retn                    ; go 
CHECKFAREAST    endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


TESTEMM         proc near               ; CODE XREF: INITDOSVARP:loc_91EB↓p
                push    ds
                xor     ax, ax
                mov     ds, ax
                les     di, dword ptr MSGCANNOTREADDRV+0Dh ; "rom drive "
                push    cs
                pop     ds
                mov     si, 8CD5h
                mov     di, 0Ah
                mov     cx, 8
                repe cmpsb
                jnz     short loc_8F30
                mov     ah, 40h ; '@'
                int     67h             ;  - LIM EMS - GET MANAGER STATUS
                                        ; Return: AH = status
                or      ah, ah
                jnz     short loc_8F30
                mov     ax, 4E03h
                int     67h             ;  - LIM EMS - GET OR SET PAGE MAP
                                        ; DS:SI -> array holding information
                                        ; ES:DI -> array to receive information
                                        ; if getting size of page-mapping array
                or      ah, ah
                jz      short loc_8F2C
                cmp     ah, 8Fh
                jnz     short loc_8F30
                mov     al, 17h

loc_8F2C:                               ; CODE XREF: TESTEMM+27↑j
                mov     cs:FEMM, al

loc_8F30:                               ; CODE XREF: TESTEMM+16↑j
                                        ; TESTEMM+1E↑j ...
                pop     ds
                assume ds:nothing
                retn
TESTEMM         endp


; =============== S U B R O U T I N E =======================================


INITDOSVARP     proc near               ; CODE XREF: BOOTSTRAP+D3↑p
                push    si
                push    di
                push    es
                push    ds
                push    cs
                pop     ds
                assume ds:cseg01
                mov     ax, 3521h       ; get the DOS int 21 handler
                int     21h             ; DOS - 2+ - GET INTERRUPT VECTOR
                                        ; AL = interrupt number
                                        ; Return: ES:BX = value of interrupt vector
                mov     word ptr PREVINT21PROC, bx ; move it to kernel data segment for later WINOLDAP
                mov     word ptr PREVINT21PROC+2, es
                mov     ah, 30h ; '0'
                int     21h             ; DOS - GET DOS VERSION
                                        ; Return: AL = major version number (00h for DOS 1.x)
                cmp     al, 2           ; DOS 1.x?
                jb      short loc_8F51
                cmp     al, 4           ; DOS 4.x or later (MT-DOS/MDOS4 check)
                jb      short loc_8F54

loc_8F51:                               ; CODE XREF: INITDOSVARP+19↑j
                jmp     incorrect_dos_version
; ---------------------------------------------------------------------------

loc_8F54:                               ; CODE XREF: INITDOSVARP+1D↑j
                mov     DOS_VERSION, al
                mov     DOS_REVISION, ah
                mov     DOS_OEM, bl
                mov     bx, 28h ; '('
                cmp     al, 3
                jb      short loc_8F71
                mov     bx, 38h ; '8'
                cmp     ah, 0
                jz      short loc_8F71
                mov     bx, 35h ; '5'

loc_8F71:                               ; CODE XREF: INITDOSVARP+32↑j
                                        ; INITDOSVARP+3A↑j
                mov     FILEENTRYSIZE, bx
                mov     ah, 52h ; 'R'
                int     21h             ; DOS - 2+ internal - GET LIST OF LISTS
                                        ; Return: ES:BX -> DOS list of lists
                lea     bx, [bx+4]
                mov     word ptr PFILETABLE, bx
                mov     word ptr PFILETABLE+2, es

loc_8F84:                               ; CODE XREF: INITDOSVARP+59↓j
                les     bx, es:[bx]
                cmp     word ptr es:[bx], 0FFFFh
                jnz     short loc_8F84
                mov     word ptr PSFTLINK, bx
                mov     word ptr PSFTLINK+2, es
                mov     ah, 35h ; '5'
                mov     al, 22h ; '"'
                int     21h             ; DOS - 2+ - GET INTERRUPT VECTOR
                                        ; AL = interrupt number
                                        ; Return: ES:BX = value of interrupt vector
                mov     ah, 25h ; '%'
                mov     al, 22h ; '"'
                mov     dx, 8DD6h
                int     21h             ; DOS - SET INTERRUPT VECTOR
                                        ; AL = interrupt number
                                        ; DS:DX = new vector to be used for specified interrupt
                xor     ax, ax
                mov     ds, ax
                mov     cx, cs
                mov     si, cs:INT22BASE
                cmp     [si], dx
                jnz     short loc_8FB8
                cmp     [si+2], cx
                jz      short loc_8FC6

loc_8FB8:                               ; CODE XREF: INITDOSVARP+7F↑j
                mov     si, 3C0h
                cmp     [si], dx
                jnz     short loc_8FC4
                cmp     [si+2], cx
                jz      short loc_8FC6

loc_8FC4:                               ; CODE XREF: INITDOSVARP+8B↑j
                xor     si, si

loc_8FC6:                               ; CODE XREF: INITDOSVARP+84↑j
                                        ; INITDOSVARP+90↑j
                mov     ax, es
                mov     ds, ax
                assume ds:nothing
                mov     dx, bx
                mov     ah, 25h ; '%'
                mov     al, 22h ; '"'
                int     21h             ; DOS - SET INTERRUPT VECTOR
                                        ; AL = interrupt number
                                        ; DS:DX = new vector to be used for specified interrupt
                mov     ax, cs
                mov     ds, ax
                assume ds:cseg01
                or      si, si
                jnz     short loc_8FDD
                jmp     no_int_22h_handler
; ---------------------------------------------------------------------------

loc_8FDD:                               ; CODE XREF: INITDOSVARP+A6↑j
                mov     INT22BASE, si
                cmp     DOS_VERSION, 3
                jb      short loc_9028
                cmp     DOS_REVISION, 0Ah
                jb      short loc_9064
                push    ds
                mov     ax, 5D06h
                int     21h             ; DOS - 3.1+ internal - GET ADDRESS OF DOS SWAPPABLE DATA AREA
                                        ; Return: CF set on error, CF clear if successful
                mov     ax, ds
                pop     ds
                assume ds:nothing
                mov     ds:40h, si
                mov     ds:42h, ax
                add     si, 0Ch
                mov     ds:2Ch, si
                mov     ds:2Eh, ax
                add     si, 4
                mov     ds:38h, si
                mov     ds:3Ah, ax
                add     si, 6
                mov     ds:3Ch, si
                mov     ds:3Eh, ax
                inc     si
                mov     ds:34h, si
                mov     ds:36h, ax
                jmp     loc_90AF
; ---------------------------------------------------------------------------

loc_9028:                               ; CODE XREF: INITDOSVARP+B4↑j
                cmp     byte ptr ds:51h, 19h
                jnz     short loc_9064
                mov     ah, 52h ; 'R'
                int     21h             ; DOS - 2+ internal - GET LIST OF LISTS
                                        ; Return: ES:BX -> DOS list of lists
                mov     ax, es
                mov     word ptr ds:2Ch, 0E2h
                mov     ds:2Eh, ax
                mov     word ptr ds:3Ch, 123h
                mov     ds:3Eh, ax
                mov     word ptr ds:40h, 126h
                mov     ds:42h, ax
                mov     word ptr ds:38h, 18Eh
                mov     ds:3Ah, ax
                mov     word ptr ds:34h, 12Bh
                mov     ds:36h, ax
                jmp     short loc_90AF
; ---------------------------------------------------------------------------

loc_9064:                               ; CODE XREF: INITDOSVARP+BB↑j
                                        ; INITDOSVARP+FB↑j
                mov     ah, 2Fh ; '/'
                int     21h             ; DOS - GET DISK TRANSFER AREA ADDRESS
                                        ; Return: ES:BX -> DTA
                mov     cx, bx
                mov     dx, es
                mov     ah, 52h ; 'R'
                int     21h             ; DOS - 2+ internal - GET LIST OF LISTS
                                        ; Return: ES:BX -> DOS list of lists
                cmp     bx, 22h ; '"'
                jnz     short loc_90BE
                mov     ax, es
                mov     byte ptr ds:51h, 5
                mov     word ptr ds:4Ch, 35h ; '5'
                mov     word ptr ds:40h, 19Bh
                mov     ds:42h, ax
                mov     word ptr ds:2Ch, 1B2h
                mov     ds:2Eh, ax
                mov     word ptr ds:38h, 14h
                mov     ds:3Ah, ax
                mov     word ptr ds:3Ch, 1BCh
                mov     ds:3Eh, ax
                mov     word ptr ds:34h, 174h
                mov     ds:36h, ax

loc_90AF:                               ; CODE XREF: INITDOSVARP+F3↑j
                                        ; INITDOSVARP+130↑j
                mov     ah, 34h ; '4'
                int     21h             ; DOS - 2+ internal - RETURN CritSectFlag (InDOS) POINTER
                mov     ds:30h, bx
                mov     word ptr ds:32h, es
                jmp     loc_91BC
; ---------------------------------------------------------------------------

loc_90BE:                               ; CODE XREF: INITDOSVARP+141↑j
                sub     bx, 1Bh
                cmp     es:[bx], cx
                jnz     short loc_90CC
                cmp     es:[bx+2], dx
                jz      short loc_90F3

loc_90CC:                               ; CODE XREF: INITDOSVARP+192↑j
                add     bx, 0Ah
                cmp     es:[bx], cx
                jnz     short loc_90DA
                cmp     es:[bx+2], dx
                jz      short loc_90F3

loc_90DA:                               ; CODE XREF: INITDOSVARP+1A0↑j
                cmp     byte ptr ds:50h, 3
                jnz     short loc_90F0
                add     bx, 202h
                cmp     es:[bx], cx
                jnz     short loc_90F0
                cmp     es:[bx+2], dx
                jz      short loc_90F3

loc_90F0:                               ; CODE XREF: INITDOSVARP+1AD↑j
                                        ; INITDOSVARP+1B6↑j
                jmp     wrong_dta_address
; ---------------------------------------------------------------------------

loc_90F3:                               ; CODE XREF: INITDOSVARP+198↑j
                                        ; INITDOSVARP+1A6↑j ...
                mov     ds:2Ch, bx
                mov     word ptr ds:2Eh, es
                mov     ah, 34h ; '4'
                int     21h             ; DOS - 2+ internal - RETURN CritSectFlag (InDOS) POINTER
                mov     ds:30h, bx
                mov     word ptr ds:32h, es
                mov     ah, 33h ; '3'
                mov     al, 0
                int     21h             ; DOS - EXTENDED CONTROL-BREAK CHECKING
                                        ; AL = 00h get state / 01h set state / 02h set AND get
                                        ; DL = 00h for OFF or 01h for ON
                cmp     byte ptr ds:50h, 3
                jnz     short loc_9120
                sub     bx, 1A8h
                cmp     es:[bx], dl
                jz      short loc_912B
                jmp     wrong_ctrlc_flag
; ---------------------------------------------------------------------------

loc_9120:                               ; CODE XREF: INITDOSVARP+1E0↑j
                add     bx, 5
                cmp     es:[bx], dl
                jz      short loc_912B
                jmp     wrong_ctrlc_flag
; ---------------------------------------------------------------------------

loc_912B:                               ; CODE XREF: INITDOSVARP+1E9↑j
                                        ; INITDOSVARP+1F4↑j
                mov     ds:34h, bx
                mov     word ptr ds:36h, es
                sub     bx, 2
                cmp     byte ptr ds:50h, 3
                jz      short loc_9142
                les     bx, ds:30h
                inc     bx

loc_9142:                               ; CODE XREF: INITDOSVARP+209↑j
                mov     ds:40h, bx
                mov     word ptr ds:42h, es
                les     bx, ds:30h
                add     bx, 5
                cmp     byte ptr ds:50h, 3
                jz      short loc_915B
                sub     bx, 8

loc_915B:                               ; CODE XREF: INITDOSVARP+224↑j
                mov     ds:3Ch, bx
                mov     word ptr ds:3Eh, es
                les     bx, ds:34h
                cld
                mov     dx, bx
                add     dx, 0C8h

loc_916E:                               ; CODE XREF: INITDOSVARP+24E↓j
                                        ; INITDOSVARP+259↓j
                inc     bx
                cmp     bx, dx
                jb      short loc_9176
                jmp     no_current_pdb
; ---------------------------------------------------------------------------

loc_9176:                               ; CODE XREF: INITDOSVARP+23F↑j
                mov     di, bx
                mov     si, 8CC2h
                mov     cx, 9
                repe cmpsb
                jnz     short loc_916E
                inc     di
                mov     si, 8CCBh
                mov     cx, 0Ah
                repe cmpsb
                jnz     short loc_916E
                mov     bx, di
                mov     ax, ds:10h
                cmp     byte ptr ds:50h, 3
                jz      short loc_91A9
                cmp     ax, es:[bx]
                jz      short loc_91B4
                add     bx, 4
                cmp     ax, es:[bx]
                jz      short loc_91B4
                jmp     short wrong_current_pdb
; ---------------------------------------------------------------------------
                db 90h
; ---------------------------------------------------------------------------

loc_91A9:                               ; CODE XREF: INITDOSVARP+265↑j
                mov     bx, 188h
                cmp     ax, es:[bx]
                jz      short loc_91B4
                jmp     short wrong_current_pdb
; ---------------------------------------------------------------------------
                align 2

loc_91B4:                               ; CODE XREF: INITDOSVARP+26A↑j
                                        ; INITDOSVARP+272↑j ...
                mov     ds:38h, bx
                mov     word ptr ds:3Ah, es

loc_91BC:                               ; CODE XREF: INITDOSVARP+189↑j
                les     bx, ds:38h
                mov     ax, ds:10h
                cmp     es:[bx], ax
                jnz     short wrong_current_pdb
                les     bx, ds:40h
                cmp     byte ptr es:[bx], 0
                jnz     short wrong_error_mode_flag
                mov     ah, 19h
                int     21h             ; DOS - GET DEFAULT DISK NUMBER
                mov     dl, al
                mov     ah, 0Eh
                int     21h             ; DOS - SELECT DISK
                                        ; DL = new default drive number (0 = A, 1 = B, etc.)
                                        ; Return: AL = number of logical drives
                cmp     al, 14h
                jnb     short loc_91EB
                xchg    al, dl
                les     bx, ds:3Ch
                cmp     es:[bx], al
                jnz     short wrong_current_drive

loc_91EB:                               ; CODE XREF: INITDOSVARP+2AC↑j
                call    TESTEMM
                mov     ax, 0FFFFh
                jmp     short loc_9236
; ---------------------------------------------------------------------------
                align 2

incorrect_dos_version:                  ; CODE XREF: INITDOSVARP:loc_8F51↑j
                mov     ax, offset SZERRDOSWRONGVERSION ; "DOS 2.0 or greater required$"
                jmp     short print_boot_error
; ---------------------------------------------------------------------------

wrong_dta_address:                      ; CODE XREF: INITDOSVARP:loc_90F0↑j
                mov     ax, offset SZERRWRONGDISKTRANSFERADDR ; "Disk transfer address does not match$"
                jmp     short print_boot_error
; ---------------------------------------------------------------------------

wrong_ctrlc_flag:                       ; CODE XREF: INITDOSVARP+1EB↑j
                                        ; INITDOSVARP+1F6↑j
                mov     ax, offset SZERRCTRLCNOTMATCH ; "Control-C flag does not match$"
                jmp     short print_boot_error
; ---------------------------------------------------------------------------

no_current_pdb:                         ; CODE XREF: INITDOSVARP+241↑j
                mov     ax, offset SZERRCURRENTPDBNOTFOUND ; "CurrentPDB not found$"
                jmp     short print_boot_error
; ---------------------------------------------------------------------------

wrong_current_pdb:                      ; CODE XREF: INITDOSVARP+274↑j
                                        ; INITDOSVARP+27F↑j ...
                mov     ax, offset SZERRCURRENTPDBNOTMATCH ; "CurrentPDB does not match$"
                jmp     short print_boot_error
; ---------------------------------------------------------------------------
                align 2

no_int_22h_handler:                     ; CODE XREF: INITDOSVARP+A8↑j
                mov     ax, offset SZERRINT22HNOTFOUND ; "DOS int 22h not found$"
                jmp     short print_boot_error
; ---------------------------------------------------------------------------
                align 2

wrong_error_mode_flag:                  ; CODE XREF: INITDOSVARP+29E↑j
                mov     ax, offset SZERRMODENOTMATCH ; "Error mode flag does not match$"
                jmp     short print_boot_error
; ---------------------------------------------------------------------------
                align 2

wrong_current_drive:                    ; CODE XREF: INITDOSVARP+2B7↑j
                mov     ax, offset SZERRCURRENTDRIVENOTMATCH ; "Current drive does not match$"

print_boot_error:                       ; CODE XREF: INITDOSVARP+2C5↑j
                                        ; INITDOSVARP+2CA↑j ...
                push    ax
                mov     ax, offset SZERRWRONGDOSVERSION ; "Incorrect DOS version$"
                push    cs
                push    ax
                call    BOOTFAILUREEXIT
                pop     ax
                push    cs
                push    ax
                call    BOOTFAILUREEXIT

print_string_terminator:
                mov     ax, 8DD3h
                push    cs
                push    ax
                call    BOOTFAILUREEXIT
                xor     ax, ax

loc_9236:                               ; CODE XREF: INITDOSVARP+2BF↑j
                pop     ds
                pop     es
                pop     di
                pop     si
                retn
INITDOSVARP     endp


; ---------------------------------------------------------------------------
                align 8
                db 4Dh, 2 dup(0FFh), 29h, 0Ch dup(0), 4Dh, 2 dup(0FFh)
                db 28h, 16h dup(0)
word_93FA       dw 0                    ; DATA XREF: BOOTSTRAP+54↑w
word_93FC       dw 0                    ; DATA XREF: BOOTSTRAP+4B↑w
word_93FE       dw 0                    ; DATA XREF: BOOTSTRAP+46↑w
                db 470h dup(0), 20h dup(0FFh)
cseg01          ends


                end BOOTSTRAP
