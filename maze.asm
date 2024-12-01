.data
maze:
    .word 0,1,1,1, 1,0,0,1, 0,1,1,1, 0,0,0,1, 1,1,0,0
    .word 0,0,1,1, 0,0,0,0, 1,1,0,1, 1,0,1,0, 1,0,1,1
    .word 1,1,1,0, 0,1,1,0, 0,0,0,1, 1,1,0,0, 1,0,1,0
    .word 0,0,1,1, 0,0,0,1, 1,0,0,0, 0,1,1,1, 1,0,0,0
    .word 1,1,1,0, 1,0,1,0, 0,1,1,0, 0,0,0,1, 1,1,0,0
    .word 0,1,0,1, 0,1,0,0, 1,1,0,1, 0,1,1,0, 1,1,0,1
buffer: .space 100
mistake_count:  .word 0
total_moves:    .word 0
start:          .word 1
end:            .word 0
prompt:         .asciiz "Welcome to the MIPS maze solver!\nEnter a direction: R for right, L for Left, F for Forward and B for Backward:\n"
invalid_move:   .asciiz "Invalid move! Try again...\n"
success_message: .asciiz "Congratulations! You reached the exit."
count_mistake_message: .asciiz "Number of mistakes: "
count_move_message: .asciiz "Total number of moves: "
first_move: .asciiz "First move "
output: .asciiz "You entered: "
i_prompt: .asciiz "i = "  
j_prompt: .asciiz "j = "  


.text
.globl main
main:
    # Print prompt message
	li $v0, 4
    	la $a0, prompt
    	syscall

    # Initialize variables
	li $t0, 0         # i = 0
    	li $t1, 0         # j = 0
    	li $t2, 1         # start = 1
    	li $t3, 0         # end = 0
    	li $t4, 0         # mistake_count = 0
    	li $t5, 0         # total_moves = 0
    	li $t6, 0   
    	la $t7, maze
    	li $t8, 0

loop:
	addi $t5,$t5,1
 # Read and store user input (string)
 	li $v0, 8               
        la $a0, buffer          
        li $a1, 100             
        syscall
        
 	lb $t6, 0($a0)  # store user input in $t6
 	
 	# Check if start == 1
        beq $t2, 1, check_move # If start == 1, jump to check_move
        beq $t3, 1, check_end
        j skip_logic           # Otherwise, skip this logic

check_move:
	# Check if move == 'F'
	beq $t6, 70, set_start_point # If move == 'F', jump to set_start_point
	j skip_logic           # Otherwise, skip this logic

set_start_point:
	# Set i, j to 5, 0
	li $t0, 5              # i = 5
	li $t1, 0              # j = 0
	
	# Set start = 0
	li $t2, 0              # start = 0
	
	j loop
	
check_end:
	beq $t6, 76, print_success_message

print_success_message:
	li $v0, 4
	la $a0, success_message
	syscall  
	li $v0, 11          
    	li $a0, 10          
   	syscall            
   	
	li $v0, 4
	la $a0, count_mistake_message
	syscall  
	li $v0, 1       
    	move $a0, $t4      
    	syscall 
    	li $v0, 11          
    	li $a0, 10          
   	syscall             
   	
	li $v0, 4
	la $a0, count_move_message
	syscall  
	li $v0, 1        
    	move $a0, $t5       
    	syscall 
	li $v0, 10      
	syscall
	
skip_logic:
        # Compare the input with 'R'
        beq $t6, 70, move_forward  
        beq $t6, 82, move_right  
        beq $t6, 66, move_backward 
        beq $t6, 76, move_left 
        j loop

count_index:
    	mul $t8, $t0, 20   	#$t8 = i * 20
    	mul $t9, $t1, 4		#$t9 = j * 4
    	add $s0, $t8, $t9
        
