; ---------------------------------------------------------------------------
                db 6 dup(0)

;
; LDFASTB.ASM
;
; Implements fast-boot. Fast boot is a method of boo
;

; =============== S U B R O U T I N E =======================================

; Function Name: Fastboot
;
; Purpose: Boots fast, without forward references.
;
; Parameters: ax -> function to run after                           
;
; Returns: KERNELERROR called and system exits if boot fails. Calls the function pointer (relative to current code segment) in AX if boot succeeds.
;
; Notes: Internal only function. Not for C. Possibly needs debugging

FASTBOOT        proc near               ; CODE XREF: BOOTSTRAP+264↑j

var_9           = byte ptr -9
var_8           = word ptr -8
var_6           = word ptr -6
var_4           = word ptr -4
var_2           = word ptr -2

                push    bp
                mov     bp, sp
                sub     sp, 0Ah
                mov     es, cs:SEGINITMEM
                mov     ax, es:8
                sub     ax, cs:CPSHRUNK
                mov     cs:word_84B8, ax
                push    cs:HINITMEM
                call    MYLOCK
                xchg    ax, cs:SEGINITMEM
                sub     ax, cs:SEGINITMEM
                add     cs:word_84B8, ax
                push    ax
                call    SHRINK
                pop     ax
                sub     cs:CPSHRUNK, ax
                mov     di, 873Dh
                mov     cx, 2
                cmp     word ptr cs:LPBOOTAPP+2, 0
                jz      short loc_878B
                inc     cx

loc_878B:                               ; CODE XREF: FASTBOOT+45↑j
                                        ; FASTBOOT+60↓j
                mov     bx, 6
                mov     ax, 1
                xor     dx, dx
                push    bx
                push    dx
                push    ax
                nop
                push    cs
                call    near ptr GLOBALALLOC
                cld
                push    cs
                pop     es
                assume es:cseg01
                stosw
                cmp     di, 8743h
                jb      short loc_878B
                call    INITPROFILE

loc_87A8:                               ; CODE XREF: FASTBOOT+3B6↓j
                mov     ax, cs:SEGINITMEM
                add     ax, cs:word_84B8
                mov     es, ax
                assume es:nothing
                xor     di, di
                mov     ax, es:[di+8]
                mov     [bp+var_4], ax
                mov     di, es:4
                add     di, es:6
                mov     cx, es:1Ch
                add     di, cx
                shl     cx, 1
                add     di, cx
                add     di, cx
                add     di, cx
                add     cx, 2
                shl     cx, 1
                add     di, cx
                mov     cx, es:30h
                add     di, cx
                shl     cx, 1
                shl     cx, 1
                add     di, cx
                xor     cx, cx
                push    cx
                push    di
                call    FINDFREESEG
                jcxz    short loc_8807
                xor     ax, ax
                push    ax
                push    ax
                nop
                push    cs
                call    near ptr GLOBALCOMPACT
                push    cs:HINITMEM
                call    MYLOCK
                mov     cs:SEGINITMEM, ax

loc_8807:                               ; CODE XREF: FASTBOOT+AD↑j
                mov     ax, cs:SEGINITMEM
                add     ax, cs:word_84B8
                mov     cx, 0FFFFh
                xor     di, di
                push    ax
                push    cx
                push    di
                push    di
                call    LOADEXEHEADER
                mov     es, ax
                mov     [bp+var_2], ax
                push    es
                push    es
                call    ADDMODULE
                pop     es
                mov     word ptr es:2, 8000h
                xor     si, si
                mov     di, es:28h
                jmp     short loc_88AE
; ---------------------------------------------------------------------------

loc_8837:                               ; CODE XREF: FASTBOOT+170↓j
                mov     ax, 0FFFFh
                push    es
                push    ax
                push    word ptr es:[di]
                call    GETSTRINGPTR
                mov     es, dx
                mov     bx, ax
                or      ax, dx
                jz      short forward_ref_on_installed
                xor     ax, ax
                mov     al, es:[bx]
                inc     bx
                push    es
                push    bx
                push    ax
                call    FINDEXEINFO

forward_ref_on_installed:               ; CODE XREF: FASTBOOT+105↑j
                or      ax, ax
                jnz     short loc_88A2
                xor     bx, bx
                mov     ax, 401h
                push    ax
                mov     ax, 886Ch       ; Forward reference not allowed in installed Windows
                push    cs
                push    ax
                push    bx
                push    bx
                call    KERNELERROR
                jmp     short loc_88A0
; ---------------------------------------------------------------------------
SZERRFORWARDREFERENCE db 'Forward reference not allowed in installed Windows',0
                db 24h
; ---------------------------------------------------------------------------

loc_88A0:                               ; CODE XREF: FASTBOOT+127↑j
                xor     ax, ax

