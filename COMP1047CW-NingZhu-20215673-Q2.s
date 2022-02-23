		# This program takes two integer x and y, x and y should in the range of -2147483648--2147483647.
		# This program returns the result of x^3 + 3*x^2*y + 3*x*y^2 + 9*y^3. Note that any calculation step cause overflow will halt the program.
	
		# Notice that x^3 + 3*x^2*y + 3*x*y^2 + 9*y^3 can be simpified as (x+y)^3 + (2y)^3
		# Steps to calculate:
		# 1.Check whether input x and y overflow.
		# 2.Calculate (x+y) and check overflow.
		# 3.Calculate (2y) and check overflow.
		# 4.Calculate (x+y)^2 and check overflow.
		# 5.Calculate (2y)^2 and check overflow.
		# 6.Calculate (x+y)^3 and check overflow.
		# 7.Calculate (2y)^3 and check overflow.
		# 8.Calculate (x+y)^3 + (2y)^3 and check overflow.
		# Note that any time overflow happens, the next steps will not be executed.
		
		# In my code, three kinds of abnormal inputs are handled:
		# 1.Empty input (ask user whether enter again)
		# 2.Input not a integer	(ask user whether enter again)
		# 3.Input integer overflow (program break down)
		
		# If the user successfully get the final result, user will be asked to whether play again, press 'p' to do the whole program again, otherwise to exit.
		
		# Outstanding part: For every listed "wrong situation"(overflow during calculation,abnormal inputs), this program has corresponding error message to point out which part is wrong.
		
		.data
		# Prompt message
		reminder:	.asciiz "Input not a integer will halt the program! Any overflow will crush the program!\nNote that any choices are case sensitive!\n"
		input_1:	.asciiz "Please enter the first 32-bit integer x: "
		prompt_1:	.asciiz "Great! Get the first input!\n"
		input_2:	.asciiz "Please enter the second 32-bit integer y: "
		prompt_2:	.asciiz "Excellent! Get the second input!\n\n"
		
		# Output
		output:		.asciiz "After calculation, overflow does not happen.\nThe final result of x^3 + 3*x^2*y + 3*x*y^2 + 9*y^3 is: "
		
		# Error message
		error_1:	.asciiz "Invalid! Input can not be empty!\n"
		error_2:	.asciiz "Invalid! Input not a integer!\n"
		
		# Overflow
		situation_1_1:	.asciiz "Positive overflow happens when getting the first input number x.\n"
		situation_2_1:	.asciiz "Positive overflow happens when getting the second input number y.\n"
		situation_1_2:	.asciiz "Negative overflow happens when getting the first input number x.\n"
		situation_2_2:	.asciiz "Negative overflow happens when getting the second input number y.\n"
		situation_3:	.asciiz	"Overflow happens when calculating x+y.\n"
		situation_4:	.asciiz	"Overflow happens when calculating 2y. \n"
		situation_5:	.asciiz "Overflow happens when calculating (x+y)* (x+y).\n"
		situation_6:	.asciiz "Overflow happens when calculating (2y)*(2y).\n"
		situation_7:	.asciiz "Overflow happens when calculating (x+y)^2 * (x+y).\n"
		situation_8:	.asciiz "Overflow happens when calculating (2y)^2 * (2y).\n"
		situation_9:	.asciiz "Overflow happens when calculating (x+y)^3 + (2y)^3.\n"

		# Allocate space
		x:			.space 100
		y:			.space 100
		
		# Break line
		breakLine: .asciiz "\n"
		
		# Choice
		choice_1:	.asciiz "Do you want to retype? Press 'r' to retype otherwise to exit.\n"
		choice_2:	.asciiz "Do you want to play again? Press 'p' to play again otherwise to exit.\n"
		choice_retype:	.asciiz "You choose to retype!\n"
		choice_exit:	.asciiz "You choose to exit!\n"
		choice_play:	.asciiz "You choose to play again!\n"
		
		# Ending
		ending:	.asciiz "The program is ended successfully!\n"
		
	.text
	.globl main
	
main:
	
firstInput:
	li $v0,4
	la $a0,reminder
	syscall		# Reminder the user what format is not accpeted

	li $v0,4
	la $a0,input_1
	syscall		# Ask for the first number
	
	li $v0,8
	la $a0,x
	la $a1,100
	syscall		# Get the first number
	
	li $t7,1
	move $t0,$a0
	jal checkEmpty
	jal checkValidation
	la $t0,x
	jal checkOverflow	
				# If the input pass all error detection, print the message let the user know and continue
	li $v0,4
	la $a0,prompt_1
	syscall
	
