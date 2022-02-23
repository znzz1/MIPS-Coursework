	.data 
	input: .space 1000
	string: .space 800
	
	error:	.asciiz "An error has occurred."
	result:	.asciiz "The result is:"
	.text
	.globl main
	
main:
	li $v0,8
	la $a0,input
	la $a1,1000
	syscall
	
	move $t0,$a0
	lb $t1,0($t0)
	bne $t1,0x50,exit
	addi $t0,$t0,1
	lb $t1,0($t0)
	bne $t1,0x31,exit
	addi $t0,$t0,1
	lb $t1,0($t0)
	bne $t1,0x3a,exit
loop:	
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x20,loop
	bne $t1,0x22,exit
	li $t7,0	# $t7 to record the " times
loop1:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x22,check1
	beq $t1,0x0a,exit
	j loop1
check1:
	addi $sp,$sp,-4
	sw $t0,0($sp)
	li $t2,0
checkLoop1:
	addi $t0,$t0,-1
	lb $t1,0($t0)
	bne $t1,0x5c,judge1
	addi $t2,$t2,1
	j checkLoop1
judge1:
	lw $t0,0($sp)
	addi $sp,$sp,4
	div $t3,$t2,2
	mul $t3,$t3,2
	beq $t2,$t3,check2
	j loop1
check2:
	addi $sp,$sp,-4
	sw $t0,0($sp)
checkLoop2:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x0a,exit
	bne $t1,0x20,judge2
	j checkLoop2
judge2:
	div $t3,$t7,2
	mul $t3,$t3,2
	bne $t3,$t7,judge3
	beq $t1,0x3b,found1st
	beq $t1,0x22,nextLoop1
	j exit
nextLoop1:
	lw $t0,0($sp)
	addi $sp,$sp,4
	addi $t7,$t7,1
	j loop1
judge3:
	beq $t1,0x3b,exit
	beq $t1,0x0a,exit
	beq $t1,0x22,nextLoop1
	addi $t0,$t0,1
	lb $t1,0($t0)
	j judge3
	
found1st:
	div $t3,$t7,2
	mul $t3,$t3,2
	bne $t3,$t7,exit
	
	move $s0,$t0
	
	addi $t0,$t0,1
	lb $t1,0($t0)
	bne $t1,0x50,exit
	addi $t0,$t0,1
	lb $t1,0($t0)
	bne $t1,0x32,exit
	addi $t0,$t0,1
	lb $t1,0($t0)
	bne $t1,0x3a,exit
loop2:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x20,loop2
	bne $t1,0x22,exit
	li $t7,0	# $t7 to record the " times
loop3:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x22,check3
	beq $t1,0x0a,exit
	j loop3
check3:
	addi $sp,$sp,-4
	sw $t0,0($sp)
	li $t2,0
checkLoop3:
	addi $t0,$t0,-1
	lb $t1,0($t0)
	bne $t1,0x5c,judge4
	addi $t2,$t2,1
	j checkLoop3
judge4:
	lw $t0,0($sp)
	addi $sp,$sp,4
	div $t3,$t2,2
	mul $t3,$t3,2
	beq $t2,$t3,check4
	j loop3
check4:
	addi $sp,$sp,-4
	sw $t0,0($sp)
checkLoop4:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x0a,exit
	bne $t1,0x20,judge5
	j checkLoop4	
judge5:
	div $t3,$t7,2
	mul $t3,$t3,2
	bne $t3,$t7,judge6
	beq $t1,0x3b,found2nd
	beq $t1,0x22,nextLoop2
	j exit	
nextLoop2:
	lw $t0,0($sp)
	addi $sp,$sp,4
	addi $t7,$t7,1
	j loop3	
	
judge6:
	beq $t1,0x3b,exit
	beq $t1,0x0a,exit
	beq $t1,0x22,nextLoop2
	addi $t0,$t0,1
	lb $t1,0($t0)
	j judge6

found2nd:
	div $t3,$t7,2
	mul $t3,$t3,2
	bne $t3,$t7,exit
	
	move $s1,$t0
	
	addi $t0,$t0,1
	lb $t1,0($t0)
	bne $t1,0x50,exit
	addi $t0,$t0,1
	lb $t1,0($t0)
	bne $t1,0x33,exit
	addi $t0,$t0,1
	lb $t1,0($t0)
	bne $t1,0x3a,exit
loop4:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x0a,exit
	beq $t1,0x3b,check5
	j loop4
