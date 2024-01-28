
; =============== S U B R O U T I N E =======================================


INT21ALLOC      proc near               ; CODE XREF: DOSAllocMemoryHook+3↑p
                call    GENTERCURRENTPDB
                call    GALLOC
                jmp     short GLEAVE
INT21ALLOC      endp

; ---------------------------------------------------------------------------
                db 90h

; =============== S U B R O U T I N E =======================================


INT21REALLOC    proc near               ; CODE XREF: DOSResizeMemoryHook+35↑p
                call    GENTERCURRENTPDB
                call    GREALLOC
                jmp     short GLEAVE
INT21REALLOC    endp

; ---------------------------------------------------------------------------
                align 2

; =============== S U B R O U T I N E =======================================


j_GENTERCURRENTPDB proc near            ; CODE XREF: DOSFreeMemoryHook+5↑p
                call    GENTERCURRENTPDB
j_GENTERCURRENTPDB endp


; =============== S U B R O U T I N E =======================================


INT21FREE       proc near
                xor     cx, cx
                call    GFREE
                jmp     short GLEAVE
INT21FREE       endp
