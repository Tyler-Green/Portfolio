package Assembler;

import absyn.*;
import java.util.*;

public class Assembler implements AssemblerVisitor {
  private int instructionCnt;
  private int varCnt;
  private int patchCount = 0;
  private int scopeCount = 0;
  private ArrayList<HashMap<String, Integer>> MapList;
  private HashMap<String, Integer> functionMap;

  /* Registers */
  static private final int AC = 0; // Arithmetic Operations
  static private final int AC1 = 1; // Arithmetic Operations
  static private final int STORE = 2; // Arithmetic Operations Value
  static private final int VAL = 3; //
  static private final int ADR = 4; // For The Return Address
  static private final int FP = 5; // Frame Pointer
  static private final int GP = 6; // Global Pointer
  static private final int PC = 7; // Program Counter

  public enum Operations {HALT, IN, OUT, ADD, SUB, MUL, DIV, LD, ST, LDA, LDC, JLT, JLE, JGT, JGE, JEQ, JNE;}

  private List<Operations> registerOnly = Arrays.asList(Operations.HALT, Operations.IN, Operations.OUT, Operations.ADD, Operations.SUB, Operations.MUL, Operations.DIV);

  //Create a new level of scope
  public void addScope() {
    HashMap<String,Integer> newMap = new HashMap<String, Integer>();
    MapList.add(newMap);
  }

  // Add a symbol to the current scope's hashmap
  public void addToScope(String name, Integer offset) {
    if ((MapList.get(MapList.size()-1)).get(name) == null) (MapList.get(MapList.size()-1)).put(name, offset);
  }

  // Clears the hashmap of the current scope and deletes it
  public void deleteScope() {
    (MapList.get(MapList.size()-1)).clear();
    MapList.remove(MapList.size()-1);
  }

  //checks if a variable is declared and returns value for variable if it is
  public Integer[] isDeclared(String key) {
    int currentScope = MapList.size()-1;
    for (int i=currentScope; i>=0; i--) {
      if (MapList.get(i).get(key) != null){
        Integer[] values = new Integer[2];
        values[1] = MapList.get(i).get(key);
        values[0] = currentScope - i;
        return values;
      }
    }
    return null;
  }

  public Assembler(String filename) {
    System.out.println("* C-Minus Compilation to TM Code");
    System.out.println("* File: " + (filename.substring(0, filename.length()-2) + "tm"));
    System.out.println("* Standard prelude:\n"+
    "  0:     LD  6,0(0) 	load gp with maxaddress\n"+
    "  1:    LDA  5,0(6) 	copy to gp to fp\n"+
    "  2:     ST  0,0(0) 	clear location 0\n"+
    "* Jump around i/o routines here\n"+
    "  3:    LDA  7,7(7) 	jump around i/o code\n"+
    "* code for input routine\n"+
    "  4:     ST  0,-1(5) 	store return\n"+
    "  5:     IN  0,0,0 	input\n"+
    "  6:     LD  7,-1(5) 	return to caller\n"+
    "* code for output routine\n"+
    "  7:     ST  0,-1(5) 	store return\n"+
    "  8:     LD  0,-2(5) 	load output value\n"+
    "  9:    OUT  0,0,0 	output\n"+
    " 10:     LD  7,-1(5) 	return to caller\n"+
    "* End of standard prelude.");
    writeComment("");
    instructionCnt = 11;
    varCnt = 0;
    this.MapList = new ArrayList<HashMap<String,Integer>>();
    functionMap = new HashMap<String, Integer>();
    functionMap.put("input", 4);
    functionMap.put("output", 7);
    addScope();
  }

  public void finale() {
      writeComment("");
      writeComment("Finale");
      String temp = "Call"+patchCount++;
      //move pc to reg 0
      writeAsm(instructionCnt++, Operations.LDA, 0, 0, 7, "PC stuff");
      //move val to reg 1
      int instr = instructionCnt++;
      //stack.add(new APatchLine(instructionCnt++, Operations.LDC, 1, 0, temp, "Creating Offset"));
      //add reg 1 to pc
      writeAsm(instructionCnt++, Operations.ADD, 0, 0, 1, "More PC Stuff");
      //move reg 0 to stack;
      writeAsm(instructionCnt++, Operations.ST, 0, varCnt-1, 5, "Storing Pc");
      writeAsm(instructionCnt++, Operations.ST, 5, varCnt-3, 5, "Storing FP");
      writeAsm(instructionCnt++, Operations.LDA, 5, varCnt-3, 5, "Updating FP");
      addScope();
      int lineNum = functionMap.get("main");
      writeAsm(instructionCnt++, Operations.LDA, 7, lineNum - instructionCnt, 7, "Jumping To Function Main");
      //checkPatchLine(temp, instructionCnt+1);
      writeAsm(instr, Operations.LDC, 1, 0, 0, "Creating Offset");
      writeAsm(instructionCnt++, Operations.LD, 5, 1, 5, "load old fp");
      writeAsm(instructionCnt++, Operations.HALT, 0, 0, 0,"Halt");
  }

