
; External Entry #3 into the Module
; Attributes (0001): Fixed Exported
;

;
; External Entry #44 into the Module
; Attributes (0001): Fixed Exported
;


;
; External Entry #43 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public ISSCREENGRAB
ISSCREENGRAB    proc far
                mov     ax, cs:FWINX    ; KERNEL_43
                retf
ISSCREENGRAB    endp

; ---------------------------------------------------------------------------
unk_48BE        db    0                 ; DATA XREF: sub_48D3+2↓r
                db    0
unk_48C0        db    0                 ; DATA XREF: sub_48C1+C↓w

; =============== S U B R O U T I N E =======================================


sub_48C1        proc far
                add     [bp+di], al     ; these are all also different interrupt handlers.
                or      al, 48h
                ror     word ptr [bx+si+2Eh], cl
                mov     ds:48BEh, bx
                mov     word ptr cs:unk_48C0, es
                retf
sub_48C1        endp


; =============== S U B R O U T I N E =======================================


sub_48D3        proc far
                push    ds
                push    bx
                lds     bx, dword ptr cs:unk_48BE
                mov     word ptr [bx+3], 300h
                pop     bx
                pop     ds
                retf
sub_48D3        endp
