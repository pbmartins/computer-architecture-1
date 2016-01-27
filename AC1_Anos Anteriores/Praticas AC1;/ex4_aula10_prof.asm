#Exerc�cio4_Aula10;
#PROF;
#Fun��o para calcular o valor m�dio de um array de reais codificados em formato de v�rgula flutuante em precis�o dupla
#e imprime o valor m�ximo do array;

#Faz mal o c�lculo do m�ximo do array!!!!
#REVER!


		.include "tp3_macros.asm"
		.data
		.eqv SIZE,11
array:		.double 8.1,-4.35,3.25,5.1,12.4,-15.0,87.45,9.5,27.3,15.8,35.19
k1:		.double 0.0
#str:		.asciiz "O array de doubles inicial �: "
str1:		.asciiz "\nO valor m�dio do array �: " 
str2:		.asciiz "\nO valor m�ximo do array �: "
		.text
		.globl main
		
main:
		addiu $sp,$sp,-8			#reserva espa�o na stack para $ra e $s0;
		sw $ra,0($sp)				#guarda $ra
		sw $s0,4($sp)				#guarda $s0
		
		la $a0,array				#$a0 = array;
		move $s0,$a0				#guarda $a0
		li $a1,SIZE				#$a1 = SIZE = 11; 
		
		#print_str(str)
		#move $a0,$s0
		#falta fazer o print do array inicial!
			
		jal d_avg				#result in $f0
		
		print_str(str1)
		
		mov.d $f12,$f0				#passa para $f12 o valor de $f0 para fazer a syscall;
		#print_double		
		li $v0,3
		syscall
		
		move $a0,$s0
		jal d_max
		
		print_str(str2)
		mov.d $f12,$f0
		#print_double		
		li $v0,3
		syscall
		
		
		li $v0,0				#return 0
		lw $ra,0($sp)				#restaura $ra
		lw $s0,4($sp)				#restaura $s0
		addiu $sp,$sp,8				#liberta espa�o na stack;
		jr $ra

d_avg:
		l.d $f0,k1				#soma = 0.0
		li $t0,0				#i = 0;
		
avg_for:
		#for(; i<n; ){
		bge $t0,$a1,avg_ef			
		sll $t1,$t0,3				#$t1 = 8xi
		addu $t1,$t1,$a0			#$t1 = &A[i]
		l.d $f4,0($t1)				#$f4 = A[i]
		add.d $f0,$f0,$f4			#soma += A[i]
		addi $t0,$t0,1				#i++
		b avg_for				#}
		
avg_ef:
		beqz $a1,avg_eif			#if(n==0) avg_eif
		mtc1 $a1,$f4				
		cvt.d.w $f4,$f4				#$f4 = (double) n;
		div.d $f0,$f0,$f4			#return soma/(double)n;
		
avg_eif:
		jr $ra					#}
		
d_max:
		bnez $a1,m_notz
		l.d $f0,k1
		jr $ra
		
m_notz:
		l.d $f0,0($a0)
		li $t0,1
		
max_for:
		bge $t0,$a1,max_ex
		sll $t1,$t0,3
		addu $t1,$t1,$a0
		l.d $f4,0($t1)
		c.le.d $f4,$f0
		bc1t max_eif
		mov.d $f0,$f4
		
max_eif:
		addi $t0,$t0,1
		b avg_eif

max_ex:
		jr $ra