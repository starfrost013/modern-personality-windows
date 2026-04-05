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
INITDATA_UNK    db 4Dh, 2 dup(0FFh), 29h, 0Ch dup(0), 4Dh, 2 dup(0FFh),
                28h, 0Ch dup(0)

; end of kernel data
PUBLIC KERNEL_TEXTEND
KERNEL_TEXTEND db 0Ah dup(0)
PUBLIC KERNEL_STACKBOTTOM
KERNEL_STACKBOTTOM       dw 0                    ; DATA XREF: BOOTSTRAP+54↑w
PUBLIC KERNEL_STACKMIN 
KERNEL_STACKMIN       dw 0                    ; DATA XREF: BOOTSTRAP+4B↑w

; This is horrible but is intended to kind of look like what microsoft was doing until we figure out the full usage of this
PUBLIC KERNEL_STACKTOP
KERNEL_STACKTOP       dw 0                    ; DATA XREF: BOOTSTRAP+46↑w


; Some boot data like BOOTTDB needs to be moved here...

; It is a very bad idea to change this

KERNELSTACKSIZE = 640 ; Was 512 bytes in later versions. But it ensures that at least 128 bytes are free    
                        ; ALSO CHANGE KERNEL_STACKMAXUSE IN LDBOOT.ASM (TODO: MOEV EVERYTHING FRROM THERE HERE!)
    
KERNELSTACK   db KERNELSTACKSIZE dup(?)

PUBLIC KERNEL_STACKEND
KERNEL_STACKEND           dw 0

; End of memory arena list
FINALARENA      db 20h dup(0FFh)   ; Last part is for the FinalArena

; force this crap compiler to do things properly

sEnd CODE

end
