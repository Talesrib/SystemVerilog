.section .text
.globl main
main:
	addi x10, zero, 2
  addi x11, zero, 4
  beq x10, x11, outro
  add x12, x10, x10
  j fim
outro:
	add x12, x11, x11
fim:
  nop