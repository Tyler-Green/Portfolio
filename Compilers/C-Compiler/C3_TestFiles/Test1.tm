* C-Minus Compilation to TM Code
* File: C3_TestFiles/Test1.tm
* Standard prelude:
  0:     LD  6,0(0) 	load gp with maxaddress
  1:    LDA  5,0(6) 	copy to gp to fp
  2:     ST  0,0(0) 	clear location 0
* Jump around i/o routines here
* code for input routine
  4:     ST  0,-1(5) 	store return
  5:     IN  0,0,0 	input
  6:     LD  7,-1(5) 	return to caller
* code for output routine
  7:     ST  0,-1(5) 	store return
  8:     LD  0,-2(5) 	load output value
  9:    OUT  0,0,0 	output
 10:     LD  7,-1(5) 	return to caller
  3:    LDA  7,7(7) 	jump around i/o code
* End of standard prelude.
* processing function: func
* If Exp
* If Part
* Op Exp
* Simple Var Exp
 12:    LDA  4,0(5) 	Loading FP
 13:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
 14:     LD  3,0(4) 	Loading varialble value
 15:     ST  3,-2(5) 	saving reg 0 to stack
* Int Exp
 16:    LDC  3,5(0) 	loading constant to reg 3
 17:     LD  0,-2(5) 	saving lhs back to reg 0
 18:    LDA  1,0(3) 	moving rhs
 19:    SUB  3,0,1 	substracting rsh from lhs
* End Op Exp
 21:     ST  5,-2(5) 	Storing FP
 22:    LDA  5,-2(5) 	Loading new FP
* Return exp
* Simple Var Exp
 23:    LDA  4,0(5) 	Loading FP
 24:     LD  4,0(4) 	Loading Old FP
 25:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
 26:     LD  3,0(4) 	Loading varialble value
 27:    LDA  4,0(5) 	loading fp to reg 4
 28:     LD  4,0(4) 	going to scope
 29:     ST  3,1(4) 	Storing the return value
 30:    LDA  5,0(4) 	load old fp
 31:     LD  2,2(5) 	Load return address
 32:    LDA  7,0(2) 	Loading return add
 33:     LD  5,0(5) 	reloading FP
 20:    JLE  3,13(7) 	Jump to end if
* Return exp
* Call Exp
 34:     ST  0,1(5) 	Store reg 0
 35:     ST  1,0(5) 	Store reg 1
 36:    LDA  0,0(7) 	PC stuff
 38:    ADD  0,0,1 	More PC Stuff
 39:     ST  0,-1(5) 	Storing Pc
 40:     ST  5,-3(5) 	Storing FP
 41:    LDA  5,-3(5) 	UPdating FP
* Op Exp
* Simple Var Exp
 42:    LDA  4,0(5) 	Loading FP
 43:     LD  4,0(4) 	Loading Old FP
 44:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
 45:     LD  3,0(4) 	Loading varialble value
 46:     ST  3,-1(5) 	saving reg 0 to stack
* Int Exp
 47:    LDC  3,1(0) 	loading constant to reg 3
 48:     LD  0,-1(5) 	saving lhs back to reg 0
 49:    LDA  1,0(3) 	moving rhs
 50:    ADD  3,0,1 	adding rhs to lhs
* End Op Exp
 51:     ST  3,-1(5) 	add params
 52:    LDA  7,-41(7) 	jumping to function
 37:    LDC  1,16(0) 	Creating Offset
 53:     LD  2,2(5) 	Load returna
 54:     LD  5,0(5) 	load old fp
 55:     LD  1,0(5) 	restore reg 1
 56:     LD  0,1(5) 	restore reg 0
 57:    LDA  4,0(5) 	loading fp to reg 4
 58:     ST  3,1(4) 	Storing the return value
 59:    LDA  5,0(4) 	load old fp
 60:     LD  2,2(5) 	Load return address
 61:    LDA  7,0(2) 	Loading return add
 62:     LD  7,2(5) 	Loading PC
 11:    LDA  7,51(7) 	jump around fn body
* processing function: main
* Assign Exp
* Int Exp
 64:    LDC  3,1(0) 	loading constant to reg 3
 65:     ST  3,-2(5) 	Saving  rhs result to stack
* Simple Var Exp
 66:    LDA  4,0(5) 	Loading FP
 67:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
 68:     LD  3,0(4) 	Loading varialble value
 69:     LD  0,-2(5) 	Saving rhs back to reg 0
 70:     ST  0,0(4) 	Assigning rhs to lhs
* Call Exp
* Call Exp
 71:     ST  0,-2(5) 	Store reg 0
 72:     ST  1,-3(5) 	Store reg 1
 73:    LDA  0,0(7) 	PC stuff
 75:    ADD  0,0,1 	More PC Stuff
 76:     ST  0,-4(5) 	Storing Pc
 77:     ST  5,-6(5) 	Storing FP
 78:    LDA  5,-6(5) 	UPdating FP
* Simple Var Exp
 79:    LDA  4,0(5) 	Loading FP
 80:     LD  4,0(4) 	Loading Old FP
 81:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
 82:     LD  3,0(4) 	Loading varialble value
 83:     ST  3,-1(5) 	add params
 84:    LDA  7,-73(7) 	jumping to function
 74:    LDC  1,11(0) 	Creating Offset
 85:     LD  2,2(5) 	Load returna
 86:     LD  5,0(5) 	load old fp
 87:     LD  1,-3(5) 	restore reg 1
 88:     LD  0,-2(5) 	restore reg 0
 89:     ST  0,-2(5) 	Store reg 0
 90:     ST  5,-3(5) 	Store the fp
 91:    LDA  5,-3(5) 	Create new fp
 92:     ST  3,-2(5) 	Storing outputn value
 93:    LDA  0,1(7) 	Store Pc with offset
 94:    LDA  7,-88(7) 	move return add to reg 0
 95:     LD  5,0(5) 	Reload the fp
 96:     LD  0,-2(5) 	Restore reg 0
 97:     LD  7,2(5) 	Loading PC
 63:    LDA  7,34(7) 	jump around fn body
 98:    LDA  0,0(7) 	PC stuff
100:    ADD  0,0,1 	More PC Stuff
101:     ST  0,-3(5) 	Storing Pc
102:     ST  5,-5(5) 	Storing FP
103:    LDA  5,-5(5) 	Updating FP
104:    LDA  7,-41(7) 	jumping to function
 99:    LDC  1,6(0) 	Creating Offset
105:     LD  5,1(5) 	load old fp
106:   HALT  0,0,0 	HALLTTTT