check5:
	addi $t0,$t0,1
	lb $t1,0($t0)
	bne $t1,0x0a,exit

checkNumberValidation:
	addi $t0,$s1,3
loop5:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x20,loop5
	# Find the first non-space character
	beq $t1,0x27,checkAscii
	bgt $t1,0x39,exit
	blt $t1,0x30,exit
	beq $t1,0x30,checkSpecial
	# Right above
checkDecimal:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x2e,checkFloat
	beq $t1,0x2a,checkArith
	beq $t1,0x2b,checkArith
	beq $t1,0x2d,checkArith
	beq $t1,0x2f,checkArith
	beq $t1,0x3b,finishCheck
	bgt $t1,0x39,exit
	blt $t1,0x30,checkSpace
	j checkDecimal
checkFloat:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x3b,finishCheck
	bgt $t1,0x39,exit
	blt $t1,0x30,checkSpace
	j checkFloat
checkArith:
	j finishCheck
	
checkSpecial:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x3b,finishCheck
	beq $t1,0x2e,checkFloat
	beq $t1,0x58,checkHex
	beq $t1,0x78,checkHex
	beq $t1,0x42,checkBinary
	beq $t1,0x62,checkBinary
checkOctal:
	beq $t1,0x3b,finishCheck
	bgt $t1,0x37,exit
	blt $t1,0x30,checkSpace
	addi $t0,$t0,1
	lb $t1,0($t0)
	j checkOctal
checkHex:
	addi $t0,$t0,1
	lb $t1,0($t0)
	blt $t1,0x30,exit
	bgt $t1,0x39,checkEng
checkHexLoop:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x3b,finishCheck
	blt $t1,0x30,checkSpace
	bgt $t1,0x39,checkEng
	j checkHexLoop
checkEng:
	blt $t1,0x61,checkEngUpper
	bgt $t1,0x66,exit
	j checkHexLoop
checkEngUpper:
	blt $t1,0x41,exit
	bgt $t1,0x46,exit
	j checkHexLoop
checkBinary:
	addi $t0,$t0,1
	lb $t1,0($t0)
	bgt $t1,0x31,exit
	blt $t1,0x30,exit
checkBinaryLoop:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x3b,finishCheck
	bgt $t1,0x31,exit
	blt $t1,0x30,checkSpace
	j checkBinaryLoop
checkSpaceAdd:
	addi $t0,$t0,1
	lb $t1,0($t0)
checkSpace:
	beq $t1,0x3b,finishCheck
	bne $t1,0x20,exit
	addi $t0,$t0,1
	lb $t1,0($t0)
	j checkSpace
checkAscii:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x0a,exit
	beq $t1,0x27,checkSpaceAdd
	j checkAscii

finishCheck:

storeFirstString:
	la $t0,input
	la $t5,string		# $t5 very important
	addi $t0,$t0,2
loopFind1:
	addi $t0,$t0,1
	lb $t1,0($t0)
	bne $t1,0x22,loopFind1
single1:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x5c,transfer1
	beq $t1,0x22,double1
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single1
double1:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x20,double1
	beq $t1,0x3b,getFirst
	beq $t1,0x22,single1
transfer1:
	addi $t0,$t0,1
	lb $t1,0($t0)
	
	beq $t1,0x61,transferA1
	beq $t1,0x62,transferB1
	beq $t1,0x66,transferF1
	beq $t1,0x6e,transferN1
	beq $t1,0x72,transferR1
	beq $t1,0x74,transferT1
	beq $t1,0x76,transferV1
	beq $t1,0x5c,transferX1
	beq $t1,0x3f,transferW1
	beq $t1,0x22,transferD1
	beq $t1,0x27,transferS1
	beq $t1,0x78,transferHex1
	bgt $t1,0x2f,checkCheck1
	
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single1
checkCheck1:
	blt $t1,0x38,transferOct1
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single1
transferOct1:
	li $t2,0
	addi $t1,$t1,-48
	add $t2,$t2,$t1
	
	addi $t0,$t0,1
	lb $t1,0($t0)
	blt $t1,0x30,transferOctFinish1
	bgt $t1,0x37,transferOctFinish1
	mul $t2,$t2,8
	addi $t1,$t1,-48
	add $t2,$t2,$t1
	
	addi $t0,$t0,1
	lb $t1,0($t0)
	blt $t1,0x30,transferOctFinish1
	bgt $t1,0x37,transferOctFinish1
	mul $t2,$t2,8
	addi $t1,$t1,-48
	add $t2,$t2,$t1
	
	sb $t2,0($t5)
	addi $t5,$t5,1
	j single1
	
