; Modern:Personality
; Original code © 1982-1986 Microsoft Corporation
; Time wasted reverse engineering © 2023-2024 starfrost
;
; int21.asm         January 27, 2024
; This code traps, detours, replaces, thunks, and does various incredibly cursed things to the Interrupt 21h DOS API.

; External Entry #102 into the Module
; Attributes (0001): Fixed Exported

; =============== S U B R O U T I N E =======================================


; Function Name: dos3call
;
; Purpose: Calls an MS-DOS 3.x API
;
; Parameters: regs -> parameters for INT21 call                         
;
; Returns: Whatever the DOS API call returned
;
; Notes: This function is called DOS3CALL as it is opposed to a call going out to Multitasking MS-DOS 4.0 (the early protected mode builds) or OS/2 aka Multitasking MS-DOS 5.0, which would be handled using static linking.
                public DOS3CALL
DOS3CALL        proc far
                int     21h             ; KERNEL_102
                retf
DOS3CALL        endp

;
; External Entry #103 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Function Name: NETBIOSCALL
;
; Purpose: Calls a NetBIOS call
;
; Parameters: regs -> parameters for NETBIOS call                         
;
; Returns: Whatever the DOS API call returned
;
; Notes: This function is called DOS3CALL as it is opposed to a call going out to Multitasking MS-DOS 4.0 (the early protected mode builds) or OS/2 aka Multitasking MS-DOS 5.0, which would be handled using static linking.
                public NETBIOSCALL
NETBIOSCALL     proc far
                int     5Ch             ; KERNEL_103
                retf
NETBIOSCALL     endp

; ---------------------------------------------------------------------------
word_3D72       dw 0                    ; DATA XREF: ENABLEDOS+6↓w
                                        ; DISABLEDOS+12↓w ...
word_3D74       dw 0                    ; DATA XREF: INT21HANDLER+25↓w
                                        ; INT21HANDLER+35↓r ...
                db 0
                db 0
                db 0
                db 0

; TODO: Convert to STRUCTURE
; three byte structure
; 0         start
; then a series of 3 byte entries
; 1         BYTE        function number in AH reg
; 2         WORD        pointer to function within this code segment that handles it when called within Windows
INT21_HOOK_TABLE db 0                   ; DATA XREF: INT21HANDLER+A4↓w
                                        ; INT21HANDLER:loc_413F↓r ...
                                        ; Int 21h hook table. Re-implements DOS API for windows use.
                                        ; 3 byte format:
                                        ; [BYTE] int 21h function ID
                                        ; [WORD PTR] ptr to function that handles it in kernel code seg
                db 0
                db 2                    ; Int 21/AH=02h - DOS 1+ - WRITE CHARACTER TO STANDARD OUTPUT
                dw offset DOSPrintCharHook
                db 9                    ; Int 21/AH=09h - DOS 1+ - WRITE STRING TO STANDARD OUTPUT
                dw offset DOSPrintStringHook
                db 40h                  ; Int 21/AH=40h - DOS 2+ - WRITE - WRITE TO FILE OR DEVICE
                dw offset DOSWriteHook
                db 3Eh                  ; Int 21/AH=3Eh - DOS 2+ - CLOSE - CLOSE FILE
                dw offset DOSGeneralFileHook
                db 42h                  ; Int 21/AH=42h - DOS 2+ - LSEEK - SET CURRENT FILE POSITION
                dw offset DOSGeneralFileHook
                db 45h                  ; Int 21/AH=45h - DOS 2+ - DUP - DUPLICATE FILE HANDLE
                dw offset DOSGeneralFileHook
                db 46h                  ; Int 21/AH=46h - DOS 2+ - DUP2, FORCEDUP - FORCE DUPLICATE FILE HANDLE
                dw offset DOSGeneralFileHook
                db 57h                  ; Int 21/AX=5700h - DOS 2+ - GET FILE'S LAST-WRITTEN DATE AND TIME
                                        ; Int 21/AX=5701h - DOS 2+ - SET FILE'S LAST-WRITTEN DATE AND TIME
                dw offset DOSGeneralFileHook
                db 5Ch                  ; Int 21/AH=5Ch - DOS 3.0+ - FLOCK - RECORD LOCKING
                dw offset DOSGeneralFileHook
                db 39h                  ; Int 21/AH=39h - DOS 2+ - MKDIR - CREATE SUBDIRECTORY
                dw offset DOSGeneralFileHook2
                db 3Ah                  ; Int 21/AH=3Ah - DOS 2+ - RMDIR - REMOVE SUBDIRECTORY
                dw offset DOSGeneralFileHook2
                db 3Ch                  ; Int 21/AH=3Ch - DOS 2+ - CREAT - CREATE OR TRUNCATE FILE
                dw offset DOSGeneralFileHook2
                db 3Dh                  ; Int 21/AH=3Dh - DOS 2+ - OPEN - OPEN EXISTING FILE
                dw offset DOSGeneralFileHook2
                db 41h                  ; Int 21/AH=41h - DOS 2+ - UNLINK - DELETE FILE
                dw offset DOSGeneralFileHook2
                db 43h                  ; Int 21/AX=4300h - DOS 2+ - GET FILE ATTRIBUTES
                                        ; Int 21/AX=4301h - DOS 2+ - CHMOD - SET FILE ATTRIBUTES
                dw offset DOSGeneralFileHook2
                db 4Eh                  ; Int 21/AH=4Eh - DOS 2+ - FINDFIRST - FIND FIRST MATCHING FILE
                dw offset DOSGeneralFileHook2
                db 56h                  ; Int 21/AH=56h - DOS 2+ - RENAME - RENAME FILE
                dw offset DOSRenameHook
                db 5Ah                  ; Int 21/AH=5Ah - DOS 3.0+ - CREATE TEMPORARY FILE
                dw offset DOSGeneralFileHook2
                db 5Bh                  ; Int 21/AH=5Bh - DOS 3.0+ - CREATE NEW FILE
                dw offset DOSGeneralFileHook2
                db 47h                  ; Int 21/AH=47h - DOS 2+ - CWD - GET CURRENT DIRECTORY
                dw offset DOSCwdHook
                db 36h                  ; Int 21/AH=36h - DOS 2+ - GET FREE DISK SPACE
                dw offset DOSDiskHook
                db 0Fh                  ; Int 21/AH=0Fh - DOS 1+ - OPEN FILE USING FCB
                dw offset DOSFcbHook
                db 11h                  ; Int 21/AH=11h - DOS 1+ - FIND FIRST MATCHING FILE USING FCB
                dw offset DOSFcbHook
                db 13h                  ; Int 21/AH=13h - DOS 1+ - DELETE FILE USING FCB
                dw offset DOSFcbHook
                db 16h                  ; Int 21/AH=16h - DOS 1+ - CREATE OR TRUNCATE FILE USING FCB
                dw offset DOSFcbHook
                db 17h                  ; Int 21/AH=17h - DOS 1+ - RENAME FILE USING FCB
                dw offset DOSFcbHook
                db 23h                  ; Int 21/AH=23h - DOS 1+ - GET FILE SIZE FOR FCB
                dw offset DOSFcbHook
                db 5Fh                  ; Int 21/AX=5F00h - DOS 3.1+ network - GET REDIRECTION MODE
                                        ; Int 21/AX=5F01h - DOS 3.1+ network - SET REDIRECTION MODE
                                        ; Int 21/AX=5F02h - DOS 3.1+ network - GET REDIRECTION LIST ENTRY
                                        ; Int 21/AX=5F03h - DOS 3.1+ network - REDIRECT DEVICE
                                        ; Int 21/AX=5F04h - DOS 3.1+ network - CANCEL REDIRECTION
                dw offset DOSNetRedirectorHook
                db 32h                  ; Int 21/AH=32h - DOS 2+ - GET DOS DRIVE PARAMETER BLOCK FOR SPECIFIC DRIVE
                dw offset DOSDiskHook
                db 60h                  ; Int 21/AH=60h - DOS 3.0+ - TRUENAME - CANONICALIZE FILENAME OR PATH
                dw offset DOSTruenameHook
                db 6                    ; Int 21/AH=06h - DOS 1+ - DIRECT CONSOLE OUTPUT
                                        ; Int 21/AH=06h/DL=FFh - DOS 1+ - DIRECT CONSOLE INPUT
                dw offset DOSDirectOutHook
                db 0Bh                  ; Int 21/AH=0Bh - DOS 1+ - GET STDIN STATUS
                dw offset DOSStdinHook
                db 44h                  ; Int 21/AX=4400h - DOS 2+ - IOCTL - GET DEVICE INFORMATION
                                        ; Int 21/AX=4401h - DOS 2+ - IOCTL - SET DEVICE INFORMATION
                                        ; Int 21/AX=4402h - DOS 2+ - IOCTL - READ FROM CHARACTER DEVICE CONTROL CHANNEL
                                        ; Int 21/AX=4403h - DOS 2+ - IOCTL - WRITE TO CHARACTER DEVICE CONTROL CHANNEL
                                        ; Int 21/AX=4404h - DOS 2+ - IOCTL - READ FROM BLOCK DEVICE CONTROL CHANNEL
                                        ; Int 21/AX=4405h - DOS 2+ - IOCTL - WRITE TO BLOCK DEVICE CONTROL CHANNEL
                                        ; Int 21/AX=4406h - DOS 2+ - IOCTL - GET INPUT STATUS
                                        ; Int 21/AX=4407h - DOS 2+ - IOCTL - GET OUTPUT STATUS
                                        ; Int 21/AX=4408h - DOS 3.0+ - IOCTL - CHECK IF BLOCK DEVICE REMOVABLE
                                        ; Int 21/AX=4409h - DOS 3.1+ - IOCTL - CHECK IF BLOCK DEVICE REMOTE
                                        ; Int 21/AX=440Ah - DOS 3.1+ - IOCTL - CHECK IF HANDLE IS REMOTE
                                        ; Int 21/AX=440Bh - DOS 3.1+ - IOCTL - SET SHARING RETRY COUNT
                                        ; Int 21/AX=440Ch - DOS 3.2+ - IOCTL - GENERIC CHARACTER DEVICE REQUEST
                                        ; Int 21/AX=440Dh - DOS 3.2+ - IOCTL - GENERIC BLOCK DEVICE REQUEST
                dw offset DOSIoctlHook
                db 7                    ; Int 21/AH=07h - DOS 1+ - DIRECT CHARACTER INPUT, WITHOUT ECHO
                dw offset DOSDirectNoEchoHook
                db 8                    ; Int 21/AH=08h - DOS 1+ - CHARACTER INPUT WITHOUT ECHO
                dw offset DOSStdInNoEchoHook
                db 0Ah                  ; Int 21/AH=0Ah - DOS 1+ - BUFFERED INPUT
                dw offset DOSBufferedInputHook
                db 0Ch                  ; Int 21/AH=0Ch - DOS 1+ - FLUSH BUFFER AND READ STANDARD INPUT
                dw offset DOSFlushBufferStdinHook
                db 1                    ; Int 21/AH=01h - DOS 1+ - READ CHARACTER FROM STANDARD INPUT, WITH ECHO
                dw offset DOSStdinHook
                db 3Fh                  ; Int 21/AH=3Fh - DOS 2+ - READ - READ FROM FILE OR DEVICE
                dw offset DOSReadHook
                db 0Eh                  ; Int 21/AH=0Eh - DOS 1+ - SELECT DEFAULT DRIVE
                dw offset DOSSelectDefaultDriveHook
                db 3Bh                  ; Int 21/AH=3Bh - DOS 2+ - CHDIR - SET CURRENT DIRECTORY
                dw offset DOSChdirHook
                db 25h                  ; Int 21/AH=25h - DOS 1+ - SET INTERRUPT VECTOR
                dw offset DOSSetInterruptVectorHook
                db 48h                  ; Int 21/AH=48h - DOS 2+ - ALLOCATE MEMORY
                dw offset DOSAllocMemoryHook
                db 49h                  ; Int 21/AH=49h - DOS 2+ - FREE MEMORY
                dw offset DOSFreeMemoryHook
                db 4Ah                  ; Int 21/AH=4Ah - DOS 2+ - RESIZE MEMORY BLOCK
                dw offset DOSResizeMemoryHook
                db 4Bh                  ; Int 21/AH=4Bh - DOS 2+ - EXEC - LOAD AND/OR EXECUTE PROGRAM
                dw offset DOSExecHook
                db 0                    ; Int 21/AH=00h - DOS 1+ - TERMINATE PROGRAM
                dw offset DOSTerminateOldHook
                db 4Ch                  ; Int 21/AH=4Ch - DOS 2+ - EXIT - TERMINATE WITH RETURN CODE
                dw offset DOSTerminateHook
                db 31h                  ; Int 21/AH=31h - DOS 2+ - TERMINATE AND STAY RESIDENT
                dw offset DOSTSRHook
