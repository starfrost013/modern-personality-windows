; ****** modern:personality project ******
; Reverse engineered code  © 2022-2025 starfrost. See licensing information in the licensing file
; Original code            © 1982-1986 Microsoft Corporation

; KDATA.ASM : KERNEL global variables 
; Todo: Convert to "global" macro (globalB etc)
INCLUDE KERNEL.inc

sBegin CODE

assumeS CS,CODE
assumeS DS,CODE

                ;.model flat
                ;.model large ; ?????? it could also be compact.
; ===========================================================================

; Kernel CS:0000
; The handle of the master object (system-wide, far pointer) heap. Offset address within the kernel(?) code segment.

globalW HGLOBALHEAP,0
; KERNEL CS:0002
; The physical address (segaddr) of the master object (i.e. head) of the global (system-wide, far-pointer) heap. 
globalW PGLOBALHEAP,0

; Kernel CS:0004
globalD PSWAPHOOK,0
; Kernel CS:0008
; Segaddress pointer to the module list.
; The module list contains all of the loaded modules in the system.
globalW HEXEHEAD,0
; Kernel CS:000A
; The first module for the memory manager's Least Recently Used (LRU)
; algorithm to examine (possibly least recently loaded module?)
globalW HEXESWEEP,0
; Kernel CS:000C
globalW HTHUNKS,0
; Kernel CS:000E
globalW HHANDLE,0
; The top of the Process Data Block (PDB) list on Windows start. See BOOTSTRAP function!
; Kernel CS:0010
globalW TOPPDB,0
; Pointer to the current head of the PDB linked list. Modified by INT21h only
; Kernel CS:0012
globalW HEADPDB,0

; The size of the MS-DOS PDB on Windows entry.
; I don't know if this is used, as IDA struggles to determine offsets and I didn't do the manual analysis yet.
; Might be used in STARTPROCADDRESS.
; Kernel CS:0014
globalW TOPSIZEPDB,0

; A (most likely segaddress) pointer to the current head of the task queue.
; Aka, the next task to run.
; Kernel CS:0016
globalW HEADTDB,0

;  A (most likely segaddress) pointer to the The current task that is running.
; Kernel CS:0018
globalW CURTDB,0

; Segaddress pointer to the current "supertask".
; A supertask is a task with such high priority that nothing else is allowed to run.
; Kernel CS:001A
globalW LOCKTDB,0
; Kernel CS:001C
globalW FWINX,0

