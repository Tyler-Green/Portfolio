* C-Minus Compilation to TM Code
* File: C3_TestFiles/sort.tm
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
* Declaring Array: x
* Array Size Of: 10
 11:    LDC  2,10(0) 	Load Array Size Into Reg[3]
 12:     ST  2,-11(5) 	Storing Array Size
* 
* Function Declaration: minloc
 14:     ST  4,-1(5) 	Store The Return Address
* Declaring Array: a
* Array Size Of: 0
 15:    LDC  2,0(0) 	Load Array Size Into Reg[3]
 16:     ST  2,-12(5) 	Storing Array Size
* Declaration Of: low
* Declaration Of: high
* Declaration Of: i
* Declaration Of: x
* Declaration Of: k
* Assign Exp
* Simple Var Exp
 17:    LDA  4,0(5) 	Loading FP To Reg[5]
 18:    LDA  3,-13(4) 	Loading Variable Address To Reg[4]
 19:     LD  2,0(4) 	Loading Varialble Value To Reg[3]
* Simple Var Exp
 20:    LDA  4,0(5) 	Loading FP To Reg[5]
 21:    LDA  3,-17(4) 	Loading Variable Address To Reg[4]
 22:     LD  2,0(4) 	Loading Varialble Value To Reg[3]
* Assign Exp
* Index Var Exp
* Simple Var Exp
 23:    LDA  4,0(5) 	Loading FP To Reg[5]
 24:    LDA  3,-13(4) 	Loading Variable Address To Reg[4]
 25:     LD  2,0(4) 	Loading Varialble Value To Reg[3]
* Simple Var Exp
 26:    LDA  4,0(5) 	Loading FP To Reg[5]
 27:    LDA  3,-16(4) 	Loading Variable Address To Reg[4]
 28:     LD  2,0(4) 	Loading Varialble Value To Reg[3]
* Assign Exp
* Op Exp
* Simple Var Exp
 29:    LDA  4,0(5) 	Loading FP To Reg[5]
 30:    LDA  3,-13(4) 	Loading Variable Address To Reg[4]
 31:     LD  2,0(4) 	Loading Varialble Value To Reg[3]
* Int Exp
 32:    LDC  2,1(0) 	Loading Constant (1) To Reg[3]
* End Op Exp
* Simple Var Exp
 33:    LDA  4,0(5) 	Loading FP To Reg[5]
 34:    LDA  3,-15(4) 	Loading Variable Address To Reg[4]
 35:     LD  2,0(4) 	Loading Varialble Value To Reg[3]
* While Exp
* Op Exp
* Simple Var Exp
 36:    LDA  4,0(5) 	Loading FP To Reg[5]
 37:    LDA  3,-15(4) 	Loading Variable Address To Reg[4]
 38:     LD  2,0(4) 	Loading Varialble Value To Reg[3]
* Simple Var Exp
 39:    LDA  4,0(5) 	Loading FP To Reg[5]
 40:    LDA  3,-14(4) 	Loading Variable Address To Reg[4]
 41:     LD  2,0(4) 	Loading Varialble Value To Reg[3]
* End Op Exp
