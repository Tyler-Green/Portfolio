* C-Minus Compilation to TM Code
* File: C3_TestFiles/fac.tm
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
* processing function: main
* Assign Exp
* Int Exp
 12:    LDC  3,5(0) 	loading constant to reg 3
 13:     ST  3,-3(5) 	Saving  rhs result to stack
* Simple Var Exp
 14:    LDA  4,0(5) 	Loading FP
 15:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
 16:     LD  3,0(4) 	Loading varialble value
 17:     LD  0,-3(5) 	Saving rhs back to reg 0
 18:     ST  0,0(4) 	Assigning rhs to lhs
* Assign Exp
* Int Exp
 19:    LDC  3,1(0) 	loading constant to reg 3
 20:     ST  3,-3(5) 	Saving  rhs result to stack
* Simple Var Exp
 21:    LDA  4,0(5) 	Loading FP
 22:    LDA  4,-2(4) 	Loading Variable Address To Reg 4
 23:     LD  3,0(4) 	Loading varialble value
 24:     LD  0,-3(5) 	Saving rhs back to reg 0
 25:     ST  0,0(4) 	Assigning rhs to lhs
* While Exp
* Op Exp
* Simple Var Exp
 26:    LDA  4,0(5) 	Loading FP
 27:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
 28:     LD  3,0(4) 	Loading varialble value
 29:     ST  3,-3(5) 	saving reg 0 to stack
* Int Exp
 30:    LDC  3,1(0) 	loading constant to reg 3
 31:     LD  0,-3(5) 	saving lhs back to reg 0
 32:    LDA  1,0(3) 	moving rhs
 33:    SUB  3,0,1 	substracting rsh from lhs
* End Op Exp
 35:     ST  5,-3(5) 	Storing FP
 36:    LDA  5,-3(5) 	Storing FP
* Assign Exp
* Op Exp
* Simple Var Exp
 37:    LDA  4,0(5) 	Loading FP
 38:     LD  4,0(4) 	Loading Old FP
 39:    LDA  4,-2(4) 	Loading Variable Address To Reg 4
 40:     LD  3,0(4) 	Loading varialble value
 41:     ST  3,-4(5) 	saving reg 0 to stack
* Simple Var Exp
 42:    LDA  4,0(5) 	Loading FP
 43:     LD  4,0(4) 	Loading Old FP
 44:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
 45:     LD  3,0(4) 	Loading varialble value
 46:     LD  0,-4(5) 	saving lhs back to reg 0
 47:    LDA  1,0(3) 	moving rhs
 48:    MUL  3,0,1 	multiplying lsh and rhs
* End Op Exp
 49:     ST  3,-4(5) 	Saving  rhs result to stack
* Simple Var Exp
 50:    LDA  4,0(5) 	Loading FP
 51:     LD  4,0(4) 	Loading Old FP
 52:    LDA  4,-2(4) 	Loading Variable Address To Reg 4
 53:     LD  3,0(4) 	Loading varialble value
 54:     LD  0,-4(5) 	Saving rhs back to reg 0
 55:     ST  0,0(4) 	Assigning rhs to lhs
* Assign Exp
* Op Exp
* Simple Var Exp
 56:    LDA  4,0(5) 	Loading FP
 57:     LD  4,0(4) 	Loading Old FP
 58:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
 59:     LD  3,0(4) 	Loading varialble value
 60:     ST  3,-4(5) 	saving reg 0 to stack
* Int Exp
 61:    LDC  3,1(0) 	loading constant to reg 3
 62:     LD  0,-4(5) 	saving lhs back to reg 0
 63:    LDA  1,0(3) 	moving rhs
 64:    SUB  3,0,1 	substracting rsh from lhs
* End Op Exp
 65:     ST  3,-4(5) 	Saving  rhs result to stack
* Simple Var Exp
 66:    LDA  4,0(5) 	Loading FP
 67:     LD  4,0(4) 	Loading Old FP
 68:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
 69:     LD  3,0(4) 	Loading varialble value
 70:     LD  0,-4(5) 	Saving rhs back to reg 0
 71:     ST  0,0(4) 	Assigning rhs to lhs
 72:     LD  5,0(5) 	Storing FP
 73:    LDA  7,-48(7) 	While end
 34:    JLE  3,39(7) 	while condition
 74:     LD  7,2(5) 	Loading PC
 11:    LDA  7,63(7) 	jump around fn body
 75:    LDA  0,0(7) 	PC stuff
 77:    ADD  0,0,1 	More PC Stuff
 78:     ST  0,-3(5) 	Storing Pc
 79:     ST  5,-5(5) 	Storing FP
 80:    LDA  5,-5(5) 	Updating FP
 81:    LDA  7,-70(7) 	jumping to function
 76:    LDC  1,6(0) 	Creating Offset
 82:     LD  5,1(5) 	load old fp
 83:   HALT  0,0,0 	HALLTTTT