secondInput:
	li $v0,4
	la $a0,input_2
	syscall		# Ask for the second number
	
	li $v0,8
	la $a0,y
	la $a1,100
	syscall		# Get the second number
	
	li $t7,2
	move $t0,$a0
	jal checkEmpty
	jal checkValidation
	la $t0,y
	jal checkOverflow
				# If the input pass all error detection, print the message let the user know and continue
	li $v0,4
	la $a0,prompt_2
	syscall
				# Convert the first number
	la $t0,x
	jal convert
	move $s0,$t2
				# Convert the second number
	la $t0,y
	jal convert
	move $s1,$t2
				# Every step we need to do the overflow detection.
calculation:
	move $t0,$s0	# $t0 = x
	move $t1,$s1	# $t1 = y
	
	li $t8,1	
	move $t4,$t0	# $t4 = x
	move $t5,$t1	# $t5 = y
	addu $t6,$t4,$t5	# $t6 = x + y
	jal checkAdditionOverflow
	move $t2,$t6	# $t2 = x + y
	
	li $t8,2
	move $t5,$t1	# $t5 = y
	move $t4,$t5	# $t4 = y
	addu $t6,$t5,$t5	# $t6 = 2y
	jal checkAdditionOverflow
	move $t3,$t6	# $t3 = 2y
	
	li $t9,1
	move $t4,$t2	# $t4 = x + y
	move $t5,$t2	# $t5 = x + y
	mul $t6,$t4,$t5	# $t6 = (x + y)^2
	jal checkMultiplicationOverflow
	move $t0,$t6	# $t0 = (x + y)^2
	
	li $t9,2
	move $t4,$t3	# $t4 = 2y
	move $t5,$t3	# $t5 = 2y
	mul $t6,$t4,$t5	# $t6 = (2y)^2
	jal checkMultiplicationOverflow
	move $t1,$t6	# $t1 = (2y)^2
	
	li $t9,3	
	move $t4,$t0	# $t4 = (x + y)^2
	move $t5,$t2	# $t5 = (x + y)
	mul $t6,$t4,$t5	# $t6 = (x + y)^3
	jal checkMultiplicationOverflow
	move $t2,$t6	# $t2 = (x + y)^3
	
	li $t9,4
	move $t4,$t1	# $t4 = (2y)^2
	move $t5,$t3	# $t5 = 2y
	mul $t6,$t4,$t5	# $t6 = (2y)^3
	jal checkMultiplicationOverflow
	move $t3,$t6	# $t3 = (2y)^3
	
	li $t8,3
	move $t4,$t2	# $t4 = (x + y)^3
	move $t5,$t3	# $t5 = (2y)^3
	addu $t6,$t4,$t5	# $t6 record the final result
	jal checkAdditionOverflow

printResult:
	li $v0,4
	la $a0,output
	syscall			# Print the prompt message
	
	li $v0,1
	move $a0,$t6
	syscall			# Print the result
	
	li $v0,4
	la $a0,breakLine
	syscall			# \n for format
	
	li $v0,4
	la $a0,choice_2
	syscall			# Ask user whether to play again
	
	li $v0,12
	syscall			# Read the character
	
	beq $v0,0x70,playAgain	# If user press 'r', play again
	
	j chooseToExit	# Otherwise exit the program
	
playAgain:
	li $v0,4
	la $a0,breakLine
	syscall			# \n for format
	
	j firstInput	# Go to the begining of the program
	
convert:
	li $t2,0
	lb $t1,0($t0)
	beq $t1,0x2d,convertNeg	# Judge the number postive or negative
	addiu $t1,$t1,-48
	addu $t2,$t2,$t1
					# Convert positive
loopP:
	addiu $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x0a,endLoopP
	mul $t2,$t2,10
	addiu $t1,$t1,-48
	addu $t2,$t2,$t1	
	
	j loopP
	
endLoopP:
	jr $ra
					# Convert negative
convertNeg:
	addiu $t0,$t0,1
	lb $t1,0($t0)
	addiu $t1,$t1,-48
	addu $t2,$t2,$t1

loopN:
	addiu $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x0a,endLoopN
	mul $t2,$t2,10
	addiu $t1,$t1,-48
	addu $t2,$t2,$t1	
	
	j loopN
	
endLoopN:
	li $t3,-1
	xor $t2,$t2,$t3
	addiu $t2,$t2,1
	jr $ra
					# Check empty input
checkEmpty:
	lb $t1,0($t0)	# Check the first character
	beq $t1,0x0a,inputEmpty
	jr $ra

