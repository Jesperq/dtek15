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

# hexac: maps 0-15 in decimals to ASCII chars
# Written by Rickard Larsson & Jesper Qvarfordt
  
hexasc:
	
 	andi	$a0, $a0, 15	# Maska med 1111 = 15 för att bara få de minst signifikanta bitarna
 	
 	addi	$a0, $a0, 0x30	# Lägg till 0x30 för att komma till "rätt" index i ASCII-tabellen
 	
 	li	$t1, 0x39	# Lagra index för 9 i ASCII-tabellen som ska jämföras med värdet i $a0
 	ble	$a0, $t1, done	# om $a0 <= $t1 vet vi att vi har ett nummer, och vi är klara
 	nop
 	
 	addi	$a0, $a0, 7	# Lägg till 7 för att komma till versaler i ASCII-tabellen
 	
done:
 	andi 	$v0, $a0, 127	# Maska med 1111111 = 127 för att enbart spara de 7 minst signifikanta bitarna
 	
 	jr	$ra
 	nop
 	
# delay: delays for x milliseconds
# Written by Rickard Larsson & Jesper Qvarfordt

 delay:
	addi	$sp,$sp,-4	#pusha return adress till stack point
	sw	$ra,0($sp)	#
	
	li 	$a0, 1000	#ms
	li	$t1, 500	#konstant (ändras pga dator osv)
	li	$t2, 0		#i=0
	
while:
	blez $a0, breakwhile	# om ms <= 0 bryt while loopen
	nop
	addi $a0, $a0, -1
	
for:	
	bgt $t2, $t1, breakfor	#om i > konstant, bryt
	nop
	addi $t2, $t2, 1	#i++
	j for
	nop
	
breakfor:
	j while			#loop
	nop
		
breakwhile:
	lw	$ra,0($sp)	#poppa return adress från stack point
	addi	$sp,$sp,4	
	
	jr $ra
	nop
 	
# time2string: 
# Written by Rickard Larsson & Jesper Qvarfordt

time2string:

	addi	$sp,$sp,-4	# pusha return adress till stacken
	sw	$ra,0($sp)	#
	
	addi	$sp,$sp,-4	# spara ner värde på $s0 till stacken
	sw	$s0,0($sp)	#
	move 	$s0, $0		# nollställer $s0
	
	addi	$sp,$sp,-4	# spara ner värde på $s1 till stacken
	sw	$s1,0($sp)	#
	move	$s1, $a0	# spara ner minnesadressen till $s1
	
	andi	$a1, $a1, 65535	# Vi vill bara ha de 16 minst signifikanta bitarna (4 tecken)
	
	#-------------------------------------------------------------------------
	
	
	# Tredje siffran
	srl	$a0, $a1, 4	# Skifta $a1 4 bitar åt höger för att få
	andi	$a0, $a0, 15	# den näst sista NBCD-codade siffran (00:X0) <- X
	jal	hexasc		# omvandla till "ASCII-index"
	nop
	or	$s0, $s0, $v0	# "ora" på returvärdet på $s0
	
	# Lägg till ":"
	li	$t1, 0x3a	# 0x3a är : i ASCII
	sll	$s0, $s0, 8	# shifta 8 bitar till vänster för att få plats
	or	$s0, $s0, $t1	# "ora" på kolon
	
	# Andra siffran
	srl	$a0, $a1, 8	# Skifta $a1 8 bitar åt höger för att få
	andi	$a0, $a0, 15	# den andra NBCD-codade siffran (0X:00) <- X
	jal	hexasc		# omvandla till "ASCII-index"
	nop
	sll	$s0, $s0, 8	# shifta 8 bitar till vänster för att få plats
	or	$s0, $s0, $v0	# "ora" på returvärdet på $s0	
	
	# Första siffran
	srl	$a0, $a1, 12	# Skifta $a1 12 bitar åt höger för att få
	andi	$a0, $a0, 15	# den första NBCD-codade siffran (X0:00) <- X
	jal	hexasc		# omvandla till "ASCII-index"
	nop
	sll	$s0, $s0, 8	# shifta 8 bitar till vänster för att få plats
	or	$s0, $s0, $v0	# "ora" på returvärdet på $s0	
	
	sw	$s0, 0($s1)	# 8*4 = 32 bitar, vi sparar ner de 4 första tecknena via minnesadressen
	move	$s0, $0		# Nollställer $s0
	
	# Lägg till NULL
	li	$t1, 0x00	# 0x00 är NULL i ASCII (1 bit)
	sll	$s0, $s0, 8	# shifta 4 bitar till vänster för att få plats
	or	$s0, $s0, $t1	# "ora" på returvärdet på $s0	
	
	# Fjärde siffran
	andi	$a0, $a1, 15	# maska för att få sista NBCD-codade siffran (00:0X) <- X
	jal	hexasc		# omvandla till "ASCII-index"
	nop
	or	$s0, $s0, $v0	# "ora" på returvärdet på $s0
	
	sw	$s0, 4($s1)	# Gå till nästa plats i minnet
	
	#-------------------------------------------------------------------------
		
	move	$a0, $s1	# lägg tillbaka minnesadressen i $a0
	
	lw	$s1,0($sp)	# Återställ $s1
	addi	$sp,$sp,4	#
	
	lw	$s0,0($sp)	# Återställ $s0
	addi	$sp,$sp,4	#
	
	lw	$ra,0($sp)	# poppa return adress från stacken
	addi	$sp,$sp,4	#
	
	jr	$ra		#jump back to return adress
	nop
	
	
	
 	
