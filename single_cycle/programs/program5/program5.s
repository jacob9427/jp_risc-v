.globl _start # testing all new branch instructions

_start: 
  addi x1, x0, -4
  addi x2, x0, -8

  bne  x1, x1, bne_taken # not taken
  bne  x1, x2, bne_taken # is taken
  addi x3, x0, 111 # not executed

bne_taken:
  addi x3, x0, 222
  beq  x1, x2, beq_taken # not taken
  beq  x1, x1, beq_taken # is taken
  addi x4, x0, 222 # not executed

beq_taken:
  addi x4, x0, 333
  blt  x1, x2, blt_taken # not taken
  blt  x2, x1, blt_taken # is taken
  addi x5, x0, 333 # not executed

blt_taken:
  addi x5, x0, 444
  bltu x2, x1, bltu_taken # not taken
  bltu x1, x2, bltu_taken # is taken
  addi x6, x0, 444 # note executed

bltu_taken:
  addi x6, x0, 555
  bge  x2, x1, bge_taken # not taken
  bge  x1, x2, bge_taken # is taken
  addi x7, x0, 555 # not executed

bge_taken:
  addi x8, x0, 666
  bgeu x1, x2, bgeu_taken # not taken
  bgeu x2, x1, bgeu_taken # is taken
  addi x9, x0, 666 # not executed

bgeu_taken:
  addi x9, x0, 777

done:   beq x0, x0, done    # infinite loop

# 00000000 <_start>:
#    0:   ffc00093                li      ra,-4
#    4:   ff800113                li      sp,-8
#    8:   00109663                bne     ra,ra,14 <bne_taken>
#    c:   00209463                bne     ra,sp,14 <bne_taken>
#   10:   06f00193                li      gp,111

# 00000014 <bne_taken>:
#   14:   0de00193                li      gp,222
#   18:   00208663                beq     ra,sp,24 <beq_taken>
#   1c:   00108463                beq     ra,ra,24 <beq_taken>
#   20:   0de00213                li      tp,222

# 00000024 <beq_taken>:
#   24:   14d00213                li      tp,333
#   28:   0020c663                blt     ra,sp,34 <blt_taken>
#   2c:   00114463                blt     sp,ra,34 <blt_taken>
#   30:   14d00293                li      t0,333

# 00000034 <blt_taken>:
#   34:   1bc00293                li      t0,444
#   38:   00116663                bltu    sp,ra,44 <bltu_taken>
#   3c:   0020e463                bltu    ra,sp,44 <bltu_taken>
#   40:   1bc00313                li      t1,444

# 00000044 <bltu_taken>:
#   44:   22b00313                li      t1,555
#   48:   00115663                bge     sp,ra,54 <bge_taken>
#   4c:   0020d463                bge     ra,sp,54 <bge_taken>
#   50:   22b00393                li      t2,555

# 00000054 <bge_taken>:
#   54:   29a00413                li      s0,666
#   58:   0020f663                bgeu    ra,sp,64 <bgeu_taken>
#   5c:   00117463                bgeu    sp,ra,64 <bgeu_taken>
#   60:   29a00493                li      s1,666

# 00000064 <bgeu_taken>:
#   64:   30900493                li      s1,777

# 00000068 <done>:
#   68:   00000063                beqz    zero,68 <done>