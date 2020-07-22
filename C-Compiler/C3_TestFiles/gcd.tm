* C-Minus Compilation to TM Code
* File: C3_TestFiles/gcd.tm
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
* Function Declaration: gcd
 12:     ST  4,-1(5) 	Store The Return Address
* Declaration Of: u
* Declaration Of: v
