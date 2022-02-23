	# This program takes one non-empty string 'a' within 21 English characters and two English characters 'b' and 'c' as inputs.
	# This program returns a new 'a' string which all of 'b' in 'a' are replaced by 'c'.
	
	# Below shows the C code version to make the replacement:
	# void replace(char* a, char b, char c){
	#	int temp = 0;
	#	while(1){
	#		if *(a+temp) == '\n'
	#			break;
	#		if *(a+temp) == b
	#			*(a+temp) = c;
	#		temp++;
	#	}
	#	printf("The new string is: %d",a);
	# }
	
	# In my mips code, five kinds of special inputs are handled:
	#	1. Empty input.
	#	2. Inputs out of the range of length. (String:20, character:1)
	#	3. Inputs contain non-English character.
	#	4. Input b can not be found in a.	(a should contain b)
	#	5. b and c has same value.
	
	# Anytime after user enter the special input, the program will ask the user whether to retype or exit the program.
	# Anytime after one replacement finished, the program will ask the user whether to play again or exit the program.
	
	# The whole procedure of the program(assume no special input)£º
	#	1. Get the inputs
	#	2. Do the replacement
	#	3. Ask whether user play again, if play again, back to 1
	#	4. Exit the program
	
	.data
		# Prompt message
		input_1:	.asciiz "Please enter the non-empty string within 21 English characters (informal input may halt the program): "
		prompt_1:	.asciiz "The first input is saved successfully!\n"
		input_2:	.asciiz "Please enter the first English character (character not exists in string or non-English character may halt the program): "
		prompt_2:	.asciiz "The second input is saved successfully!\n"
		input_3:	.asciiz "Please enter the second English character (repeat character or non-English character may halt the program): "
		prompt_3:	.asciiz "The third input is saved successfully!\n\n\n"
		
		# Output
		output:		.asciiz "After exchanging, the final output string is: "
		
		# Apply space to reserve user's inputs
		buf_1:		.space	200
		buf_2:		.space	30
		buf_3:		.space	30
		
		# Error messages for special inputs
		em_1:	.asciiz "Invalid input! You have entered nothing!\n"
		em_2:	.asciiz "Invalid input! You have entered too many characters! Do not enter more than 20 characters!\n"
		em_3:	.asciiz "Invalid input! You have entered too many characters! Do not enter more than 1 character!\n"
		em_4:	.asciiz "Invalid input! Your input contains non-English character!\n"
		em_5:	.asciiz "Invalid input! Your input can not be found in the first string!\n"
		em_6:	.asciiz "Invalid input! You have entered two same characters!\n"
		
		# Break line
		breakLine:	.asciiz "\n"
		
		# Choice
		choice_1:	.asciiz "Do you want to continue? Press 'r' to retype otherwise to exit.\n"
		choice_2:	.asciiz "Do you want to play again? Press 'p' to play again otherwise to exit.\n"
		choice_retype:	.asciiz "You choose to retype!\n"
		choice_exit:	.asciiz "You choose to exit!\n"
		choice_play:	.asciiz "You choose to play again!\n"
		
		
		# End the program
		ending:	.asciiz "The program is ended successfully!\n"
		
	.text
	.globl main
	
main:

firstInput:					
	li $v0,4
	la $a0,input_1
	syscall				# Ask for the first input
		
	li $v0,8
	la $a0,buf_1
	li $a1,200
	syscall				# Get the first input
				# Check the first input
	li $t7,1			# Used to position when retyping
	move $t0,$a0								
	jal checkEmpty				
	jal checkStringLength
	la $t0,buf_1				
	jal	checkEnglishCharacter
				# If the input pass all error detection, print the message let the user know and continue
	li $v0,4
	la $a0,prompt_1
	syscall			
	
secondInput:											
	li $v0,4
	la $a0,input_2
	syscall				# Ask for the second input
	
	li $v0,8
	la $a0,buf_2
	la $a1,30
	syscall				# Get the second input
				# Check the second input
	li $t7,2			# Used to position when retyping
	move $t0,$a0								
	jal checkEmpty
	jal checkCharacterLength					
	jal	checkEnglishCharacter
	jal checkIn	
				# If the input pass all error detection, print the message let the user know and continue
	li $v0,4
	la $a0,prompt_2
	syscall
						
thirdInput:				
	li $v0,4
	la $a0,input_3
	syscall				# Ask for the third input
	
	li $v0,8
	la $a0,buf_3
	la $a1,30
	syscall				# Get the third input
				# Check the third input
	li $t7,3			# Used to position when retyping
	move $t0,$a0	
	jal checkEmpty				
	jal checkCharacterLength			
	jal	checkEnglishCharacter	
	jal checkSame				
				# If the input pass all error detection, print the message let the user know and continue
	li $v0,4
	la $a0,prompt_3
	syscall
				# Since all inputs are valid, start to do the main task -- replacement!
replacement:
	la $t0,buf_1		# let $t0 point to the first element of a 
	la $t1,buf_2
	lb $t1,0($t1)		# let $t1 = b
	la $t2,buf_3
	lb $t2,0($t2)		# let $t2 = c
	
loop_2:
	lb $t4,0($t0)		# End the loop when meets \n
	beq $t4,0x0a,printResult
	beq $t4,$t1,exchange	# Compare the current character and b
				
