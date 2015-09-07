  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0, 16			# change this to test different values

	jal	hexasc			# call hexasc
	nop				# delay slot filler (just in case)	

	move	$a0, $v0		# copy return value to argument register

	li	$v0, 11			# syscall with v0 = 11 will print out
	syscall				# one byte from a0 to the Run I/O window
	
stop:	j	stop			# stop after one run
	nop				# delay slot filler (just in case)

  # You can write your own code for hexasc here
  # Written by Rickard Larsson 2015

hexasc:
	andi  	$t0, $a0, 15		# "mask" parameter with 1111 = 15 to get the 4 least 
					# significant bits of $a0 inly, igniore higher bits
	
	addi  	$v0, $t0, 0x30		# add 0x30 = the position of 0 in ASCII table
					# lets call this the "offset"
	
	bltu   	$v0, 0x3a, number	# check if the parameter is a number or if it is a letter
					# if $v0 < 0x3a we know it is a number, its inside the span
	
	addi	$v0, $v0, 7		# we know that the parameter is a letter, go to letters A-F
					# in the ASCII table (7 steps forward) from 0
	
number:
	andi $v0, $v0, 127		# make sure that only the 7 least significant bits will be returned
					# use the "mask" 1111111 = 127
	
	jr $ra				# go back to return adress in main to print out