:: Windowss 1.0 Decomp Kernel Temporary Compile Script (Powershell...because it has native VHD mounting)
::
:: This is a horrific kludge that will suffice until the crosscompilation infrastructure (dev16) works
::
:: This spins up a vhd with the current source code in it, starts 86box with custom args and then compiles the code so you can run it under dos.
:: The vhd is then mounted and spat out
::
:: Only for Windows but this is meant to be temporary

title Creating build environment...

:: Type 2 (PC-AT)

:: Delete the existing vhd
IF EXIST latest.vhd (del latest.vhd)
IF EXIST diskpart_temp.txt del diskpart_temp.txt

:: PC/AT 20mb hdd
VhdTool /create latest.vhd 21307392 

::we have to generate the diskpart scripts because path names have to be absolute???
echo select vdisk file="%~dp0latest.vhd" >> diskpart_temp.txt
echo attach vdisk >> diskpart_temp.txt
echo clean >> diskpart_temp.txt
::must be mbr
echo convert mbr >> diskpart_temp.txt 
echo create partition primary >> diskpart_temp.txt
echo select partition 1 >> diskpart_temp.txt
echo format quick fs=fat >> diskpart_temp.txt
echo assign letter=W >> diskpart_temp.txt

::run the diskpart script
diskpart /s diskpart_temp.txt

xcopy /E /exclude:compiletemp_exclude.txt ..\ W:\