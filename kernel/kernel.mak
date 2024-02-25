# Modern Personality makefile for KERNEL
# Requires: MASMv4, MSCv4

#
# | | | KERNSTUB | | |
# yes the build output is in the kernel folder


KERNSTUB.OBJ:	kernel\KERNSTUB.ASM
	MASM kernel\KERNSTUB.ASM 

#KERNSTUB.EXE:	kernel\KERNSTUB.OBJ#
#	LINK kernel\KERNSTUB.EXE $@
#$@ = kernstub