  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0,10		# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  # Written by Rickard Larsson & Jesper Qvarfordt
  
 hexasc:
 	andi	$a0, $a0, 15	# Maska med 1111 = 15 för att bara få de minst signifikanta bitarna
 	
 	addi	$a0, $a0, 0x30	# Lägg till 0x30 för att komma till "rätt" index i ASCII-tabellen
 	
 	li	$t1, 0x39		# Lagra index för 9 i ASCII-tabellen som ska jämföras med värdet i $a0
 	ble	$a0, $t1, done	# om $a0 <= $t1 vet vi att vi har ett nummer, och vi är klara
 	
 	addi	$a0, $a0, 7	# Lägg till 7 för att komma till versaler i ASCII-tabellen
 	
 done:
 	andi 	$v0, $a0, 127	# Maska med 1111111 = 127 för att enbart spara de 7 minst signifikanta bitarna
 	
 	jr	$ra
 	nop

