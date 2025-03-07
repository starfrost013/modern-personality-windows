; ****** modern:personality project ******
; Reverse engineered code  © 2022-2024 starfrost. See licensing information in the licensing file
; Original code            © 1982-1986 Microsoft Corporation

; KDATA.ASM : KERNEL global variables 

;
; +-------------------------------------------------------------------------+
; |      This file was generated by The Interactive Disassembler (IDA)      |
; |           Copyright (c) 2022 Hex-Rays, <support@hex-rays.com>           |
; +-------------------------------------------------------------------------+
;
; Input SHA256 : 0854155A7D522DBF11A3F1DAF22D8A6D157496C5FD3FDF95809EEED73A82093F
; Input MD5    : DBA8DED7D0D6F8C8D2DD1ED42F51CEAF
; Input CRC32  : 0E431DF3

; File Name   : D:\research\win1.03\debugkernel\KERNEL.EXE
; Format      : New Executable (NE) Windows
; Title 'Microsoft Windows Kernel Interface for 2.x and 3.x'
; Target operating system         unknown
; File Load CRC                   00D0674F3h
; Program Entry Point   (CS:IP)   0001:800A
; Initial Stack Pointer (SS:SP)   0000:0000
; Auto Data Segment Index         0000h  (     0. )
; Initial Local Heap Size         0200h  (   512. )
; Initial Stack Size              0000h  (     0. )
; Linker Version                  4.0
; Minimum code swap area size     0
; Expected Windows Version        0.0
; Program Flags (8004): DLL No data Global initialization
; Other EXE Flags (0000):
; ----------------------------------------------------------------------------
; Segment Number    : 1
; Alloc Size        : 9890h
; Offset in the file: 0B90h  Length: 9890h
; Attributes  (0040): CODE Preloaded DPL: 0

                ;.model flat
                .model large ; ?????? it could also be compact.
; ===========================================================================

; Segment type: Pure code
cseg01          segment para public 'CODE' use16
                assume cs:cseg01
                assume es:nothing, ss:nothing, ds:nothing, fs:nothing, gs:nothing

; Kernel CS:0000
; The handle of the master object (system-wide, far pointer) heap. Offset address within the kernel(?) code segment.
HGLOBALHEAP     dw 0                    ; DATA XREF: GLOBALMASTERHANDLE↓r
                                        ; GLOBALINIT+93↓w
; KERNEL CS:0002
; The physical address (segaddr) of the master object (i.e. head) of the global (system-wide, far-pointer) heap. 
PGLOBALHEAP     dw 0                    ; DATA XREF: ALLOCALLSEGS+6E↓r
                                        ; FREEMODULE+60↓r ...
; Kernel CS:0004
PSWAPHOOK       dd 0                    ; DATA XREF: EXITKERNEL+6C↓r
                                        ; GHANDLE+7E↓r ...
; Kernel CS:0008
; Segaddress pointer to the module list.
; The module list contains all of the loaded modules in the system.
HEXEHEAD        dw 0                    ; DATA XREF: FINDEXEINFO+9↓r
                                        ; ADDMODULE+3↓r ...
; Kernel CS:000A
; The first module for the memory manager's Least Recently Used (LRU)
; algorithm to examine (possibly least recently loaded module?)
HEXESWEEP       dw 0                    ; DATA XREF: ADDMODULE+1C↓r
                                        ; ADDMODULE+2C↓w ...
; Kernel CS:000C
HTHUNKS         dw 0                    ; DATA XREF: MAKEPROCINSTANCE+6↓r
                                        ; MAKEPROCINSTANCE+1E↓r ...
; Kernel CS:000E
HHANDLE         dw 0                    ; DATA XREF: PATCHTHUNKS+B↓r
                                        ; PATCHTHUNKS+109↓r ...

; The top of the Process Data Block (PDB) list on Windows start. See BOOTSTRAP function!
; Kernel CS:0010
TOPPDB          dw 0                    ; DATA XREF: CREATETASK+9A↓r
                                        ; ENABLEDOS+28↓r ...
; Pointer to the current head of the PDB linked list. Modified by INT21h only
; Kernel CS:0012
HEADPDB         dw 0                    ; DATA XREF: CREATETASK+B2↓w
                                        ; CLOSEOPENFILES+65↓r ...
