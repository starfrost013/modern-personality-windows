TITLE				Assembly definitions for NE header


savedCS = 4
savedIP = 2
savedBP = 0
savedDS = -2

EMAGIC  = 05A4Dh ; 'MZ' header
ERESWDS =  0010h
ENEWHDR =  003Eh
ENEWEXE =  0040h

EXE_HDR     STRUC
e_magic     DW  ?               ; magic in same location		0x00
e_cblp      DW  ?				; 0x02
e_cp        DW  ?				; 0x04
e_crlc      DW  ?				; 0x06
e_cparhdr   DW  ?				; 0x08 
e_minalloc  DW  ?				; 0x0A
e_maxalloc  DW  ?				; 0x0C
e_ss        DW  ?				; 0x0E
e_sp        DW  ?				; 0x10
e_csum      DW  ?				; 0x12
e_cs        DW  ?				; 0x14
e_ip        DW  ?				; 0x16 (cs:ip 0x14-0x18)
e_lfarlc    DW  ?				; 0x18
e_ovno      DW  ?				; 0x20 
e_res       DW  ERESWDS DUP (?)	; 0x22?
e_lfanew    DD  ?				; 0x26
EXE_HDR     ENDS


NEMAGIC     = 454Eh
NERESBYTES  = 0

NEW_EXE         STRUC
ne_magic        DW  ?           ; Magic value 'NE'												0x00
ne_ver          DB  ?           ; linker version number											0x02
ne_rev          DB  ?           ; linker revision number										0x03
ne_enttab       DW  ?           ; offset to entry table											0x04
ne_cbenttab     DW  ?           ; number of bytes in entry table								0x06

ne_timestamp    DD  ?           ; DOS-format timestamp. This is a CRC in later versions			0x08

ne_flags        DW  ?           ; flag word														0x0C
ne_autodata     DW  ?           ; segment number of auto data segment							0x0E
ne_heap         DW  ?           ; initial size of local heap									0x10
ne_stack        DW  ?           ; initial size of stack											0x12

ne_csip         DD  ?           ; CS:IP start address											0x14
ne_sssp         DD  ?           ; SS:SP initial stack pointer.  0 if							0x18
                                ; stack size word non-zero

ne_cseg         DW  ?           ; number of segment in segment table							0x1C
ne_cmod         DW  ?           ; number of entries in module reference table					0x1E
ne_cbnrestab    DW  ?           ; number of bytes in non-resident name table					0x20

ne_segtab       DW  ?           ; NE relative offset to segment table							0x22
ne_rsrctab      DW  ?           ; NE relative offset to resource table							0x24
ne_restab       DW  ?           ; NE relative offset to resident name table						0x26
ne_modtab       DW  ?           ; NE relative offset to module reference table					0x28
ne_imptab       DW  ?           ; NE relative offset to imported name table						0x2A
ne_nrestab      DD  ?           ; file offset to non-resident name table						0x2C
ne_cmovent      DW  ?           ; Count of movable entries										0x30
ne_align        DW  ?           ; Alignment shift count for segment data						0x32
ne_cres         DW  ?           ; Count of resource segments									0x34
ne_exetyp		DB  ?			; Target operating system										0x36
ne_flagsothers	DB  ?			; Other .EXE flags												0x37
ne_pretthunks   DW  ?           ; offset to return thunks										0x39
ne_psegrefbytes DW  ?           ; offset to segment ref. bytes									0x3A
; These are probably not present in 1.03
;ne_reserved1	DW  ?			; win3.0+ gangload area. not used in 1.03						0x3C
;ne_reserved2	DW	?			; offset for win3.0+ gangload. not used in 1.03					0x3E
;ne_swaparea     DW  ?           ; Minimum code swap area size									0x41
;ne_expver       DW  ?           ; Expected Windows version number								0x43
NEW_EXE         ENDS

; Chksum not supported unless ne_psegcsum defined in NEW_EXE structure

