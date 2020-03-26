* C-Minus Compilation to TM Code
* File: C3_TestFiles/Test1.tm
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
* Declaration Of: b
* Declaring Array: c
* Array Size Of: 10
 13:    LDC  2,10(0) 	Load Array Size Into Reg[3]
 14:     ST  2,-12(5) 	Storing Array Size
* Simple Var Exp
 15:    LDA  4,0(5) 	Loading FP To Reg[5]
 16:    LDA  3,-1(4) 	Loading Variable Address To Reg[4]
 17:     LD  2,0(4) 	Loading Varialble Value To Reg[3]
 18:     LD  7,-1(5) 	Loading Return Address
* Jump Around Function main
 11:    LDA  7,7(7) 	Jumping Around Function
* 
* Finale
 19:    LDA  0,0(7) 	PC stuff
 21:    ADD  0,0,1 	More PC Stuff
 22:     ST  0,-13(5) 	Storing Pc
 23:     ST  5,-15(5) 	Storing FP
 24:    LDA  5,-15(5) 	Updating FP
 25:    LDA  7,-14(7) 	Jumping To Function Main
 20:    LDC  1,0(0) 	Creating Offset
 26:     LD  5,1(5) 	load old fp
 27:   HALT  0,0,0 	Halt
