# Modern Personality makefile for KERNEL
# Requires: MASMv4, MSCv4

#
# | | | KERNSTUB | | |
#

KERNSTUB.OBJ:	KERNSTUB.ASM
	MASM KERNSTUB.ASM

KERNSTUB.EXE:	KERNSTUB.OBJ
	LINK KERNSTUB.EXE $@
#$@ = kernstub