checkValidation:	
	lb $t1,0($t0)	
	beq $t1,0x2d,checkNext		
	blt $t1,0x30,inputNotValid
	bgt $t1,0x39,inputNotValid	
checkNext:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x0a,getValid		# \n means successful
	blt $t1,0x30,inputNotValid
	bgt $t1,0x39,inputNotValid
	j checkNext
getValid:
	lb $t1,-1($t0)
	beq $t1,0x2d,inputNotValid	# Check the situation when only a - signal
	jr $ra
					
checkOverflow:
	lb $t1,0($t0)
	beq $t1,0x2d,checkNegOverflow
					# Check positive overflow
checkPosOverflow:
	li $t2,10
	li $t3,0
	addi $t0,$t0,-1
				# Get the length ignore the leading zero
loopLP:				
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x30,loopLP
					# Find the first non-zero number
loopLPS:
	beq $t1,0x0a,endLoopLP
	addi $t0,$t0,1
	lb $t1,0($t0)
	addi $t3,$t3,1
	j loopLPS
				# Calculate the length			
endLoopLP:
	bgt $t3,$t2,inputOverflowP
	blt $t3,$t2,noOverflow
	# When the length of third input is ten, need one by one comparation
	sub $t0,$t0,$t3
	# First number	
	lb $t1,0($t0)
	bgt $t1,0x32,inputOverflowP
	blt $t1,0x32,noOverflow
	# Second number	
	lb $t1,1($t0)
	bgt $t1,0x31,inputOverflowP
	blt	$t1,0x31,noOverflow
	# Third number	
	lb $t1,2($t0)
	bgt $t1,0x34,inputOverflowP
	blt	$t1,0x34,noOverflow
	# Forth number	
	lb $t1,3($t0)
	bgt $t1,0x37,inputOverflowP
	blt $t1,0x37,noOverflow
	# Fifth number	
	lb $t1,4($t0)
	bgt $t1,0x34,inputOverflowP
	blt $t1,0x34,noOverflow
	# Sixth number	
	lb $t1,5($t0)
	bgt $t1,0x38,inputOverflowP
	blt $t1,0x38,noOverflow
	# Seventh number	
	lb $t1,6($t0)
	bgt $t1,0x33,inputOverflowP
	blt	$t1,0x33,noOverflow
	# Eighth number	
	lb $t1,7($t0)
	bgt $t1,0x36,inputOverflowP
	blt	$t1,0x36,noOverflow
	# Ninth number	
	lb $t1,8($t0)
	bgt $t1,0x34,inputOverflowP
	blt	$t1,0x34,noOverflow
	# Tenth number	
	lb $t1,9($t0)
	bgt $t1,0x37,inputOverflowP
	
noOverflow:
	jr $ra	
				# Check negative overflow
checkNegOverflow:
	li $t2,10
	li $t3,0
				# Get the length, ignore the signal and leading zero
loopLN:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x30,loopLN
					# Find the first non-zero number
loopLNS:
	beq $t1,0x0a,endLoopLN
	addi $t0,$t0,1
	lb $t1,0($t0)
	addi $t3,$t3,1
	j loopLNS
				# Calculate the length
endLoopLN:
	bgt $t3,$t2,inputOverflowN
	blt $t3,$t2,noOverflow
	# When the length of third input is ten, need one by one comparation	
	sub $t0,$t0,$t3
	# First number	
	lb $t1,0($t0)
	bgt $t1,0x32,inputOverflowN
	blt $t1,0x32,noOverflow
	# Second number
	lb $t1,1($t0)
	bgt $t1,0x31,inputOverflowN
	blt	$t1,0x31,noOverflow
	# Third number
	lb $t1,2($t0)
	bgt $t1,0x34,inputOverflowN
	blt	$t1,0x34,noOverflow
	# Forth number
	lb $t1,3($t0)
	bgt $t1,0x37,inputOverflowN
	blt $t1,0x37,noOverflow
	# Fifth number
	lb $t1,4($t0)
	bgt $t1,0x34,inputOverflowN
	blt $t1,0x34,noOverflow
	# Sixth number
	lb $t1,5($t0)
	bgt $t1,0x38,inputOverflowN
	blt $t1,0x38,noOverflow
	# Seventh number
	lb $t1,6($t0)
	bgt $t1,0x33,inputOverflowN
	blt	$t1,0x33,noOverflow
	# Eighth number
	lb $t1,7($t0)
	bgt $t1,0x36,inputOverflowN
	blt	$t1,0x36,noOverflow
	# Ninth number
	lb $t1,8($t0)
	bgt $t1,0x34,inputOverflowN
	blt	$t1,0x34,noOverflow
	# Tenth number
	lb $t1,9($t0)
	bgt $t1,0x38,inputOverflowN
	j noOverflow
				# Check addition overflow
