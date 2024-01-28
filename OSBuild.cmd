:: ModernPersonality Build Environment
:: Version 0.1, 2023/12/13

@echo off
setlocal
path=%~dp0bin\;%path%

call :echobuild
echo Building Kernel...

msdos -d -e -m make kernel\kernel.mak

goto :eof

:echobuild
::terrible!!!!
<nul set /p="[BUILD]: "
exit /b 

:eof