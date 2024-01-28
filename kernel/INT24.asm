

; =============== S U B R O U T I N E =======================================


INT24HANDLER    proc far
                inc     cs:INSCHEDULER
                cmp     cs:INSCHEDULER, 1
                jz      short notinscheduler
                jmp     inscheduler
; ---------------------------------------------------------------------------

notinscheduler:                         ; CODE XREF: INT24HANDLER+B↑j
                sti
                cld
                push    ds
                push    es
                push    dx
                push    cx
                push    bx
                push    di
                mov     ds, bp
                mov     cx, [si+4]
                mov     cs:CDEVAT, ch
                push    cs
                pop     es
                assume es:cseg01
                mov     di, 1DAh
                mov     cx, 8
                lea     si, [si+0Ah]
                push    si
                rep movsb
                pop     si
                mov     di, 1FAh
                mov     cx, 8
                rep movsb
                pop     di
                mov     bp, sp
                mov     bp, [bp+1Ch]
                push    cs
                pop     ds
                assume ds:cseg01
                mov     si, 92h
                mov     BUFPOS, si
                add     al, 41h ; 'A'
                mov     byte ptr DRVLET1, al ; "X:"
                mov     byte ptr DRVLET2, al ; "X:"
                mov     byte ptr DRVLET3, al ; "X:"
                test    ah, 1
                jz      short loc_4949
                mov     si, 1E3h
                test    CDEVAT, 80h
                jnz     short loc_4956
                mov     si, 1A9h
                jmp     short loc_4956
; ---------------------------------------------------------------------------

loc_4949:                               ; CODE XREF: INT24HANDLER+56↑j
                mov     si, 1C2h
                test    CDEVAT, 80h
                jnz     short loc_4956
                mov     si, 18Fh

loc_4956:                               ; CODE XREF: INT24HANDLER+60↑j
                                        ; INT24HANDLER+65↑j ...
                mov     ax, di
                xor     ah, ah
                mov     OLDERRNO, ax
                mov     dx, 16Eh
                or      ax, ax
                jz      short loc_496D
                mov     dx, 203h
                cmp     al, 9
                jz      short loc_496D
                mov     dx, si

loc_496D:                               ; CODE XREF: INT24HANDLER+80↑j
                                        ; INT24HANDLER+87↑j
                call    APPEND
                call    GENTER
                inc     word ptr [di+2]
                call    GLEAVE
                call    loc_49D9
                call    GENTER
                dec     word ptr [di+2]
                call    GLEAVE
                cmp     ax, 2
                nop
                mov     al, 2
                jz      short loc_498F
                mov     al, 1

loc_498F:                               ; CODE XREF: INT24HANDLER+A9↑j
                pop     bx
                pop     cx
                pop     dx
                pop     es
                assume es:nothing
                pop     ds
                assume ds:nothing
                cmp     al, 2
                jb      short dos31_or_above

inscheduler:                            ; CODE XREF: INT24HANDLER+D↑j
                mov     al, 3
                cmp     cs:DOS_VERSION, al
                jb      short loc_49B3
                ja      short dos31_or_above
                cmp     cs:DOS_REVISION, 0Ah
                jnb     short dos31_or_above
                test    cs:CDEVAT, 80h
                jz      short dos31_or_above

loc_49B3:                               ; CODE XREF: INT24HANDLER+BD↑j
                lds     si, cs:PERRMODE
                mov     byte ptr [si], 0
                mov     bp, sp
                or      byte ptr [bp+1Ch], 1
                add     sp, 8
                pop     bx
                pop     cx
                pop     dx
                pop     si
                pop     di
                pop     bp
                pop     ds
                pop     es
                mov     ax, cs:OLDERRNO
                add     ax, 13h

dos31_or_above:                         ; CODE XREF: INT24HANDLER+B4↑j
                                        ; INT24HANDLER+BF↑j ...
                dec     cs:INSCHEDULER
                iret
; ---------------------------------------------------------------------------

loc_49D9:                               ; CODE XREF: INT24HANDLER+97↑p
                mov     bx, 153h
                mov     cx, 1015h
                mov     ds, cs:CURTDB
                mov     di, ss
                cmp     di, ds:4
                jz      short SHOWDIALOGBOX2
                mov     si, sp
                cli
                mov     ss, word ptr ds:4
                mov     sp, ds:2
                sti
                mov     bp, sp
                add     bp, 10h
                call    SHOWDIALOGBOX2
                mov     ds:2, sp
                cli
                mov     ss, di
                mov     sp, si
                sti
                retn
INT24HANDLER    endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


SHOWDIALOGBOX2  proc near               ; CODE XREF: PROMPT:loc_217D↑p
                                        ; INT24HANDLER+108↑j ...
                xor     ax, ax
                cmp     cs:FINT21, al
                jz      short locret_4A25
                push    ax
                push    cs
                mov     dx, 92h
                push    dx
                push    cs
                push    bx
                push    cx
                call    cs:PMBOXPROC
                cmp     ax, 2

locret_4A25:                            ; CODE XREF: SHOWDIALOGBOX2+7↑j
                retn
SHOWDIALOGBOX2  endp