  /* add instruction line to output StringBuilder */
  private void writeAsm(int address, Operations oper, int r, int s, int t, String comment) {
    String addr = String.format("%1$3s", Integer.toString(address));
    String op = String.format("%1$6s", oper.name());
    if(registerOnly.contains(oper)) {
      System.out.println(addr + ": " + op + "  " + r + "," + s + "," + t + " \t" + comment);
    }
    else {
      System.out.println(addr + ": " + op + "  " + r + "," + s + "(" + t + ")" + " \t"  +  comment);
    }
  }
  /* add comment line to the output */
  private void writeComment(String comment) {
    System.out.println("* " + comment);
  }

  public void visit( ArrayDec exp) {
      //no further recursion
  }

  public void visit( AssignExp exp) {
    writeComment("Assign Exp");
    exp.rhs.accept(this);
    exp.lhs.accept(this);
  }

  public void visit( CallExp exp) {
    writeComment("Call Exp");
    exp.args.accept(this);
  }

  public void visit( CompoundExp exp) {
      exp.vars.accept(this);
      if (exp.exps!=null) exp.exps.accept(this);
  }

  public void visit( DecList decList) {
      while( decList != null ) {
          decList.head.accept(this);
          decList = decList.tail;
      }
  }
  public void visit( ExpList expList) {
      while( expList != null ) {
          expList.head.accept(this);
          expList = expList.tail;
      }
  }
  public void visit( ExpList expList, int value) {
      while( expList != null ) {
      expList.head.accept(this);
      //not sure why i had this instruction
      //writeAsm(instructionCnt++, Operations.ST, 3, --varCnt, 5, "add params");
      expList = expList.tail;
    }
  }


  public void visit ( FunctionDec exp) {
      int startInstruction = instructionCnt++;
      writeComment("Function Declaration: " + exp.ID);
      functionMap.put(exp.ID, instructionCnt);
      addScope();
      writeAsm(instructionCnt++, Operations.ST, ADR, -1, FP, "Store The Return Address");
      if (exp.params!=null) exp.params.accept(this);
      if (exp.exps!=null) exp.exps.accept(this);
      writeAsm(instructionCnt++, Operations.LD, PC, -1, FP, "Loading Return Address");
      deleteScope();
      writeComment("Jump Around Function " + exp.ID);
      writeAsm(startInstruction, Operations.LDA, PC, instructionCnt-startInstruction-1, PC, "Jumping Around Function");
  }

  public void visit( IfExp exp) {
    writeComment("If Exp");
    exp.ifpart.accept(this);
    exp.thenpart.accept(this);
    exp.elsepart.accept(this);
  }

  public void visit( IntExp exp) {
    writeComment("Int Exp");
    //no further recursion
  }

  public void visit( OpExp exp) {
    writeComment("Op Exp");
    switch (exp.op) {
      case OpExp.PLUS:
        break;
      case OpExp.MINUS:
        break;
      case OpExp.TIMES:
        break;
      case OpExp.OVER:
        break;
      case OpExp.EQ:
        break;
      case OpExp.NEQ:
        break;
      case OpExp.LT:
        break;
      case OpExp.LEQ:
        break;
      case OpExp.GT:
        break;
      case OpExp.GEQ:
        break;
      default:
        System.err.println("Something went wrong");
        break;
    }
    exp.left.accept(this);
    exp.right.accept(this);
    writeComment("End Op Exp");
  }

  public void visit( ReturnExp exp) {
    writeComment("Return exp");
    exp.exp.accept(this);
  }

  public void visit( SimpleDec exp) {
      //no further recursion
  }

  public void visit( VarExp exp) {
      exp.var.accept(this);
  }

  public void visit ( WhileExp exp) {
    writeComment("While Exp");
    exp.condition.accept(this);
    exp.body.accept(this);
  }

  public void visit ( SimpleVarExp exp) {
    writeComment("Simple Var Exp");
    //no further recursion
  }

  public void visit ( IndexVarExp exp) {
    writeComment("Index Var Exp");
    exp.index.accept(this);
  }

  public void visit ( NillExp exp) {
    writeComment("Nil Exp");
    //no further recursion
  }

  public void visit ( TypeSpec exp) {
      //no further recursion
  }
}
