; ****** modern:personality project ******
; Reverse engineered code  © 2022-2025 starfrost. See licensing information in the licensing file
; Original code            © 1982-1986 Microsoft Corporation

; I21MEM.INC: Utility functions for allocating memory for the use of 

; IN ORDER TO MATCH, THIS MUST BE LINKED <64K AWAY FRMOM GMEM.ASM!

; =============== S U B R O U T I N E =======================================
INCLUDE KERNEL.inc
INCLUDE KDATA.inc

externNP GALLOC

externNP GENTERCURRENTPDB

externNP GFREE

externNP GLEAVE
externNP GREALLOC

sBegin CODE

assumeS CS,CODE
assumeS DS,CODE

INT21ALLOC      proc near               ; CODE XREF: DOSAllocMemoryHook+3↑p
                call    GENTERCURRENTPDB
                call    GALLOC
                ;jmp     short GLEAVE ; optimisation
                jmp     GLEAVE        ; TODO: Figure out how to change to above so that we match
INT21ALLOC      endp

; ---------------------------------------------------------------------------
                db 90h

; =============== S U B R O U T I N E =======================================


INT21REALLOC    proc near               ; CODE XREF: DOSResizeMemoryHook+35↑p
                call    GENTERCURRENTPDB
                call    GREALLOC
                ;jmp     short GLEAVE ; optimisation
                jmp     GLEAVE        ; TODO: Figure out how to change to above so that we match
INT21REALLOC    endp

; ---------------------------------------------------------------------------
                ;align 2

; =============== S U B R O U T I N E =======================================


INT21ENTERCURRENTPDB proc near            ; CODE XREF: DOSFreeMemoryHook+5↑p
                call    GENTERCURRENTPDB
INT21ENTERCURRENTPDB endp


; =============== S U B R O U T I N E =======================================


INT21FREE       proc near
                xor     cx, cx
                call    GFREE
                ;jmp     short GLEAVE ; optimisation
                jmp     GLEAVE        ; TODO: Figure out how to change to above so that we match
INT21FREE       endp

sEnd CODE

end
