; ****** modern:personality project ******
; Reverse engineered code  © 2022-2025 starfrost. See licensing information in the licensing file
; Original code            © 1982-1986 Microsoft Corporation

; kernel.asm: Misc unidentified crap.
INCLUDE KERNEL.inc
INCLUDE KDATA.inc
sBegin CODE

assumeS CS,CODE
assumeS DS,CODE



; ---------------------------------------------------------------------------


sEnd CODE

; Some boot data like BOOTTDB needs to be moved here...
BOOTSTACKSIZE = 512 

sBegin  STACK
    
    db BOOTSTACKSIZE dup (?)
sEnd STACK

end