transferOctFinish1:
	addi $t0,$t0,-1
	sb $t2,0($t5)
	addi $t5,$t5,1
	j single1
	
transferHex1:
	li $t2,0
hexLoop1:
	addi $t0,$t0,1
	lb $t1,0($t0)
	blt $t1,0x30,hexConvert1
	bgt $t1,0x39,hexCheckChar1
	j hexLoop1
hexCheckChar1:
	blt $t1,0x41,hexConvert1
	bgt $t1,0x46,hexCheckLower1
	j hexLoop1
hexCheckLower1:
	blt $t1,0x61,hexConvert1
	bgt $t1,0x66,hexConvert1
	j hexLoop1
hexConvert1:
	addi $t0,$t0,-1
	lb $t1,0($t0)
	beq $t1,0x78,exit
	
	blt $t1,0x41,hexConvertNum1
	blt $t1,0x61,hexConvertUpper1
	
	addi $t1,$t1,-87
	add $t2,$t2,$t1
hexConvertNext1:	
	lb $t1,-1($t0)
	beq $t1,0x78,hexConvertFinish1

	blt $t1,0x41,hexConvertNum2
	blt $t1,0x61,hexConvertUpper2

	addi $t1,$t1,-87
	mul $t1,$t1,16
	add $t2,$t2,$t1

hexConvertFinish1:
	sb $t2,0($t5)
	addi $t5,$t5,1
	j single1
hexConvertNum1:
	addi $t1,$t1,-48
	add $t2,$t2,$t1
	j hexConvertNext1
hexConvertUpper1:
	addi $t1,$t1,-55
	add $t2,$t2,$t1
	j hexConvertNext1
hexConvertNum2:
	addi $t1,$t1,-48
	mul $t1,$t1,16
	add $t2,$t2,$t1
	j hexConvertFinish1
hexConvertUpper2:
	addi $t1,$t1,-55
	mul $t1,$t1,16
	add $t2,$t2,$t1
	j hexConvertFinish1
	
transferA1:
	li $t1,7
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single1					
transferB1:
	li $t1,8
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single1	
transferF1:
	li $t1,12
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single1	
transferN1:
	li $t1,10	
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single1	
transferR1:
	li $t1,13
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single1	
transferT1:
	li $t1,9
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single1	
transferV1:
	li $t1,11
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single1	
transferX1:
	li $t1,92
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single1	
transferW1:
	li $t1,63
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single1	
transferD1:
	li $t1,34
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single1	
transferS1:
	li $t1,39
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single1	

getFirst:														
storeSecondString:
	move $t0,$s0
	la $t5,string
	addi $t5,$t5,5
	addi $t0,$t0,3
	li $t4,0x00
	sb $t4,0($t5)																	
loopFind2:
	addi $t0,$t0,1
	lb $t1,0($t0)
	bne $t1,0x22,loopFind2
single2:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x5c,transfer2
	beq $t1,0x22,double2
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single2
double2:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x20,double2
	beq $t1,0x3b,getSecond
	beq $t1,0x22,single2
transfer2:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x61,transferA2
	beq $t1,0x62,transferB2
	beq $t1,0x66,transferF2
	beq $t1,0x6e,transferN2
	beq $t1,0x72,transferR2
	beq $t1,0x74,transferT2
	beq $t1,0x76,transferV2
	beq $t1,0x5c,transferX2
	beq $t1,0x3f,transferW2
	beq $t1,0x22,transferD2
	beq $t1,0x27,transferS2
	beq $t1,0x78,transferHex2
	bgt $t1,0x2f,checkCheck2
	
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single2
checkCheck2:
	blt $t1,0x38,transferOct2
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single2
transferOct2:
	li $t2,0
	addi $t1,$t1,-48
	add $t2,$t2,$t1
	
	addi $t0,$t0,1
	lb $t1,0($t0)
	blt $t1,0x30,transferOctFinish2
	bgt $t1,0x37,transferOctFinish2
	mul $t2,$t2,8
	addi $t1,$t1,-48
	add $t2,$t2,$t1
	
	addi $t0,$t0,1
	lb $t1,0($t0)
	blt $t1,0x30,transferOctFinish2
	bgt $t1,0x37,transferOctFinish2
	mul $t2,$t2,8
	addi $t1,$t1,-48
	add $t2,$t2,$t1
	
	sb $t2,0($t5)
	addi $t5,$t5,1
	j single2
	
