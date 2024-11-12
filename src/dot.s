.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0            
    li t1, 0         

loop_start:
    bge t1, a2, loop_end
    lw t2, 0(a0)
    lw t3, 0(a1)

mul:
    li t4, 0
    bge t2, zero, mul_loop_t2
    bge t3, zero, mul_loop_t3
    neg t2, t2
    neg t3, t3 

mul_loop_t2:
    beq t2, zero, mul_end
    add t4, t4, t3
    addi t2, t2, -1
    j mul_loop_t2

mul_loop_t3:
    beq t3, zero, mul_end
    add t4, t4, t2
    addi t3, t3, -1
    j mul_loop_t3

mul_end:
    add t0, t0, t4
    addi t1, t1, 1
    mv t5, zero
    
a0_stride:
    addi a0, a0, 4
    addi t5, t5, 1
    blt t5, a3, a0_stride
    mv t5, zero

a1_stride:
    addi a1, a1, 4
    addi t5, t5, 1
    blt t5, a4, a1_stride
    j loop_start

loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit
