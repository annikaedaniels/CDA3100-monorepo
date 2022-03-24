.data
#all variables declared here, string variables defined

HDR:        .asciiz  "Name: Annika Daniels\nClass: CDA3100\nAssignment: #5 Read in five integer values, save them in an array, and calculate sum, mean, min, max, and variance.\n"
MSG:        .asciiz  "\nEnter 5 integer numbers.\n"
REP:        .asciiz  "\nEnter another number.\n"
FPL:        .asciiz  "\nFloating Point List.\n"
newline:    .asciiz  "\n"
SUMMSG:     .asciiz  "\nThe sum of the numbers is: \n"
MINMSG:     .asciiz  "\nThe smallest number is: \n"
MAXMSG:     .asciiz  "\nThe largest number is: \n" 
MEANMSG:    .asciiz  "\nThe mean of the numbers is: \n"
VARMSG:     .asciiz  "\nThe variance of the numbers is: \n"

#int variables

INDEX:   .word  0
COUNTER: .word  0
MAX_C:   .word  5
ITERATE: .word  0
SIZE:    .word  4

MAX_FP:  .float 5.00000000
MIN1_FP: .float 4.00000000

#declaring array, 20 bytes because storing 5 floats

ARRAY:  .align 4 
        .space 20

.text

.globl main

main:
    li $v0, 4               #string print out call
    la $a0, HDR             #tells syscall to print HDR
    syscall                 #execute command

    lw $t1, COUNTER         #loading size
    lw $t2, MAX_C           #loading the max size for counter to get to
    lw $t3, INDEX           #loading array index
    
    li $v0, 4               #string print out call
    la $a0, MSG             #tells syscall to print MSG
    syscall                 #execute command
    
    la $2, ARRAY

#jump to accept until all array values are accepted
accept:
    beq $t1, $t2, print     #jump to print when counter == max count
    
    li $v0, 4               #string print out call
    la $a0, REP             #tells syscall to print REP
    syscall                 #execute command
    
    li $v0, 5               #take user input call
    syscall                 #execute command
    move, $s1, $v0          #save int at s1
    
    mtc1 $s1, $f1           #moves into to FP register
    cvt.s.w $f1, $f1        #converts to floating point
    swc1 $f1, ARRAY($t3)    #adds f1 to array at index stored in t3
    
    addiu $t3, $t3, 4       #increments index by 4
    addiu $t1, $t1, 1       #increments counter by 1
    
    blt $t1, $t2, accept    #repeats loop if counter is less than max count  

#load array values needed
    la $t0, ARRAY           #loading array address
    lw $t1, ITERATE         #loading iterator for array
    lw $t2, SIZE            #loading array size
    
    li $v0, 4               #string print out call
    la $a0, FPL             #tells syscall to print FPL
    syscall                 #execute command
    
    li $v0, 4               #string print out call
    la $a0, newline         #go to new line
    syscall                 #execute command

#print first of the array
    li $v0, 2               #floating point print call
    lwc1 $f12, 0($t0)       #print what is stored at that part of the array
    syscall                 #execute command

    li $v0, 4               #string print out call
    la $a0, newline         #go to new line
    syscall                 #execute command

#jump to print until all array values are printerd
print:
    bgt $t1, $t2, sec_one   #jump to sec_one when iterator is greater than size
    
    addiu $t0, $t0, 4       #add 4 to array address
    
    li $v0, 2               #floating point print call
    lwc1 $f12, 0($t0)       #print what is stored at that part of array
    syscall                 #execute command
    
    addiu $t1, $t1, 1       #add one to iterator
    
    li $v0, 4               #string print out call
    la $a0, newline         #go to new line
    syscall                 #execute command
    
    blt $t1, $t2, print     #repeats jump if iterator is less than size

sec_one:
    la $t0, ARRAY           #resets array address
    lw $t1, ITERATE         #resets iterator
    lw $t2, SIZE            #resets size
    lw $t3, MAX_C           #resets max


#float sum stored in f20
float_sum:
    bgt $t1, $t2, sec_two   #jump to sec_two when iterator is greater than size
    
    lwc1 $f2, 0($t0)        #load float at array position
    add.s $f20, $f20, $f2   #add float to f20 (sum)
    
    addiu $t1, $t1, 1       #add one to iterator
    
    addiu $t0, $t0, 4       #add 4 to array address
    
    blt $t1, $t3, float_sum #repeats float_sum if iterator is less than size
  
  
