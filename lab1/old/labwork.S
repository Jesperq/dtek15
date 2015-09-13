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
	andi $t4, 15		#maska med 15 för att få fyra första bitarna
	addi $t4, $t4, 48	#hoppa fram till ascii för 0 (minst)
	
	blt $t4, 58, print	#om a0 är mellan 0-9 printas det direkt
	nop
	addi $t4, $t4, 7	#annars lägg till 7 för att komma till ascii för A
	
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
	li	$t0, 500000	#konstant (ändras pga dator osv)
	li	$t1, 0		#i=0
	
while:
	bge $0, $a0, done	#om ms är lika med noll bryt
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
	
	
	lw	$t1,0($sp)	#poppa t1 från stack point
	addi	$sp,$sp,4
	
	lw	$t0,0($sp)	#poppa t0 från stack point
	addi	$sp,$sp,4
	
	lw	$a0,0($sp)	#poppa a0 från stack point
	addi	$sp,$sp,4
	
	lw	$ra,0($sp)	#poppa return adress från stack point
	addi	$sp,$sp,4	
	
	jr $ra
	nop
	
	
  #time2string function
  #
  
time2string:

	addi	$sp,$sp,-4	#pusha return adress till stack point
	sw	$ra,0($sp)
	
	srl $t4, $a1, 4		#skifta 4 åt höger för att hämta nästa 4 bitar
	jal hexasc		#skicka till hexasc för att få ascii för tredje siffran		
	nop	
	or $t5, $t5, $t4	#maska med t5
	
	li $t4, 0x3A 		#ascii för :
	sll $t5, $t5, 8		#skifta t5 8 bitar för att få plats med nästa två tecken
	or $t5, $t5, $t4	#maska med t5

	srl $t4, $a1, 8		#skifta 8 åt höger för att hämta nästa 4 bitar
	jal hexasc		#skicka till hexasc för att få ascii för andra siffran	
	nop
	sll $t5, $t5, 8		#skifta t5 8 bitar för att få plats med nästa två tecken
	or $t5, $t5, $t4	#maska med t5

	srl $t4, $a1, 12	#skifta 12 åt höger för att få nästa 4 bitar	
	jal hexasc		#skicka till hexasc för att få ascii för första siffran	
	nop
	sll $t5, $t5, 8		#skifta t5 8 bitar för att få plats med nästa två tecken
	or $t5, $t5, $t4	#maska med t5
		
	sw $t5, 0($a0)		#skicka 4 första tecken till a0 (då vi har använt 32 bitar och ej får plats med flera)
	
	move $t5, $0		#nolla t5
	
	li $t4, 0x00		#ascii för null byte			
	sll $t5, $t5, 4		#skifta t5 4 bitar för att få plats med nästkommande tecken (nullbiten är bara 4 bitar och vi behöver därför bara skifta 4)
	or $t5, $t5, $t4	#maska med t5
	
	move $t4, $a1 		#lägg hela a1 i t1
	jal hexasc		#skicka till hexasc för att få ascii för fjärde siffran		
	nop
	sll $t5, $t5, 8		#skifta t5 8 bitar för att få plats med nästa två tecken
	or $t5, $t5, $t4	#maska med t5
	
	sw $t5, 4($a0)		#skicka resten till a0
	
	lw	$ra,0($sp)	#poppa return adress från stack point
	addi	$sp,$sp,4	
	
	move $t5, $0		#nolla t4 för nästa iteration
	
	jr $ra
	nop