; Stores the last value of AH (and therefore the most recently called "major" INT21 function number)  sent to INT21HANDLER.
; Has no other purpose.
LAST_INT21_FUNCTION_NUMBER       db 0                    ; DATA XREF: INT21HANDLER+3↓w
                dw offset loc_4296
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
                db 0
;
; External Entry #101 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public NOHOOKDOSCALL
NOHOOKDOSCALL   proc far
                pushf                   ; KERNEL_101
                cli
                call    cs:PREVINT21PROC
                retf
NOHOOKDOSCALL   endp

;
; External Entry #41 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public ENABLEDOS
ENABLEDOS       proc far                ; CODE XREF: ENABLEINT21+D↓p
                push    si              ; KERNEL_41
                mov     si, 3D7Ch
                mov     dx, si
                xchg    si, cs:word_3D72
                cmp     si, dx
                jnz     short loc_3E46
                jmp     loc_3EE7
; ---------------------------------------------------------------------------

loc_3E46:                               ; CODE XREF: ENABLEDOS+D↑j
                les     bx, cs:PCNTCFLAG
                xor     ax, ax
                xchg    al, es:[bx]
                mov     cs:FBREAK, al
                les     bx, cs:PCURRENTPDB
                push    word ptr es:[bx]
                mov     bx, cs:TOPPDB
                mov     ah, 50h ; 'P'
                int     21h             ; DOS - 2+ internal - SET PSP SEGMENT
                                        ; BX = segment address of new PSP

loc_3E65:                               ; CODE XREF: ENABLEDOS+3C↓j
                mov     ah, 6
                mov     dl, 0FFh
                pushf
                cli
                call    cs:PREVINT21PROC
                jnz     short loc_3E65
                pop     bx
                mov     ah, 50h ; 'P'
                int     21h             ; DOS - 2+ internal - SET PSP SEGMENT
                                        ; BX = segment address of new PSP
                cmp     si, 3DD6h
                jz      short loc_3E96
                mov     ah, 52h ; 'R'
                int     21h             ; DOS - 2+ internal - GET LIST OF LISTS
                                        ; Return: ES:BX -> DOS list of lists
                mov     ax, 48BEh
                xchg    ax, es:[bx+0Ch]
                mov     word ptr cs:PREVBCON, ax
                mov     ax, cs
                xchg    ax, es:[bx+0Eh]
                mov     word ptr cs:PREVBCON+2, ax

loc_3E96:                               ; CODE XREF: ENABLEDOS+47↑j
                mov     ax, 3524h
                int     21h             ; DOS - 2+ - GET INTERRUPT VECTOR
                                        ; AL = interrupt number
                                        ; Return: ES:BX = value of interrupt vector
                mov     word ptr cs:PREVINT24PROC, bx
                mov     word ptr cs:PREVINT24PROC+2, es
                push    ds
                push    cs
                pop     ds
                assume ds:cseg01
                mov     dx, 48E2h
                mov     ax, 2524h
                int     21h             ; DOS - SET INTERRUPT VECTOR
                                        ; AL = interrupt number
                                        ; DS:DX = new vector to be used for specified interrupt
                mov     bx, 2
                xor     ax, ax
                push    bx
                push    ax
                call    cs:PSYSPROC
                push    cs
                pop     ds
                mov     bx, 3E12h
                xor     cx, cx