move_forward:
	# count index
	mul $t8, $t0, 20   	#$t8 = i * 20
    	mul $t9, $t1, 4		#$t9 = j * 4
    	add $s0, $t8, $t9
    	addi $s0, $s0, 0
    	
    	
    	# locate the value 
    	mul $s3, $s0, 4  
    	
    	add $s1, $t7, $s3  
    	lw $s2, 0($s1) 
    	
    	bne $s2, 0, handle_invalid_move_f
	addi $t1, $t1, 1
	j check_i
	
move_backward:
	# count index
	mul $t8, $t0, 20   	
    	mul $t9, $t1, 4		
    	add $s0, $t8, $t9
    	# backward index
    	addi $s0, $s0, 2
    	
    	# locate the value 
    	mul $s3, $s0, 4   
    	add $s1, $t7, $s3   
    	lw $s2, 0($s1) 
    	
    	bne $s2, 0, handle_invalid_move_b
	subi $t1, $t1, 1
	j check_i

move_right:
	# count index
	mul $t8, $t0, 20   	
    	mul $t9, $t1, 4		
    	add $s0, $t8, $t9
    	# right index
    	addi $s0, $s0, 1
    	
    	# locate the value 
    	mul $s3, $s0, 4   
    	add $s1, $t7, $s3   
    	lw $s2, 0($s1) 
    	
    	bne $s2, 0, handle_invalid_move_r
    	
	addi $t0, $t0, 1
	j check_i

move_left:
	# count index
	mul $t8, $t0, 20   	
    	mul $t9, $t1, 4		
    	add $s0, $t8, $t9
    	# right left
    	addi $s0, $s0, 3
    	
    	# locate the value 
    	mul $s3, $s0, 4   
    	add $s1, $t7, $s3   
    	lw $s2, 0($s1) 
    	
    	bne $s2, 0, handle_invalid_move_l
    	
	subi $t0, $t0, 1
	j check_i


handle_invalid_move_f:
	li $v0, 4               
	la $a0, invalid_move          
	syscall
	
    	addi $t4, $t4, 1           # mistake_count += 1
    	addi $t5, $t5, 1           # total_moves += 1

    	li $v0, 8               
        la $a0, buffer          
        li $a1, 100             
        syscall
        
 	lb $t6, 0($a0)  # store user input in $t6
 	
    	beq $t6, 66, loop

    	j handle_invalid_move_f
    	
handle_invalid_move_b:
	li $v0, 4               
	la $a0, invalid_move          
	syscall
	
    	addi $t4, $t4, 1           # mistake_count += 1
    	addi $t5, $t5, 1           # total_moves += 1

    	li $v0, 8               
        la $a0, buffer          
        li $a1, 100             
        syscall
        
 	lb $t6, 0($a0)  
 	
    	beq $t6, 70, loop  

    	j handle_invalid_move_b
    	
handle_invalid_move_l:
	li $v0, 4              
	la $a0, invalid_move          
	syscall
	
    	addi $t4, $t4, 1           # mistake_count += 1
    	addi $t5, $t5, 1           # total_moves += 1

    	li $v0, 8               
        la $a0, buffer          
        li $a1, 100             
        syscall
        
 	lb $t6, 0($a0)  # store user input in $t6
 	
    	beq $t6, 82, loop  

    	j handle_invalid_move_l

handle_invalid_move_r:
	li $v0, 4               
	la $a0, invalid_move          
	syscall
	
    	addi $t4, $t4, 1           # mistake_count += 1
    	addi $t5, $t5, 1           # total_moves += 1

    	li $v0, 8               
        la $a0, buffer          
        li $a1, 100             
        syscall
        
 	lb $t6, 0($a0)  # store user input in $t6
 	
    	beq $t6, 76, loop  

    	j handle_invalid_move_r
    	
check_i:    	
    beq $t0, 0, check_j 
    j loop         

check_j:
    beq $t1, 4, set_end 
    j loop        

set_end:
    li $t3, 1            
    j loop
	