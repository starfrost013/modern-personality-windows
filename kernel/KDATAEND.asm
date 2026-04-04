; Some fucking bastards decided to put some padding data at the end of KERNEL, that KERNEL ignores while copying!
; If you don't do this, half of the code gets overwritten with memory management information!
; ****** modern:personality project ******
; Reverse engineered code  © 2022-2025 starfrost. See licensing information in the licensing file
; Original code            © 1982-1986 Microsoft Corporation

; LDBOOT.ASM: Windows slow-boot code. Most of this is only in debug builds, but has been kept on for the purposes of validation and debugging
; until Setup has been reversed.
INCLUDE KERNEL.inc
INCLUDE KDATA.inc

sBegin CODE

assumeS CS,CODE
assumeS DS,CODE

PUBLIC INITDATA_UNK
INITDATA_UNK    db 4Dh, 2 dup(0FFh), 29h, 0Ch dup(0), 4Dh, 2 dup(0FFh)
                db 28h, 
PUBLIC BOOTSTACK_START
BOOTSTACK_START db 16h dup(0)
PUBLIC UNUSED1_STACK
UNUSED1_STACK       dw 0                    ; DATA XREF: BOOTSTRAP+54↑w
PUBLIC BOOTSTACKSEG 
BOOTSTACKSEG       dw 0                    ; DATA XREF: BOOTSTRAP+4B↑w

; This is horrible but is intended to kind of look like what microsoft was doing until we figure out the full usage of this
PUBLIC BOOTSTACKBOTTOM
BOOTSTACKBOTTOM       dw 0                    ; DATA XREF: BOOTSTRAP+46↑w
PUBLIC BOOTSTACK
BOOTSTACK              db 264h dup(0)

PUBLIC BOOTSTACK_END
BOOTSTACK_END           dw 0

FINALARENA      db 20h dup(0FFh)   ; Last part is for the FinalArena

; force this crap compiler to do things properly

sEnd CODE
END

end
