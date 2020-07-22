* C-Minus Compilation to TM Code
* File: C3_TestFiles/fac.tm
* Standard prelude:
  0:     LD  6,0(0) 	load gp with maxaddress
  1:    LDA  5,0(6) 	copy to gp to fp
  2:     ST  0,0(0) 	clear location 0
* Jump around i/o routines here
  3:    LDA  7,7(7) 	jump around i/o code
* code for input routine
  4:     ST  0,-1(5) 	store return
  5:     IN  0,0,0 	input
  6:     LD  7,-1(5) 	return to caller
* code for output routine
  7:     ST  0,-1(5) 	store return
  8:     LD  0,-2(5) 	load output value
  9:    OUT  0,0,0 	output
 10:     LD  7,-1(5) 	return to caller
* End of standard prelude.
* 
* Function Declaration: main
 12:     ST  4,-1(5) 	Store The Return Address
* Declaration Of: x
* Declaration Of: fac
* Assign Exp
* Int Exp
 13:    LDC  2,5(0) 	Loading Constant (5) To Reg[3]
* Simple Var Exp
 14:    LDA  4,0(5) 	Loading FP To Reg[5]
 15:    LDA  3,-1(4) 	Loading Variable Address To Reg[4]
 16:     LD  2,0(4) 	Loading Varialble Value To Reg[3]
* Assign Exp
* Int Exp
 17:    LDC  2,1(0) 	Loading Constant (1) To Reg[3]
* Simple Var Exp
 18:    LDA  4,0(5) 	Loading FP To Reg[5]
 19:    LDA  3,-2(4) 	Loading Variable Address To Reg[4]
 20:     LD  2,0(4) 	Loading Varialble Value To Reg[3]
* While Exp
* Op Exp
* Simple Var Exp
 21:    LDA  4,0(5) 	Loading FP To Reg[5]
 22:    LDA  3,-1(4) 	Loading Variable Address To Reg[4]
 23:     LD  2,0(4) 	Loading Varialble Value To Reg[3]
* Int Exp
 24:    LDC  2,1(0) 	Loading Constant (1) To Reg[3]
* End Op Exp
