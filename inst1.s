.text
.globl main
main:
	li a0, 1
    li a1, 1
    addi a2, zero, 5
    beq a2, zero, fim
loop:
	mul a1, a1, a2
    sub a2, a2, a0
    beq a2, a0, fim
    bgt a2, a0, loop
fim:
	nop