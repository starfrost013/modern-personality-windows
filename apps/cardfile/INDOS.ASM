        title   indos.asm

;****************************************************************/
;*                                                              */
;*  Windows Cardfile - Written by Mark Cliggett                 */
;*  (c) Copyright Microsoft Corp. 1985 - All Rights Reserved    */
;*                                                              */
;****************************************************************/

.xlist
include \lib\cmacros.inc
.list

createSeg   _FILE,nrfile,byte,public,CODE

sBegin  DATA
sEnd    DATA

sBegin  NRFILE

assumes CS,NRFILE
assumes DS,DATA

cProc   Frename,<PUBLIC,NEAR>,<di>
    parmW src
    parmW dst
cBegin
        mov     dx,src
        push    ds
        pop     es
        mov     di,dst
        mov     ah,56h
        int     21h
        jc      renexit
        xor     ax,ax
renexit:
cEnd

;
; Fdelete (pch) - delete a file
;   returns 0 or -1
;

cProc   Fdelete,<PUBLIC,FAR>
    parmW src
cBegin
        mov     dx,src
        mov     ah,41h
        int     21h
        jc      rmexit
        xor     ax,ax
rmexit:
cEnd

cProc mylread,<PUBLIC,NEAR>
    parmW fh
    parmD buf
    parmW count
cBegin
    push    ds
    mov     bx,fh
    lds     dx,buf
    mov     ah,3fh
    mov     cx,count
    int     21h
    jnc     lreaddone
    xor     ax,ax
lreaddone:
    pop     ds
cEnd

cProc myread,<PUBLIC,NEAR>
    parmW fh
    parmW buf
    parmW count
cBegin
    mov     bx,fh
    mov     dx,buf
    mov     ah,3fh
    mov     cx,count
    int     21h
    jnc     readdone
    xor     ax,ax
readdone:
cEnd

cProc mylwrite,<PUBLIC,NEAR>
    parmW   fh
    parmD   buf
    parmW   count
cBegin
    push    ds
    mov     bx,fh
    lds     dx,buf
    mov     ah,40h
    mov     cx,count
    int     21h
    jnc     lwritedone
    xor     ax,ax
lwritedone:
    pop     ds
cEnd

cProc mywrite,<PUBLIC,NEAR>
    parmW   fh
    parmW   buf
    parmW   count
cBegin
    mov     bx,fh
    mov     dx,buf
    mov     ah,40h
    mov     cx,count
    int     21h
    jnc     writedone
    xor     ax,ax
writedone:
cEnd

sEnd    NRFILE

end