nextloop:
	addi $t0,$t0,1		# Compare the next character
	j loop_2

exchange:
	sb $t2,($t0)		# Replace the current character with c if current character == b
	j nextloop
				# After replacement, print the final result		
printResult:
	li $v0,4
	la $a0,output
	syscall				# Description message
	
	li $v0,4
	la $a0,buf_1
	syscall				# Print the final string
	
	li $v0,4
	la $a0,breakLine
	syscall
	
	li $v0,4
	la $a0,choice_2
	syscall				# Ask the user whether to play again
	
	li $v0,12
	syscall
				# If user enter 'p', then play again. Otherwise exit the program.
	beq $v0,0x70,again	# Judge whether input == 'p'
										
	j otherwise			# If not, exit the program
				# If play again, go to the begining of the program
again:
	li $v0,4
	la $a0,breakLine
	syscall
	
	j firstInput
	
# Codes below show how the inputs to be checked.
				# First special input: empty input
				# Check the first character == \n
checkEmpty:				
	lb $t1,0($t0)
	beq $t1,0x0a,inputEmpty				
	jr $ra		
				# Second special input: input out of the range of length (String:20)
				# Find the next character until \n, then calculate the number of characters and compare the sum with the given length 20.
checkStringLength:	
	li $t1,0
	li $t2,20
	
loop_1:
	lb $t3,0($t0)
	beq $t3,0x0a,compare_1
	addi $t0,$t0,1		# Next character
	addi $t1,$t1,1		# Sum++
	j loop_1
	
compare_1:
	bgt $t1,$t2,inputStringOutOfRange
	jr $ra
				# Second special input: input out of the range of length (Char:1)
				# Check the second character == \n
checkCharacterLength:
	lb $t3,1($t0)
	bne $t3,0x0a,inputCharacterOutOfRange
	jr $ra
				# Third special input: input with non-English characters
				# Find the next character until \n, everytime check the ascii of the character between 0x41-0x5a or 0x61-0x7a.
checkEnglishCharacter:
	lb $t3,0($t0)
	beq $t3,0x0a,exitLoop
	bgt $t3,0x7a,inputInvalid	# > 0x7a
	blt $t3,0x41,inputInvalid	# < 0x41
	bgt $t3,0x5a,checkLower		# Else if >0x5a
nextCharacter:
	addi $t0,$t0,1
	j checkEnglishCharacter
	
exitLoop:
	jr $ra
	
checkLower:
	blt $t3,0x61,inputInvalid
	j nextCharacter
				# Forth special input: b not in a
				# Anytime if find b, break and back. Once find \n, go to the error part.
checkIn:
	la $t0,buf_2	# $t0 -> buf_2
	lb $t2,0($t0)	# $t2 = b
	la $t0,buf_1	# $t0 -> buf_1
	
loop_3:
	lb $t1,0($t0)
	beq $t1,0x0a,inputNotIn
	beq $t1,$t2,find
	addi $t0,$t0,1
	j loop_3

find:
	jr $ra

				# Fifth special input: b and c have same value
				# Get and compare b and c
checkSame:
	la $t0,buf_2			# $t0 -> b
	la $t1,buf_3			# $t1 -> c
	lb $t3,0($t0)			# $t3 = b
	lb $t4,0($t1)			# $t4 = c
	beq $t3,$t4,inputSame		
	jr $ra						

# Codes below to print the corresponding error message.

inputEmpty:
	li $v0,4
	la $a0,em_1
	syscall					# Print error message for empty input
	
	j getChoice
		
inputStringOutOfRange:
	li $v0,4
	la $a0,em_2
	syscall					# Print error message for string out of range
	
	j getChoice
		
inputCharacterOutOfRange:
	li $v0,4
	la $a0,em_3
	syscall					# Print error message for character out of range
	
	j getChoice		

inputInvalid:
	li $v0,4
	la $a0,em_4
	syscall					# Print error message for input of non-English character
	
	j getChoice

inputNotIn:
	li $v0,4
	la $a0,em_5
	syscall					# Print error message for input not included in the first string
	
	j getChoice

inputSame:
	li $v0,4
	la $a0,em_6
	syscall					# Print error message for b and c have same value
				
getChoice:					# Ask the user to make choice when get special inputs
	li $v0,4
	la $a0,choice_1
	syscall					# Prompt message
	
	li $v0,12
	syscall					# Get the instruction
	
	beq $v0,0x72,switch		# If type 'r' then retype else exit
	j otherwise
	
switch:						# Retype part, use $t7 to decide whether we retype.
	li $v0,4
	la $a0,breakLine
	syscall					# Tell user they will do the retyping

	li $v0,4
	la $a0,choice_retype
	syscall					# Prompt message
	
	beq $t7,1,firstInput	# 1 - first
	beq $t7,2,secondInput	# 2 - second
 	beq $t7,3,thirdInput	# 3 - third
	
# Exit the program
otherwise:
	li $v0,4
	la $a0,breakLine
	syscall					# Modify the format

	li $v0,4
	la $a0,choice_exit
	syscall					# Go to exit

exit:
	li $v0,4
	la $a0,ending
	syscall					# Print message for exiting
	
	li $v0,10
	syscall					# Exit the program
