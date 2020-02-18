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

_____________________________________________

Compilation and Execution:
---------------------------------------------
To compile type "make"
To run:
type "java Main <flag> <filename>",
	where <flag> is one of:
		-a for abstract syntax tree
		-s for symbol table (not yet implemented)
		-c for compile with assembly output (not yet implemented)
	where <filename> is the name of the cm source file
or
type "java Main <filename> <flag>",
	where <filename> is the name of the cm source file
	where <flag> is one of:
		-a for abstract syntax tree
		-s for symbol table (not yet implemented)
		-c for compile with assembly output (not yet implemented)

_____________________________________________

Testing:
---------------------------------------------

To run the testing documents for checkpoint 1 type "make test_c1"

To run the testing documents for checkpoint 2 type "make test_c2"

_____________________________________________
