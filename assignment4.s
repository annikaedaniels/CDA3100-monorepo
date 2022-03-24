.data 
#all variables declared here, string variables defined

HDR:     .asciiz "Name: Annika Daniels\nClass: CDA3100\nAssignment: #4 Read in three numbers and work with sum, difference, product, division, and shifting.\n"
ENTR1:   .asciiz "Enter the first number: \n"
ENTR2:   .asciiz "Enter the second number: \n"
ENTR3:   .asciiz "Enter the third number: \n"
ERR:     .asciiz "Error: user input is below 1 \n"

#numbers declared with value 0 so value can be accepted

NUM1:    .word   0
NUM2:    .word   0
NUM3:    .word   0

#string variables for operations

SUM:    .asciiz "\nSum: "
DIFF:   .asciiz "\nDifference: "
PROD:   .asciiz "\nProduct: "
QUOT:   .asciiz "\nQuotient: "
REM:    .asciiz "\nRemainder: "

SHFT1:  .asciiz "\nNUM1 Shift Left 1: "
SHFT2:   .asciiz "\nNUM2 Shift Right 2: "

.text

.globl main

main: 
    li $v0, 4           #string print out call
    la $a0, HDR         #tells syscall to print HDR
    syscall             #execute command
    
    li $v0, 4           #string print out call
    la $a0, ENTR1       #tells syscall to print ENTR1
    syscall             #execute command
    
    li $v0, 5           #take input command
    syscall             #execute command
    sw $v0, NUM1        #load NUM1 into register
    lw $s1, NUM1        #save NUM1 into memory
    
    blt $s1, 1, BOT     #if input<1, skip to bot
    
    li $v0, 4           #string print out call
    la $a0, ENTR2       #tells syscall to print ENTR2
    syscall             #execute command
    
    li $v0, 5           #take input command
    syscall             #execute command
    sw $v0, NUM2        #load NUM2 into register
    lw $s2, NUM2        #save NUM2 into memory
    
    blt $s2, 1, BOT     #if input<1, skip to bot
    
    li $v0, 4           #string pirnt out call
    la $a0, ENTR3       #tells syscall to print ENTR3
    syscall             #execute command
    
    li $v0, 5           #take input command
    syscall             #execute command
    sw $v0, NUM3        #load NUM3 into register
    lw $s3, NUM3        #save NUM3 into memory
    
    blt $s3, 1, BOT     #if input<1, skip to bot
    
    add $t4, $s1, $s2   #$t4= $s1+$s2
    add $t4, $t4, $s3   #$t4= $t4+$s3
    
    li $v0, 4           #string print out call
    la $a0, SUM         #tells syscall to print SUM
    syscall             #execute command
    li $v0, 1           #int print out call
    move $a0, $t4       #assign $a0 with temp value
    syscall             #execute command
    
    sub $t4, $s1, $s2   #$tr= $s1-$s2
    
    li $v0, 4           #string print out call
    la $a0, DIFF        #tells syscall to print DIFF
    syscall             #execute command
    li $v0, 1           #int print out call
    move $a0, $t4       #assign $a0 with temp value
    syscall             #execute command
    
    mul $t4, $s1, $s2   #$t4= $s1*$s2
    mul $t4, $t4, $s3   #$t4= $t4*$s3
    
    li $v0, 4           #string print out call
    la $a0, PROD        #tells syscall to print PROD
    syscall             #execute command
    li $v0, 1           #int print out call
    move $a0, $t4       #assign $a0 with temp value
    syscall             #execute command
    
    div $s2, $s3       #$s2/$s3 and $s2%$s3
    
    li $v0, 4           #string print out call
    la $a0, QUOT        #tells syscall to print QUOT
    syscall             #execute command
    li $v0, 1           #int print out call
    mflo $a0            #lo= a0
    syscall             #execute command
    
    li $v0, 4           #string print out call
    la $a0, REM         #tells syscall to print REM
    syscall             #execute command
    li $v0, 1           #int print out call
    mfhi $a0            #hi= a0
    syscall             #execute command
    
    sll $t4, $s1, 1     #shift NUM1 by one binary digit left
    srl $t5, $s2, 2     #shift NUM2 by one binary digit right
   
    li $v0, 4           #string print out call
    la $a0, SHFT1       #tells syscall to print SHFT1
    syscall             #execute command
    li $v0, 1           #int print out call
    move $a0, $t4       #assign $a0 with temp value
    syscall             #execute command
    
    li $v0, 4           #string print out call
    la $a0, SHFT2       #tells syscall to print SHFT2
    syscall             #execute command
    li $v0, 1           #int print out call
    move $a0, $t5       #assign $a0 with temp value
    syscall             #execute command
    
    jr $ra
    
BOT: 
    li, $v0, 4          #string print out call
    la $a0, ERR         #tells syscall to print ERR
    syscall             #execute command
    
    jr $ra 