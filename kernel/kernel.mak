# Modern Personality makefile for KERNEL 1.03
# Requires: 
#		MASM 4.0 (1985)
#		Microsoft C 4.0 (1986)
#		Microsoft LINK ("Overlay Linker") 3.51
# 		Microsoft Link4 ("Segmented-Executable Linker") 5.00.12

#
# | | | KERNSTUB | | |
# yes the build output is in the kernel folder


KERNSTUB.OBJ:	kernel\KERNSTUB.ASM
	NASM kernel\KERNSTUB.ASM 

KERNSTUB.EXE:	kernel\KERNSTUB.OBJ#
	LINK kernel\KERNSTUB.EXE $@

$@ = kernstub

