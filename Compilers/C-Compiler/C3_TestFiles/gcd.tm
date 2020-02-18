* C-Minus Compilation to TM Code
* File: C3_TestFiles/gcd.tm
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
* processing function: gcd
* If Exp
* If Part
* Op Exp
* Simple Var Exp
 12:    LDA  4,0(5) 	Loading FP
 13:    LDA  4,-2(4) 	Loading Variable Address To Reg 4
 14:     LD  3,0(4) 	Loading varialble value
 15:     ST  3,-3(5) 	saving reg 0 to stack
* Int Exp
 16:    LDC  3,0(0) 	loading constant to reg 3
 17:     LD  0,-3(5) 	saving lhs back to reg 0
 18:    LDA  1,0(3) 	moving rhs
 19:    SUB  0,0,1 	substracting rsh from lhs
 20:    MUL  0,0,0 	multiplying lsh and rhs
 21:    LDC  1,-1(0) 	moving -1 to reg 1
 22:    MUL  0,0,1 	multiplying lsh and rhs
 23:    SUB  3,0,1 	subtracting rhs from lhs
* End Op Exp
 25:     ST  5,-3(5) 	Storing FP
 26:    LDA  5,-3(5) 	Loading new FP
* Return exp
* Simple Var Exp
 27:    LDA  4,0(5) 	Loading FP
 28:     LD  4,0(4) 	Loading Old FP
 29:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
 30:     LD  3,0(4) 	Loading varialble value
 31:    LDA  4,0(5) 	loading fp to reg 4
 32:     LD  4,0(4) 	going to scope
 33:     ST  3,1(4) 	Storing the return value
 34:    LDA  5,0(4) 	load old fp
 35:     LD  2,2(5) 	Load return address
 36:    LDA  7,0(2) 	Loading return add
 37:     LD  5,0(5) 	reloading FP
* Else Part
 38:     ST  5,0(5) 	Storing FP
 39:    LDA  5,0(5) 	Loading new FP
 24:    JLE  3,16(7) 	Jump to else
* Return exp
* Call Exp
 41:     ST  0,-1(5) 	Store reg 0
 42:     ST  1,-2(5) 	Store reg 1
 43:    LDA  0,0(7) 	PC stuff
 45:    ADD  0,0,1 	More PC Stuff
 46:     ST  0,-3(5) 	Storing Pc
 47:     ST  5,-5(5) 	Storing FP
 48:    LDA  5,-5(5) 	UPdating FP
* Simple Var Exp
 49:    LDA  4,0(5) 	Loading FP
 50:     LD  4,0(4) 	Loading Old FP
 51:     LD  4,0(4) 	Loading Old FP
 52:    LDA  4,-2(4) 	Loading Variable Address To Reg 4
 53:     LD  3,0(4) 	Loading varialble value
 54:     ST  3,-1(5) 	add params
* Op Exp
* Simple Var Exp
 55:    LDA  4,0(5) 	Loading FP
 56:     LD  4,0(4) 	Loading Old FP
 57:     LD  4,0(4) 	Loading Old FP
 58:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
 59:     LD  3,0(4) 	Loading varialble value
 60:     ST  3,-2(5) 	saving reg 0 to stack
* Op Exp
* Op Exp
* Simple Var Exp
 61:    LDA  4,0(5) 	Loading FP
 62:     LD  4,0(4) 	Loading Old FP
 63:     LD  4,0(4) 	Loading Old FP
 64:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
 65:     LD  3,0(4) 	Loading varialble value
 66:     ST  3,-3(5) 	saving reg 0 to stack
* Simple Var Exp
 67:    LDA  4,0(5) 	Loading FP
 68:     LD  4,0(4) 	Loading Old FP
 69:     LD  4,0(4) 	Loading Old FP
 70:    LDA  4,-2(4) 	Loading Variable Address To Reg 4
 71:     LD  3,0(4) 	Loading varialble value
 72:     LD  0,-3(5) 	saving lhs back to reg 0
 73:    LDA  1,0(3) 	moving rhs
 74:    DIV  3,0,1 	dividing lhs by rhs
* End Op Exp
 75:     ST  3,-3(5) 	saving reg 0 to stack
* Simple Var Exp
 76:    LDA  4,0(5) 	Loading FP
 77:     LD  4,0(4) 	Loading Old FP
 78:     LD  4,0(4) 	Loading Old FP
 79:    LDA  4,-2(4) 	Loading Variable Address To Reg 4
 80:     LD  3,0(4) 	Loading varialble value
 81:     LD  0,-3(5) 	saving lhs back to reg 0
 82:    LDA  1,0(3) 	moving rhs
 83:    MUL  3,0,1 	multiplying lsh and rhs