loc_3EC3:                               ; CODE XREF: ENABLEDOS+B0↓j
                push    cx
                push    bx
                mov     dx, 1
                push    dx
                push    cx
                call    cs:PSYSPROC
                pop     bx
                pop     cx
                mov     byte ptr [bx], 0
                cmp     ax, 2
                jnb     short loc_3EDF
                or      dx, dx
                jz      short loc_3EDF
                mov     [bx], dl

loc_3EDF:                               ; CODE XREF: ENABLEDOS+A3↑j
                                        ; ENABLEDOS+A7↑j
                inc     bx
                inc     cx
                cmp     cx, 1Ah
                jb      short loc_3EC3
                pop     ds
                assume ds:nothing

loc_3EE7:                               ; CODE XREF: ENABLEDOS+F↑j
                pop     si
                retf
ENABLEDOS       endp

;
; External Entry #42 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public DISABLEDOS
DISABLEDOS      proc far                ; CODE XREF: DISABLEINT21+11↓p

arg_0           = byte ptr  6

                inc     bp              ; KERNEL_42
                push    bp
                mov     bp, sp
                push    ds
                mov     bx, 2
                mov     ax, 1
                push    bx
                push    ax
                call    cs:PSYSPROC
                mov     cs:word_3D72, 3DD6h
                lds     dx, cs:PREVINT24PROC
                mov     ax, 2524h
                int     21h             ; DOS - SET INTERRUPT VECTOR
                                        ; AL = interrupt number
                                        ; DS:DX = new vector to be used for specified interrupt
                mov     dl, cs:FBREAK
                mov     ax, 3301h
                int     21h             ; DOS - EXTENDED CONTROL-BREAK CHECKING
                                        ; AL = 00h get state / 01h set state / 02h set AND get
                                        ; DL = 00h for OFF or 01h for ON
                cmp     [bp+arg_0], 0
                jnz     short loc_3F34
                mov     cs:word_3D72, 3DF1h
                mov     ah, 52h ; 'R'
                int     21h             ; DOS - 2+ internal - GET LIST OF LISTS
                                        ; Return: ES:BX -> DOS list of lists
                lds     ax, cs:PREVBCON
                mov     es:[bx+0Ch], ax
                mov     word ptr es:[bx+0Eh], ds

loc_3F34:                               ; CODE XREF: DISABLEDOS+31↑j
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
DISABLEDOS      endp


; =============== S U B R O U T I N E =======================================


ENABLEINT21     proc near               ; CODE XREF: SLOWBOOT+89↓p
                                        ; FASTBOOT+3E8↓p
                mov     al, 1
                xchg    al, cs:FINT21
                or      al, al
                jnz     short locret_3F75
                nop
                push    cs
                call    near ptr ENABLEDOS
                xor     bx, bx
                mov     es, bx
                assume es:cseg01
                mov     bx, 80h
                cli
                mov     word ptr es:[bx], 408Ch
                mov     word ptr es:[bx+2], cs
                mov     word ptr es:[bx+4], offset INT21HANDLER
                mov     word ptr es:[bx+6], cs
                mov     word ptr es:[bx+1Ch], offset INT27HANDLER
                mov     word ptr es:[bx+1Eh], cs
                sti

locret_3F75:                            ; CODE XREF: ENABLEINT21+9↑j
                retn
ENABLEINT21     endp


; =============== S U B R O U T I N E =======================================


DISABLEINT21    proc near               ; CODE XREF: EXITKERNEL+24↓p
                xor     ax, ax
                xchg    al, cs:FINT21
                or      al, al
                jz      short locret_3FC4
                cli
                xor     ax, ax
                push    ax
                nop
                push    cs
                call    near ptr DISABLEDOS
                xor     bx, bx
                mov     es, bx
                mov     bx, 80h
                mov     ax, word ptr cs:PREVINT20PROC ; ""
                mov     dx, word ptr cs:PREVINT20PROC+2 ; ""
                mov     es:[bx], ax     ; ES:[BX] contains ISR
                mov     es:[bx+2], dx
                mov     ax, word ptr cs:PREVINT21PROC
                mov     dx, word ptr cs:PREVINT21PROC+2
                mov     es:[bx+4], ax
                mov     es:[bx+6], dx
                mov     ax, word ptr cs:PREVINT27PROC ; ""
                mov     dx, word ptr cs:PREVINT27PROC+2 ; ""
                mov     es:[bx+1Ch], ax
                mov     es:[bx+1Eh], dx
                sti

locret_3FC4:                            ; CODE XREF: DISABLEINT21+9↑j
                retn
DISABLEINT21    endp

;
; External Entry #2 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public EXITKERNEL
EXITKERNEL      proc near               ; CODE XREF: FATALEXIT+10B↓p
                                        ; BOOTSTRAP+291↓p ...
                mov     si, sp          ; KERNEL_2
                mov     si, ss:[si+4]
                xor     ax, ax
                mov     es, ax
                mov     bx, 0FCh
                mov     ax, word ptr cs:PREVINT3FPROC
                mov     es:[bx], ax
                mov     ax, word ptr cs:PREVINT3FPROC+2
                mov     es:[bx+2], ax
                cmp     word ptr cs:PREVINT21PROC+2, 0
                jz      short loc_3FEC
                call    DISABLEINT21

loc_3FEC:                               ; CODE XREF: EXITKERNEL+22↑j
                mov     ax, 0C00h
                int     21h             ; DOS - CLEAR KEYBOARD BUFFER
                                        ; AL must be 01h, 06h, 07h, 08h, or 0Ah.
                mov     bx, cs:HEADPDB

loc_3FF6:                               ; CODE XREF: EXITKERNEL+4A↓j
                mov     es, bx
                assume es:nothing
                mov     ah, 50h ; 'P'
                int     21h             ; DOS - 2+ internal - SET PSP SEGMENT
                                        ; BX = segment address of new PSP
                mov     cx, 14h

loc_3FFF:                               ; CODE XREF: EXITKERNEL+41↓j
                mov     bx, cx
                dec     bx
                mov     ah, 3Eh ; '>'
                int     21h             ; DOS - 2+ - CLOSE A FILE WITH HANDLE
                                        ; BX = file handle
                loop    loc_3FFF
                mov     bx, es:42h
                or      bx, bx
                jnz     short loc_3FF6
                les     bx, cs:PSFTLINK
                mov     cx, es
                jcxz    short loc_4025
                mov     word ptr es:[bx], 0FFFFh
                mov     word ptr es:[bx+2], 0

loc_4025:                               ; CODE XREF: EXITKERNEL+53↑j
                cmp     word ptr cs:PSWAPHOOK+2, 0
                jz      short loc_4036
                xor     ax, ax
                push    ax
                push    ax
                call    cs:PSWAPHOOK

loc_4036:                               ; CODE XREF: EXITKERNEL+66↑j
                mov     ax, si
                mov     ah, 4Ch ; 'L'
                int     21h             ; DOS - 2+ - QUIT WITH EXIT CODE (EXIT)
EXITKERNEL      endp                    ; AL = exit code

;
; External Entry #99 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public GETLPERRMODE
GETLPERRMODE    proc far
                mov     ax, word ptr cs:PERRMODE ; KERNEL_99
                mov     dx, word ptr cs:PERRMODE+2
                retf
GETLPERRMODE    endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

PDB_CALL_SYSTEM_ENTRY proc far

