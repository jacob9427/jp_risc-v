.globl _start # just testing new alu operations

_start: addi x1, x0, 4      # x1 = 4
        srli x2, x1, 2      # x2 = 1
        sll  x3, x2, x1     # x3 = 16
        addi x4, x0, -10    # x4 = -10
        srai x4, x4, 1      # x4 = -5

        slt x5, x4, x2      # x5 = (-5 < 64) = 1
        sltu x6, x4, x2     # x6 = (really big number < 64) = 0
        addi x7, x0, 15     # x7 = 15

        xor x8, x2, x7      # x8 = 1 xor 15 = 14

done:   beq x0, x0, done    # infinite loop
