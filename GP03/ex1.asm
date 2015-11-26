.data
str1: .asciiz "Introduza um numero:\n"
str2: .asciiz "\nO valor em binario: "
char0: .asciiz "0"
char1: .asciiz "1"
space: .asciiz " "

.text
.globl main
main:	la $a0, str1
	ori $v0, $0, 4
	syscall
	
	ori $v0, $0, 5
	syscall
	or $s0, $0, $v0
	
	la $a0, str2
	ori $v0, $0, 4
	syscall
	
	# $s0 = value
	# $t1 = i
	# $t2 = 31
	# $t3 = bit
	# $t4 = 4bit counter
	# $t5 = 4
	
	ori $t1, $0, 0
	ori $t2, $0, 32
	ori $t4, $0, 1
	ori $t5, $0, 4
for:	beq $t1, $t2, exit

	# Set to print char
	ori $v0, $0, 4
	
	andi $t3, $s0, 0x80000000
	beqz $t3, pchar0
	j pchar1
	
pchar0:	la $a0, char0 # print 0
	syscall
	j shift
	
pchar1:	la $a0, char1 # print 1
	syscall
	
shift:	sll $s0, $s0, 1

	beq $t4, $t5, psp
	j addlp

psp:	la $a0, space # print space
	syscall
	ori $t4, $0, 0

addlp:	addi $t1, $t1, 1
	addi $t4, $t4, 1
	j for

exit:	jr $ra