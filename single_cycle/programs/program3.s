.globl _start # test jalr instruction

_start: addi x1, x0, 4      # 0x00 x1 = 4
        srli x2, x1, 2      # 0x04 x2 = 2
        sll  x3, x2, x1     # 0x08 x3 = 32
        addi x4, x0, -10    # 0x0C x4 = -10
        srai x4, x4, 1      # 0x10 x4 = -5

        slt x5, x4, x2      # 0x14 x5 = (-5 < 64) = 1
        sltu x6, x4, x2     # 0x18 x6 = (really big number < 64) = 0
        addi x7, x0, 15     # 0x1C x7 = 15

        xor x8, x2, x7      # 0x20 x8 = 64 xor 15 = 79

        jalr x10, x3, 16    # 0x24 should jump to PC @ 16 + 32 = 48 = 0x30
                            # store 0x28 in x10

        addi x1, x0, 13     # 0x28 shouldnt execute
        addi x2, x0, 17     # 0x2C shouldnt execute

        addi x4, x0, 43     # 0x30 x4 = 43
        jalr x11, x4, 20    # 0x34 should jump to PC @ 20 + 43 = 63 -> mask bit 0 = 62 = 0x3E

        addi x3, x0, 1      # 0x38
        addi x5, x0, 1      # 0x3C
        jal x0, done        # 0x3E (usally would be trigger an exception but this is just for verification purpose)



done:   beq x0, x0, done    # infinite loop
