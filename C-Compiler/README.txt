_____________________________________________

JFlex/JCUP Implementation of C- Compiler
---------------------------------------------
Authors: Jessica Authier and Tyler Green
Last Modified: March 4, 2019

_____________________________________________

Limitations and Restrictions and Assumptions:
---------------------------------------------
There are no nested comments
The syntax in the specification is correct.
Variable cannot be initialized as void
Only one flag is given
One file is provided
There is a limitation that at most only one flag can be given
One and only one file must be given

An incorrect program will crash the symbol table
    It will still tell you the errors it found, it crashes after that fact (needs fixing)

_____________________________________________

Compilation and Execution:
---------------------------------------------
To compile type "make"
To run:
type "java Main <flag> <filename>",
	where <flag> is one of:
		-a for abstract syntax tree
		-s for symbol table
		-c for compile with assembly output
	where <filename> is the name of the cm source file
or
type "java Main <filename> <flag>",
	where <filename> is the name of the cm source file
	where <flag> is one of:
		-a for abstract syntax tree
		-s for symbol table
		-c for compile with assembly output

_____________________________________________

Testing:
---------------------------------------------

To run the testing documents for checkpoint 1 type "make test_c1"

To run the testing documents for checkpoint 2 type "make test_c2"

To run the testing documents for checkpoint 3 "type make test_c3"

_____________________________________________