var_s4          = word ptr  4
arg_0           = word ptr  0Ah

                push    ds
                push    bp
                push    ax
                mov     bp, sp
                xor     ax, ax
                mov     ds, ax
                assume ds:cseg01
                mov     ds, word ptr PREVINT3FPROC
                assume ds:nothing
                mov     ax, [bp+var_s4]
                cli
                mov     ds:3D78h, ax
                mov     ax, [bp+8]
                mov     ds:3D76h, ax
                mov     ax, [bp+arg_0]
                mov     ds:3D74h, ax
                pop     ax
                pop     bp
                add     sp, 8
                pushf
                push    word ptr ds:3D76h
                push    word ptr ds:3D74h
                push    ds
                mov     word ptr ds:3D76h, offset INT21HANDLER
                push    word ptr ds:3D76h
                mov     ds, word ptr ds:3D78h
                sti
                mov     ah, cl
                retf
PDB_CALL_SYSTEM_ENTRY endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================

; Function Name: Int27Handler
;
; Purpose: Handles INT 27 (legacy, DOS 1.x, Terminate and Stay Resident function) 
;
; Parameters: None                     
;
; Returns: See Int21Handler
;
; Notes: Simply calls INT21HANDLER with function number 31 (Terminate and Stay Resident)
INT27HANDLER    proc near               ; DATA XREF: ENABLEINT21+2B↑o
                mov     ax, 3100h               ; set up DOS API number to 31h (Terminate and Stay Resident)
                jmp     short INT21HANDLER      ; call DOS API thunk handler
INT27HANDLER    endp


; =============== S U B R O U T I N E =======================================

; Function Name: Int20Handler
;
; Purpose: Handles INT 20 (legacy, DOS 1.x, Terminate function) 
;
; Parameters: CS - Code segment of program to terminate. (PSP must be at zero)  
;                      
; Returns: See Int21Handler
;
; Notes: Simply calls INT21HANDLER with function number 0 (Legacy Terminate)
INT20HANDLER    proc near
                xor     ax, ax                  ; set ax to 0 (INT 21h,ah=0) DOS 1.x terminate program
INT20HANDLER    endp


; =============== S U B R O U T I N E =======================================


; Function Name: Int21Handler
;
; Purpose: Handles Windows' insane trapping of MS-DOS INT 21h functions
;
; Parameters: ah,al,bh,bl... = Int21 Function Parameters 
;                      
; Returns: To be determine
;
; Notes: A lot of crazy shit is done here.
;        What does this do when it's run after a DISABLEINT21 call???
INT21HANDLER    proc near               ; CODE XREF: INT27HANDLER+3↑j
                                        ; INT21HANDLER:loc_415B↓j
                                        ; DATA XREF: ...
                inc     bp
                push    bp
                push    ds
                mov     cs:LAST_INT21_FUNCTION_NUMBER, ah
                mov     bp, cs:word_3D72
                sub     bp, 3

loc_409E:                               ; CODE XREF: INT21HANDLER+17↓j
                add     bp, 3
                cmp     ah, cs:[bp+0]
                jnz     short loc_409E
                push    word ptr cs:[bp+1]
                mov     bp, sp
                add     bp, 4
                sti
                retn
; ---------------------------------------------------------------------------

loc_40B2:                               ; CODE XREF: DOSIoctlHook+16↓p
                                        ; DOSIoctlHook:DOSWriteHook↓p ...
                cli
                pop     cs:word_3D74
                push    dx
                push    es
                push    bx
                push    ax
                push    cx
                push    si
                push    di
                and     byte ptr [bp+6], 0FEh
                push    cs:word_3D74
                cld
                sti
                retn
; ---------------------------------------------------------------------------

loc_40CB:                               ; CODE XREF: INT21HANDLER+A1↓p
                                        ; DOSIoctlHook:loc_4410↓p ...
                cli
                pop     cs:word_3D74
                pop     di
                pop     si
                pop     cx
                pop     ax
                pop     bx
                pop     es
                pop     dx
                pop     ds
                pop     bp
                dec     bp
                jmp     cs:word_3D74
; ---------------------------------------------------------------------------

DOSTSRHook:                             ; DATA XREF: cseg01:3E0D↑o
                mov     ah, 1Bh
                jmp     short loc_40E7
; ---------------------------------------------------------------------------

loc_40E4:                               ; CODE XREF: DOSIoctlHook+2E↓p
                                        ; DOSIoctlHook+3E↓p ...
                or      ah, 80h

loc_40E7:                               ; CODE XREF: INT21HANDLER+54↑j
                                        ; DOSIoctlHook+67↓p ...
                push    ds
                pop     es
                mov     ds, cs:CURTDB
                cmp     word ptr ds:7Eh, 4454h
                jnz     short locret_415E
                cmp     word ptr ds:1Eh, 0
                jz      short locret_415E
                mov     di, ss
                cmp     di, ds:4
                jnz     short loc_410B
                call    dword ptr ds:1Ch
                jmp     short loc_412C
; ---------------------------------------------------------------------------

loc_410B:                               ; CODE XREF: INT21HANDLER+75↑j
                push    bp
                mov     si, sp
                cli
                mov     ss, word ptr ds:4
                mov     sp, ds:2
                sti
                mov     bp, sp
                add     bp, 10h
                call    dword ptr ds:1Ch
                mov     ds:2, sp
                cli
                mov     ss, di
                mov     sp, si
                sti
                pop     bp

loc_412C:                               ; CODE XREF: INT21HANDLER+7B↑j
                jcxz    short locret_415E
                pop     ax
                call    loc_40CB
                mov     word ptr cs:INT21_HOOK_TABLE, sp
                int     23h             ; DOS - CONTROL "C" EXIT ADDRESS
                                        ; Return: return via RETF 2 with CF set
                                        ; DOS will abort program with errorlevel 0
                                        ; else
                                        ; interrupted DOS call continues
                pushf
                pop     cs:word_3D74

loc_413F:
                cmp     sp, word ptr cs:INT21_HOOK_TABLE
                jz      short loc_415B
                add     sp, 2
                cmp     sp, word ptr cs:INT21_HOOK_TABLE
                jnz     short loc_4158
                push    cs:word_3D74
                popf
                jnb     short loc_415B

loc_4158:                               ; CODE XREF: INT21HANDLER+C0↑j
                mov     ax, 4C00h

loc_415B:                               ; CODE XREF: INT21HANDLER+B6↑j
                                        ; INT21HANDLER+C8↑j
                jmp     INT21HANDLER
; ---------------------------------------------------------------------------

locret_415E:                            ; CODE XREF: INT21HANDLER+66↑j
                                        ; INT21HANDLER+6D↑j ...
                retn
; ---------------------------------------------------------------------------

DOSNetRedirectorHook:                   ; DATA XREF: cseg01:3DCE↑o
                cmp     ax, 5F03h
                jnz     short loc_41DC  ; these are all handlers for int21 function
                cmp     bl, 4
                jnz     short loc_41DC
                cmp     byte ptr [si], 0
                jz      short loc_41DC
                push    dx
                mov     dx, si
                call    near ptr PATHDRVDSDX
                pop     dx
                jnb     short loc_41DC
                push    word ptr [si]
                mov     byte ptr [si], 24h ; '$'
                pushf
                cli
                call    cs:PREVINT21PROC
                pop     word ptr [si]
                jmp     loc_4541
; ---------------------------------------------------------------------------

DOSTruenameHook:                        ; DATA XREF: cseg01:3DD4↑o
                push    dx
                mov     dx, si
                call    near ptr PATHDRVDSDX
                pop     dx
                jnb     short loc_41DC
                push    word ptr [si]
                mov     byte ptr [si], 24h ; '$'
                pushf
                cli
                call    cs:PREVINT21PROC
                pop     word ptr [si]
                jmp     loc_4541
; ---------------------------------------------------------------------------

DOSGeneralFileHook2:                    ; DATA XREF: cseg01:3D98↑o
                                        ; cseg01:3D9B↑o ...
                call    near ptr PATHDRVDSDX
                jnb     short loc_41DC
                call    near ptr PREVINT21RETURN_1
                jmp     loc_4541
