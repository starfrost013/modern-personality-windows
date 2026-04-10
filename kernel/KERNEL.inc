; ****** modern:personality project ******
; Reverse engineered code  © 2022-2025 starfrost. See licensing information in the licensing file
; kernel.inc - core includes

; Only use 8086/8087 instructions
.8086
.8087

%out Modern Personality Operating System Version 1.03.02
%out (c) 2022, 2025, 2026 starfrost

; Prevent implicit creation of segments
?NODATA = 1
?DF = 1
SWAPPRO = 0 ; can we remove this entirely?`

; Include CMACROS
include CMACROS.inc
include NEWEXE.inc

; 0 = Retail Windows
KDEBUG=1

; 0 = Windows 1.03
; 1 = ModernPersonality
MPENHANCE=1

; Windows 1.0 Kernel is a tiny application 
createSeg   _TEXT,CODE,PARA,PUBLIC,CODE ; TODO: get IGROUP to work
createSeg   STACK,STACK,WORD,PUBLIC,DATA ; But there still needs to be a stack.

;
; DEFINE
;

KEYBOARDINFO STRUC
kbUnknown	DB	12 dup (0)  ; Probably Far East stuff. But it is just a placeholder!

KEYBOARDINFO ENDS

; Fatalexit code (informally called "RIP codes - Rest in Peace")
ERR_LHEAP_INVALID=100h                      ; Invalid local heap
ERR_LHEAP_CRITICAL=140h                     ; Invalid heap locking state (critical section fucked)
ERR_INVALID_LOCAL_HANDLE=180h               ; Invalid local handle
ERR_LHEAP_USAGE_OVERFLOW=1C0h               ; Local heap usage overflow
ERR_LHEAP_USAGE_OVERFLOW=1F0h               ; Local heap usage underflow

ERR_INVALID_GLOBAL_HEAP=200h                ; Invalid global heap
ERR_FREED_LOCKED_OBJECT=2F0h                ; Tried to free a locked object

ERR_INVALID_TASK_HANDLE=301h                ; An invalid task handle was found 
ERR_INVALID_BP_CHAIN=303h                   ; Invalid BP chain


ERR_BOOT_CANT_LOAD=401h                     ; Boot file not found or invalid
ERR_INVALID_ORDINAL=403h                    ; Invalid ordinal
ERR_INVALID_PROC_NAME=404h                  ; Invalid procedure name or entry point
ERR_INVALID_MODULE_HANDLE=406h              ; Invalid module handle
ERR_RELOC_RECORDS_TRASHED=407h              ; Relocation records trashed
ERR_SEGMENT_TRASHED=409h                    ; Segment trashed or could not read contents
ERR_RELOC_RECORDS_LOAD_FAIL=410h            ; Error loading relocation records
ERR_NR_TABLE=412h                           ; Couldn't load non-resident name table during demand loading of segments
ERR_SEGMENT_LOAD_FAILED=4FFh                ; Couldn't load segment

ERR_RESOURCE_INVALID=504h                   ; Invalid resource
ERR_RESOURCE_LOAD_FAIL=505h                 ; Could not load resource

;
; ***** LoadModule and co. error codes *****
;

LME_FNF = 2                                 ; File not found
LME_INVEXE = 11                             ; Invalid binary
LME_MAXERR = 32                             ; for comparisons

;
; Instance data / NULL segment at the start of DGROUP (idk if it should be a struct?)
;
; If [0] is not a heap it is not a null segment,
; If [0x06] is not a pointer to valid local heap it is not a null segment
; Also PSTACKMIN & BOT don't exist on DLL

__ACRTUSED = 1                              ; Determiens if the crt was used?
PLOCALHEAP = 6                              ; Pointer to the local heap of a task (near pointers)
PATOMTABLE = 8                              ; Pointer to the local atom table of a task
PSTACKTOP = 0Ah                            ; Top of the task's stack
PSTACKMIN = 0Ch                            ; High water mark of current stack use
PSTACKBOT = 0Eh                            ; Bottom of the stack