ne_psegcsum = word ptr ne_exetyp
ne_onextexe = word ptr ne_crc

NEW_EXE1        STRUC
                DW  ?
ne_usage        DW  ?
                DW  ?
ne_pnextexe     DW  ?
ne_pautodata    DW  ?
ne_pfileinfo    DW  ?
NEW_EXE1        ENDS

NENOTP          = 8000h         ; Not a process (i.e. a library module)
NEPRIVLIB       = 4000h         ; A library which lives above the line
NEIERR          = 2000h         ; Errors in image
NEAPPTYP        = 0700h         ; Application type mask
NENOTWINCOMPAT  = 0100h         ; Not compatible with P.M. Windowing
NEWINCOMPAT     = 0200h         ; Compatible with P.M. Windowing
NEWINAPI        = 0300h         ; Uses P.M. Windowing API
NEFLTP          = 0080h         ; Floating-point instructions
NEI286          = 0020h         ; 286 instructions
NEI086          = 0010h         ; 8086 instructions
NEPROT          = 0008h         ; Runs in protected mode only
NEPPLI          = 0004h         ; Per-Process Library Initialization
NEINST          = 0002h         ; Instance data
NESOLO          = 0001h         ; Solo data

; Following private bit is a runtime only flag used only ROM Windows.

NEMODINROM	= NEEMSSEPINST	; Module loaded from ROM


; Target operating systems

NE_UNKNOWN	= 0		; Unknown (any "new-format" OS)
NE_OS2		= 1		; Microsoft/IBM OS/2 (default)
NE_WINDOWS	= 2		; Microsoft Windows
NE_DOS4 	= 3		; Microsoft MS-DOS 4.x

ifndef NO_APPLOADER
NEAPPLOADER     = 0800h         ; set if application has its own loader
endif ;!NO_APPLOADER


NEW_SEG         STRUC
ns_sector       DW  ?   ; logical sector number in file of start of segment
ns_cbseg        DW  ?   ; number bytes in file
ns_flags        DW  ?   ; segment flags
ns_minalloc     DW  ?   ; minimum number bytes to allocate for segment
NEW_SEG         ENDS

NEW_SEG1        STRUC
                DB  SIZE NEW_SEG DUP (?)
ns_handle       DW  ?   ; Handle to segment (0 if not loaded)
NEW_SEG1        ENDS

NSTYPE          =  0007h    ; Segment type mask
NSCODE          =  0000h    ; Code segment
NSDATA          =  0001h    ; Data segment
NSITER          =  0008h    ; Iterated segment data
NSMOVE          =  0010h    ; Moveable segment
NSSHARE         =  0020h    ; Shareable segment
NSPRELOAD       =  0040h    ; Preload this segment
NSERONLY        =  0080h    ; EXECUTE ONLY code/READ ONLY data segment
NSRELOC         =  0100h    ; Relocation information following segment data
NSDPL           =  0C00h    ; 286 DPL bits
NSDISCARD       =  1000h    ; Discard priority bits
NS286DOS        = 0EE06h    ; These bits only used by 286DOS

NSALIGN         = 9         ; Default alignment shift count for seg. data

NSALLOCED       = 0002h     ; set if ns_handle points to uninitialized mem.
NSLOADED        = 0004h     ; set if ns_handle points to initialized mem.
NSUSESDATA      = 0400h     ; set if an entry point in this segment uses
                            ; the automatic data segment of a SOLO library

NSGETHIGH	= 0200h
NSINDIRECT	= 2000h
NSWINCODE	= 4000h     ; flag for code

NSKCACHED	= 0800h		; cached by kernel
NSPRIVLIB	= NSITER
NSNOTP		= 8000h

NSINROM 	= NSINDIRECT	; segment is loaded in ROM
NSCOMPR 	= NSGETHIGH	; segment is compressed in ROM

ifndef NO_APPLOADER
NSCACHED	= 8000h		;* in AppLoader Cache
endif ;!NO_APPLOADER


