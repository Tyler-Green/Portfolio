/*
    Main.java
    This file initiates the entire compiler.

    Authors: Jessica Authier and Tyler Green
    Last Modified: 02/12/2019
*/

import java.io.*;
import java.util.*;
import absyn.*;
import symbol.*;
import Assembler.*;

class CM {
  // public final static boolean SHOW_TREE = true;
  public static void main(String[] args) {
	if (args.length > 2 || args.length < 1) {
		System.err.println("Invalid Number of Arguements\nAborting...");
		System.exit(1);
	}
	boolean flagA, flagS, flagC;
	flagA = flagS = flagC = false;
	if (args.length > 1) {
		if (args[0].equals("-a")) {
			flagA = true;
		} else if (args[0].equals("-s")) {
			flagS = true;
		} else if (args[0].equals("-c")) {
			flagC = true;
		} else  {
			System.err.println("Flag Unknown: "+args[0]+"\nKnown Flags Are -a -s -c\nAborting...");
			System.exit(2);
		}
	}
	//check if file exists

	File file = new File(args[args.length-1]);
	if (!file.exists()) {
		System.err.println("File: "+args[args.length-1]+" Cannot Be Found\nAborting...");
		System.exit(3);
	}

  String[] filename = args[args.length-1].split("\\.");
  System.out.println(filename[0]);

    try {
      parser p = new parser(new Lexer(new FileReader(args[args.length-1])));
      Absyn result = (Absyn)(p.parse().value);
      if (flagA && parser.errors != true) {
        try {
          PrintStream fileOut = new PrintStream("./"+filename[0]+".ast");
          System.setOut(fileOut);
        } catch (FileNotFoundException e){
          System.err.println("Output file not found");
        }
        System.out.println("The Abstract Syntax Tree Is:");
        ShowTreeVisitor visitor = new ShowTreeVisitor();
        result.accept(visitor, 0);
      }
      if ((flagS || flagC) && parser.errors != true) {
        try {
          PrintStream fileOut = new PrintStream("./"+filename[0]+".smb");
          System.setOut(fileOut);
        } catch (FileNotFoundException e){
          System.err.println("Output file not found");
        }
        if (flagS) System.out.println("The Symbol Table Is:");
        SymbolTable visitor = new SymbolTable(flagS);
        result.accept(visitor);
        visitor.deleteScope("GlobalScope");
        if (flagC && visitor.errorFlag != true) {
          try {
            PrintStream fileOut = new PrintStream("./"+filename[0]+".tm");
            System.setOut(fileOut);
          } catch (FileNotFoundException e){
            System.err.println("Output file not found");
          }
            Assembler assembler = new Assembler(args[args.length-1]);
            result.accept(assembler);
            assembler.finale();
        }
      }
    } catch (Exception e) {
      /* do cleanup here -- possibly rethrow e */
      e.printStackTrace();
    }
  }

}
