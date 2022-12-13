.text
addi  a0, x0, 4               # 4 = Print string
la    a1, teste               # a1 - endereco que aponta para string
ecall                         # Call para saida - string

.data                         # memoria de dados (0x10000000)
teste:  .asciiz "HELLO WORLD\n"   # string