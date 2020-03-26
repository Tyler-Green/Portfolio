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
 13:     LD  7,-1(5) 	Loading Return Address
* Jump Around Function main
 11:    LDA  7,2(7) 	Jumping Around Function
* 
* Finale
 14:    LDA  0,0(7) 	PC stuff
 16:    ADD  0,0,1 	More PC Stuff
 17:     ST  0,-1(5) 	Storing Pc
 18:     ST  5,-3(5) 	Storing FP
 19:    LDA  5,-3(5) 	Updating FP
 20:    LDA  7,-9(7) 	jumping to function
 15:    LDC  1,6(0) 	Creating Offset
 21:     LD  5,1(5) 	load old fp
 22:   HALT  0,0,0 	Halt