loc_88A2:                               ; CODE XREF: FASTBOOT+115↑j
                mov     es, [bp+var_2]
                cld
                stosw
                push    es
                push    ax
                call    INCEXEUSAGE
                pop     es
                inc     si

loc_88AE:                               ; CODE XREF: FASTBOOT+F2↑j
                cmp     si, es:1Eh
                jb      short loc_8837
                mov     word ptr es:2, 1
                mov     si, es:8
                or      si, si
                jz      short loc_890F
                mov     bx, es:[si+4]
                test    bl, 40h
                jz      short loc_890F
                test    bl, 10h
                jnz     short loc_88DF
                push    es
                push    si
                call    FINDFREESEG
                push    es
                push    si
                call    ALLOCSEG
                jmp     short loc_890F
; ---------------------------------------------------------------------------

loc_88DF:                               ; CODE XREF: FASTBOOT+18E↑j
                xor     ax, ax
                mov     bx, 873Dh
                mov     cx, 3

loc_88E7:                               ; CODE XREF: FASTBOOT+1AB↓j
                cmp     cs:[bx], ax
                jnz     short loc_88F0
                inc     bx
                inc     bx
                loop    loc_88E7

loc_88F0:                               ; CODE XREF: FASTBOOT+1A7↑j
                xchg    ax, cs:[bx]
                mov     es:[si+8], ax
                or      byte ptr es:[si+4], 2
                push    ds
                call    GENTER
                mov     bx, ax
                mov     bx, [bx]
                call    GLEAVE
                dec     bx
                mov     ds, bx
                mov     word ptr ds:1, es
                pop     ds

loc_890F:                               ; CODE XREF: FASTBOOT+180↑j
                                        ; FASTBOOT+189↑j ...
                xor     di, di
                mov     si, es:22h
                sub     si, 0Ah

loc_8919:                               ; CODE XREF: FASTBOOT+1F3↓j
                                        ; FASTBOOT+1F8↓j ...
                mov     es, [bp+var_2]
                add     si, 0Ah
                inc     di
                cmp     di, es:1Ch
                jbe     short loc_892A
                jmp     loc_8A1D
; ---------------------------------------------------------------------------

loc_892A:                               ; CODE XREF: FASTBOOT+1E2↑j
                mov     bx, es:[si+4]
                test    bl, 40h
                jnz     short loc_8965
                test    bl, 2
                jnz     short loc_8919
                test    bl, 10h
                jz      short loc_8919
                xor     cx, cx
                push    es
                push    bx
                push    cx
                push    cx
                call    MYALLOC
                pop     es
                mov     es:[si+8], dx
                and     byte ptr es:[si+4], 0FBh
                or      byte ptr es:[si+4], 2
                mov     ax, es
                mov     es, cs:PGLOBALHEAP
                mov     bx, dx
                mov     es:[bx], ax
                mov     es, ax
                jmp     short loc_8919
; ---------------------------------------------------------------------------

loc_8965:                               ; CODE XREF: FASTBOOT+1EE↑j
                mov     ax, es:[si]
                test    bx, 0F000h
                jnz     short loc_897E
                test    word ptr es:0Ch, 2
                jz      short loc_8989
                cmp     es:8, si
                jnz     short loc_8989

loc_897E:                               ; CODE XREF: FASTBOOT+229↑j
                mov     ax, es:[si+2]
                xchg    ax, es:[si+6]
                xchg    ax, es:[si]

loc_8989:                               ; CODE XREF: FASTBOOT+232↑j
                                        ; FASTBOOT+239↑j
                mov     [bp+var_6], ax
                sub     ax, cs:CPSHRUNK
                mov     cs:word_84B8, ax
                test    byte ptr es:[si+4], 2
                jnz     short loc_89C1
                push    es
                push    si
                call    FINDFREESEG
                jcxz    short loc_89BA
                test    byte ptr es:[si+4], 10h
                jnz     short loc_89BA
                push    [bp+var_2]
                push    [bp+var_6]
                push    es
                push    si
                push    di
                push    cx
                call    LOADFIXEDSEG

loc_89B7:                               ; CODE XREF: FASTBOOT+27C↓j
                jmp     loc_8919
; ---------------------------------------------------------------------------

loc_89BA:                               ; CODE XREF: FASTBOOT+25E↑j
                                        ; FASTBOOT+265↑j
                push    es
                push    si
                call    ALLOCSEG
                jz      short loc_89B7

loc_89C1:                               ; CODE XREF: FASTBOOT+257↑j
                cmp     es:8, si
                jnz     short loc_89F5
                test    byte ptr es:[si+4], 10h
                jz      short loc_89F5
                push    es
                push    si
                call    FINDFREESEG
                mov     ax, es:[si+6]
                add     ax, es:12h
                add     ax, es:10h
                xor     dx, dx
                mov     cx, 2
                push    es
                push    word ptr es:[si+8]
                push    dx
                push    ax
                push    cx
                nop
                push    cs
                call    near ptr GLOBALREALLOC
                pop     es