transferOctFinish2:
	addi $t0,$t0,-1
	sb $t2,0($t5)
	addi $t5,$t5,1
	j single2

transferHex2:
	li $t2,0
hexLoop2:
	addi $t0,$t0,1
	lb $t1,0($t0)
	blt $t1,0x30,hexConvert2
	bgt $t1,0x39,hexCheckChar2
	j hexLoop2
hexCheckChar2:
	blt $t1,0x41,hexConvert2
	bgt $t1,0x46,hexCheckLower2
	j hexLoop2
hexCheckLower2:
	blt $t1,0x61,hexConvert2
	bgt $t1,0x66,hexConvert2
	j hexLoop2
hexConvert2:
	addi $t0,$t0,-1
	lb $t1,0($t0)
	beq $t1,0x78,exit
	
	blt $t1,0x41,hexConvertNum3
	blt $t1,0x61,hexConvertUpper3
	
	addi $t1,$t1,-87
	add $t2,$t2,$t1
hexConvertNext2:	
	lb $t1,-1($t0)
	beq $t1,0x78,hexConvertFinish2

	blt $t1,0x41,hexConvertNum4
	blt $t1,0x61,hexConvertUpper4

	addi $t1,$t1,-87
	mul $t1,$t1,16
	add $t2,$t2,$t1

hexConvertFinish2:
	sb $t2,0($t5)
	addi $t5,$t5,1
	j single2
hexConvertNum3:
	addi $t1,$t1,-48
	add $t2,$t2,$t1
	j hexConvertNext2
hexConvertUpper3:
	addi $t1,$t1,-55
	add $t2,$t2,$t1
	j hexConvertNext2
hexConvertNum4:
	addi $t1,$t1,-48
	mul $t1,$t1,16
	add $t2,$t2,$t1
	j hexConvertFinish2
hexConvertUpper4:
	addi $t1,$t1,-55
	mul $t1,$t1,16
	add $t2,$t2,$t1
	j hexConvertFinish2
transferA2:
	li $t1,7
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single2					
transferB2:
	li $t1,8
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single2	
transferF2:
	li $t1,12
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single2	
transferN2:
	li $t1,10	
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single2	
transferR2:
	li $t1,13
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single2	
transferT2:
	li $t1,9
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single2	
transferV2:
	li $t1,11
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single2	
transferX2:
	li $t1,92
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single2	
transferW2:
	li $t1,63
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single2	
transferD2:
	li $t1,34
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single2	
transferS2:
	li $t1,39
	sb $t1,0($t5)
	addi $t5,$t5,1
	j single2	
																													
getSecond:
convertNumber:
	move $t0,$s1
	addi $t0,$t0,3
loopFind3:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x20,loopFind3
	beq $t1,0x3b,exit
	li $t9,0		# Use $t9 to record the number
	beq $t1,0x27,convertAssci
	beq $t1,0x30,convertSpecial
loopConvertDecimal:
	beq $t1,0x2a,convertMul
	beq $t1,0x2b,convertAdd
	beq $t1,0x2d,convertMine
	beq $t1,0x2f,convertDiv
	beq $t1,0x2e,convertFloat
	beq $t1,0x20,getNumber
	beq $t1,0x3b,getNumber
	addi $t1,$t1,-48
	mul $t9,$t9,10
	addu $t9,$t9,$t1
	addi $t0,$t0,1
	lb $t1,0($t0)
	j loopConvertDecimal
	
convertMul:
	lb $t1,1($t0)
	beq $t1,0x3b,exit
	li $t8,0
	jal getLater
	mulo $t9,$t9,$t8
	beq $t1,0x3b,getNumber
	j nextArith
convertAdd:
	lb $t1,1($t0)
	beq $t1,0x3b,exit
	li $t8,0
	jal getLater
	add $t9,$t9,$t8
	beq $t1,0x3b,getNumber
	j nextArith
convertMine:
	lb $t1,1($t0)
	beq $t1,0x3b,exit
	li $t8,0
	jal getLater
	sub $t9,$t9,$t8
	beq $t1,0x3b,getNumber
	j nextArith
convertDiv:
	lb $t1,1($t0)
	beq $t1,0x3b,exit
	li $t8,0
	jal getLater
	div $t9,$t9,$t8
	beq $t1,0x3b,getNumber
	j nextArith
	
