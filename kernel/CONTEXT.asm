; ****** modern:personality project ******
; Reverse engineered code  © 2022-2024 starfrost. See licensing information in the licensing file
; Original code            © 1982-1986 Microsoft Corporation

; CONTEXT.ASM: Context management for processes (events, yielding, handles...)
;
; Also has the main loop of the scheduler in the RESCHEDULE function (that handles task priority and waits for the processes to yield)
; No, it's not in SCHEDULE.ASM...Why microsoft?

;
; External Entry #30 into the Module
; Attributes (0001): Fixed Exported
;
; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public WAITEVENT
WAITEVENT       proc far

arg_0           = word ptr  6

                inc     bp              ; KERNEL_30
                push    bp
                mov     bp, sp
                push    ds
                mov     ax, [bp+arg_0]
                call    GETTASKHANDLE
                mov     ds, ax
                xor     ax, ax
loc_3C01:
                pushf
                cli
                dec     word ptr ds:6 ; decrement remaining event count
                jge     short loc_3C1E ; is it FF, then leave
                mov     word ptr ds:6, 0
                jmp     short loc_3C12
; ---------------------------------------------------------------------------

ret1:                                   ; CODE XREF: WAITEVENT+21↓p
                iret
; ---------------------------------------------------------------------------

loc_3C12:                               ; CODE XREF: WAITEVENT+1D↑j
                push    cs
                call    ret1
                mov     ax, offset loc_3C01
                push    cs
                push    ax
                jmp     near ptr RESCHEDULE
; ---------------------------------------------------------------------------

loc_3C1E:                               ; CODE XREF: WAITEVENT+15↑j
                jmp     short loc_3C21
; ---------------------------------------------------------------------------

ret2:                                   ; CODE XREF: WAITEVENT+30↓p
                iret
; ---------------------------------------------------------------------------

loc_3C21:                               ; CODE XREF: WAITEVENT:loc_3C1E↑j
                push    cs
                call    ret2
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf    2
WAITEVENT       endp
;
; External Entry #29 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

                public YIELD
YIELD           proc far                ; CODE XREF: STARTTASK+69↑p
                inc     bp              ; KERNEL_29
                push    bp
                mov     bp, sp
                push    ds
                xor     ax, ax
                cmp     cs:INSCHEDULER, al
                jnz     short yield_done ; if we are currently scheduling, don't bother yielding
                mov     ds, cs:CURTDB   ; get the current task data block
                cmp     word ptr ds:7Eh, 4454h ; is 0x7E in the TDB 'MZ' header?
                jnz     short not_task_handle
                mov     ax, offset loc_3C85
                inc     word ptr ds:6
                push    cs
                push    ax
                jmp     near ptr RESCHEDULE
; ---------------------------------------------------------------------------

not_task_handle:                        ; CODE XREF: YIELD+19↑j
                mov     ax, 301h
                push    ax
                mov     ax, offset SZERRYIELDINVALIDTASKHANDLE ; "YIELD: Invalid task handle"
                push    cs
                push    ax
                xor     ax, ax
                push    ax
                push    ax
                call    KERNELERROR
                jmp     short loc_3C85
; ---------------------------------------------------------------------------
SZERRYIELDINVALIDTASKHANDLE db 'YIELD: Invalid task handle',0
                                        ; DATA XREF: YIELD+2B↑o
                db 24h
; ---------------------------------------------------------------------------

loc_3C85:                               ; CODE XREF: YIELD+37↑j
                dec     word ptr ds:6
                mov     ax, 0FFFFh

yield_done:                               ; CODE XREF: YIELD+C↑j
                sub     bp, 2
                mov     sp, bp
                pop     ds
                pop     bp
                dec     bp
                retf
YIELD           endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================


GETTASKHANDLE_VARIANT_UNDOCUMENTED proc near ; CODE XREF: SETTASKQUEUE↓p
                                        ; SETPRIORITY↓p
                mov     bx, sp
                mov     ax, ss:[bx+8]
                mov     bx, ss:[bx+6]
                jmp     short GETTASKHANDLE
GETTASKHANDLE_VARIANT_UNDOCUMENTED endp


; =============== S U B R O U T I N E =======================================


GETTASKHANDLE_VARIANT_UNDOCUMENTED_2 proc near ; CODE XREF: POSTEVENT↓p
                                        ; GETTASKQUEUE↓p
                mov     bx, sp
                mov     ax, ss:[bx+6]