NEW_RSRC        STRUC
rs_align        DW  ?
NEW_RSRC        ENDS

RSORDID         = 08000h    ; If high bit of rt_id or rn_id set then integer id

RSRC_TYPEINFO   STRUC
rt_id           DW  ?
rt_nres         DW  ?
rt_proc         DD  ?
RSRC_TYPEINFO   ENDS

RSRC_NAMEINFO   STRUC
rn_offset       DW  ?
rn_length       DW  ?
rn_flags        DW  ?
rn_id           DW  ?
rn_handle       DW  ?
rn_usage        DW  ?
RSRC_NAMEINFO   ENDS
RNMOVE          = 00010h    ; Moveable resource
RNPURE          = 00020h    ; Pure resource (read only)
RNPRELOAD       = 00040h    ; Preload this resource
RNDISCARD       = 01000h    ; Discard bit
RNLOADED	= 00004h    ; True if handler proc return handle

RNUNUSED	= 0CD8Bh    ; Unused resource flags

ENTFIXED        STRUC
entflags        DB  ?
entoffset       DW  ?
ENTFIXED        ENDS

if SWAPPRO

ENTMOVEABLE	STRUC
		DB  ?			; Entry flags
entsar		DB  5 DUP (?)		; sar cs:[xxxx] instruction
		DW  ?			; INT 0F0H for swap profiler
entjmpfarop	DB  ?
entjmpfaroff	DW  ?
entjmpfarseg	DW  ?
ENTMOVEABLE	ENDS

ENTSWAPPED	STRUC
		DB  ?			; Entry flags
		DB  5 DUP (?)		; sar cs:[xxxx] instruction
		DW  ?			; INT 0F0H for swap profiler
entintop	DB  ?
entintvec	DB  ?
entintsegno	DB  ?
entintoff	DW  ?
ENTSWAPPED	ENDS

else		; no swap profiler

ENTMOVEABLE	STRUC
		DB  ?			; Entry flags
entsar		DB  5 DUP (?)		; sar cs:[xxxx] instruction
entjmpfarop	DB  ?
entjmpfaroff	DW  ?
entjmpfarseg	DW  ?
ENTMOVEABLE	ENDS

ENTSWAPPED	STRUC
		DB  ?			; Entry flags
		DB  5 DUP (?)		; sar cs:[xxxx] instruction
entintop	DB  ?
entintvec	DB  ?
entintsegno	DB  ?
entintoff	DW  ?
ENTSWAPPED	ENDS

endif		; if swap profiler

errnz <SIZE ENTMOVEABLE - SIZE ENTSWAPPED>

PENT		STRUC
penttype	DB  ?
pentflags	DB  ?
pentsegno	DB  ?
pentoffset	DW  ?
PENT		ENDS

PM_EntStruc	STRUC
PM_EntStart	dw	?
PM_EntEnd	dw	?
PM_EntNext	dw	?
PM_EntStruc	ENDS

ENT_UNUSED	= 000h
ENT_ABSSEG      = 0FEh
ENT_MOVEABLE    = 0FFh
ENT_PUBLIC      = 001h
ENT_DATA        = 002h
INTOPCODE       = 0CDh

if SWAPPRO
SWAPVECTOR	= 0F0h
endif

NEW_RLCINFO     STRUC
nr_nreloc       DW  ?
NEW_RLCINFO     ENDS

NEW_RLC         STRUC
nr_stype        DB  ?
nr_flags        DB  ?
nr_soff         DW  ?
nr_mod          DW  ?
nr_proc         DW  ?
NEW_RLC         ENDS
nr_segno        EQU nr_flags+3
nr_entry        EQU nr_proc

NRSTYP          = 07h
NRSBYTE         = 00h
NRSSEG          = 02h
NRSPTR          = 03h
NRSOFF          = 05h

NRADD           = 04h
NRRTYP          = 03h
NRRINT          = 00h
NRRORD          = 01h
NRRNAM          = 02h
OSFIXUP 	= 03h
