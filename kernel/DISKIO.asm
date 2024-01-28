;
; External Entry #85 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public _LOPEN
_LOPEN          proc near
                mov     ch, 3Dh ; '='   ; KERNEL_85
_LOPEN          endp

; ---------------------------------------------------------------------------
                db 0BBh
;
; External Entry #83 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public _LCREAT
_LCREAT         proc far
                mov     ch, 3Ch ; '<'   ; KERNEL_83
                mov     bx, sp
                push    ds
                mov     dx, ss:[bx+6]
                mov     ds, word ptr ss:[bx+8]
                mov     cl, ss:[bx+4]
                mov     ax, cx
                xor     ch, ch
                int     21h             ; DOS -
                jnb     short loc_51FF
                mov     ax, 0FFFFh

loc_51FF:                               ; CODE XREF: _LCREAT+17↑j
                pop     ds
                retf    6
_LCREAT         endp

;
; External Entry #81 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public _LCLOSE
_LCLOSE         proc far                ; CODE XREF: STARTMODULE+42↑p
                                        ; STARTMODULE+63↑p ...
                mov     bx, sp          ; KERNEL_81
                mov     bx, ss:[bx+4]
                mov     ah, 3Eh ; '>'
                int     21h             ; DOS - 2+ - CLOSE A FILE WITH HANDLE
                                        ; BX = file handle
                mov     ax, 0FFFFh
                jb      short locret_5213
                inc     ax

locret_5213:                            ; CODE XREF: _LCLOSE+D↑j
                retf    2
_LCLOSE         endp

;
; External Entry #84 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public _LLSEEK
_LLSEEK         proc far                ; CODE XREF: FINDSEGSYMS+1F4↓p
                                        ; FINDSEGSYMS+24B↓p ...
                mov     bx, sp          ; KERNEL_84
                mov     dx, ss:[bx+6]
                mov     cx, ss:[bx+8]
                mov     ax, ss:[bx+4]
                mov     bx, ss:[bx+0Ah]
                mov     ah, 42h ; 'B'
                int     21h             ; DOS - 2+ - MOVE FILE READ/WRITE POINTER (LSEEK)
                                        ; AL = method:
                                        ; 0-from beginnig,1-from current,2-from end
                jnb     short locret_5232
                mov     ax, 0FFFFh
                cwd

locret_5232:                            ; CODE XREF: _LLSEEK+16↑j
                retf    8
_LLSEEK         endp

;
; External Entry #82 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public _LREAD
_LREAD          proc near               ; CODE XREF: FINDSEGSYMS+170↓p
                                        ; FINDSEGSYMS+18D↓p ...
                mov     cl, 3Fh ; '?'   ; KERNEL_82
_LREAD          endp

; ---------------------------------------------------------------------------
                db 0BBh
;
; External Entry #86 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public _LWRITE
_LWRITE         proc far                ; CODE XREF: KERNELERROR+26↓p
                                        ; KERNELERROR+8A↓p ...
                mov     cl, 40h ; '@'   ; KERNEL_86
                mov     bx, sp
                push    ds
                mov     ah, cl
                mov     dx, ss:[bx+6]
                mov     ds, word ptr ss:[bx+8]
                mov     cx, ss:[bx+4]
                mov     bx, ss:[bx+0Ah]
                int     21h             ; DOS - 2+ - WRITE TO FILE WITH HANDLE
                                        ; BX = file handle, CX = number of bytes to write, DS:DX -> buffer
                jnb     short loc_5256
                mov     ax, 0FFFFh

loc_5256:                               ; CODE XREF: _LWRITE+19↑j
                pop     ds
                retf    8
_LWRITE         endp