nextArith:
	beq $t1,0x2b,convertAdd
	beq $t1,0x2d,convertMine
	beq $t1,0x2f,convertDiv
	beq $t1,0x2a,convertMul

	
getLater:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x2f,back
	beq $t1,0x2a,back
	beq $t1,0x2d,back
	beq $t1,0x2b,back
	beq $t1,0x3b,back
	mul $t8,$t8,10
	addi $t1,$t1,-48
	add $t8,$t8,$t1
	j getLater
back:
	jr $ra
	
	
convertFloat:
	addi $t0,$t0,1
	lb $t1,0($t0)
	bgt $t1,0x34,addOne
	j getNumber
addOne:
	addu $t9,$t9,1
	j getNumber
convertSpecial:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x2e,convertFloat
	beq $t1,0x78,convertHex
	beq $t1,0x58,convertHex
	beq $t1,0x62,convertBinary
	beq $t1,0x42,convertBinary
	addi $t0,$t0,-1
convertOctal:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x30,convertOctal
loopConvertOctal:
	beq $t1,0x20,getNumber
	beq $t1,0x3b,getNumber
	addi $t1,$t1,-48
	mul $t9,$t9,8
	addu $t9,$t9,$t1
	addi $t0,$t0,1
	lb $t1,0($t0)
	j loopConvertOctal
convertHex:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x30,convertHex
loopConvertHex:
	beq $t1,0x20,getNumber
	beq $t1,0x3b,getNumber
	bgt $t1,0x60,lowerCase
	bgt $t1,0x40,upperCase
	addi $t1,$t1,-48
	mul $t9,$t9,16
	addu $t9,$t9,$t1
	addi $t0,$t0,1
	lb $t1,0($t0)
	j loopConvertHex
	
upperCase:
	addi $t1,$t1,-55
	mul $t9,$t9,16
	addu $t9,$t9,$t1
	addi $t0,$t0,1
	lb $t1,0($t0)
	j loopConvertHex	
lowerCase:
	addi $t1,$t1,-87
	mul $t9,$t9,16
	addu $t9,$t9,$t1
	addi $t0,$t0,1
	lb $t1,0($t0)
	j loopConvertHex	

convertBinary:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x30,convertBinary
loopConvertBinary:
	beq $t1,0x20,getNumber
	beq $t1,0x3b,getNumber
	addi $t1,$t1,-48
	mul $t9,$t9,2
	addu $t9,$t9,$t1
	addi $t0,$t0,1
	lb $t1,0($t0)
	j loopConvertBinary
	
convertAssci:
	addi $t0,$t0,1
	lb $t1,0($t0)
	beq $t1,0x27,loopConvertAssci
	j convertAssci
loopConvertAssci:
	lb $s3,-1($t0)
	beq $s3,0x27,exit
	lb $s4,-2($t0)
	beq $s4,0x27,calculate_1
	lb $s5,-3($t0)
	beq $s5,0x27,calculate_2
	lb $s6,-4($t0)
	beq $s5,0x27,calculate_3
calculate_4:
	move $t9,$s6
	mulo $t9,$t9,256
	addu $t9,$t9,$s5
	mulo $t9,$t9,256
	addu $t9,$t9,$s4
	mulo $t9,$t9,256
	addu $t9,$t9,$s3
	j getNumber
calculate_3:
	move $t9,$s5
	mulo $t9,$t9,256
	addu $t9,$t9,$s4
	mulo $t9,$t9,256
	addu $t9,$t9,$s3
	j getNumber
calculate_2:
	move $t9,$s4
	mulo $t9,$t9,256
	addu $t9,$t9,$s3
	j getNumber
calculate_1:
	move $t9,$s3
getNumber:
preparation:
	li $t5,0																										
	la $t0,string
	addi $t2,$t0,5
	li $s3,0	# $s3 = temp
loopMain:
	beq $s3,$t9,printRes
	lbu $t1,0($t0)
	lbu $t3,0($t2)
	sub $t5,$t1,$t3
	bnez $t5,printRes
	beq $t1,0x00,printRes
	beq $t3,0x00,printRes
	addi $t0,$t0,1
	addi $t2,$t2,1
	addi $s3,$s3,1
	j loopMain
																																															
printRes:
	li $v0,4
	la $a0,result
	syscall
	
	li $v0,1
	move $a0,$t5
	syscall
																																																																														
	li $v0,10
	syscall																																																																																							
															
exit:
	li $v0,4
	la $a0,error
	syscall
	
	li $v0,10
	syscall
	