; ---------------------------------------------------------------------------

DOSDiskHook:                            ; DATA XREF: cseg01:3DB9↑o
                                        ; cseg01:3DD1↑o
                call    sub_425B
                jnb     short loc_41DC
                call    PREVINT21RETURN_2
                jmp     loc_44E6
; ---------------------------------------------------------------------------

DOSCwdHook:                             ; DATA XREF: cseg01:3DB6↑o
                call    sub_425B
                jnb     short loc_41DC
                call    PREVINT21RETURN_2
                jmp     loc_4541
; ---------------------------------------------------------------------------

DOSFcbHook:                             ; DATA XREF: cseg01:3DBC↑o
                                        ; cseg01:3DBF↑o ...
                push    dx
                push    si
                mov     si, dx
                cmp     byte ptr [si], 0FFh
                jnz     short loc_41CF
                add     si, 7

loc_41CF:                               ; CODE XREF: INT21HANDLER+13C↑j
                mov     dl, [si]
                or      dl, dl
                jz      short loc_41DA
                call    sub_425B
                jb      short loc_41DF

loc_41DA:                               ; CODE XREF: INT21HANDLER+145↑j
                pop     si
                pop     dx

loc_41DC:                               ; CODE XREF: INT21HANDLER+D4↑j
                                        ; INT21HANDLER+D9↑j ...
                jmp     loc_4296
; ---------------------------------------------------------------------------

loc_41DF:                               ; CODE XREF: INT21HANDLER+14A↑j
                push    dx
                mov     dx, si
                mov     byte ptr [si], 0F0h
                pushf
                cli
                call    cs:PREVINT21PROC
                pop     dx
                mov     [si], dl
                pop     si
                pop     dx
                jmp     loc_44E6
; ---------------------------------------------------------------------------

DOSRenameHook:                          ; DATA XREF: cseg01:3DAD↑o
                call    near ptr PATHDRVDSDX
                jb      short loc_420A
                xchg    di, dx
                push    ds
                push    es
                pop     ds
                pop     es
                call    near ptr PATHDRVDSDX
                xchg    di, dx
                push    ds
                push    es
                pop     ds
                pop     es
                jnb     short loc_41DC

loc_420A:                               ; CODE XREF: INT21HANDLER+169↑j
                push    word ptr es:[di]
                mov     byte ptr es:[di], 24h ; '$'
                call    near ptr PREVINT21RETURN_1
                pop     word ptr es:[di]
                jmp     loc_4541
INT21HANDLER    endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


PATHDRVDSDX     proc far                ; CODE XREF: OPENFILE+52↑p
                                        ; INT21HANDLER+E3↑p ...
                push    si
                push    dx
                mov     si, dx
                mov     dx, [si]
                or      dl, dl
                jz      short loc_4238
                or      dh, dh
                jz      short loc_4238
                cmp     dh, 3Ah ; ':'
                jnz     short loc_4238
                or      dl, 20h
                sub     dl, 60h ; '`'
                call    sub_425B
                jmp     short loc_4239
; ---------------------------------------------------------------------------

loc_4238:                               ; CODE XREF: PATHDRVDSDX+8↑j
                                        ; PATHDRVDSDX+C↑j ...
                clc

loc_4239:                               ; CODE XREF: PATHDRVDSDX+1C↑j
                pop     dx
                pop     si
                retn
PATHDRVDSDX     endp


; =============== S U B R O U T I N E =======================================


PREVINT21RETURN_1 proc far              ; CODE XREF: INT21HANDLER+119↑p
                                        ; INT21HANDLER+183↑p ...
                push    si              ; ======== THIS IS THE START ========
                                        ; ====== OF INTERRUPT HANDLERS ======
                mov     si, dx
                push    word ptr [si]
                mov     byte ptr [si], 24h ; '$'
                pushf
                cli
                call    cs:PREVINT21PROC
                pop     word ptr [si]
                pop     si
                retn
PREVINT21RETURN_1 endp


; =============== S U B R O U T I N E =======================================


PREVINT21RETURN_2 proc near             ; CODE XREF: INT21HANDLER+124↑p
                                        ; INT21HANDLER+12F↑p ...
                push    dx
                mov     dl, 0F0h
                pushf
                cli
                call    cs:PREVINT21PROC
                pop     dx

nullsub_3:                              ; CODE XREF: SftThing+B↓j
                retn
PREVINT21RETURN_2 endp


; =============== S U B R O U T I N E =======================================


sub_425B        proc near               ; CODE XREF: INT21HANDLER:DOSDiskHook↑p
                                        ; INT21HANDLER:DOSCwdHook↑p ...
                push    bx
                push    dx
                mov     bx, 3E12h
                cmp     dl, 1Ah
                ja      short loc_4276
                or      dl, dl
                jz      short loc_4276
                dec     dl
                xor     dh, dh
                add     bx, dx
                cmp     byte ptr cs:[bx], 0
                stc
                jnz     short loc_4277

loc_4276:                               ; CODE XREF: sub_425B+8↑j
                                        ; sub_425B+C↑j
                clc

loc_4277:                               ; CODE XREF: sub_425B+19↑j
                pop     dx
                pop     bx
                retn
sub_425B        endp


; =============== S U B R O U T I N E =======================================


sub_427A        proc near               ; CODE XREF: DOSIoctlHook:loc_43B9↓p
                push    ax
                call    sub_4336
                jmp     short loc_4292
sub_427A        endp


; =============== S U B R O U T I N E =======================================


sub_4280        proc near               ; CODE XREF: DOSIoctlHook:DOSFlushBufferStdinHook↓p
                                        ; DOSDirectNoEchoHook↓p ...
                push    ax
                xor     ax, ax
                call    sub_4338
                jmp     short loc_4292
sub_4280        endp


; =============== S U B R O U T I N E =======================================


SftThing        proc near               ; CODE XREF: SftThing+16↓j
                                        ; SftThing+20↓j
                jmp     jmp_previous_int21
; ---------------------------------------------------------------------------

loc_428B:                               ; CODE XREF: DOSIoctlHook:loc_4458↓p
                                        ; DOSPrintStringHook↓p ...
                push    ax
                mov     ax, 1
                call    sub_4338

loc_4292:                               ; CODE XREF: sub_427A+4↑j
                                        ; sub_4280+6↑j
                pop     ax
                jz      short nullsub_3
                pop     ds

loc_4296:                               ; CODE XREF: INT21HANDLER:loc_41DC↑j
                                        ; DATA XREF: cseg01:3E10↑o
                cmp     ah, 29h ; ')'
                jb      short loc_42AA
                cmp     ah, 30h ; '0'
                jbe     short SftThing
                cmp     ah, 50h ; 'P'
                jb      short loc_42AA
                cmp     ah, 51h ; 'Q'
                jbe     short SftThing

loc_42AA:                               ; CODE XREF: SftThing+11↑j
                                        ; SftThing+1B↑j ...
                mov     ds, cs:CURTDB
                test    byte ptr ds:3Ah, 40h
                jnz     short loc_4325
                cmp     word ptr ds:7Eh, 4454h
                jnz     short loc_4325
                push    ax
                push    bx
                push    dx
                push    es
                inc     cs:INSCHEDULER
                xor     ax, ax
                mov     es, ax
                assume es:cseg01
                mov     bx, 90h
                mov     ax, 48E2h
                xchg    ax, es:[bx]
                push    ax
                mov     ax, cs
                xchg    ax, es:[bx+2]
                push    ax
                mov     dl, ds:3Ah
                and     dx, 3Fh
                or      byte ptr ds:3Ah, 40h
                mov     ah, 0Eh
                cmp     cs:word_3D72, 3D7Ch
                jnz     short loc_4301
                push    bx
                mov     bx, 3E12h
                add     bx, dx
                cmp     byte ptr cs:[bx], 0
                pop     bx
                jnz     short loc_4315

