  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0,12		# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  # Written by Rickard Larsson 2015

hexasc:
	li	$t0, 0x7F	# 1111111, "mask"
	and 	$t0, $a0, $t0	# bitwise to igniore higher bits
	
	addi  	$v0, $a0, 0x30
	
	li	$t1, 0x39	# hexa 9, overflow check
	
	blt	$v0, $t1, overflow
	
	addi	$v0, $v0, 7	# go to letters A-F
	
overflow:
	
	jr $ra			# go back to return adress in main

	