sec_two:
    li $v0, 4               #string print out call
    la $a0, SUMMSG          #tells syscall to print SUMMSG
    syscall                 #execute command
    
    li $v0, 2               #floating point print call
    mov.s $f12, $f20        #print f20
    syscall                 #execute command
    
#load array values needed
    la $t0, ARRAY           #resets array address
    lw $t1, ITERATE         #resets iterator
    lw $t2, SIZE            #resets size
    
#f0 will be min value
    lwc1 $f0, 0($t0)        #load first value of the array
    
 
#section to find minimum value
min:    
    bgt $t1, $t2, sec_three #jump to sec_three when iterator is greater than size
    
    addiu $t0, $t0, 4       #adds 4 to array address
    
    lwc1 $f2, 0($t0)        #load float at array position to compare to f0
    
    addiu $t1, $t1, 1       #add one to iterator
    
    c.lt.s $f0, $f2         #if f0 is less than f2
    bc1f not_min            #jump to not_min
    
    blt $t1, $t2, min       #repeats min if iterator is less than size
    
not_min:
    mov.s $f0 $f2           #put f2 into f0
    j min                   #jump to min


sec_three:
    li $v0, 4               #string print out call
    la $a0, MINMSG          #tells syscall to print MINMSG
    syscall                 #execute command
    
    li $v0, 2               #floating point print call
    mov.s $f12, $f0         #print f0
    syscall                 #execute command

#load array values needed
    la $t0, ARRAY           #resets array address
    lw $t1, ITERATE         #resets iterator
    lw $t2, SIZE            #resets size

#f0 will be the max value
    lwc1 $f0, 0($t0)        #load first value of array
    

#section to find maximum value
max:
    bgt $t1, $t2, sec_four  #jump to sec_four when iterator is greater than size
    
    addiu $t0, $t0, 4       #adds 4 to array address
    
    lwc1 $f2, 0($t0)        #load float at array position to compare to f0
    
    addiu $t1, $t1, 1       #add one to iterator
    
    c.lt.s $f2, $f0         #if f0 is greater than f2
    bc1f not_max            #jump to not_max
    
    blt $t1, $t2, max       #repeat max if iterator is less than size
    
not_max:    
    mov.s $f0, $f2          #put f2 into f0
    j max                   #jump to max
    
    
sec_four:   
    li $v0, 4               #string print out call
    la $a0, MAXMSG          #tells syscall to print MAXMSG
    syscall                 #execute command
    
    li $v0, 2               #floating point print call
    mov.s $f12, $f0         #print f0
    syscall                 #execute command
    
    li $v0, 4               #string print out call
    la $a0, MEANMSG         #tells syscall to print MEANMSG
    syscall                 #execute command
    
    lwc1 $f18, MAX_FP       #load MAX_FP at f18
    
    div.s $f19, $f20, $f18  #find mean (sum/5)
    
    li $v0, 2               #floating point print call
    mov.s $f12, $f19        #print f19
    syscall                 #execute command

#load array values needed
    la $t0, ARRAY           #resets array address
    lw $t1, ITERATE         #resets iterator
    lw $t2, SIZE            #resets size
    lw $t3, MAX_C           #resets max
    
    
#f14 is where sum of squared values is stored    
square_sum:
    bgt $t1, $t2, sec_five  #jump to sec_five when iterator is greater than size
    
    lwc1 $f2, 0($t0)        #loads floating point
    
    mul.s $f10, $f2, $f2    #sqares f2, adds to f10
    add.s $f14, $f14, $f10  #add squared value to f14
    
    addiu $t1, $t1, 1       #add one to iterator
    
    addiu $t0, $t0, 4       #adds 4 to array address
    
    blt $t1, $t3, square_sum    #repeat sqaure_sum if iterator is less than size


#calculate variance
sec_five:
    lwc1 $f15, MIN1_FP

    mul.s $f8, $f20, $f20   #square the sum
    div.s $f8, $f8, $f18    #divide by num (5)
    sub.s $f8, $f14, $f8    #sum of squares- f8
    div.s $f8, $f8, $f15    #f8/4
    
    li $v0, 4               #string print out call
    la $a0, VARMSG          #tells syscall to print VARMSG
    syscall                 #execute command
    
    li $v0, 2               #print floating point call
    mov.s $f12, $f8         #print f8
    syscall                 #execute command
    

jr $ra