loc_4301:                               ; CODE XREF: SftThing+6A↑j
                pushf
                cli
                call    cs:PREVINT21PROC
                lea     dx, ds:3Ch
                mov     ah, 3Bh ; ';'
                pushf
                cli
                call    cs:PREVINT21PROC

loc_4315:                               ; CODE XREF: SftThing+77↑j
                pop     word ptr es:[bx+2]
                pop     word ptr es:[bx]
                dec     cs:INSCHEDULER
                pop     es
                assume es:nothing
                pop     dx
                pop     bx
                pop     ax

loc_4325:                               ; CODE XREF: SftThing+2C↑j
                                        ; SftThing+34↑j
                cmp     ah, 3Dh ; '='
                jnz     short jmp_previous_int21
                call    GROWSFT

jmp_previous_int21:                     ; CODE XREF: SftThing↑j
                                        ; SftThing+A0↑j ...
                pop     ds
                pop     bp
                dec     bp
                cli
                jmp     cs:PREVINT21PROC
SftThing        endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


sub_4336        proc near               ; CODE XREF: sub_427A+1↑p
                                        ; DOSIoctlHook+24↓p ...
                mov     ax, bx
sub_4336        endp


; =============== S U B R O U T I N E =======================================


sub_4338        proc near               ; CODE XREF: sub_4280+3↑p
                                        ; SftThing+7↑p
                push    es
                push    bx
                les     bx, cs:PCURRENTPDB
                mov     es, word ptr es:[bx]
                mov     bx, ax
                mov     al, es:[bx+18h]
                cmp     al, 0FEh
                jnz     short loc_4354
                inc     byte ptr es:[bx+18h]

loc_4350:                               ; CODE XREF: sub_4338+27↓j
                or      ax, ax
                jmp     short loc_43A3
; ---------------------------------------------------------------------------

loc_4354:                               ; CODE XREF: sub_4338+12↑j
                les     bx, cs:PFILETABLE

loc_4359:                               ; CODE XREF: sub_4338+2D↓j
                les     bx, es:[bx]
                cmp     bx, 0FFFFh
                jz      short loc_4350
                sub     al, es:[bx+4]
                jnb     short loc_4359
                add     al, es:[bx+4]
                lea     bx, [bx+0Ah]
                or      al, al
                jz      short loc_437B

loc_4372:                               ; CODE XREF: sub_4338+41↓j
                add     bx, cs:FILEENTRYSIZE
                dec     al
                jnz     short loc_4372

loc_437B:                               ; CODE XREF: sub_4338+38↑j
                cmp     cs:DOS_VERSION, 3
                jb      short loc_4396
                test    byte ptr es:[bx+2], 80h
                jnz     short loc_43A3
                add     bx, 1Dh
                cmp     cs:DOS_REVISION, 0
                jz      short loc_4396
                dec     bx

loc_4396:                               ; CODE XREF: sub_4338+49↑j
                                        ; sub_4338+5B↑j
                cmp     word ptr es:[bx], 4F43h
                jnz     short loc_43A3
                cmp     word ptr es:[bx+2], 204Eh

loc_43A3:                               ; CODE XREF: sub_4338+1A↑j
                                        ; sub_4338+50↑j ...
                pop     bx
                pop     es
                retn
sub_4338        endp


; =============== S U B R O U T I N E =======================================


DOSIoctlHook    proc far                ; DATA XREF: cseg01:3DDD↑o
                cmp     al, 6
                jz      short loc_43B9
                cmp     al, 4
                jb      short loc_43C4
                cmp     al, 7
                jz      short loc_43C4
                cmp     al, 0Ah
                jz      short loc_43C4
                jmp     loc_42AA
; ---------------------------------------------------------------------------

loc_43B9:                               ; CODE XREF: DOSIoctlHook+2↑j
                call    sub_427A
                call    loc_40B2
                mov     ah, 0Bh
                jmp     loc_4490
; ---------------------------------------------------------------------------

loc_43C4:                               ; CODE XREF: DOSIoctlHook+6↑j
                                        ; DOSIoctlHook+A↑j ...
                jmp     DOSGeneralFileHook
; ---------------------------------------------------------------------------

DOSWriteHook:                           ; DATA XREF: cseg01:3D83↑o
                call    loc_40B2
                call    sub_4336
                jnz     short loc_43ED
                mov     [bp-0Ah], cx
                mov     ah, 9
                call    loc_40E4
                jmp     loc_44DF
; ---------------------------------------------------------------------------

DOSReadHook:                            ; DATA XREF: cseg01:3DEF↑o
                call    loc_40B2
                call    sub_4336
                jnz     short loc_43ED
                mov     ah, 5
                call    loc_40E4
                mov     [bp-0Ah], ax
                jmp     loc_44DF
; ---------------------------------------------------------------------------

loc_43ED:                               ; CODE XREF: DOSIoctlHook+27↑j
                                        ; DOSIoctlHook+3A↑j
                lds     bx, cs:PCURRENTPDB
                mov     bx, [bx]
                mov     ds, bx
                cmp     word ptr ds:4Ah, 0
                jz      short loc_4410
                cmp     [bp+4], bx
                jb      short loc_4410
                mov     bx, ds:2
                cmp     [bp+4], bx
                jnb     short loc_4410
                mov     ah, 17h
                call    loc_40E7

loc_4410:                               ; CODE XREF: DOSIoctlHook+55↑j
                                        ; DOSIoctlHook+5A↑j ...
                call    loc_40CB
                jmp     cs:PREVINT21PROC
; ---------------------------------------------------------------------------

DOSFlushBufferStdinHook:                ; DATA XREF: cseg01:3DE9↑o
                call    sub_4280
                call    loc_40B2
                push    dx
                push    ax
                call    loc_40E7
                pop     ax
                pop     dx
                mov     ah, al
                mov     al, 0
                cmp     ah, 1
                jz      short loc_4490
                cmp     ah, 0Ah
                jz      short loc_449E
                cmp     ah, 6
                jz      short loc_446A
                cmp     ah, 7
                jz      short loc_447B
                cmp     ah, 8
                mov     ah, 7
                jz      short loc_4490
                jmp     loc_44DF
; ---------------------------------------------------------------------------

DOSDirectOutHook:                       ; DATA XREF: cseg01:3DD7↑o
                cmp     cs:word_3D72, 3D7Ch
                jz      short loc_4458
                cmp     dl, 0FFh
                jz      short loc_4458
                jmp     jmp_previous_int21
; ---------------------------------------------------------------------------

loc_4458:                               ; CODE XREF: DOSIoctlHook+A8↑j
                                        ; DOSIoctlHook+AD↑j
                call    loc_428B
                call    loc_40B2
                cmp     dl, 0FFh
                jz      short loc_446A
                mov     ah, 2
                call    loc_40E7
                jmp     short loc_44DF
; ---------------------------------------------------------------------------

loc_446A:                               ; CODE XREF: DOSIoctlHook+90↑j
                                        ; DOSIoctlHook+BB↑j
                or      byte ptr [bp+6], 40h
                mov     ah, 0Bh
                call    loc_40E7
                or      al, al
                jz      short loc_4493
                and     byte ptr [bp+6], 0BFh

loc_447B:                               ; CODE XREF: DOSIoctlHook+95↑j
                                        ; DOSDirectNoEchoHook+6↓j
                mov     ah, 7
                call    loc_40E7
                jmp     short loc_4493
DOSIoctlHook    endp


; =============== S U B R O U T I N E =======================================


DOSDirectNoEchoHook proc far            ; DATA XREF: cseg01:3DE0↑o
                call    sub_4280
                call    loc_40B2
                jmp     short loc_447B
DOSDirectNoEchoHook endp


; =============== S U B R O U T I N E =======================================


DOSStdinHook    proc far                ; DATA XREF: cseg01:3DDA↑o
                                        ; cseg01:3DEC↑o
                call    sub_4280
                call    loc_40B2

