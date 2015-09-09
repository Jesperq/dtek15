  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text more text lots of text\0"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,2
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
  #
  
hexasc:
	andi $t4, 15		#maska med 15 för att få fyra första bitarna
	addi $t4, $t4, 48	#hoppa fram till ascii för 0 (minst)
	
	blt $t4, 58, print	#om a0 är mellan 0-9 printas det direkt
	addi $t4, $t4, 7	#annars lägg till 7 för att komma till ascii för A
	
print:
	andi $t4, 127		#maska de 7 minst signifikanta bitarna
	jr $ra			#hoppa tillbaka
	nop
	
  #delay function
  #

delay:
	addi	$sp,$sp,-4	#pusha return adress till stack point
	sw	$ra,0($sp)	#
	
	addi	$sp,$sp,-4	#pusha $a0 till stacken
	sw	$a0,0($sp)	#
	
	addi	$sp,$sp,-4	#pusha $a1 till stacken
	sw	$a1,0($sp)	#
	
	addi	$sp,$sp,-4	#pusha $a2 till stacken
	sw	$a2,0($sp)	#
	
	li	$a0, 1000	#variable ms
	li	$a1, 70000	#variable for for loop, should be easy to change
	move	$a2, $0		#variable "i" for for loop
	
while:
	beq  $a0, $0, done	# if ms == 0, we are done
	subiu	$a0,$a0,1	# decrease ms
	
for:	
	bgt $a2, $a1, break	# if i > 4711 we are done
	addi $a2, $a2, 1	#i++
	nop
	j for
	
break:
	j while	
	
done:
	lw	$a2,0($sp)	#popa tillbaka $a2
	addi	$sp,$sp,4	#
	
	lw	$a1,0($sp)	#popa tillbaka $a1
	addi	$sp,$sp,4	#
	
	lw	$a0,0($sp)	#popa tillbaka $a0
	addi	$sp,$sp,4	#
	
	lw	$ra,0($sp)	#poppa return adress från stack point
	addi	$sp,$sp,4	#
	
	jr $ra
	nop
	
	
  #time2string function
  #
  
time2string:

	addi	$sp,$sp,-4	#pusha return adress till stack point
	sw	$ra,0($sp)
	
	srl $t4, $a1, 4		#skifta 4 åt höger för att hämta nästa 4 bitar
	jal hexasc		#skicka till hexasc för att få ascii för tredje siffran			
	or $t5, $t5, $t4	#maska med t5
	
	li $t4, 0x3A 		#ascii för :
	sll $t5, $t5, 8		#skifta t5 8 bitar för att få plats med nästa två tecken
	or $t5, $t5, $t4	#maska med t5

	srl $t4, $a1, 8		#skifta 8 åt höger för att hämta nästa 4 bitar
	jal hexasc		#skicka till hexasc för att få ascii för andra siffran	
	sll $t5, $t5, 8		#skifta t5 8 bitar för att få plats med nästa två tecken
	or $t5, $t5, $t4	#maska med t5

	srl $t4, $a1, 12	#skifta 12 åt höger för att få nästa 4 bitar	
	jal hexasc		#skicka till hexasc för att få ascii för första siffran	
	sll $t5, $t5, 8		#skifta t5 8 bitar för att få plats med nästa två tecken
	or $t5, $t5, $t4	#maska med t5
		
	sw $t5, 0($a0)		#skicka 4 första tecken till a0 (då vi har använt 32 bitar och ej får plats med flera)
	
	move $t5, $0		#nolla t5
	
	li $t4, 0x00		#ascii för null byte			
	sll $t5, $t5, 4		#skifta t5 4 bitar för att få plats med nästkommande tecken (nullbiten är bara 4 bitar och vi behöver därför bara skifta 4)
	or $t5, $t5, $t4	#maska med t5
	
	move $t4, $a1 		#lägg hela a1 i t1
	jal hexasc		#skicka till hexasc för att få ascii för fjärde siffran		
	sll $t5, $t5, 8		#skifta t5 8 bitar för att få plats med nästa två tecken
	or $t5, $t5, $t4	#maska med t5
	
	sw $t5, 4($a0)		#skicka resten till a0
	
	lw	$ra,0($sp)	#poppa return adress från stack point
	addi	$sp,$sp,4	
	
	move $t5, $0		#nolla t4 för nästa iteration
	
	jr $ra
	nop