checkAdditionOverflow:
				# Check signal, if same, go to further check
	srl $t4,$t4,31
	srl $t5,$t5,31
	beq $t4,$t5,checkAddition
	
additionWithoutOverflow:
	jr $ra
				# Check the signal
checkAddition:
	srl $t5,$t6,31
	beq $t4,$t5,additionWithoutOverflow
	j additionOverflow
				# Check multiplication overflow
checkMultiplicationOverflow:
	mflo $t4
	mfhi $t5
	sra $t4,$t4,31
	bne $t4,$t5,multiplicationOverflow
	jr $ra
				
inputEmpty:
	li $v0,4
	la $a0,error_1
	syscall		# Print error message for empty input
	
	j getChoice	# Get choice, retype or exit

inputNotValid:
	li $v0,4
	la $a0,error_2
	syscall		# Print error message for input not a integer
	
	j getChoice	# Get choice, retype or exit

inputOverflowP:
	beq $t7,1,inputXOverflowP
	beq $t7,2,inputYOverflowP

inputOverflowN:
	beq $t7,1,inputXOverflowN
	beq $t7,2,inputYOverflowN		
	
inputXOverflowP:
	li $v0,4
	la $a0,situation_1_1
	syscall		# Print error message for input X with positive overflow
	
	j exit		# Exit
	
inputYOverflowP:
	li $v0,4
	la $a0,situation_2_1
	syscall		# Print error message for input Y with positive overflow
	
	j exit		# Exit
	
inputXOverflowN:
	li $v0,4
	la $a0,situation_1_2
	syscall		# Print error message for input X with negative overflow
	
	j exit		# Exit
	
inputYOverflowN:
	li $v0,4
	la $a0,situation_2_2
	syscall		# Print error message for input Y with negative overflow
	
	j exit		# Exit
	
getChoice:
	li $v0,4
	la $a0,choice_1
	syscall		# Ask user whether retype or exit
	
	li $v0,12
	syscall		# Get choice
	
	beq $v0,0x72,switchRetypePos	# Press 'r' to retype 
	j chooseToExit					# Otherwise to exit
	
switchRetypePos:
	li $v0,4
	la $a0,breakLine
	syscall		# \n for format
	
	li $v0,4
	la $a0,choice_retype
	syscall		# Prompt message
	
	beq $t7,1,firstInput
	beq $t7,2,secondInput
	
chooseToExit:
	li $v0,4
	la $a0,breakLine
	syscall		# \n for format
	
	li $v0,4
	la $a0,choice_exit
	syscall		# Prompt message
	
	j exit		# Exit

additionOverflow:
	beq $t8,1,additionOverMsg_1
	beq $t8,2,additionOverMsg_2
	beq $t8,3,additionOverMsg_3
	
multiplicationOverflow:
	beq $t9,1,multiOverMsg_1
	beq $t9,2,multiOverMsg_2
	beq $t9,3,multiOverMsg_3
	beq $t9,4,multiOverMsg_4
	
additionOverMsg_1:
	li $v0,4
	la $a0,situation_3
	syscall		# Overflow happens when x+y
	
	j exit		# Exit
	
additionOverMsg_2:
	li $v0,4
	la $a0,situation_4
	syscall		# Overflow happens when y+y
	
	j exit		# Exit
	
additionOverMsg_3:
	li $v0,4
	la $a0,situation_9
	syscall		# Overflow happens when (x+y)^3 + (2y)^3
	
	j exit		# Exit
	
multiOverMsg_1:
	li $v0,4
	la $a0,situation_5
	syscall		# Overflow happens when (x+y)^2
	
	j exit		# Exit
	
multiOverMsg_2:
	li $v0,4
	la $a0,situation_6
	syscall		# Overflow happens when (2y)^2
	
	j exit		# Exit
	
multiOverMsg_3:
	li $v0,4
	la $a0,situation_7
	syscall		# Overflow happens when (x+y)^3
	
	j exit		# Exit
	
multiOverMsg_4:
	li $v0,4
	la $a0,situation_8
	syscall		# Overflow happens when (2y)^3
	
	j exit		# Exit
		
exit:
	li $v0,4
	la $a0,ending
	syscall		# Prompt for exit

	li $v0,10
	syscall		# Exit