; The size of the MS-DOS PDB on Windows entry.
; I don't know if this is used, as IDA struggles to determine offsets and I didn't do the manual analysis yet.
; Might be used in STARTPROCADDRESS.
; Kernel CS:0014
TOPSIZEPDB      db 2 dup(0)

; A (most likely segaddress) pointer to the current head of the task queue.
; Aka, the next task to run.
; Kernel CS:0016
HEADTDB         dw 0                    ; DATA XREF: PATCHSTACK+B↓r
                                        ; SEARCHSTACK+7↓r ...

;  A (most likely segaddress) pointer to the The current task that is running.
; Kernel CS:0018
CURTDB          dw 0                    ; DATA XREF: GETCURRENTTASK↓r
                                        ; INSERTTASK+F↓w ...

; Pointer to the current "supertask".
; A supertask is a task with such high priority that nothing else is allowed to run.
; Kernel CS:001A
LOCKTDB         dw 0                    ; DATA XREF: LOCKCURRENTTASK:loc_3993↓w
                                        ; BOOTSCHEDULE+2B↓r
; Kernel CS:001C
FWINX           dw 0                    ; DATA XREF: ISSCREENGRAB↓r
                                        ; BOOTSTRAP+67↓w ...
; This is an interesting case.
; Windows calls the FNINIT function to try and determine if the 8087 is present.
; But then never sets this to anything (todo: check it's not just fucked up offsets)?
; Kernel CS:001E
F8087           dw 0                    ; DATA XREF: STATEXJUMP+A↓r
; Kernel CS:0020
; 1 if the scheduler is running.
; RESCHEDULE -> BOOTSCHEDULE is the scheduler.
INSCHEDULER     db 0                    ; DATA XREF: BOOTSCHEDULE:loc_3B5F↓w
                                        ; BOOTSCHEDULE+99↓w ...
; Kernel CS:0021 (related to expanded memory)
FEMM            db 0                    ; DATA XREF: CREATETASK+22↓r
                                        ; CREATETASK+8B↓r ...
; Kernel CS:0022 idk what these do yet. May be master object
BUFFER          dw 0                    ; DATA XREF: BUFFERINIT+2↓r
                                        ; BUFFERINIT+55↓w ...
; Kernel CS:0024
BUFADDR         dw 0                    ; DATA XREF: BUFFERINIT+63↓r
                dw 0
; Kernel CS:0028 Handle to WIN.INI file.
HFILE           dw 0FFFFh               ; DATA XREF: BUFFERINIT+38↓w

; Address within the x86 Interrupt Service Table (0x4*0x22=0x88) to the INT 22h (terminate address - where execution goes when a DOS program exits) handler
; Needs debugging to see if it's into PSP pointer though.
; Kernel CS:002A
INT22BASE       dw 88h                  ; DATA XREF: DOSTerminateHook+6D↓r
                                        ; INITDOSVARP+78↓r ...

; May, as it's a dword, be the seg:off address to call DMA
; Kernel CS:002C?
PDMAADD         dd 0                    ; DATA XREF: SAVESTATE:loc_39CA↓r

; Kernel CS:0030?
; Is DOS INT 21 running?
PINDOS          dd 0                    ; DATA XREF: BOOTSCHEDULE+38↓r

; Kernel CS:0034?
; The current state of the Control+C (break) keys (DOS?)
PCNTCFLAG       dd 0                    ; DATA XREF: SAVESTATE+42↓r

; Kernel CS:0038?  
                                        ; RESTORESTATE+24↓r ...
PCURRENTPDB     dd 0                    ; DATA XREF: SEARCHPATH+12↓r
                                        ; GETTEMPFILENAME+20↓r ...
; Kernel CS:003C?
PCURRENTDRIVE:
                align 8
; Not sure about sizees for some of these
; Kernel CS:0040
; The error mode (for DOS?)
PERRMODE        dd 0                    ; DATA XREF: SAVESTATE+4D↓r
                                        ; RESTORESTATE+2F↓r ...
; Kernel CS:0044
PSFTLINK        dd 0                    ; DATA XREF: EXITKERNEL+4C↓r
                                        ; INITDOSVARP+5B↓w ...
; Kernel CS:0048
; Seg:off far pointer to the start of the MS-DOS system file table linked list (which windows also uses - the only major part of dos left is the fat12 driver.)
PFILETABLE      dd 0                    ; DATA XREF: GROWSFT+8↓r
                                        ; GROWSFT+82↓r ...
; Kernel CS:004C
; Size of a single MS-DOS system file table entry (I believe this depends on DOS version...)
FILEENTRYSIZE   dw 0                    ; DATA XREF: GROWSFT+D↓r
                                        ; CLOSEOPENFILES:loc_397A↓r ...
; Kernel CS:004E
; Drive letter of the last drive that experienced a disk swap (change).
LASTDRIVESWAPPED db 0                   ; DATA XREF: PROMPT+3C↓w
                                        ; GETLASTDISKCHANGE+2↓w
; Kernel CS:004F
; Value of MS-DOS break key flag (when DOS is enabled...)
FBREAK          db 0                    ; DATA XREF: ENABLEDOS+1C↓w
                                        ; DISABLEDOS+23↓r
; Kernel CS:0050
; Holds the major version of DOS that Windows is running on. 
DOS_VERSION     db 0                    ; DATA XREF: GETTEMPFILENAME+AB↓r
                                        ; CLOSEOPENFILES+8↓r ...

; Kernel CS:0051
; Holds the minor version of DOS that Windows is running on.
DOS_REVISION    db 0                    ; DATA XREF: sub_4338+55↓r
                                        ; INT24HANDLER+C1↓r ...

; Kernel CS:0052
; Holds the MS-DOS OEM number.
; In the early days of DOS, you could get your OEM copy of DOS "personalised" with an OEM ID that was assigned
; by microsoft. Very few bothered after the first few years, but Windows 1.0 is early enough
; to store it here. Woo!
DOS_OEM         db 0                    ; DATA XREF: INITDOSVARP+29↓w

; Kernel CS:0053
; Determines if Windows INT 21 handling (mostly thunks) is installed
; Set to 0 by ENABLEINT21,
; 1 by DISABLEINT21
FINT21          db 0                    ; DATA XREF: OPENFILE+B2↓r
                                        ; OPENFILE+150↓r ...
; Kernel CS:0054
FEVENT          db 0

; Kernel CS:0055
; Stores keyboard information
; THIS IS A STRUCT, MAKE IT ONE!
; 0x00-0x01 and 0x02-0x03 are used to both determine if this is a "far east"
KEYINFO         db 0,0,0,0,0,0,0,0,0,0,0,0 ; DATA XREF: ISKANJI+8↓r
                                        ; ISKANJI:loc_53E5↓r
                                        ; KEYINFO IS A STRUCT

; Kernel CS:0061
; set to 1 (using inc) by CHECKFAREAST if keyinfo[1] <= keyinfo[0]
; or keyinfo[3] > keyinfo[2] (presumably checks for Japanese Kanji?)
FFAREAST        db 0                    ; DATA XREF: ANSIPREV+8↓r
                                        ; ISKANJI↓r ...
; Kernel CS:0062
; Seg:off far pointer to the USER function that spawns message boxes.
PMBOXPROC       dd 0                    ; DATA XREF: SHOWDIALOGBOX2+12↓r
                                        ; INITFWDREF+62↓w ...

; Kernel CS:0066
; Holds a far pointer (seg:off) of the function used to exit the kernel.
; Set to EXITKERNEL function pointer during init.
; Then set to (via a hardcoded grab of ordinal #2 in a call to getprocaddress) USER's ExitWindows function in INITFWDREF if forward references are enabled later in boot
PEXITPROC       dd 0                    ; DATA XREF: DOSTerminateHook+C8↓r
                                        ; BOOTSTRAP+D9↓w ...

; Kernel CS:006A
; Far pointer to SYSTEM.DRV's InquireSystem (get capabilities?) function (obtained via hardcoded ordinal number).
PSYSPROC        dd 0                    ; DATA XREF: ISFLOPPY+5↓r
                                        ; ENABLEDOS+83↓r ...

; Kernel CS:006E
; Far pointer to SYSTEM.DRV's create timer function (obtained via hardcoded ordinal number).
PTIMERPROC      dd 0                    ; DATA XREF: BOOTDONE+53↓r
                                        ; INITFWDREF+A4↓w ...

; Kernel CS:0072
; Far pointer to KEYBOARD.DRV's ANSIToOem function - to convert ansi strings to current OEM codepage strings (obtained via hardcoded ordinal number).
PKEYPROC        dd 0                    ; DATA XREF: OPENFILE+BE↓r
                                        ; INITFWDREF+C2↓w ...

; Kernel CS:0076
; MS-DOS's original INT 20h (old terminate) pointer - restored by DISABLEINT21, overwritten by ENABLEINT21, but stored here so they can be restored.
PREVINT20PROC   dd 0                     ; DATA XREF: DISABLEINT21+1B↓r
                                        ; INITFWDREF+9↓w ...

; Kernel CS:007A
; MS-DOS's original INT 21h (DOS API) pointer - restored by DISABLEINT21, overwritten by ENABLEINT21, but stored here so they can be restored.
PREVINT21PROC   dd 0                    ; DATA XREF: OPENFILE+59↓r
                                        ; RESTORESTATE+42↓r ...
; Kernel CS:007E
; MS-DOS's original INT 24h (fatal error) pointer - restored by DISABLEINT21, overwritten by ENABLEINT21, but stored here so they can be restored.
PREVINT24PROC   dd 0                    ; DATA XREF: ENABLEDOS+67↓w
                                        ; DISABLEDOS+19↓r ...
; Kernel CS:0082
; MS-DOS's original INT 27h (old TSR) pointer - restored by DISABLEINT21, overwritten by ENABLEINT21, but stored here so they can be restored.
PREVINT27PROC   dd 0                    ; DATA XREF: DISABLEINT21+3C↓r
                                        ; INITFWDREF+30↓w ...

; Kernel CS:0086
; Original INT 3Fh (dynamic linking) pointer - may be present on MDOS4, if something like novell netware is running? Does windows change this itself?
PREVINT3FPROC   dd 0                    ; DATA XREF: EXITKERNEL+D↓r
                                        ; PDB_CALL_SYSTEM_ENTRY+9↓r ...

; Kernel CS:008A
; Stores the seg address pointer to the internal MS-DOS console device within the SYSVARS table of MS-DOS by calling the GET LIST OF LISTS (SYSVARS) undocumented function.
; Presumably so WINOLDAP can redirect console handling for "well behaved" apps like COMMAND.COM
PREVBCON        dd 0                    ; DATA XREF: ENABLEDOS+54↓w
                                        ; DISABLEDOS+3E↓r ...

; Kernel CS:008E
; 1 if the kernel is still initialising, 0 if it isn't. Set to 0 during INIITASK function phase of boot, 1 by default.
FBOOTING        db 1                    ; DATA XREF: ALLOCSEG+16↓r
                                        ; ADDMODULE+35↓r ...
; Kernel CS:008F
CDEVAT          db 0                    ; DATA XREF: INT24HANDLER+1D↓w
                                        ; INT24HANDLER+5B↓r ...

; Kernel CS:0090
; stores the previous MS-DOS INT 24 error number.
OLDERRNO        dw 0                    ; DATA XREF: INT24HANDLER+78↓w
                                        ; INT24HANDLER+EA↓r
; Kernel CS:0092
; Another buffer? (maybe BUFFER is some sort of mmaster buffer object)
OUTBUF          db 32h dup(0)
; Kernel CS:00C4
; The current position within outbuf? or userprobuf? DEBUG!
BUFPOS          dw 0                    ; DATA XREF: INT24HANDLER+44↓w
                                        ; APPENDFIRST↓w ...
; Kernel CS:00C6
; Buffer for reading from the user profile (WIN.INI file)
USERPROBUF      db 50h dup(0)

; Kernel CS:0116
; Filename of the user profile. In Windows 1.0 DR4 (and possibly earlier), as well DR5 and Windows 1.0 Alpha, this file was called USER.PRO
SZUSERPRO       db 'WIN.INI',0

; Kernel CS:011E
; Start of the message telling you to insert a disk if, (usually in floppy-based Windows installations),
; it can't find a file
SZDISKMSG1      db 'Insert ',0

; Kernel CS:0126
; Second part of the aforementioned message.
SZDISKMSG2      db ' disk in drive '

; Kernel CS:0135
; Placeholder drive letter for (usually in floppy-based Windows installations) telling you to insert a disk
; when it can't find a file, as well as some other purposes
DRVLET          db 'X:',0               ; DATA XREF: PROMPT+E↓r
                                        ; PROMPT+39↓w
                                        ; placeholder
; Kernel CS:0138                                    
; A string referring to the Windows system disk for the aforementioned error message
SZWINDISK       db 'Windows System',0

; Kernel CS:0147
; A string telling you to change disk
SZDISKCAP       db 'Change Disk',0
; Kernel CS:0153
; A string displayed on a system error.
SYSERR          db 'System Error',0
; Kernel CS:0160
; A string displayed when the OS can't find something (e.g. a drive) - probably passed via PMBOXPROC
SZCANNOTFIND1   db 'Cannot find ',0
                db    0
; Kernel CS:016E
; A string displayed when DOS FAT12 driver is telling the kernel it's trying to access a write protected drive.
SZCANNOTFIND2   db 'Write protected disk in drive '

; Kernel CS:018F
; Another placeholder drive letter for the above error message.
DRVLET1         db 'X:',0               ; DATA XREF: INT24HANDLER+4A↓w
; Kernel CS:0192
; A string displayed when DOS FAT12 driver is telling the kernel it can't read from a drive.
MSGCANNOTREADDRV db 'Cannot read from drive ' ; DATA XREF: TESTEMM+5↓r

; Kernel CS:01A6
; Another placeholder drive letter for the above error message.
DRVLET2         db 'X:',0               ; DATA XREF: INT24HANDLER+4D↓w

; Kernel CS:01A9
; A string displayed when DOS FAT12 driver is telling the kernel it can't write to a drive.
MSGCANNOTWRITEDRV db 'Cannot write to drive '

; Kernel CS:01BF
; Another placeholder drive letter for the above error message.
DRVLET3         db 'X:',0               ; DATA XREF: INT24HANDLER+50↓w

; Kernel CS:01C2
; A string displayed when DOS FAT12 driver is telling the kernel it can't read from a device.
SZERRCANNOTREAD db 'Cannot read from device ',0
                db 8 dup(0) ; placeholder for up to 8 character dos device name

; Kernel CS:01E3
; A string displayed when DOS FAT12 driver is telling the kernel it can't write to a device.
SZERRCANNOTWRITE db 'Cannot write to device ',0
                db 8 dup(0) ; placeholder for up to 8 character dos device name
; Kernel CS:0203
; A string displayed when DOS FAT12 driver is telling the kernel it can't write to a device.
SZERRPRINTERNOTREADY db 'Printer not ready',0

; These strings are used by GETDEBUGSTRING
; **** DEBUG BUILDS ONLY ****
SZERRFAILEDLOADING db 'KERNEL: Failed loading - ',0
SZERRFAILEDLOADINGNEWINSTANCE db 'KERNEL: Failed loading new instance of - ',0
SZERRFAILEDLOADINGRESOURCE db 'Error loading from resource file - ',0
                db 0Dh,0Ah,0
; Kernel CS:0218 (release builds)
; Unknown, needs debugging (debug builds)
; A string displayed when FATALEXIT is called
SZERRFATALEXIT  db 7,0Dh,0Ah
                db 'FatalExit code = ',0
; Kernel CS:021A (release builds)
; Unknown, needs debugging (debug builds)
; A string displayed when the stack overflows
SZERRSTACKOVERFLOW db ' stack overflow',0

; These strings are used by debug build only kernelerror
; **** DEBUG BUILDS ONLY ****
SZERRSTACKTRACE db 0Dh,0Ah
                db 'Stack trace:',0Dh,0Ah,0
SZERRABORT      db 7,0Dh,0Ah
                db 'Abort, Break or Ignore? ',0
SZERRINVALIDBPCHAIN db 'Invalid BP chain',7,0Dh,0Ah,0
                db ': ',0
                align 2
;end