loc_89F5:                               ; CODE XREF: FASTBOOT+283↑j
                                        ; FASTBOOT+28A↑j
                push    cs:HINITMEM
                call    MYLOCK
                mov     cs:SEGINITMEM, ax
                mov     ax, [bp+var_6]
                add     ax, cs:SEGINITMEM
                sub     ax, cs:CPSHRUNK
                mov     cx, 0FFFFh
                push    [bp+var_2]
                push    di
                push    ax
                push    cx
                call    LOADSEGMENT
                jmp     loc_8919
; ---------------------------------------------------------------------------

loc_8A1D:                               ; CODE XREF: FASTBOOT+1E4↑j
                cld
                mov     es, [bp+var_2]
                mov     si, es:24h
                cmp     si, es:26h
                jnz     short loc_8A30
                jmp     loc_8AC4
; ---------------------------------------------------------------------------

loc_8A30:                               ; CODE XREF: FASTBOOT+2E8↑j
                lods    word ptr es:[si]
                mov     [bp+var_9], al
                jmp     loc_8ABB
; ---------------------------------------------------------------------------

loc_8A38:                               ; CODE XREF: FASTBOOT+37E↓j
                lods    word ptr es:[si]
                mov     [bp+var_8], ax
                mov     word ptr es:[si], 3173h
                mov     word ptr es:[si+2], cs
                add     si, 4

loc_8A49:                               ; CODE XREF: FASTBOOT+376↓j
                test    word ptr es:[si+4], 40h
                jz      short loc_8AB3
                mov     dx, es:[si]
                push    es
                push    dx
                mov     ax, es:[si+4]
                and     ax, 10h
                mov     bx, es:[si+2]
                mov     cl, [bp+var_9]
                shl     bx, cl
                push    ax
                push    bx
                call    FINDFREESEG
                jcxz    short loc_8A8D
                test    byte ptr es:[si+4], 10h
                jz      short loc_8A78
                pop     dx
                pop     es
                jmp     short loc_8AB3
; ---------------------------------------------------------------------------

loc_8A78:                               ; CODE XREF: FASTBOOT+32F↑j
                xor     ax, ax
                push    ax
                push    ax
                nop
                push    cs
                call    near ptr GLOBALCOMPACT
                push    cs:HINITMEM
                call    MYLOCK
                mov     cs:SEGINITMEM, ax

loc_8A8D:                               ; CODE XREF: FASTBOOT+328↑j
                pop     dx
                pop     es
                xor     dx, dx
                xchg    dx, es:[si+8]
                xchg    dx, es:[si]
                mov     ax, cs:SEGINITMEM
                sub     ax, cs:CPSHRUNK
                add     ax, dx
                push    es
                mov     bx, 0FFFFh
                push    es
                push    si
                push    ax
                push    bx
                call    RESALLOC
                pop     es
                mov     es:[si+8], ax

loc_8AB3:                               ; CODE XREF: FASTBOOT+30C↑j
                                        ; FASTBOOT+333↑j
                add     si, 0Ch
                dec     [bp+var_8]
                jnz     short loc_8A49

loc_8ABB:                               ; CODE XREF: FASTBOOT+2F2↑j
                lods    word ptr es:[si]
                or      ax, ax
                jz      short loc_8AC4
                jmp     loc_8A38
; ---------------------------------------------------------------------------

loc_8AC4:                               ; CODE XREF: FASTBOOT+2EA↑j
                                        ; FASTBOOT+37C↑j
                push    es
                call    TRIMEXEHEADER
                mov     ax, [bp+var_4]
                or      ax, ax
                jnz     short loc_8AD2
                jmp     short FB6
; ---------------------------------------------------------------------------
                align 2

loc_8AD2:                               ; CODE XREF: FASTBOOT+38A↑j
                sub     ax, cs:CPSHRUNK
                mov     cs:word_84B8, ax
                push    cs:HINITMEM
                call    MYLOCK
                mov     cs:SEGINITMEM, ax
                add     ax, cs:word_84B8
                mov     es, ax
                mov     cx, es:0
                cmp     cx, 454Eh
                jnz     short loc_8AFC
                jmp     loc_87A8
; ---------------------------------------------------------------------------

loc_8AFC:                               ; CODE XREF: FASTBOOT+3B4↑j
                jcxz    short FB6
                push    ds
                push    es
                pop     ds
                push    cs
                pop     es
                assume es:cseg01
                mov     si, 2
                mov     di, 84BAh
                cld
                mov     word ptr cs:LPBOOTAPP, di
                mov     word ptr cs:LPBOOTAPP+2, es
                rep movsb
                xor     ax, ax
                stosb
                pop     ds

