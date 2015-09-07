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
	
delay:
	jr $ra
	nop
	
 # Written by Rickard Larsson 2015

time2string:
	jr $ra
	nop
	