loc_4490:                               ; CODE XREF: DOSIoctlHook+1B↑j
                                        ; DOSIoctlHook+86↑j ...
                call    loc_40E4

loc_4493:                               ; CODE XREF: DOSIoctlHook+CF↑j
                                        ; DOSIoctlHook+DA↑j
                mov     [bp-0Ah], al
                jmp     short loc_44DF
DOSStdinHook    endp


; =============== S U B R O U T I N E =======================================


DOSBufferedInputHook proc far           ; DATA XREF: cseg01:3DE6↑o
                call    sub_4280
                call    loc_40B2

loc_449E:                               ; CODE XREF: DOSIoctlHook+8B↑j
                mov     di, dx
                mov     ds, word ptr [bp-2]
                mov     cx, [di]
                add     dx, 2
                call    loc_40E4
                mov     di, [bp-4]
                mov     ds, word ptr [bp-2]
                or      al, al
                jz      short loc_44B7
                dec     al

loc_44B7:                               ; CODE XREF: DOSBufferedInputHook+1B↑j
                mov     [di+1], al
                jmp     short loc_44DF
DOSBufferedInputHook endp


; =============== S U B R O U T I N E =======================================


DOSPrintStringHook proc far             ; DATA XREF: cseg01:3D80↑o
                call    loc_428B
                call    loc_40B2
                mov     di, ds
                mov     es, di
                mov     di, dx
                mov     cx, 0FFFFh
                mov     al, 24h ; '$'
                repne scasb
                neg     cx
                sub     cx, 2
                jmp     short loc_44DC
DOSPrintStringHook endp


; =============== S U B R O U T I N E =======================================


DOSPrintCharHook proc far               ; DATA XREF: cseg01:3D7D↑o
                call    loc_428B
                call    loc_40B2

loc_44DC:                               ; CODE XREF: DOSPrintStringHook+18↑j
                call    loc_40E4

loc_44DF:                               ; CODE XREF: DOSIoctlHook+31↑j
                                        ; DOSIoctlHook+44↑j ...
                pop     di
                pop     si
                pop     cx
                pop     ax
                pop     bx
                pop     es
                pop     dx

loc_44E6:                               ; CODE XREF: INT21HANDLER+127↑j
                                        ; INT21HANDLER+163↑j ...
                pop     ds
                pop     bp
                dec     bp
                iret
DOSPrintCharHook endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


DOSStdInNoEchoHook proc far             ; DATA XREF: cseg01:3DE3↑o
                call    sub_4280
                call    loc_40B2
                mov     ah, 7
                jmp     short loc_4490
DOSStdInNoEchoHook endp


; =============== S U B R O U T I N E =======================================


DOSSelectDefaultDriveHook proc far      ; DATA XREF: cseg01:3DF2↑o
                cmp     cs:word_3D72, 3D7Ch
                jnz     short loc_450A
                push    dx
                inc     dx
                call    sub_425B
                pop     dx
                jnb     short loc_450A
                call    PREVINT21RETURN_2
                jmp     short loc_44E6
; ---------------------------------------------------------------------------

loc_450A:                               ; CODE XREF: DOSSelectDefaultDriveHook+7↑j
                                        ; DOSSelectDefaultDriveHook+F↑j
                push    dx
                mov     ah, 19h
                pushf
                cli
                call    cs:PREVINT21PROC
                mov     ah, 0Eh
                cmp     al, dl
                pop     dx
                jz      short loc_452D

loc_451B:                               ; CODE XREF: DOSChdirHook+7↓j
                                        ; DOSChdirHook+C↓j
                mov     ds, cs:CURTDB
                cmp     word ptr ds:7Eh, 4454h
                jnz     short loc_452D
                and     byte ptr ds:3Ah, 7Fh

loc_452D:                               ; CODE XREF: DOSSelectDefaultDriveHook+25↑j
                                        ; DOSSelectDefaultDriveHook+32↑j
                jmp     loc_42AA
DOSSelectDefaultDriveHook endp


; =============== S U B R O U T I N E =======================================


DOSChdirHook    proc far                ; DATA XREF: cseg01:3DF5↑o
                cmp     cs:word_3D72, 3D7Ch
                jnz     short loc_451B
                call    near ptr PATHDRVDSDX
                jnb     short loc_451B
                call    near ptr PREVINT21RETURN_1

loc_4541:                               ; CODE XREF: INT21HANDLER+F7↑j
                                        ; INT21HANDLER+111↑j ...
                or      byte ptr [bp+6], 1
                jmp     short loc_44E6
DOSChdirHook    endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


DOSSetInterruptVectorHook proc far      ; DATA XREF: cseg01:3DF8↑o
                pop     ds
                pop     bp
                dec     bp
                cmp     al, 21h ; '!'
                jnz     short loc_454F
                iret
; ---------------------------------------------------------------------------

loc_454F:                               ; CODE XREF: DOSSetInterruptVectorHook+5↑j
                cli
                jmp     cs:PREVINT21PROC
DOSSetInterruptVectorHook endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


DOSGeneralFileHook proc near            ; CODE XREF: DOSIoctlHook:loc_43C4↑j
                                        ; DATA XREF: cseg01:3D86↑o ...
                push    es
                push    di
                les     di, cs:PCURRENTPDB
                mov     es, word ptr es:[di]
                cmp     byte ptr es:[bx+18h], 0FEh
                jnz     short loc_456A
                inc     byte ptr es:[bx+18h]

loc_456A:                               ; CODE XREF: DOSGeneralFileHook+F↑j
                pop     di
                pop     es
                jmp     jmp_previous_int21
DOSGeneralFileHook endp


; =============== S U B R O U T I N E =======================================


DOSResizeMemoryHook proc far            ; DATA XREF: cseg01:3E01↑o

; FUNCTION CHUNK AT 45B0 SIZE 00000016 BYTES

                call    loc_40B2
                mov     dx, es
                dec     dx
                mov     ds, dx
                assume ds:nothing
                inc     dx
                cmp     dx, cs:TOPPDB
                ja      short loc_4586
                mov     bx, ds:3
                jmp     short loc_45B6
; ---------------------------------------------------------------------------
                nop

loc_4586:                               ; CODE XREF: DOSResizeMemoryHook+E↑j
                mov     ax, 7
                cmp     byte ptr ds:0, 4Dh ; 'M'
                jz      short loc_4597
                cmp     byte ptr ds:0, 5Ah ; 'Z'
                jnz     short loc_45BC

loc_4597:                               ; CODE XREF: DOSResizeMemoryHook+1F↑j
                mov     cx, ds:1
                lds     si, cs:PCURRENTPDB
                assume ds:nothing
                cmp     cx, [si]
                jnz     short loc_45BC
                call    INT21REALLOC
                jmp     short loc_45B0
; ---------------------------------------------------------------------------
                nop
DOSResizeMemoryHook endp


; =============== S U B R O U T I N E =======================================


DOSAllocMemoryHook proc near            ; DATA XREF: cseg01:3DFB↑o
                call    loc_40B2
                call    INT21ALLOC
DOSAllocMemoryHook endp

; START OF FUNCTION CHUNK FOR PREVINT21RETURN_1
;   ADDITIONAL PARENT FUNCTION DOSResizeMemoryHook

loc_45B0:                               ; CODE XREF: DOSResizeMemoryHook+38↑j
                or      ax, ax
                jnz     short loc_45C0
                mov     bx, dx

loc_45B6:                               ; CODE XREF: DOSResizeMemoryHook+14↑j
                mov     [bp-8], bx

loc_45B9:                               ; CODE XREF: DOSFreeMemoryHook+A↓j
                mov     ax, 8

loc_45BC:                               ; CODE XREF: DOSResizeMemoryHook+26↑j
                                        ; DOSResizeMemoryHook+33↑j
                or      byte ptr [bp+6], 1

loc_45C0:                               ; CODE XREF: PREVINT21RETURN_1+376↑j
                                        ; DOSFreeMemoryHook+C↓j
                mov     [bp-0Ah], ax
                jmp     loc_44DF
