.globl _start # testing lui and auipc

_start: lui x1, 0x12345  # x1 = 0x12345000
        addi x1, x1, 0x678 # x1 = 0x12345678
        auipc x2, 0x67676     # x2 = 0x67676008

        jal x0, done

done:   beq x0, x0, done    # infinite loop