GETTASKHANDLE_VARIANT_UNDOCUMENTED_2 endp


; =============== S U B R O U T I N E =======================================

; Function Name: GetTaskHandle
;
; Purpose: Gets a handle to a running task.
;
; Parameters: ax (optional): A pointer (likely segaddr handle) to a hTask object.
;                            If NULL, gets the handle to the currently running task.
;
; Returns: The task handle.
;          This function failing is a FATAL ERROR, and the OS EXITS.
;
; Notes: Internal only function. Not for user apps. Possibly needs debugging


GETTASKHANDLE   proc near               ; CODE XREF: WAITEVENT+8↑p
                                        ; GETTASKHANDLE_VARIANT_UNDOCUMENTED+A↑j ...
                or      ax, ax                          ; did the user provide a hTask pointer?
                jnz     short verify_and_return_handle  ; if they did, branch
                mov     ax, cs:CURTDB                   ; if they didn't, get the current TDB (task data block) segaddr 

verify_and_return_handle:                               
                mov     es, ax                          ; convert to segaddress so it can be referenced as a segment
                cmp     word ptr es:7Eh, 4454h          ; is 0x7E of the task data block the string "TD"? (same as MDOS4!)
                jnz     short invalid_task_handle       ; If not, this is considered a fatal error (as it can't be a TDB). 
                retn
; ---------------------------------------------------------------------------

invalid_task_handle:                               ; CODE XREF: GETTASKHANDLE+11↑j
                mov     ax, 301h
                push    ax
                mov     ax, offset SZERRINVALIDTASKHANDLE ; "GetTaskHandle: Invalid task handle"
                push    cs
                push    ax
                xor     ax, ax
                push    ax
                push    ax
                call    KERNELERROR
                jmp     short locret_3CF1
; ---------------------------------------------------------------------------
SZERRINVALIDTASKHANDLE db 'GetTaskHandle: Invalid task handle',0
                                        ; DATA XREF: GETTASKHANDLE+18↑o
                db 24h
; ---------------------------------------------------------------------------

locret_3CF1:                            ; CODE XREF: GETTASKHANDLE+24↑j
                retn
GETTASKHANDLE   endp

;
; External Entry #31 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public POSTEVENT
POSTEVENT       proc far
                call    GETTASKHANDLE_VARIANT_UNDOCUMENTED_2 ; KERNEL_31
                inc     word ptr es:6
                retf    2
POSTEVENT       endp

;
; External Entry #35 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public GETTASKQUEUE
GETTASKQUEUE    proc far
                call    GETTASKHANDLE_VARIANT_UNDOCUMENTED_2 ; KERNEL_35
                mov     ax, es:12h
                retf    2
GETTASKQUEUE    endp

; ---------------------------------------------------------------------------
;
; External Entry #38 into the Module
; Attributes (0001): Fixed Exported
;

                public SETTASKSIGNALPROC
SETTASKSIGNALPROC:
                mov     cl, 14h ; probably tdb offset
; ---------------------------------------------------------------------------
                db 0BBh
; ---------------------------------------------------------------------------
;
; External Entry #40 into the Module
; Attributes (0001): Fixed Exported
;

                public SETTASKINTERCHANGE
SETTASKINTERCHANGE:
                mov     cl, 1Ch ; probably tdb offset
; ---------------------------------------------------------------------------
                db 0BBh
;
; External Entry #39 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public SETTASKSWITCHPROC
SETTASKSWITCHPROC proc far
                mov     cl, 18h
                mov     bx, sp
                mov     ax, ss:[bx+8]
                call    GETTASKHANDLE
                mov     ax, ss:[bx+4]
                mov     dx, ss:[bx+6]
                xor     bx, bx
                mov     bl, cl
                xchg    ax, es:[bx]
                xchg    dx, es:[bx+2]
                retf    6
SETTASKSWITCHPROC endp

;
; External Entry #34 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


                public SETTASKQUEUE
SETTASKQUEUE    proc far
                call    GETTASKHANDLE_VARIANT_UNDOCUMENTED ; KERNEL_34
                mov     ax, bx
                xchg    ax, es:12h
                retf    4
SETTASKQUEUE    endp

;
; External Entry #32 into the Module
; Attributes (0001): Fixed Exported
;

; =============== S U B R O U T I N E =======================================


; Function Name: SetPriority(hTask, nChangeAmount)
;
; Purpose: Modifies the priority of task hTask (pointer to which is represented by the hTask handle) by amount nChangeAmount.
; Priority must be between -15 and 15. Yes, this is a signed value.
;
; Returns: The new process priority.
;
; Notes: Incredibly hacky. They delete the task and re-create it. Wtf?

                public SETPRIORITY
SETPRIORITY     proc far
                call    GETTASKHANDLE_VARIANT_UNDOCUMENTED ; get the TDB from hTask, this will fatalexit if the task is wrong
                add     bl, es:8                    ; get new task priority by adding the old task priority (TDB:0008h) to bl (nChangeAmount)
                cmp     bl, 0E0h                    ; is new priority above or equal to -15?
                jge     short check_priority_high   ; branch   
                mov     bl, 0E0h                    ; set it to -15 if it's below -15 

check_priority_high:                                ; CODE XREF: SETPRIORITY+B↑j
                cmp     bl, 0Fh                     ; Is priority above 15?
                jle     short set_priority          ; no, branch
                mov     bl, 0Fh                     ; now, go

set_priority:                               ; CODE XREF: SETPRIORITY+12↑j
                push    bx                          ; bx contains task priority
                inc     bx                          ; increment by 1
                mov     es:8, bl                    ; set priority (TDB:0x08)
                push    es                          
                push    es                          ; push task (why are there two pushes here, probably for insert and delete)
                call    DELETETASK                  ; delete the entire god damn task
                push    ax                          ; ax->task pointer for inserttask call
                call    INSERTTASK                  ; recreate the task (the purpose of this is to push it down the queue)
                pop     es                          ; get new task 
                dec     byte ptr es:8               ; decrement the priority by 1 for some reason (we incremented it ealrier)
                pop     ax                          ; return value from INSERTTASK 
                cbw                                 ; sign extend it for calling convention
                retf    4                           
SETPRIORITY     endp


; =============== S U B R O U T I N E =======================================

; Attributes: bp-based frame

; This is the main loop and handles scheduling all tasks.
; When no task is running, this functions runs.
RESCHEDULE      proc far                ; CODE XREF: WAITEVENT+29↓j
                                        ; YIELD+24↓j
                inc     bp
                ; interrupt to 1427:xxxx normally happens here?
                push    bp
                mov     bp, sp
                push    ds
                push    si
                push    di
                push    ax              
RESCHEDULE      endp ; sp-analysis failed

      
; =============== S U B R O U T I N E =======================================

; is actually the second half of RESCHEDULE, this is called during boot
; TODO: CHANGE TO LABEL
BOOTSCHEDULE    proc far                ; CODE XREF: BOOTSCHEDULE+A↓j
                                        ; BOOTSCHEDULE+E3↓j ...
                mov     ax, cs:HEADTDB  ; get currently running process
; nothing to do...so sleep :)

