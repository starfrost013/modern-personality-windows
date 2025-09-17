@echo off

echo Building Kernel...


del out\*.obj
del out\*.lst
del out\*.crf
del out\*.exe
REM REQUIRED for some stupid stuff
REM Run under MS-DOS!

SET "PATH=..\kernel;.\out"

make ..\kernel\kernel.mak

REM this crappy old dos version doesn't have "move" command and I can't change MASM's output directory
REM and the linkers don't like not being in current dir

copy *.obj out
copy *.lst out
copy *.crf out
del *.lst
del *.crf
del *.obj 
copy kernstub.exe out
copy kernel.exe out

REM get out of ms-dos player
exit 