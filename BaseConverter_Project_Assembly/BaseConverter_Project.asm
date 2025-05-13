.data
    promptCurrentBase: .asciiz "Enter the current system: "
    promptNumber: .asciiz "Enter the number: "
    promptNewBase: .asciiz "Enter the new system: "
    outputMsg: .asciiz "The number in the new system: "
    errorMsg: .asciiz "Error: '"
    errorMsg2: .asciiz "' is not valid in base "
    period: .asciiz ".\n"
    newline: .asciiz "\n"
    number: .space 50
    result: .space 50

.text
.globl main

main:
    li $v0, 4
    la $a0, promptCurrentBase
    syscall
    
    li $v0, 5
    syscall
    move $s0, $v0
    
    li $v0, 4
    la $a0, promptNumber
    syscall
    
    li $v0, 8
    la $a0, number
    li $a1, 50
    syscall
    
    la $t0, number
remove_newline:
    lb $t1, ($t0)
    beq $t1, 10, replace_newline
    beq $t1, 0, input_done
    addi $t0, $t0, 1
    j remove_newline
replace_newline:
    sb $zero, ($t0)
input_done:

    la $t0, number
validate_loop:
    lb $t1, ($t0)
    beqz $t1, validate_done
    
    addi $sp, $sp, -12
    sw $ra, 8($sp)
    sw $t0, 4($sp)
    sw $s0, 0($sp)
    
    move $a0, $t1
    jal val
    
    lw $s0, 0($sp)
    lw $t0, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12
    
    move $t2, $v0
    bltz $t2, print_error
    bge $t2, $s0, print_error
    
    addi $t0, $t0, 1
    j validate_loop

print_error:
    li $v0, 4
    la $a0, errorMsg
    syscall
    
    li $v0, 11
    lb $a0, ($t0)
    syscall
    
    li $v0, 4
    la $a0, errorMsg2
    syscall
    
    li $v0, 1
    move $a0, $s0
    syscall
    
    li $v0, 4
    la $a0, period
    syscall
    
    li $v0, 10
    syscall

validate_done:
    li $v0, 4
    la $a0, promptNewBase
    syscall
    
    li $v0, 5
    syscall
    move $s1, $v0
    
    la $a0, number
    move $a1, $s0
    jal OtherToDecimal
    move $s2, $v0
    
    la $a0, result
    move $a1, $s1
    move $a2, $s2
    jal DecimalToOther
    
    li $v0, 4
    la $a0, outputMsg
    syscall
    
    li $v0, 4
    la $a0, result
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 10
    syscall

val:
    li $v0, -1
    
    li $t0, '0'
    li $t1, '9'
    blt $a0, $t0, val_check_letter
    bgt $a0, $t1, val_check_letter
    sub $v0, $a0, $t0
    j val_end
    
val_check_letter:
    li $t0, 'A'
    li $t1, 'F'
    blt $a0, $t0, val_end
    bgt $a0, $t1, val_end
    sub $v0, $a0, $t0
    addi $v0, $v0, 10
    
val_end:
    jr $ra

OtherToDecimal:
    move $t0, $a0
    li $t1, 0
    li $t2, 1
    
    move $t3, $t0
strlen_loop:
    lb $t4, ($t3)
    beqz $t4, strlen_done
    addi $t3, $t3, 1
    j strlen_loop
strlen_done:
    sub $t3, $t3, $t0
    
    add $t3, $t3, -1
OtherToDecimal_loop:
    bltz $t3, OtherToDecimal_done
    
    add $t4, $t0, $t3
    lb $a0, ($t4)
    
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $t0, 12($sp)
    sw $t1, 8($sp)
    sw $t2, 4($sp)
    sw $a1, 0($sp)
    
    jal val
    
    lw $a1, 0($sp)
    lw $t2, 4($sp)
    lw $t1, 8($sp)
    lw $t0, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    
    mul $t5, $v0, $t2
    add $t1, $t1, $t5
    mul $t2, $t2, $a1
    
    addi $t3, $t3, -1
    j OtherToDecimal_loop
    
OtherToDecimal_done:
    move $v0, $t1
    jr $ra

DecimalToOther:
    move $t0, $a0
    li $t1, 0
    
    bnez $a2, DecimalToOther_loop
    li $t2, '0'
    sb $t2, ($t0)
    addi $t0, $t0, 1
    sb $zero, ($t0)
    jr $ra
    
DecimalToOther_loop:
    beqz $a2, DecimalToOther_reverse
    
    div $a2, $a1
    mfhi $t2
    mflo $a2
    
    li $t3, 10
    bge $t2, $t3, letter_digit
    
    addi $t2, $t2, '0'
    j store_digit
    
letter_digit:
    addi $t2, $t2, 'A'
    addi $t2, $t2, -10
    
store_digit:
    sb $t2, ($t0)
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    
    j DecimalToOther_loop
    
DecimalToOther_reverse:
    sb $zero, ($t0)
    
    la $t0, result
    move $t1, $t0
    
strlen_loop2:
    lb $t2, ($t1)
    beqz $t2, strlen_done2
    addi $t1, $t1, 1
    j strlen_loop2
strlen_done2:
    addi $t1, $t1, -1
    
reverse_loop:
    bge $t0, $t1, reverse_done
    
    lb $t2, ($t0)
    lb $t3, ($t1)
    sb $t3, ($t0)
    sb $t2, ($t1)
    
    addi $t0, $t0, 1
    addi $t1, $t1, -1
    j reverse_loop
    
reverse_done:
    jr $ra
