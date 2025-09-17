; KDATA.ASM kernel globals
; This file is so that KDATA.ASM can compile! This isn't in the original windows source, they defined everything in every file. But that sucks, so we did this.

; See comments there for use 


; ANY ARRAY IS EXTERNB!

; Heap
externW HGLOBALHEAP
externW PGLOBALHEAP
externW PSWAPHOOK
externW HEXEHEAD
externW HEXESWEEP
externW HTHUNKS
externW HHANDLE

; Process Data Block
externW TOPPDB
externW HEADPDB
externW TOPSIZEPDB

; Task Data Block
externW HEADTDB
externW CURTDB
externW LOCKTDB
externW FWINX
externW F8087
externB INSCHEDULER
externB FEMM
externW BUFFER
externW BUFADDR
externW HFILE
externW INT22BASE
externD PDMAADD
externD PINDOS
externD PCNTCFLAG
externD PCURRENTPDB
externD PERRMODE
externD PSFTLINK
externD PFILETABLE 
externW FILEENTRYSIZE
externB LASTDRIVESWAPPED
externB FBREAK

; DOS stuff
externB DOS_VERSION
externB DOS_REVISION
externB DOS_OEM
externB FINT21
externB FEVENT
externB KEYINFO
externB FFAREAST

; These are obtained from USER
externD PMBOXPROC
externD PEXITPROC
externD PSYSPROC
externD PTIMERPROC
externD PKEYPROC
externD PREVINT20PROC ; DOS 1.x terminate
externD PREVINT21PROC ; DOS API
externD PREVINT24PROC ; Fatal error
externD PREVINT27PROC ; Dos 1.x TSR
externD PREVINT3FPROC ; Dynamic linking
externD PREVBCON ; Console pointer
externB FBOOTING
externB CDEVAT
externW OLDERRNO
externB OUTBUF
externW BUFPOS
externB USERPROBUF

; Strings
; Are strings "extern"?
externB SZUSERPRO
externB SZDISKMSG1
externB SZDISKMSG2

; Are these duplicated strings really needed, or are they immeds?
externB DRVLET
externB DRVLET1
externB DRVLET2
externB DRVLET3
externB SZWINDISK
externB SZDISKCAP
externB SYSERR
externB SZCANNOTFIND1
externB SZCANNOTFIND2
externB MSGCANNOTREADDRV
externB MSGCANNOTWRITEDRV
externB SZERRCANNOTREAD
externB SZERRCANNOTWRITE
externB SZERRPRINTERNOTREADY
externB SZERRFAILEDLOADING
externB SZERRFAILEDLOADINGNEWINSTANCE
externB SZERRFAILEDLOADINGRESOURCE
externB SZERRFATALEXIT
externB SZERRSTACKOVERFLOW

if KDEBUG 
    externB SZERRSTACKTRACE
    externB SZERRABORT
    externB SZERRINVALIDBPCHAIN
endif
externNP KERNELERROR                        ; Let's give up    