idle_loop:                               ; CODE XREF: BOOTSCHEDULE+16↓j
                                        ; BOOTSCHEDULE+51↓j
                or      ax, ax          ; is there a curerntly running task (this is a segaddress paragraph-aligned pointer)
                jnz     short loc_3B18  ; if HEADTDB is NULL (i.e. no task currently running, as in boot), we have to reschedule and get a currently running task
                int     28h             ; DOS 2+ internal - KEYBOARD BUSY LOOP (wait state)
                jmp     short near ptr BOOTSCHEDULE ; loop
; ---------------------------------------------------------------------------

loc_3B18:                               ; CODE XREF: BOOTSCHEDULE+6↑j
                mov     ds, ax          ; set DS to current task data block
                mov     ax, ds:0        ; set up regs for compare
                cmp     word ptr ds:6, 0 ; are there any events to process for our current process?
                jz      short idle_loop ; no, go back to sleep
                mov     di, ds          ; there are, let's set up more registers
                mov     si, cs:CURTDB   ; get current process tdb pointer
; this basically checks if CurTDB != HeadTDB (i.e. is the head of the task queue - the next process to run 
; *not* the actually running process. basically, is there more than one process running)
; if there is only one process running we don't need to reschedule ever
; apparently despite being LOADMODULE'd, GDI and USER etc aren't processes (the shell is)
; todo: do GDI/USER change the calculation here
                cmp     di, si          
                jne     short reschedule_check_supertask  ; yes, time to resched
                pop     ax              ; restore the registers
                pop     di
                pop     si
                pop     ds
                pop     bp
                dec     bp
                retf                    ; go back to whatever we were doing before
; ---------------------------------------------------------------------------

