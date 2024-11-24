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
prompt:         .asciiz "Welcome to the MIPS maze solver\nEnter a direction: R for right, L for Left, F for Forward and B for Backward\n"
invalid_move:   .asciiz "Invalid move! Try again. Expected: "
success_message: .asciiz "Congratulations! You reached the exit."
count_mistake_message: .asciiz "Number of mistake: "
count_move_message: .asciiz "Total number of moves: "
first_move: .asciiz "First move "
output: .asciiz "You entered: "
i_prompt: .asciiz "i = "  # 儲存字串 "i = " 在資料段中
j_prompt: .asciiz "j = "  # 儲存字串 "i = " 在資料段中


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
 	li $v0, 8               # syscall for reading a string
        la $a0, buffer          # address to store input
        li $a1, 100             # maximum number of characters
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
	# li $v0, 4
	# la $a0, first_move
	# syscall
	
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
	li $v0, 11          # 11 是用來打印字符的系統調用號碼
    	li $a0, 10          # 10 是換行符的 ASCII 值
   	syscall             # 呼叫系統調用，打印換行符
   	
	li $v0, 4
	la $a0, count_mistake_message
	syscall  
	li $v0, 1        # 4 是打印字符串的系統調用號碼
    	move $a0, $t4      # 將 $s0 中的地址複製到 $a0
    	syscall 
    	li $v0, 11          # 11 是用來打印字符的系統調用號碼
    	li $a0, 10          # 10 是換行符的 ASCII 值
   	syscall             # 呼叫系統調用，打印換行符
   	
	li $v0, 4
	la $a0, count_move_message
	syscall  
	li $v0, 1        # 4 是打印字符串的系統調用號碼
    	move $a0, $t5        # 將 $s0 中的地址複製到 $a0
    	syscall 
	li $v0, 10       # Load the syscall code for program exit (10)
	syscall
	
skip_logic:
        # Compare the input with 'R'
        beq $t6, 70, move_forward  # if input is 'F', print the input
        beq $t6, 82, move_right  # if input is 'R', print the input
        beq $t6, 66, move_backward # if input is 'B', print the input
        beq $t6, 76, move_left # if input is 'L', print the input
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
    	
    	# li $v0, 1        # 4 是打印字符串的系統調用號碼
    	# move $a0, $s0        # 將 $s0 中的地址複製到 $a0
    	# syscall   
    	
    	# locate the value 
    	mul $s3, $s0, 4   # 計算偏移量 100 * 4 = 400
    	
    	add $s1, $t7, $s3   # 計算 maze[100] 的地址，$s8 存儲的是陣列的起始地址
    	lw $s2, 0($s1) 
    	
    	# li $v0, 1        # 4 是打印字符串的系統調用號碼
    	# move $a0, $s2       # 將 $s0 中的地址複製到 $a0
    	# syscall  
    	
    	bne $s2, 0, handle_invalid_move_f
	addi $t1, $t1, 1
	j check_i
	#j print_curr_pos
	# j loop
	
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
	#j print_curr_pos
	#j loop
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
	#j print_curr_pos
	#j loop
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
	#j print_curr_pos
	#j loop

handle_invalid_move_f:
	li $v0, 4               # syscall for printing a string
	la $a0, invalid_move          # load address of output message
	syscall
	
	# 增加錯誤計數
    	addi $t4, $t4, 1           # mistake_count += 1
    	addi $t5, $t5, 1           # total_moves += 1

    	li $v0, 8               # syscall for reading a string
        la $a0, buffer          # address to store input
        li $a1, 100             # maximum number of characters
        syscall
        
 	lb $t6, 0($a0)  # store user input in $t6
 	
    	# 比較字元
    	beq $t6, 66, loop  # 如果相等，跳轉到 valid_move

    	# 如果輸入錯誤，繼續循環
    	j handle_invalid_move_f
    	
handle_invalid_move_b:
	li $v0, 4               # syscall for printing a string
	la $a0, invalid_move          # load address of output message
	syscall
	
	# 增加錯誤計數
    	addi $t4, $t4, 1           # mistake_count += 1
    	addi $t5, $t5, 1           # total_moves += 1

    	li $v0, 8               # syscall for reading a string
        la $a0, buffer          # address to store input
        li $a1, 100             # maximum number of characters
        syscall
        
 	lb $t6, 0($a0)  # store user input in $t6
 	
    	# 比較字元
    	beq $t6, 70, loop  # 如果相等，跳轉到 valid_move

    	# 如果輸入錯誤，繼續循環
    	j handle_invalid_move_b
    	
handle_invalid_move_l:
	li $v0, 4               # syscall for printing a string
	la $a0, invalid_move          # load address of output message
	syscall
	
	# 增加錯誤計數
    	addi $t4, $t4, 1           # mistake_count += 1
    	addi $t5, $t5, 1           # total_moves += 1

    	li $v0, 8               # syscall for reading a string
        la $a0, buffer          # address to store input
        li $a1, 100             # maximum number of characters
        syscall
        
 	lb $t6, 0($a0)  # store user input in $t6
 	
    	# 比較字元
    	beq $t6, 82, loop  # 如果相等，跳轉到 valid_move

    	# 如果輸入錯誤，繼續循環
    	j handle_invalid_move_l

handle_invalid_move_r:
	li $v0, 4               # syscall for printing a string
	la $a0, invalid_move          # load address of output message
	syscall
	
	# 增加錯誤計數
    	addi $t4, $t4, 1           # mistake_count += 1
    	addi $t5, $t5, 1           # total_moves += 1

    	li $v0, 8               # syscall for reading a string
        la $a0, buffer          # address to store input
        li $a1, 100             # maximum number of characters
        syscall
        
 	lb $t6, 0($a0)  # store user input in $t6
 	
    	# 比較字元
    	beq $t6, 76, loop  # 如果相等，跳轉到 valid_move

    	# 如果輸入錯誤，繼續循環
    	j handle_invalid_move_r
	
print_curr_pos:
    	# Print the value in $t0
    	li $v0, 4          # syscall code for printing a string
    	la $a0, i_prompt     # load address of the string "i = "
    	syscall         # make the syscall to print $t0 value
    	li $v0, 1          # syscall code for printing a string
    	move $a0, $t0   # move value of $t0 to $a0
    	syscall         # make the syscall to print $t0 value

    	# Print the value in $t1
    	li $v0, 4          # syscall code for printing a string
    	la $a0, j_prompt     # load address of the string "i = "
    	syscall         # make the syscall to print $t0 value
    	li $v0, 1          # syscall code for printing a string
    	move $a0, $t1   # move value of $t1 to $a0
    	syscall         # make the syscall to print $t1 value
    	
    	j loop
    	
check_i:    	
    beq $t0, 0, check_j # 如果 i == 0，跳到檢查 j 的部分
    j loop         # 如果 i != 0，跳過 end 設定

check_j:
    beq $t1, 4, set_end # 如果 j == 4，跳到設定 end 的部分
    j loop        # 如果 j != 4，跳過 end 設定

set_end:
    li $t3, 1            # 把 1 放入 $t2 (設定 end = 1)
    j loop	
	