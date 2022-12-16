.text
.globl main
main:
	addi x4, zero, 0xFE
    li x5, 0x000
    lui x5, 0x10000
    sw x4, 0xc(x5)
    lw x10, 0xc(x5)