reschedule_check_supertask:                               ; CODE XREF: BOOTSCHEDULE+21↑j
                push    cx
                mov     cx, cs:LOCKTDB  ; is there a supertask (task that blocks all other processes)
                jcxz    short reschedule_check_dos  ; pointer to supertask TDB is NULL, so don't bother  
                cmp     cx, di
                jne     short reschedule_abort

reschedule_check_dos:                               ; CODE XREF: BOOTSCHEDULE+30↑j
                push    es
                push    bx
                ; See if an unsafe DOS API is running (DOS is not re-entrant)
                les     bx, cs:PINDOS               ; load into es:[bx] 
                cmp     byte ptr es:[bx], 0
                jnz     short loc_3B5A
                les     bx, cs:PERRMODE
                cmp     byte ptr es:[bx], 0
                jz      short loc_3B5F

loc_3B5A:                               ; CODE XREF: BOOTSCHEDULE+41↑j
                pop     bx
                pop     es
                pop     cx
                jmp     short idle_loop
; ---------------------------------------------------------------------------

loc_3B5F:                               ; CODE XREF: BOOTSCHEDULE+4C↑j
                inc     cs:INSCHEDULER ; tell the OS that we are in the scheduler
                push    dx
                inc     byte ptr ds:8 ; increment task priority
                push    ds
                call    DELETETASK ; delete it from the task queue
                push    ds
                call    INSERTTASK ; put it back (this shoves it down to the bottom of the queue and has the effect of shutting it out)
                dec     byte ptr ds:8 ; decrement task priority
                cli
                mov     es, si
                xor     si, si
                cmp     word ptr es:7Eh, 4454h ; check TDB signature (offset 0x7E), is it 'TD'?
                jne     short loc_3B93 ; no, branch
                mov     word ptr es:4, ss
                mov     es:2, sp
                mov     si, es
                push    si
                call    SAVESTATE

loc_3B93:                               ; CODE XREF: BOOTSCHEDULE+75↑j
                push    ds
                push    si
                call    RESTORESTATE
                mov     ss, word ptr ds:4
                mov     sp, ds:2
                mov     cs:CURTDB, ds
                dec     cs:INSCHEDULER
                sti
                cmp     word ptr ds:16h, 0
                jnz     short loc_3BBD

loc_3BB2:                               ; CODE XREF: BOOTSCHEDULE+D5↓j
                pop     dx
                pop     bx
                pop     es

reschedule_abort:                               ; CODE XREF: BOOTSCHEDULE+34↑j
                ; We're done whatever we need to do
                pop     cx
                pop     ax
                pop     di
                pop     si
                pop     ds
                pop     bp
                dec     bp
                retf
; ---------------------------------------------------------------------------

loc_3BBD:                               ; CODE XREF: BOOTSCHEDULE+A4↑j
                mov     ax, 10h
                mov     bp, sp
                add     bp, 10h
                mov     cx, 1
                xchg    cx, ds:6
                dec     cx
                push    cx
                push    ds
                push    ax
                push    si
                push    cx
                push    word ptr ds:12h
                call    dword ptr ds:14h ; call signal handler
                pop     cx
                add     ds:6, cx
                or      ax, ax
                jz      short loc_3BB2
                push    ds
                call    DELETETASK
                push    ds
                call    INSERTTASK
                pop     dx
                pop     bx
                pop     es
                pop     cx
                jmp     near ptr BOOTSCHEDULE
BOOTSCHEDULE    endp ; sp-analysis failed


; =============== S U B R O U T I N E =======================================
; context.asm?
; or maybe ld.asm

; Function Name: GetVersion()
;
; Purpose: Returns the operating system version.
; Windows 1.0 DR5 to 1.01                                               0x1
; Windows 1.02                                                          0x102
; Windows 1.03                                                          0x103
; Windows 1.04                                                          0x104
; Windows 2.01                                                          0x201
; Windows 2.02 (from Excel for Windows 2.0 runtime install)             0x202
; Windows 2.03                                                          0x203 (haven't checked other values)
; Windows 2.10                                                          0x210 (probably intended to be BCD)
; Windows 2.11                                                          0x211 (probably intended to be BCD)

; Returns: The new process priority. In Windows 2.01 and above, returns the DOS version and revision when called from assembly, but not in public headers. (used to detect OS/2/DOS5).


                public GETVERSION
GETVERSION      proc far                ; CODE XREF: RETTHUNK+6B↓p
                mov     ax, 301h        ; 0103h = Windows 1.03
                retf
GETVERSION      endp
