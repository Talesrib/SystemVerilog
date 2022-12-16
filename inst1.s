.text
.globl main
main:
	addi x1, zero , 5 # n
	addi x5,zero, -1 #contante com valor -1
    addi x3, zero, 1 #contante com valor 1
    addi x4, zero, 1 #x4 -e o valor final de fatorial (valor inicial um)
    add x6, zero, x1
    j fact
fact:
    bge x6,x3, maiorUm # se for maior que um
    
maiorUm:
	add x7, x1, x5
	mul x4,x6,x7
    j fact