FB6:                                    ; CODE XREF: FASTBOOT+38C↑j
                                        ; FASTBOOT:loc_8AFC↑j
                push    cs:HINITMEM
                nop
                push    cs
                call    near ptr GLOBALFREE
                mov     cs:HINITMEM, ax
                call    near ptr INITFWDREF
                call    ENABLEINT21
                mov     bx, 7F3Bh
                mov     es, cs:TOPPDB
                assume es:nothing
                mov     word ptr cs:[bx+2], 80h
                mov     word ptr cs:[bx+4], es
                mov     word ptr cs:[bx+6], offset WIN_SHOW
                mov     word ptr cs:[bx+8], cs
                mov     word ptr cs:[bx+0Ah], 6Ch ; 'l'
                mov     word ptr cs:[bx+0Ch], es
                mov     ax, es:2Ch
                mov     cs:[bx], ax
                mov     es, cs:HEXEHEAD
                push    word ptr es:6

loc_8B65:                               ; CODE XREF: FASTBOOT+433↓j
                                        ; FASTBOOT+452↓j
                pop     cx
                jcxz    short loc_8B97
                mov     es, cx
                push    word ptr es:6
                xor     ax, ax
                cmp     es:16h, ax
                jz      short loc_8B65
                xor     bx, bx
                xor     dx, dx
                test    word ptr es:0Ch, 8000h
                jnz     short loc_8B8A
                mov     bx, offset BOOTEXECBLOCK
                mov     dx, cs

loc_8B8A:                               ; CODE XREF: FASTBOOT+440↑j
                mov     cx, 0FFFFh
                push    ax
                push    dx
                push    bx
                push    es
                push    cx
                call    STARTMODULE
                jmp     short loc_8B65
; ---------------------------------------------------------------------------

loc_8B97:                               ; CODE XREF: FASTBOOT+423↑j
                cmp     word ptr cs:LPBOOTAPP+2, 0
                jz      short loc_8BB3
mov             bx, offset BOOTEXECBLOCK
                push    word ptr cs:LPBOOTAPP+2
                push    word ptr cs:LPBOOTAPP
                push    cs
                push    bx
                nop
                push    cs
                call    near ptr LOADMODULE

loc_8BB3:                               ; CODE XREF: FASTBOOT+45A↑j
                mov     sp, bp
                pop     bp
                retn
FASTBOOT        endp


; =============== S U B R O U T I N E =======================================


SHRINK          proc near               ; CODE XREF: FINDFREESEG:loc_8596↑p
                                        ; FASTBOOT+30↓p
                push    es
                push    si
                push    di
                mov     ax, cs:SEGINITMEM
                dec     ax
                mov     es, ax
                mov     dx, es:3
                inc     ax
                mov     es, ax
                xor     bx, bx
                xchg    bx, cs:word_84B8
                add     cs:CPSHRUNK, bx
                mov     si, es
                add     si, bx
                mov     bx, si
                sub     bx, ax
                sub     dx, bx
                push    dx
                push    ds
                mov     ds, si
                call    BIGMOVE
                pop     ds
                pop     ax
                mov     cx, 4
                xor     dx, dx

loc_871A:                               ; CODE XREF: SHRINK+3A↓j
                shl     ax, 1
                rcl     dx, 1
                loop    loc_871A
                push    cs:HINITMEM
                push    dx
                push    ax
                push    cx
                nop
                push    cs
                call    near ptr GLOBALREALLOC
                push    cs:HINITMEM
                call    MYLOCK
                mov     cs:SEGINITMEM, ax
                pop     di
                pop     si
                pop     es
                retn
SHRINK          endp



; =============== S U B R O U T I N E =======================================


BIGMOVE    proc near               ; CODE XREF: SHRINK+2C↑p
                mov     bx, dx
                mov     cl, 0Ch
                add     bx, 0FFFh
                shr     bx, cl
                xor     si, si
                xor     di, di
                cld
                jmp     short loc_8BDF
; ---------------------------------------------------------------------------

loc_8BC8:                               ; CODE XREF: BIGMOVE+29↓j
                sub     dx, 1000h
                mov     cx, 8000h
                rep movsw
                mov     ax, ds
                add     ax, 1000h
                mov     ds, ax
                assume ds:nothing
                mov     ax, es
                add     ax, 1000h
                mov     es, ax
                assume es:nothing

loc_8BDF:                               ; CODE XREF: BIGMOVE+F↑j
                dec     bx
                jnz     short loc_8BC8
                mov     cl, 3
                shl     dx, cl
                mov     cx, dx
                rep movsw
                retn
BIGMOVE    endp