; This is an interesting case.
; Windows calls the FNINIT function to try and determine if the 8087 is present.
; But then never sets this to anything (todo: check it's not just fucked up offsets)?
; Kernel CS:001E
globalW F8087,0

; Kernel CS:0020
; 1 if the scheduler is running.
; RESCHEDULE -> BOOTSCHEDULE is the scheduler.
globalB INSCHEDULER,0
; Kernel CS:0021 (related to expanded memory)
globalB FEMM,0
; Kernel CS:0022 idk what these do yet. May be master object
globalW BUFFER,0
; Kernel CS:0024
globalW BUFADDR,0
                dw 0                    ; placeholder for buffer +2

; Kernel CS:0028 Handle to WIN.INI file.
globalW HFILE,0FFFFh

; Address within the x86 Interrupt Service Table (0x4*0x22=0x88) to the INT 22h (terminate address - where execution goes when a DOS program exits) handler
; Needs debugging to see if it's into PSP pointer though.
; Kernel CS:002A
globalW INT22BASE,88h

; May, as it's a dword, be the seg:off address to call DMA
; Kernel CS:002C?
globalD PDMAADD,0

; Kernel CS:0030?
; Is DOS INT 21 running?
globalD PINDOS,0

; Kernel CS:0034?
; The current state of the Control+C (break) keys (DOS?)
globalD PCNTCFLAG,0

; Kernel CS:0038?  
; Current MS-DOS Program Segment Prefix/Program Data Block
globalD PCURRENTPDB,0
; Kernel CS:003C?
globalD PCURRENTDRIVE,0                 ; Unused
; Not sure about sizees for some of these
; Kernel CS:0040
; The error mode (for DOS?)
globalD PERRMODE,0

; Kernel CS:0044
globalD PSFTLINK,0
; Kernel CS:0048
; Seg:off far pointer to the start of the MS-DOS system file table linked list (which windows also uses - the only major part of dos left is the fat12 driver.)
globalD PFILETABLE,0
; Kernel CS:004C
; Size of a single MS-DOS system file table entry (I believe this depends on DOS version...)
globalW FILEENTRYSIZE,0
; Kernel CS:004E
; Drive letter of the last drive that experienced a disk swap (change).
globalB LASTDRIVESWAPPED,0
; Kernel CS:004F
; Value of MS-DOS break key flag (when DOS is enabled...)
globalB FBREAK,0
; Kernel CS:0050
; Holds the major version of DOS that Windows is running on. 
globalB DOS_VERSION,0

; Kernel CS:0051
; Holds the minor version of DOS that Windows is running on.
globalB DOS_REVISION,0

; Kernel CS:0052
; Holds the MS-DOS OEM number.
; In the early days of DOS, you could get your OEM copy of DOS "personalised" with an OEM ID that was assigned
; by microsoft. Very few bothered after the first few years, but Windows 1.0 is early enough
; to store it here. Woo!
globalB DOS_OEM,0

; Kernel CS:0053
; Determines if Windows INT 21 handling (mostly thunks) is installed
; Set to 0 by ENABLEINT21,
; 1 by DISABLEINT21
globalB FINT21,0
; Kernel CS:0054
globalB FEVENT,0

; Kernel CS:0055
; Stores keyboard information
; THIS IS A STRUCT, MAKE IT ONE!
; 0x00-0x01 and 0x02-0x03 are used to both determine if this is a "far east" build of Windows
globalB KEYINFO,0,%(SIZE KEYBOARDINFO)
                                        ; ISKANJI:loc_53E5↓r
                                        ; KEYINFO IS A STRUCT

; Kernel CS:0061
; set to 1 (using inc) by CHECKFAREAST if keyinfo[1] <= keyinfo[0]
; or keyinfo[3] > keyinfo[2] (presumably checks for Japanese Kanji?)
globalB FFAREAST,0

; Kernel CS:0062
; Seg:off far pointer to the USER function that spawns message boxes.
globalD PMBOXPROC,0

; Kernel CS:0066
; Holds a far pointer (seg:off) of the function used to exit the kernel.
; Set to EXITKERNEL function pointer during init.
; Then set to (via a hardcoded grab of ordinal #2 in a call to getprocaddress) USER's ExitWindows function in INITFWDREF if forward references are enabled later in boot
globalD PEXITPROC,0

; Kernel CS:006A
; Far pointer to SYSTEM.DRV's InquireSystem (get capabilities?) function (obtained via hardcoded ordinal number).
globalD PSYSPROC,0

; Kernel CS:006E
; Far pointer to SYSTEM.DRV's create timer function (obtained via hardcoded ordinal number).
globalD PTIMERPROC,0

; Kernel CS:0072
; Far pointer to KEYBOARD.DRV's ANSIToOem function - to convert ansi strings to current OEM codepage strings (obtained via hardcoded ordinal number).
globalD PKEYPROC,0

; Kernel CS:0076
; MS-DOS's original INT 20h (old terminate) pointer - restored by DISABLEINT21, overwritten by ENABLEINT21, but stored here so they can be restored.
globalD PREVINT20PROC,0

; Kernel CS:007A
; MS-DOS's original INT 21h (DOS API) pointer - restored by DISABLEINT21, overwritten by ENABLEINT21, but stored here so they can be restored.
globalD PREVINT21PROC,0

; Kernel CS:007E
; MS-DOS's original INT 24h (fatal error) pointer - restored by DISABLEINT21, overwritten by ENABLEINT21, but stored here so they can be restored.
globalD PREVINT24PROC,0

; Kernel CS:0082
; MS-DOS's original INT 27h (old TSR) pointer - restored by DISABLEINT21, overwritten by ENABLEINT21, but stored here so they can be restored.
globalD PREVINT27PROC,0


; Kernel CS:0086
; Original INT 3Fh (dynamic linking) pointer - may be present on MDOS4, if something like novell netware is running? Does windows change this itself?
globalD PREVINT3FPROC,0

; Kernel CS:008A
; Stores the seg address pointer to the internal MS-DOS console device within the SYSVARS table of MS-DOS by calling the GET LIST OF LISTS (SYSVARS) undocumented function.
; Presumably so WINOLDAP can redirect console handling for "well behaved" apps like COMMAND.COM
globalD PREVBCON,0


; Kernel CS:008E
; 1 if the kernel is still initialising, 0 if it isn't. Set to 0 during INIITASK function phase of boot, 1 by default.
globalB FBOOTING,1 ; 1 by default

; Kernel CS:008F
globalB CDEVAT,0

; Kernel CS:0090
; stores the previous MS-DOS INT 24 error number.
globalB OLDERRNO,0
; Kernel CS:0092
; Another buffer? (maybe BUFFER is some sort of mmaster buffer object)
public OUTBUF
OUTBUF          db 32h dup(0)
; Kernel CS:00C4
; The current position within outbuf? or userprobuf? DEBUG!
globalW BUFPOS,0
; Kernel CS:00C6
; Buffer for reading from the user profile (WIN.INI file)
public USERPROBUF
USERPROBUF      db 50h dup(0)

public SZUSERPRO
; Kernel CS:0116
; Filename of the user profile. In Windows 1.0 DR4 (and possibly earlier), as well DR5 and Windows 1.0 Alpha, this file was called USER.PRO
SZUSERPRO       db 'WIN.INI',0

; Kernel CS:011E
; Start of the message telling you to insert a disk if, (usually in floppy-based Windows installations),
; it can't find a file
public SZDISKMSG1
SZDISKMSG1      db 'Insert ',0

; Kernel CS:0126
; Second part of the aforementioned message.
public SZDISKMSG2
SZDISKMSG2      db ' disk in drive '

; Kernel CS:0135
; Placeholder drive letter for (usually in floppy-based Windows installations) telling you to insert a disk
; when it can't find a file, as well as some other purposes
public DRVLET
DRVLET          db 'X:',0               ; DATA XREF: PROMPT+E↓r
                                        ; PROMPT+39↓w
                                        ; placeholder
; Kernel CS:0138                                    
; A string referring to the Windows system disk for the aforementioned error message
public SZWINDISK
SZWINDISK       db 'Windows System',0

; Kernel CS:0147
; A string telling you to change disk
public SZDISKCAP
SZDISKCAP       db 'Change Disk',0
; Kernel CS:0153
; A string displayed on a system error.
public SYSERR
SYSERR          db 'System Error',0
; Kernel CS:0160
; A string displayed when the OS can't find something (e.g. a drive) - probably passed via PMBOXPROC
public SZCANNOTFIND1
SZCANNOTFIND1   db 'Cannot find ',0
                db    0
; Kernel CS:016E
; A string displayed when DOS FAT12 driver is telling the kernel it's trying to access a write protected drive.
public SZCANNOTFIND2
SZCANNOTFIND2   db 'Write protected disk in drive '

; Kernel CS:018F
; Another placeholder drive letter for the above error message.
public DRVLET1
DRVLET1         db 'X:',0               ; DATA XREF: INT24HANDLER+4A↓w
; Kernel CS:0192
; A string displayed when DOS FAT12 driver is telling the kernel it can't read from a drive.
public MSGCANNOTREADDRV
MSGCANNOTREADDRV db 'Cannot read from drive ' ; DATA XREF: TESTEMM+5↓r

; Kernel CS:01A6
; Another placeholder drive letter for the above error message.
public DRVLET2
DRVLET2         db 'X:',0               ; DATA XREF: INT24HANDLER+4D↓w

; Kernel CS:01A9
; A string displayed when DOS FAT12 driver is telling the kernel it can't write to a drive.
public MSGCANNOTWRITEDRV
MSGCANNOTWRITEDRV db 'Cannot write to drive '

; Kernel CS:01BF
; Another placeholder drive letter for the above error message.
public DRVLET3
DRVLET3         db 'X:',0               ; DATA XREF: INT24HANDLER+50↓w

; Kernel CS:01C2
; A string displayed when DOS FAT12 driver is telling the kernel it can't read from a device.
public SZERRCANNOTREAD
SZERRCANNOTREAD db 'Cannot read from device ',0
                db 8 dup(0) ; placeholder for up to 8 character dos device name

; Kernel CS:01E3
; A string displayed when DOS FAT12 driver is telling the kernel it can't write to a device.
public SZERRCANNOTWRITE
SZERRCANNOTWRITE db 'Cannot write to device ',0
                db 8 dup(0) ; placeholder for up to 8 character dos device name
; Kernel CS:0203
; A string displayed when DOS FAT12 driver is telling the kernel it can't write to a device.
public SZERRPRINTERNOTREADY
SZERRPRINTERNOTREADY db 'Printer not ready',0

if KDEBUG
    ; These strings are used by GETDEBUGSTRING
    ; **** DEBUG BUILDS ONLY ****
    public SZERRFAILEDLOADING
    public SZERRFAILEDLOADINGNEWINSTANCE
    public SZERRFAILEDLOADINGRESOURCE
    SZERRFAILEDLOADING db 'KERNEL: Failed loading - ',0
    SZERRFAILEDLOADINGNEWINSTANCE db 'KERNEL: Failed loading new instance of - ',0
    SZERRFAILEDLOADINGRESOURCE db 'Error loading from resource file - ',0
                    db 0Dh,0Ah,0
endif

; Kernel CS:0218 (release builds)
; Unknown, needs debugging (debug builds)
; A string displayed when FATALEXIT is called
public SZERRFATALEXIT
SZERRFATALEXIT  db 7,0Dh,0Ah
                db 'FatalExit code = ',0
; Kernel CS:021A (release builds)
; Unknown, needs debugging (debug builds)
; A string displayed when the stack overflows
public SZERRSTACKOVERFLOW
SZERRSTACKOVERFLOW db ' stack overflow',0

; These strings are used by debug build only kernelerror
; **** DEBUG BUILDS ONLY ****
if KDEBUG
    public SZERRSTACKTRACE
    SZERRSTACKTRACE db 0Dh,0Ah
                    db 'Stack trace:',0Dh,0Ah,0
    public SZERRABORT
    SZERRABORT      db 7,0Dh,0Ah
                    db 'Abort, Break or Ignore? ',0
    public SZERRINVALIDBPCHAIN
    SZERRINVALIDBPCHAIN db 'Invalid BP chain',7,0Dh,0Ah,0
                    db ': ',0
endif
;end

sEnd CODE

end
