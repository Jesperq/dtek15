  # labwork.S
  # Written 2015 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1 2015-2016.
  # The macros PUSH and POP are in the public domain



.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm

.data
.global delay, time2string
.text

  # You can add your own code here
  #
  
hexasc:
	andi $t4, 15		#maska med 15 f�r att f� fyra f�rsta bitarna
	addi $t4, $t4, 48	#hoppa fram till ascii f�r 0 (minst)
	
	blt $t4, 58, print	#om a0 �r mellan 0-9 printas det direkt
	nop
	addi $t4, $t4, 7	#annars l�gg till 7 f�r att komma till ascii f�r A
	
print:
	andi $t4, 127		#maska de 7 minst signifikanta bitarna
	jr $ra			#hoppa tillbaka
	nop
	
  #delay function
  #

delay:
	addi	$sp,$sp,-4	#pusha return adress till stack point
	sw	$ra,0($sp)
	
	addi	$sp,$sp,-4	#pusha a0 till stacken
	sw	$a0,0($sp)
	
	addi	$sp,$sp,-4	#pusha t0 till stacken
	sw	$t0,0($sp)
	
	addi	$sp,$sp,-4	#pusha t1 till stacken
	sw	$t1,0($sp)
	
	li 	$a0, 1000	#ms
	li	$t0, 500000	#konstant (�ndras pga dator osv)
	li	$t1, 0		#i=0
	
while:
	bge $0, $a0, done	#om ms �r lika med noll bryt
	nop
	addi $a0, $a0, -1
	
for:	
	bgt $t1, $t0, breakp	#om i > konstant, bryt
	nop
	addi $t1, $t1, 1	#i++
	j for
	nop
	
breakp:
	j while			#loop
	nop
		
done:
	
	
	lw	$t1,0($sp)	#poppa t1 fr�n stack point
	addi	$sp,$sp,4
	
	lw	$t0,0($sp)	#poppa t0 fr�n stack point
	addi	$sp,$sp,4
	
	lw	$a0,0($sp)	#poppa a0 fr�n stack point
	addi	$sp,$sp,4
	
	lw	$ra,0($sp)	#poppa return adress fr�n stack point
	addi	$sp,$sp,4	
	
	jr $ra
	nop
	
	
  #time2string function
  #
  
time2string:

	addi	$sp,$sp,-4	#pusha return adress till stack point
	sw	$ra,0($sp)
	
	srl $t4, $a1, 4		#skifta 4 �t h�ger f�r att h�mta n�sta 4 bitar
	jal hexasc		#skicka till hexasc f�r att f� ascii f�r tredje siffran		
	nop	
	or $t5, $t5, $t4	#maska med t5
	
	li $t4, 0x3A 		#ascii f�r :
	sll $t5, $t5, 8		#skifta t5 8 bitar f�r att f� plats med n�sta tv� tecken
	or $t5, $t5, $t4	#maska med t5

	srl $t4, $a1, 8		#skifta 8 �t h�ger f�r att h�mta n�sta 4 bitar
	jal hexasc		#skicka till hexasc f�r att f� ascii f�r andra siffran	
	nop
	sll $t5, $t5, 8		#skifta t5 8 bitar f�r att f� plats med n�sta tv� tecken
	or $t5, $t5, $t4	#maska med t5

	srl $t4, $a1, 12	#skifta 12 �t h�ger f�r att f� n�sta 4 bitar	
	jal hexasc		#skicka till hexasc f�r att f� ascii f�r f�rsta siffran	
	nop
	sll $t5, $t5, 8		#skifta t5 8 bitar f�r att f� plats med n�sta tv� tecken
	or $t5, $t5, $t4	#maska med t5
		
	sw $t5, 0($a0)		#skicka 4 f�rsta tecken till a0 (d� vi har anv�nt 32 bitar och ej f�r plats med flera)
	
	move $t5, $0		#nolla t5
	
	li $t4, 0x00		#ascii f�r null byte			
	sll $t5, $t5, 4		#skifta t5 4 bitar f�r att f� plats med n�stkommande tecken (nullbiten �r bara 4 bitar och vi beh�ver d�rf�r bara skifta 4)
	or $t5, $t5, $t4	#maska med t5
	
	move $t4, $a1 		#l�gg hela a1 i t1
	jal hexasc		#skicka till hexasc f�r att f� ascii f�r fj�rde siffran		
	nop
	sll $t5, $t5, 8		#skifta t5 8 bitar f�r att f� plats med n�sta tv� tecken
	or $t5, $t5, $t4	#maska med t5
	
	sw $t5, 4($a0)		#skicka resten till a0
	
	lw	$ra,0($sp)	#poppa return adress fr�n stack point
	addi	$sp,$sp,4	
	
	move $t5, $0		#nolla t4 f�r n�sta iteration
	
	jr $ra
	nop