; END OF FUNCTION CHUNK FOR PREVINT21RETURN_1

; =============== S U B R O U T I N E =======================================


DOSFreeMemoryHook proc far              ; DATA XREF: cseg01:3DFE↑o
                call    loc_40B2
                mov     dx, es
                call    j_GENTERCURRENTPDB
                or      ax, ax
                jnz     short loc_45B9
                jmp     short loc_45C0
DOSFreeMemoryHook endp

; ---------------------------------------------------------------------------
SZWINOLDAP      db 'WINOLDAP.MOD',0

; =============== S U B R O U T I N E =======================================


DOSExecHook     proc far                ; DATA XREF: cseg01:3E04↑o
                cmp     cs:word_3D72, 3D7Ch
                jnz     short loc_45F5
                call    near ptr PATHDRVDSDX
                jnb     short loc_45F5
                call    near ptr PREVINT21RETURN_1
                jmp     loc_4541
; ---------------------------------------------------------------------------

loc_45F5:                               ; CODE XREF: DOSExecHook+7↑j
                                        ; DOSExecHook+C↑j
                call    loc_40B2
                mov     es, cs:CURTDB
                cmp     word ptr es:1Eh, 0
                jz      short loc_4608
                jmp     loc_46B1
; ---------------------------------------------------------------------------

loc_4608:                               ; CODE XREF: DOSExecHook+22↑j
                les     di, [bp-4]
                mov     cx, 0FFFFh
                xor     al, al
                repne scasb
                neg     cx
                dec     cx
                mov     ax, es:[di-5]
                or      ah, 20h
                mov     bx, es:[di-3]
                or      bx, 2020h
                cmp     ax, 632Eh
                jnz     short loc_462F
                cmp     bx, 6D6Fh
                jz      short loc_465F

loc_462F:                               ; CODE XREF: DOSExecHook+46↑j
                cmp     ax, 622Eh
                jnz     short loc_463A
                cmp     bx, 7461h
                jz      short loc_465F

loc_463A:                               ; CODE XREF: DOSExecHook+51↑j
                cmp     ax, 702Eh
                jnz     short loc_4645
                cmp     bx, 6669h
                jz      short loc_465F

loc_4645:                               ; CODE XREF: DOSExecHook+5C↑j
                lds     si, [bp-8]
                push    cx
                push    es
                push    dx
                push    ds
                push    si
                nop
                push    cs
                call    near ptr LOADMODULE
                pop     cx
                cmp     ax, 40h ; '@'
                jb      short loc_465A
                jmp     short loc_46CA
; ---------------------------------------------------------------------------

loc_465A:                               ; CODE XREF: DOSExecHook+75↑j
                cmp     ax, 0Bh
                jnz     short loc_46C6

loc_465F:                               ; CODE XREF: DOSExecHook+4C↑j
                                        ; DOSExecHook+57↑j ...
                mov     dx, cx
                mov     ax, 80h
                sub     sp, ax
                push    ss
                pop     es
                mov     di, sp
                lds     si, [bp-8]
                lds     si, [si+2]
                xor     ch, ch
                mov     cl, [si]
                add     cx, 2
                rep movsb
                mov     cx, dx
                lds     si, [bp-4]
                rep movsb
                mov     byte ptr es:[di-1], 0Ah
                mov     di, sp
                add     es:[di], dl
                lds     si, [bp-8]
                mov     [si+2], di
                mov     word ptr [si+4], es
                mov     dx, 45D4h
                push    cs
                push    dx
                push    ds
                push    si
                nop
                push    cs
                call    near ptr LOADMODULE
                add     sp, 80h
                cmp     ax, 40h ; '@'
                jnb     short loc_46CA
                cmp     ax, 2
                jnz     short loc_46C6
                mov     al, 17h
                jmp     short loc_46C6
; ---------------------------------------------------------------------------

loc_46B1:                               ; CODE XREF: DOSExecHook+24↑j
                mov     ax, [bp-0Ah]
                les     bx, [bp-8]
                mov     cx, es
                lds     dx, [bp-4]
                mov     ah, 10h
                call    loc_40E7
                cmp     ax, 40h ; '@'
                jnb     short loc_46CA

loc_46C6:                               ; CODE XREF: DOSExecHook+7C↑j
                                        ; DOSExecHook+CA↑j ...
                or      byte ptr [bp+6], 1

loc_46CA:                               ; CODE XREF: DOSExecHook+77↑j
                                        ; DOSExecHook+C5↑j ...
                mov     [bp-0Ah], ax
                call    loc_40CB
                iret
DOSExecHook     endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


DOSTerminateOldHook proc near           ; DATA XREF: cseg01:3E07↑o
                xor     ax, ax
                lds     si, cs:PCURRENTPDB
                mov     si, [si]
                cmp     si, [bp+4]
                jz      short near ptr DOSTerminateHook
                jmp     jmp_previous_int21
DOSTerminateOldHook endp


; =============== S U B R O U T I N E =======================================


DOSTerminateHook proc far               ; CODE XREF: DOSTerminateOldHook+C↑j
                                        ; DATA XREF: cseg01:3E0A↑o
                lds     si, cs:PCURRENTPDB
                mov     bx, [si]
                mov     ds, bx
                mov     dx, ds:42h
                mov     cx, cs:HEADPDB
                cmp     bx, cx
                jnz     short loc_46FF
                mov     cs:HEADPDB, dx
                jmp     short loc_4711
; ---------------------------------------------------------------------------

loc_46FF:                               ; CODE XREF: DOSTerminateHook+14↑j
                                        ; DOSTerminateHook+28↓j
                jcxz    short loc_4711
                mov     es, cx
                mov     cx, es:42h
                cmp     cx, bx
                jnz     short loc_46FF
                mov     es:42h, dx

loc_4711:                               ; CODE XREF: DOSTerminateHook+1B↑j
                                        ; DOSTerminateHook:loc_46FF↑j
                mov     ds, cs:CURTDB
                cmp     word ptr ds:1Eh, 0
                jnz     short loc_475E
                xchg    ax, di
                xor     si, si
                push    si
                nop
                push    cs
                call    near ptr GLOBALFREEALL
                cmp     ds:16h, si
                jz      short loc_473E
                mov     bx, 20h ; ' '
                push    ds
                push    bx
                push    di
                push    word ptr ds:10h
                push    word ptr ds:12h
                call    dword ptr ds:14h

loc_473E:                               ; CODE XREF: DOSTerminateHook+48↑j
                mov     ds:7Eh, si
                push    ds
                call    DELETETASK
                mov     cx, cs:HEADTDB
                jcxz    short loc_47A8
                mov     es, si
                mov     bx, cs:INT22BASE
                mov     word ptr es:[bx], 478Ch
                mov     word ptr es:[bx+2], cs
                xchg    ax, di

loc_475E:                               ; CODE XREF: DOSTerminateHook+39↑j
                lds     si, cs:PCURRENTPDB
                mov     ds, word ptr [si]
                mov     ds, word ptr ds:16h
                mov     es, cs:HEADTDB
                mov     si, es:2
                sub     si, 18h
                mov     ds:2Eh, si
                mov     si, es:4
                mov     ds:30h, si
                mov     ah, 4Ch ; 'L'
                pushf
                cli
                call    cs:PREVINT21PROC

loc_478C:                               ; DATA XREF: BUILDPDB+8B↓o
                mov     bp, sp
                add     bp, 10h
                mov     ds, cs:CURTDB
                push    word ptr ds:10h
                push    ds
                nop
                push    cs
                call    near ptr GLOBALFREE
                nop
                push    cs
                call    near ptr FREEMODULE
                jmp     near ptr BOOTSCHEDULE
; ---------------------------------------------------------------------------

loc_47A8:                               ; CODE XREF: DOSTerminateHook+69↑j
                push    si
                push    si
                call    cs:PEXITPROC
DOSTerminateHook endp ; sp-analysis failed