* End Op Exp
 84:     LD  0,-2(5) 	saving lhs back to reg 0
 85:    LDA  1,0(3) 	moving rhs
 86:    SUB  3,0,1 	substracting rsh from lhs
* End Op Exp
 87:     ST  3,-2(5) 	add params
 88:    LDA  7,-77(7) 	jumping to function
 44:    LDC  1,45(0) 	Creating Offset
 89:     LD  2,2(5) 	Load returna
 90:     LD  5,0(5) 	load old fp
 91:     LD  1,-2(5) 	restore reg 1
 92:     LD  0,-1(5) 	restore reg 0
 93:    LDA  4,0(5) 	loading fp to reg 4
 94:     LD  4,0(4) 	going to scope
 95:     ST  3,1(4) 	Storing the return value
 96:    LDA  5,0(4) 	load old fp
 97:     LD  2,2(5) 	Load return address
 98:    LDA  7,0(2) 	Loading return add
 40:    LDA  7,58(7) 	Jump to end if
 99:     LD  5,0(5) 	reloading FP
100:     LD  7,2(5) 	Loading PC
 11:    LDA  7,89(7) 	jump around fn body
* processing function: main
* Assign Exp
* Call Exp
102:     ST  0,-3(5) 	Store reg 0
103:     ST  5,-4(5) 	Store the fp
104:    LDA  5,-4(5) 	Create new fp
105:    LDA  0,1(7) 	Store Pc with offset
106:    LDA  7,-103(7) 	move return add to reg 0
107:     LD  5,0(5) 	Reload the fp
108:    LDA  3,0(0) 	Store results
109:     LD  0,-3(5) 	Restore reg 0
110:     ST  3,-4(5) 	Saving  rhs result to stack
* Simple Var Exp
111:    LDA  4,0(5) 	Loading FP
112:    LDA  4,-2(4) 	Loading Variable Address To Reg 4
113:     LD  3,0(4) 	Loading varialble value
114:     LD  0,-4(5) 	Saving rhs back to reg 0
115:     ST  0,0(4) 	Assigning rhs to lhs
* Assign Exp
* Int Exp
116:    LDC  3,10(0) 	loading constant to reg 3
117:     ST  3,-4(5) 	Saving  rhs result to stack
* Simple Var Exp
118:    LDA  4,0(5) 	Loading FP
119:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
120:     LD  3,0(4) 	Loading varialble value
121:     LD  0,-4(5) 	Saving rhs back to reg 0
122:     ST  0,0(4) 	Assigning rhs to lhs
* Call Exp
* Call Exp
123:     ST  0,-4(5) 	Store reg 0
124:     ST  1,-5(5) 	Store reg 1
125:    LDA  0,0(7) 	PC stuff
127:    ADD  0,0,1 	More PC Stuff
128:     ST  0,-6(5) 	Storing Pc
129:     ST  5,-8(5) 	Storing FP
130:    LDA  5,-8(5) 	UPdating FP
* Simple Var Exp
131:    LDA  4,0(5) 	Loading FP
132:     LD  4,0(4) 	Loading Old FP
133:    LDA  4,-2(4) 	Loading Variable Address To Reg 4
134:     LD  3,0(4) 	Loading varialble value
135:     ST  3,-1(5) 	add params
* Simple Var Exp
136:    LDA  4,0(5) 	Loading FP
137:     LD  4,0(4) 	Loading Old FP
138:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
139:     LD  3,0(4) 	Loading varialble value
140:     ST  3,-2(5) 	add params
141:    LDA  7,-130(7) 	jumping to function
126:    LDC  1,16(0) 	Creating Offset
142:     LD  2,2(5) 	Load returna
143:     LD  5,0(5) 	load old fp
144:     LD  1,-5(5) 	restore reg 1
145:     LD  0,-4(5) 	restore reg 0
146:     ST  0,-4(5) 	Store reg 0
147:     ST  5,-5(5) 	Store the fp
148:    LDA  5,-5(5) 	Create new fp
149:     ST  3,-2(5) 	Storing outputn value
150:    LDA  0,1(7) 	Store Pc with offset
151:    LDA  7,-145(7) 	move return add to reg 0
152:     LD  5,0(5) 	Reload the fp
153:     LD  0,-4(5) 	Restore reg 0
154:     LD  7,2(5) 	Loading PC
101:    LDA  7,53(7) 	jump around fn body
155:    LDA  0,0(7) 	PC stuff
157:    ADD  0,0,1 	More PC Stuff
158:     ST  0,-5(5) 	Storing Pc
159:     ST  5,-7(5) 	Storing FP
160:    LDA  5,-7(5) 	Updating FP
161:    LDA  7,-60(7) 	jumping to function
156:    LDC  1,6(0) 	Creating Offset
162:     LD  5,1(5) 	load old fp
163:   HALT  0,0,0 	HALLTTTT
